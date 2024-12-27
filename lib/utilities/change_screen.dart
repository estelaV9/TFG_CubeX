import 'package:flutter/material.dart';

class ChangeScreen {
  static void changeScreen(Widget nameScreen, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => nameScreen,
      ),
    );
  }
}
