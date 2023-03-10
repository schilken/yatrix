import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants/app_sizes.dart';
import '../custom_widgets/custom_widgets.dart';
import '../tetris_game.dart';

typedef StringCallback = void Function(String value);

class DialogConfig {
  String? title;
  String? text1;
  String? text2;
  String? buttonText;
  VoidCallback? onCommit;
  VoidCallback? onCancel;
  StringCallback? onStringInput;

  DialogConfig({
    this.title,
    this.text1,
    this.text2,
    this.buttonText,
    this.onStringInput,
    this.onCommit,
    this.onCancel,
  });
}

class DialogOverlay extends ConsumerWidget {
  DialogOverlay({
    super.key,
    required this.game,
    required this.dialogConfig,
  });
  TetrisGame game;
  DialogConfig dialogConfig;

  var _message = '';

  void _onChanged(String message) {
    _message = message;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final containsTextfield = dialogConfig.onStringInput != null;
    return Material(
      child: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 20, 20),
          width: containsTextfield ? 300 : 250,
          height: containsTextfield ? 320 : 280,
          decoration: BoxDecoration(
              color: const Color.fromARGB(200, 20, 20, 20),
              border: Border.all(
                color: Colors.white30,
              ),
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              gapH8,
              Row(
                children: [
                  BackButtonWidget(onTapped: game.router.pop),
                ],
              ),
              gapH32,
              if (dialogConfig.title != null)
              Text(
                  dialogConfig.title!,
                  style: textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              if (dialogConfig.text1 != null) ...[
                gapH12,
                Text(
                  dialogConfig.text1!,
                  style: textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ],
              if (dialogConfig.text2 != null) ...[
                gapH12,
                Text(
                  dialogConfig.text2!,
                  style: textTheme.bodyText1,
                ),
              ],
              if (containsTextfield) ...[
                gapH12,
                StyledTextField(
                  initialValue: '',
                  hintText: 'Enter your message',
                  onChanged: _onChanged,
                ),
              ],
              const Spacer(),
              StyledButton(
                label: dialogConfig.buttonText ?? 'OK',
                onPressed: () {
                  dialogConfig.onCommit?.call();
                  dialogConfig.onStringInput?.call(_message);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
