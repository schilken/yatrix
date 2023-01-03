import 'package:flutter/material.dart';

import '../tetris_game.dart';

class UsernameDialog extends StatelessWidget {
  UsernameDialog({super.key, required this.game});
  TetrisGame game;

  @override
  Widget build(BuildContext context) {
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
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(
                    'Entry $index',
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
              'User Name',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white60,
              ),

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
