import 'package:flutter/material.dart';

class CubeTypeMenu extends StatefulWidget {
  const CubeTypeMenu({super.key});

  @override
  State<CubeTypeMenu> createState() => _CubeTypeMenuState();
}

class _CubeTypeMenuState extends State<CubeTypeMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 289,
      height: 376,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.red,
      ),
      child: Text("data"),
    );
  }
}
