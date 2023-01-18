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
    final textTheme = Theme.of(context).textTheme;
    final highScore = ref.watch(highScoreNotifier);
    return Material(
      child: Container(
        color: Color.fromARGB(200, 20, 20, 20),
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
              style: textTheme.headline4,
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
                  hintStyle: textTheme.bodyText1,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white60),
                  ),
                ),
              ),
            SizedBox(height: 12),
            if (widget.game.isGameOver)
              Text(
                'Points: ${widget.game.points}\nRows: ${widget.game.rows}',
                textAlign: TextAlign.start,
                style: textTheme.headline6,
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
                    textColor: Colors.white60,
                    tileColor: Colors.grey,
                    title: Text(
                      score.userName,
                      style: textTheme.headline6,
                    ),
                    subtitle: Text(
                      'Points: ${score.points}\nRows: ${score.rows}',
                      style: textTheme.headline6,
                    ),
                    shape: new RoundedRectangleBorder(
                        side: BorderSide(width: 2, color: Colors.amberAccent),
                        borderRadius: new BorderRadius.circular(15.0)),
                  );
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
