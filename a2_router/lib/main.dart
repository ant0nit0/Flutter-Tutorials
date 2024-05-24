import 'package:a2_router/utils/router.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

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
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
    );
  }
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('First Screen'),
      ),
      backgroundColor: Colors.amber,
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigatorKey.currentState!.pushReplacementNamed(
          Routes.secondScreen,
          arguments: const SecondScreenArgs(
            title: 'Hello from the first screen',
            message: 'This message comes from the first screen too',
          ),
        ),
        tooltip: 'Go to second page',
        child: const Icon(Icons.arrow_forward_ios_rounded),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  final SecondScreenArgs args;
  const SecondScreen(this.args, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Second Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(args.title),
            Text(args.message),
          ],
        ),
      ),
      backgroundColor: Colors.greenAccent,
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            navigatorKey.currentState!.pushReplacementNamed(Routes.firstScreen),
        tooltip: 'Go to first page',
        child: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
    );
  }
}

/// It is better to define the arguments class outside the widget class
/// in order to improve maintainability and readability.
/// This way, we can easily add or remove parameters without having to update the router
class SecondScreenArgs {
  final String title;
  final String message;

  const SecondScreenArgs({
    required this.title,
    required this.message,
  });
}
