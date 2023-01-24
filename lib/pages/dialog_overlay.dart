import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../custom_widgets/simple_button_widget.dart';
import '../constants/app_sizes.dart';
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

class DialogOverlay extends HookConsumerWidget {
  DialogOverlay({
    super.key,
    required this.game,
    required this.dialogConfig,
  });
  TetrisGame game;
  DialogConfig dialogConfig;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageEditingController = useTextEditingController();
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
                TextField(
                  controller: messageEditingController,
                  autofocus: true,
                  autocorrect: false,
                  cursorColor: Colors.white60,
                  style: textTheme.bodyText1,
                  decoration: InputDecoration(
                    hintText: 'Enter your message',
                    hintStyle: textTheme.bodyText1,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white60),
                    ),
                  ),
                ),
              ],
              const Spacer(),
              OutlinedButton(
                onPressed: () {
                  dialogConfig.onCommit?.call();
                  dialogConfig.onStringInput
                      ?.call(messageEditingController.text);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white60,
                  side: const BorderSide(color: Colors.white60),
                ),
                child: Text(dialogConfig.buttonText ?? 'OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
