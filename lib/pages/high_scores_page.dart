import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  late ScrollController _scrollController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _scrollController = ScrollController();
    _focusNode = FocusNode();
    _textEditingController.text = ref.read(highScoreNotifier).userName;
  }

  @override
  Widget build(BuildContext context) {
    final highScore = ref.watch(highScoreNotifier);
    return Material(
      child: Container(
        color: Color.fromARGB(255, 20, 20, 20),
        padding: const EdgeInsets.fromLTRB(60.0, 0, 60, 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
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
            SizedBox(height: 32),
            Text(
              'High Scores',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white60,
              ),
            ),
            SizedBox(height: 24),
            if (widget.game.isGameOver)
              TextField(
                controller: _textEditingController,
                focusNode: _focusNode,
                autofocus: true,
                autocorrect: false,
                cursorColor: Colors.white60,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white60,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter Your Name',
                  hintStyle: const TextStyle(
                    fontSize: 20,
                    color: Colors.white60,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white60),
                  ),
                ),
              ),
            SizedBox(height: 12),
            Text(
              highScore.currentScore,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 12),
            if (widget.game.isGameOver)
              OutlinedButton(
                onPressed: () {
                  widget.game.isGameOver = false;
                  ref.read(highScoreNotifier.notifier).addCurrentScoreFor(
                      userName: _textEditingController.text);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white60,
                  side: const BorderSide(color: Colors.white60),
                ),
                child: Text('Save Score'),
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
          ],
        ),
      ),
    );
  }
}
