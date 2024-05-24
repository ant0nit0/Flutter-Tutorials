# Internationalization (i18n)

## 1. Initialization

[flutter_translate | Flutter package](https://pub.dev/packages/flutter_translate)

```bash
flutter pub add flutter_translate
```

Then, you’ll need to register the built-in `flutter_localizations` package in your `pubspec.yaml` file.

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter

  # Other dependencies
```

Now, register the supported locales and the fallback locale before running the app, and wrap your app in a `LocalizedApp`.

```dart
void main() async {
		// ... App initialisation (device orientation, etc ..)
		return appRunner();
}

void appRunner() async {
  // Delegate used for translations
  final delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en',
    supportedLocales: ['en', 'fr'],
  );
  runApp(
    LocalizedApp(
      delegate,
      const ChoooseApp(),
    ),
  );
}
```

<aside>
💡 **TIP: For more modularity and easier further modifications, register your `supported_locales` and your `fallback_locale`  into a `constants.dart` file, in order to update these easier.**

</aside>

And use it in your app

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localizationDelegate = LocalizedApp.of(context).delegate;
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        title: 'Localized app',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          localizationDelegate
        ],
        supportedLocales: localizationDelegate.supportedLocales,
        locale: localizationDelegate.currentLocale,
        // ... other properties of the MaterialApp
      ),
    );
  }
}
```

Finally, create the json files used to store all the texts values.
First, create a `i18n` folder in your `lib/assets` and register it in yout `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/i18n/
```

Now, you’ll need to create a file for each supported locale registered in your app. For example, if you’ve set you supportedLocales to `supportedLocales: ['en', 'fr']` , you’ll need to create two files `fr.json` and `en.json` in your `lib/assets/i18n/` folder.
For now, you can initialize them with an empty map that we’ll fill in later.

`fr.json` / `en.json`:

```json
{}
```

### The full `main.dart` file:

```dart
import 'package:a1_internationalization/utils/contants.dart';
import 'package:a1_internationalization/utils/ktranslate_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  return appRunner();
}

void appRunner() async {
  // Delegate used for translations
  final delegate = await LocalizationDelegate.create(
    fallbackLocale: fallbackLocale,
    supportedLocales: supportedLocales,
    preferences: KTranslatePreferences(),
  );
  runApp(
    LocalizedApp(
      delegate,
      const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localizationDelegate = LocalizedApp.of(context).delegate;
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        title: 'Localized app',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          localizationDelegate
        ],
        supportedLocales: localizationDelegate.supportedLocales,
        locale: localizationDelegate.currentLocale,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Example with simple translation
        title: Text(translate('demo.title')),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Example with plural translation
              Text(
                translatePlural('demo.plural', _counter),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _incrementCounter,
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Icon(Icons.add),
                ),
              ),
              const Spacer(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // This is an example of why it is important to set
                    // the supportedLocales as a list in the constants.dart
                    for (final String locale in supportedLocales)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            changeLocale(context, locale);
                          },
                          child: Text(locale),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 40.0),
              // Example with arguments
              Text(
                translate('demo.created', args: {'name': 'Antoine Andréani'}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

```

## 2. Use it in your app

### Basic use

Now, whenether you need to add a text in your app, you need to first regsiter it in all your json files with the same key. Example:

`fr.json`:

```json
{
  "demo": {
    "title": "Exemple de titre",
    "description": "Exemlpe de description"
  }
}
```

`en.json`:

```json
{
  "demo": {
    "title": "Title example",
    "description": "Description example"
  }
}
```

Now, you can call `translate('demo.title')` or `translate('demo.description')` in your app.

```dart
Text(
	translate('demo.title'),
	style: Theme.of(context).textTheme.headlineLarge,
),
```

### Use it with variables

If you need some dynamic texts with variables, it is of course possible by passing arguments:

First, in your `json` files, you’ll need to register the places where you need to use your dynalic values:

```json
{
  "demo": {
    "created": "Tutoriel créé par {name}"
  }
}
```

And then use it like this:

```dart
final _name= "Antoine Andréani"
translate(
	'demo.args_example',
  args: {'name': _name}
),
// Output:
// Tutoriel créé par Antoine Andréani
```

### Use it with plurals

The `flutter_translate` package also provides a simple implementation for the plural translations.

Firstly, create the map of values in your `json` files.

```json
{
  "plural": {
    "zero": "You haven't pushed the button yet.",
    "one": "You have pushed the button only once.",
    "two": "You have pushed the button just two times.",
    "other": "You have pushed the button {{value}} times."
  }
}
```

The translate packages will automatically translate the int values to the corresponding Strings, returning the `other` translation in case the given value is not specified.

To use it, simply use: `translatePlural('plural.demo', _counter)`:

```dart
final _counter = 0;
Text(
	translatePlural('plural.demo', _counter)
)
// Output: You haven't pushed the button yet.
_counter++;
Text(
	translatePlural('plural.demo', _counter)
)
// Output: You have pushed the button only once.
_counter = 20+
Text(
	translatePlural('plural.demo', _counter)
)
// Output: You have pushed the button 20 times.
```

## 3. Change the locale

If you followed all the previous steps, changing the locale is now an easy game: simply call:

```dart
changeLocale(context, value);
```

## 4. Register the preferences

Storing the user’s preferences is again an easy game thanks to the `flutter_translate` package. Simply implements the `ITranslatePreferences` interface:

```dart
// utils/ktranslate_preferences.dart
import 'dart:ui';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KTranslatePreferences implements ITranslatePreferences {
  static const String _selectedLocaleKey = 'selected_locale';

  @override
  Future<Locale?> getPreferredLocale() async {
    final preferences = await SharedPreferences.getInstance();

    if (!preferences.containsKey(_selectedLocaleKey)) return null;

    final String? locale = preferences.getString(_selectedLocaleKey);

    return locale != null ? localeFromString(locale) : null;
  }

  @override
  Future savePreferredLocale(Locale locale) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(_selectedLocaleKey, localeToString(locale));
  }
}
```

<aside>
💡 Do not forget to run the `flutter pub add shared_preferences` to add it to your `pubspec.yaml`.

</aside>

And register it when creating the delegate:

```dart
// main.dart

void appRunner() async {
  // Delegate used for translations
  final delegate = await LocalizationDelegate.create(
    fallbackLocale: fallbackLocale,
    supportedLocales: supportedLocales,
    preferences: KTranslatePreferences(), // Add this line
  );
  runApp(
    LocalizedApp(
      delegate,
      const MyApp(),
    ),
  );
}
```

And voilà ! The package now will automatically save the selected locale by the user as the default one.
