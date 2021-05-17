import 'package:flutter/material.dart';
import 'package:drishti/src/cash_recognition/camera.dart';
import 'package:drishti/src/cash_recognition/info.dart';
import 'package:drishti/src/cash_recognition/history.dart';

class CashRecognitionMainScreen extends StatefulWidget {
  @override
  _CashRecognitionMainScreenState createState() =>
      _CashRecognitionMainScreenState();
}

class _CashRecognitionMainScreenState extends State<CashRecognitionMainScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final containerSize = size.width * 0.16;
    final containerMarginTop = MediaQuery.of(context).padding.top +
        size.height * 0.01; // size.height * 0.07;
    final containerMarginLeft = size.width * 0.03;
    final iconSize = size.width * 0.1;

    final instructionsButton = Align(
        alignment: Alignment.topLeft,
        child: Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black54,
                      blurRadius: 6,
                      offset: Offset(2, 2),
                      spreadRadius: 1),
                ],
                border: Border.all(
                  color: Colors.grey[100],
                  width: 0,
                ),
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[100]),
            margin: EdgeInsets.only(
                top: containerMarginTop, left: containerMarginLeft),
            child: IconButton(
              tooltip: "Instructions",
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InstructionPage()));
              },
              icon: Icon(
                Icons.info_outline,
                size: iconSize,
                color: Colors.black87,
              ),
            )));

    final historyButton = Align(
        alignment: Alignment.topRight,
        child: Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black54,
                      blurRadius: 6,
                      offset: Offset(2, 2),
                      spreadRadius: 1),
                ],
                border: Border.all(
                  color: Colors.grey[100],
                  width: 0,
                ),
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[100]),
            margin: EdgeInsets.only(
                top: containerMarginTop, right: containerMarginLeft),
            child: IconButton(
              tooltip: "History",
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HistoryScreen()));
              },
              icon: Icon(
                Icons.history,
                size: iconSize,
                color: Colors.black87,
              ),
            )));
    return Scaffold(
        body: Stack(children: [
      CashCamera(),
      instructionsButton,
      historyButton,
    ]));
  }
}
