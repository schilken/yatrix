import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../tetris_game.dart';

class HighScoresPage extends ConsumerWidget {
  HighScoresPage({super.key, required this.game});
  TetrisGame game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highScore = ref.read(highScoreNotifier);
    return Material(
      child: Container(
        color: Color.fromARGB(255, 20, 20, 20),
        padding: const EdgeInsets.fromLTRB(60.0, 0, 60, 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
                onPressed: () => game.router.pop(), child: Text('<')),
            SizedBox(height: 64),
            Text(
              'High Scores',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white60,
              ),
            ),
            SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: highScore.scores.length,
                itemBuilder: (context, index) {
                  final score = highScore.scores[index];
                  return ListTile(
                      title: Text(
                    score,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white60,
                    ),
                  ));
                },
              ),
            ),
            SizedBox(height: 32),
            Text(
              'User Name → ${highScore.userName}',
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white60,
              ),
            ),
            TextField(),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: ref.read(highScoreNotifier.notifier).addCurrentScore,
              child: Text('Save  Points: ${highScore.currentScore}'),
            )
          ],
        ),
      ),
    );
  }
}
