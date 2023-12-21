import 'package:flutter/material.dart';
import 'package:flutter_app/themes.dart';

class NumberPicker extends StatefulWidget {
  final String name;
  final int initialValue;
  final int steps;
  final ValueChanged<int>? onChanged;

  const NumberPicker({super.key, required this.name, required this.initialValue, required this.steps, this.onChanged});

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
    return Container(
      width: 200,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 100,
              child:Text(widget.name, style: Theme.of(context).textTheme.bodyMedium)
            ),
            Text(_value.toString().padLeft(2, '0'), style: Theme.of(context).textTheme.bodySmall),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: _increment,
                  child: Container(
                    width: 15.0,
                    height: 15.0,
                    child: const Icon(
                      Icons.add,
                      color: secondaryColor,
                      size: 15.0,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _decrement,
                  child: Container(
                    width: 15.0,
                    height: 15.0,
                    child: const Icon(
                      Icons.remove,
                      size: 15.0,
                      color: secondaryColor,
                    ),
                  ),
                ), 
              ],
            ),
          ],
        ),
      ),
    );
  }
}
