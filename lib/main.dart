import 'package:drishti/src/utils/haptic_feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:drishti/src/home/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HapticFeedback.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    /// Render the Home Screen view
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
