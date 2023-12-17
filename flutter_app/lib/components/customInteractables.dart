import 'package:flutter/material.dart';

class NumberPicker extends StatefulWidget {
  final int initialValue;
  final int steps;
  final ValueChanged<int>? onChanged;

  NumberPicker({required this.initialValue, required this.steps, this.onChanged});

  @override
  _NumberPickerState createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _increment() {
    setState(() {
      _value += widget.steps;
      widget.onChanged?.call(_value);
    });
  }

  void _decrement() {
    setState(() {
      _value -= widget.steps;
      widget.onChanged?.call(_value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: _decrement,
        ),
        Text(
          '$_value',
          style: const TextStyle(fontSize: 20),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: _increment,
        ),
      ],
    );
  }
}
