import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef StringCallback = void Function(String value);

class StyledTextField extends HookWidget {
  const StyledTextField({
    super.key,
    required this.initialValue,
    required this.hintText,
    required this.onChanged,
  });
  final String initialValue;
  final String hintText;
  final StringCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final nameEditingController = useTextEditingController(text: initialValue);
    return TextField(
      controller: nameEditingController,
      autocorrect: false,
      cursorColor: Colors.white60,
      style: textTheme.headline5,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: textTheme.bodyText1,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white60),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
