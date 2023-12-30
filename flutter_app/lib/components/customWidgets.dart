import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget{

  final String text;
  final String value;

  const CardWidget({super.key, required this.text, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(text),
          Text(value),
        ],
      ),
    );
  }
}