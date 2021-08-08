import 'package:drishti/src/cash_recognition/history.dart';
import 'package:drishti/src/cash_recognition/info.dart';
import 'package:drishti/src/home/home_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case '/history':
        return MaterialPageRoute(builder: (context) => HistoryScreen());
      case '/instructions':
        return MaterialPageRoute(builder: (context) => InstructionPage());
      default:
        return _errorRoute();
    }
  }

  static _errorRoute() => MaterialPageRoute(
        builder: (context) => const Material(
          child: Center(
            child: Text("404 Not Found!"),
          ),
        ),
      );
}
