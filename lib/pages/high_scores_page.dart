import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_sizes.dart';
import '../providers/providers.dart';
import '../tetris_game.dart';

class HighScoresPage extends ConsumerStatefulWidget {
  HighScoresPage({super.key, required this.game});
  TetrisGame game;

  @override
  ConsumerState<HighScoresPage> createState() => _HighScoresPageState();
}

class _HighScoresPageState extends ConsumerState<HighScoresPage> {
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
      child: Container(
        color: const Color.fromARGB(200, 20, 20, 20),
        padding: const EdgeInsets.fromLTRB(60.0, 0, 60, 30),
        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gapH12,
            Row(
              children: [
                OutlinedButton(
                  onPressed: () => widget.game.router.pop(),
                  child: Text('<'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white60,
                    side: BorderSide(color: Colors.white60),
                  ),
                ),
              ],
            ),
            gapH32,
            Text(
              'High Scores',
              style: textTheme.headline4,
            ),
            gapH24,
            if (widget.game.isGameOver) ...[
              TextField(
                controller: _textEditingController,
                focusNode: _focusNode,
                autofocus: true,
                autocorrect: false,
                cursorColor: Colors.white60,
                style: textTheme.headline5,
                decoration: InputDecoration(
                  hintText: 'Enter Your Name',
                  hintStyle: textTheme.bodyText1,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white60),
                  ),
                ),
              ),
              gapH12,
              Text(
                'Points: ${widget.game.points}\nRows: ${widget.game.rows}',
                textAlign: TextAlign.start,
                style: textTheme.headline6,
              ),
              gapH12,
              OutlinedButton(
                onPressed: () {
                  widget.game.isGameOver = false;
                  ref.read(highScoreNotifier.notifier).addCurrentScoreFor(
                        userName: _textEditingController.text,
                      );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white60,
                  side: const BorderSide(color: Colors.white60),
                ),
                child: const Text('Save Score'),
              ),
            ],
            gapH32,
            Expanded(
              child: ListView.separated(
                itemCount: highScore.scores.length,
                itemBuilder: (context, index) {
                  final score = highScore.scores[index];
                  return ListTile(
                    textColor: Colors.white60,
                    tileColor: Colors.grey,
                    title: Text(
                      score.userName,
                      style: textTheme.headline6!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Points: ${score.points}\nRows: ${score.rows}',
                      style: textTheme.headline6,
                    ),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 2,
                        color: Colors.amberAccent,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return gapH8;
                },
              ),
            ),
            gapH32,
          ],
        ),
      ),
    );
  }
}
