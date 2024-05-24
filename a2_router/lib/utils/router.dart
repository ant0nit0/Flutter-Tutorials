import 'package:a2_router/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Routes {
  static const String firstScreen = '/first';
  static const String secondScreen = '/second';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (kDebugMode) print('RouteGenerator.generateRoute: ${settings.name}');
    switch (settings.name) {
      case Routes.firstScreen:
        return MaterialPageRoute(builder: (_) => const FirstScreen());
      case Routes.secondScreen:
        return MaterialPageRoute(
          builder: (_) => SecondScreen(
            settings.arguments as SecondScreenArgs,
          ),
        );
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
