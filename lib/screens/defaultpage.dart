import 'package:flutter/material.dart';

class DefaultPage extends StatelessWidget {
  const DefaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Text(
        "Default Page",
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
        )
      )
    );
  }
}