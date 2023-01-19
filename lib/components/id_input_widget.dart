import 'package:another_xlider/another_xlider.dart';
import 'package:flutter/material.dart';

import '../app_sizes.dart';

typedef IntCallback = void Function(int value);

class IdInputWidget extends StatefulWidget {
  IdInputWidget({
    super.key,
    required this.onChanged,
  });

  IntCallback onChanged;

  @override
  State<IdInputWidget> createState() => _IdInputWidgetState();
}

class _IdInputWidgetState extends State<IdInputWidget> {
  final _digits = List<double>.filled(5, 5);

  @override
  void initState() {
    widget.onChanged(numberFromDigits);
    super.initState();
  }

  int get numberFromDigits {
    return _digits
        .fold<double>(0, (value, digit) => value * 10 + digit)
        .toInt();
  }

  void _onChanged() {
    setState(() {});
    widget.onChanged(numberFromDigits);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: Column(
        children: [
          Text(
            numberFromDigits.toString(),
            style: textTheme.headline4,
          ),
          gapH8,
          Container(
            height: 180,
            width: 320,
            child: ListView.builder(
              itemCount: 5,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return FlutterSlider(
                  axis: Axis.vertical,
                  handlerWidth: 30,
                  values: [_digits[index]],
                  rtl: true,
                  max: 9,
                  min: 0,
                  tooltip: FlutterSliderTooltip(
                    disabled: true,
                  ),
                  onDragging:
                      (handlerIndex, dynamic lowerValue, dynamic upperValue) {
                    _digits[index] = lowerValue as double;
                    _onChanged();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
