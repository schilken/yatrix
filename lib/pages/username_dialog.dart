import 'package:flutter/material.dart';

import '../tetris_game.dart';

class UsernameDialog extends StatelessWidget {
  UsernameDialog({super.key, required this.game});
  TetrisGame game;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
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
              style: TextStyle(fontSize: 32),
            ),
            SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(title: Text('Entry $index'));
                },
              ),
            ),
            SizedBox(height: 32),
            Text(
              'User Name',
              textAlign: TextAlign.start,
            ),
            TextField(),
            SizedBox(height: 24),
            ElevatedButton(onPressed: () {}, child: Text('Save  Points: 12000'))
          ],
        ),
      ),
    );
  }
}
