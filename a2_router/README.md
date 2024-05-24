# Router and navigation

Firstly, we’ll create a `router.dart` file inside our `utils` folder.

Then, we can create a `navigatorKey` , that we’ll use all over our app to push new screens.

```dart
// utils/router.dart

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
```

We need to register our navigatorKey in our MaterialApp:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Routing app',
      // other properties ...
      navigatorKey: navigatorKey,
    );
  }
}
```

Then, we’ll define a `Routes` class, used to keep a track of all the available routes in our app.

```dart
class Routes {
  static const String firstScreen = '/first';
  static const String secondScreen = '/second';
}
```

We can now register our initial screen in our app:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Routing app',
      // other properties ...
      initialRoute: Routes.firstScreen,
    );
  }
}
```

But now, we need to specify the `onGenerateRoute` function to let our app know how to trigger new screens.

For that, we’ll create another `RouteGenerator` class in our `router.dart` file, and create a function to loop over our available routes.

```dart
class RouteGenerator {

  static Route<dynamic> generateRoute(RouteSettings settings) {

    if (kDebugMode) print('RouteGenerator.generateRoute: ${settings.name}');

    switch (settings.name) {
      case Routes.firstScreen:
        return MaterialPageRoute(builder: (_) => const FirstScreen());
      // other routes ...
    }
  }

}
```

This allow us to create a custom view for routing errors (even though it should be not visible in production):

```dart
class RouteGenerator {

  static Route<dynamic> generateRoute(RouteSettings settings) {

    switch (settings.name) {

		  // Different routes cases

      default:
        return _errorRoute(settings.name ?? '', settings);
    }

  }

  static Route<dynamic> _errorRoute(String name, RouteSettings routeSettings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Oops ...')),
        body: Center(
          child: Text(name.isEmpty
              ? 'No name passed. RouteSettings: $routeSettings'
              : 'View $name not found'),
        ),
      ),
    );
  }
}
```

Great ! Now we can register the generateRoute method in our MaterialApp:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Routing app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: Routes.firstScreen,
      onGenerateRoute: RouteGenerator.generateRoute, // Add this line
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
    );
  }
}
```

And voilà ! Now, when you need to add a new route, first register it in the `Routes` class. Then, add the case inside the generateRoute to return the new screen. You will then be able to call `navigatorKey.currentState!.pushNamed(Routes.newScreen)` to push your new screen.

### Pass Arguments

To pass arguments to a new screen, here it is the cleanest way:

First, imagine the following screen:

```dart
class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
	      appBar: AppBar(title: const Text('Second Screen'),
      ),
      body: Center(
	      // Here we want to get the message from another screen
        child: Text(''),
      ),
    );
  }
}
```

We’ll first create a new class, by taking the name of the screen and adding `Args` at the end for convention.

```dart
class SecondScreenArgs {
  final String message;

  const SecondScreenArgs(this.message);
}
```

We can now use this class in our screen to get the needed values.

```dart
class SecondScreen extends StatelessWidget {
  final SecondScreenArgs args;
  const SecondScreen(this.args, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
	      appBar: AppBar(title: const Text('Second Screen'),
      ),
      body: Center(
        child: Text(args.message),
      ),
    );
  }
}
```

Then, we need to pass the arguments in the router class:

```dart
// router.dart
class RouteGenerator {

  static Route<dynamic> generateRoute(RouteSettings settings) {

    switch (settings.name) {

			// Other cases

      case Routes.secondScreen:
        return MaterialPageRoute(
          builder: (_) => SecondScreen(
            settings.arguments as SecondScreenArgs, // Here we pass the new arguments
          ),
        );

      default:
        return _errorRoute(settings.name ?? '', settings);
    }
  }
```

Now, we we want to push the new screen, we can do it like this:

```dart
onPressed: () {
	navigatorKey.currentState!.pushReplacementNamed(
    Routes.secondScreen,
    arguments: const SecondScreenArgs(
	    title: 'Hello from the first screen',
	    message: 'This message comes from the first screen',
	  ),
	);
}
```

This way, if we need to update our screen requirements, we can only update the Args class, without having to manually trigger the corresponding values in the router:

```dart
class SecondScreenArgs {
  final String title; // We add a title here
  final String message;

  const SecondScreenArgs({
    required this.title, // And here of course
    required this.message,
  });
}
```

```dart

```

We can directly use the new argument in our screen:

```dart
class SecondScreen extends StatelessWidget {
  final SecondScreenArgs args; // We do not need to update anything here
  const SecondScreen(this.args, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Screen'),
      ),
      body: Center(
        child: Column(
          children: [
		        // We can get the title now
            Text(args.title),
            Text(args.message),
          ],
        ),
      ),
    );
  }
}
```

And don’t forget to update the needed arguments on call now:

```dart
onPressed: () {
	navigatorKey.currentState!.pushReplacementNamed(
	  Routes.secondScreen,
	  arguments: const SecondScreenArgs(
	    title: 'Hello from the first screen',
	    message: 'This message comes from the first screen',
	  ),
	);
}
```
