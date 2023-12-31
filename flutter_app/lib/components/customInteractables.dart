import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter_app/providers/settingsProvider.dart';
import 'package:flutter_app/themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

class MuteButton extends ConsumerWidget{
  const MuteButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return IconButton(
      iconSize: 35,
      onPressed: settings.toggleMute,
      icon: Icon(
        settings.muted ? Icons.volume_off: Icons.volume_up,
        color: settings.muted ? dangerColor : darkColor
      ),
    );
  }
}

/* class SliderWidget extends  {

  final double minSliderValue;
  final double maxSliderValue;
  final int divisions;

  const SliderWidget({super.key, required this.minSliderValue, required this.maxSliderValue, required this.divisions});
  @override
  _SLiderState createState() => _SLiderState();
} */

class SliderWidget extends ConsumerWidget {
  final double minSliderValue;
  final double maxSliderValue;
  final int divisions;

  const SliderWidget({super.key, required this.minSliderValue, required this.maxSliderValue, required this.divisions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return Slider(
      value: settings.scale,
      onChanged: (value) {
        settings.changeScale(value);
      },
      min: minSliderValue,
      max: maxSliderValue,
      divisions: divisions,
      label: settings.scale.toString(),
    );
  }
}

class NumberPicker extends StatefulWidget {
  final String name;
  final int initialValue;
  final int steps;
  final Tuple2<int, int> range;
  final ValueChanged<int>? onChanged;

  const NumberPicker({super.key, required this.name, required this.initialValue, required this.steps, required this.range, this.onChanged});

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

  bool _toLow(){
    return _value - widget.steps < widget.range.item1;
  }

  bool _toHigh(){
    return _value + widget.steps > widget.range.item2;
  }

  void _increment() {
    setState(() {
      if(_toHigh()) return;
      _value += widget.steps;
      widget.onChanged?.call(_value);
    });
  }

  void _decrement() {
    setState(() {
      if(_toLow()) return;
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
                    width: 23.0,
                    height: 23.0,
                    child: Icon(
                      Icons.add,
                      color: _toHigh() ? disabledColor : primaryColor ,
                      size: 23.0,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _decrement,
                  child: Container(
                    width: 23.0,
                    height: 23.0,
                    child: Icon(
                      Icons.remove,
                      size: 23.0,
                      color: _toLow() ? disabledColor : primaryColor,
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
