import 'package:a1_internationalization/utils/constants.dart';
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
