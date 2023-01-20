import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/app_sizes.dart';
import '../components/simple_button_widget.dart';
import '../providers/providers.dart';
import '../tetris_game.dart';

class DialogOverlay extends ConsumerWidget {
  DialogOverlay({super.key, required this.game});
  TetrisGame game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(12, 8, 20, 20),
          width: 250,
          height: 250,
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
              gapH48,
              Text(
                'Really abort the Two-Player-Game and go back to the Menu?',
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              gapH12,
              Text(
                'You peer will win this game.',
                style: textTheme.bodyMedium,
              ),
              Spacer(),
              OutlinedButton(
                onPressed: () {
                  // pop the dialog
                  game.router.pop();
                  // then pop the TetrisGamePage
                  game.router.pop();
                  Future<void>.delayed(
                      Duration(milliseconds: 100), () => game.topIsReached());
                  ref.read(dialogNotifier.notifier).setIsCommitted();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white60,
                  side: const BorderSide(color: Colors.white60),
                ),
                child: const Text('Abort the Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
