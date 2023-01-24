// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

typedef DoubleCallback = void Function(double value);

class StyledSlider extends StatelessWidget {
  const StyledSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final double value;
  final DoubleCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final sliderTheme = Theme.of(context).sliderTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: textTheme.headline5,
        ),
        SizedBox(
          width: 250.0,
          child: Slider(
            value: value,
            divisions: 10,
            thumbColor: sliderTheme.thumbColor,
            activeColor: sliderTheme.activeTrackColor,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
