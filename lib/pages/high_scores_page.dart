import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/app_sizes.dart';
import '../components/simple_button_widget.dart';
import '../providers/providers.dart';
import '../tetris_game.dart';

class HighScoresPage extends ConsumerStatefulWidget {
  HighScoresPage({super.key, required this.game});
  TetrisGame game;

  @override
  ConsumerState<HighScoresPage> createState() => _HighScoresPageState();
}

class _HighScoresPageState extends ConsumerState<HighScoresPage> {

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final highScore = ref.watch(highScoreNotifier);
    return Material(
      child: Container(
        color: const Color.fromARGB(200, 20, 20, 20),
        padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 30),
        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gapH12,
            Row(
              children: [
                BackButtonWidget(onTapped: widget.game.router.pop),
              ],
            ),
            gapH32,
            Text(
              'High Scores',
              style: textTheme.headline4,
            ),
            gapH24,
            if (widget.game.isGameOver) ...[
              Text(
                'Nickname: ${highScore.userName}\n'
                'Points: ${widget.game.points}\nRows: ${widget.game.rows}',
                textAlign: TextAlign.start,
                style: textTheme.headline6,
              ),
              gapH12,
              OutlinedButton(
                onPressed: () {
                  widget.game.isGameOver = false;
                  ref.read(highScoreNotifier.notifier).addCurrentScore();
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
            Text('App Version: ${highScore.appVersion}'),
          ],
        ),
      ),
    );
  }
}
