import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_sizes.dart';
import '../components/simple_button_widget.dart';
import '../providers/providers.dart';
import '../tetris_game.dart';

class DialogOverlay extends ConsumerStatefulWidget {
  DialogOverlay({super.key, required this.game});
  TetrisGame game;

  @override
  ConsumerState<DialogOverlay> createState() => _HighScoresPageState();
}

class _HighScoresPageState extends ConsumerState<DialogOverlay> {
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
    _textEditingController.text = ref.read(highScoreNotifier).userName;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final highScore = ref.watch(highScoreNotifier);
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
                  BackButtonWidget(onTapped: widget.game.router.pop),
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
                  // ref.read(highScoreNotifier.notifier).addCurrentScoreFor(
                  //       userName: _textEditingController.text,
                  //     );
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
