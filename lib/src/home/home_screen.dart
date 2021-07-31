import 'package:flutter/material.dart';
import 'package:drishti/src/cash_recognition/main_screen.dart';
import 'package:drishti/src/home/component_list.dart';

class HomeScreen extends StatelessWidget {
  /// specify other components of Drishti in a similar way
  final components = [
    {
      'name': 'CASH\nRECOGNITION',
      'viewScreen': CashRecognitionMainScreen(),
      'color': Color(0xff23BD52),
      'imagePath': 'assets/cash_recognition/images/note.png'
    }
  ];

  @override
  Widget build(BuildContext context) {
    /// if more than one component, show component list view page
    /// else, directly switch to the only view screen available
    return components.length > 1
        ? ComponentList(components)
        : components[0]['viewScreen'] as Widget;
  }
}
