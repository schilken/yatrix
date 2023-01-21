import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/simple_button_widget.dart';
import '../helpers/app_sizes.dart';
import '../tetris_game.dart';

class DialogData {
  String? title;
  String? text1;
  String? text2;
  String? buttonText;
  String? returnedData;
  VoidCallback? onCommit;
  VoidCallback? onCancel;

  DialogData({
    this.title,
    this.text1,
    this.text2,
    this.buttonText,
    this.returnedData,
    this.onCommit,
    this.onCancel,
  });
}

class DialogOverlay extends ConsumerWidget {
  DialogOverlay({
    super.key,
    required this.game,
    required this.dialogData,
  });
  TetrisGame game;
  DialogData dialogData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(12, 8, 20, 20),
          width: 250,
          height: 280,
          decoration: BoxDecoration(
              color: const Color.fromARGB(200, 20, 20, 20),
              border: Border.all(
                color: Colors.white30,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              gapH8,
              Row(
                children: [
                  BackButtonWidget(onTapped: game.router.pop),
                ],
              ),
              gapH32,
              if (dialogData.title != null)
              Text(
                  dialogData.title!,
                  style: textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              if (dialogData.text1 != null) ...[
                gapH12,
                Text(
                  dialogData.text1!,
                  style: textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ],
              if (dialogData.text2 != null) ...[
                gapH12,
                Text(
                  dialogData.text2!,
                  style: textTheme.bodyText1,
                ),
              ],
              Spacer(),
              OutlinedButton(
                onPressed: () {
                  dialogData.onCommit?.call();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white60,
                  side: const BorderSide(color: Colors.white60),
                ),
                child: Text(dialogData.buttonText ?? 'OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
