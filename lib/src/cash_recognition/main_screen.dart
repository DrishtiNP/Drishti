import 'package:flutter/material.dart';
import 'package:drishti/src/cash_recognition/camera.dart';
import 'package:drishti/src/utils/colors.dart';

class CashRecognitionMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CashCamera(),
          AlignedButton(
            toolTip: "Instructions",
            icon: Icons.info_outline,
            alignment: Alignment.topLeft,
            onPressed: () {
              Navigator.of(context).pushNamed('/instructions');
            },
          ),
          AlignedButton(
            toolTip: "History",
            icon: Icons.history,
            alignment: Alignment.topRight,
            onPressed: () {
              Navigator.of(context).pushNamed('/history');
            },
          ),
        ],
      ),
    );
  }
}

class AlignedButton extends StatelessWidget {
  const AlignedButton({
    Key? key,
    required this.toolTip,
    required this.icon,
    required this.alignment,
    required this.onPressed,
  }) : super(key: key);

  final String toolTip;
  final IconData icon;
  final AlignmentGeometry alignment;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final containerSize = size.width * 0.16;
    final containerMarginTop = MediaQuery.of(context).padding.top +
        size.height * 0.01; // size.height * 0.07;
    final containerMarginSymmetric = size.width * 0.03;
    final iconSize = size.width * 0.1;

    return Align(
      alignment: alignment,
      child: Container(
        width: containerSize,
        height: containerSize,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: iconShadowColor,
              blurRadius: 6,
              offset: const Offset(2, 2),
              spreadRadius: 1,
            ),
          ],
          border: Border.all(
            color: iconsBorderColor,
            width: 0,
          ),
          borderRadius: BorderRadius.circular(50),
          color: iconsBorderColor,
        ),
        margin: EdgeInsets.only(
          top: containerMarginTop,
          left: containerMarginSymmetric,
          right: containerMarginSymmetric,
        ),
        child: IconButton(
          tooltip: toolTip,
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
