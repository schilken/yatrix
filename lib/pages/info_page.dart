import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../tetris_game.dart';

class InfoPage extends StatelessWidget {
  InfoPage({super.key, required this.game});

  final TetrisGame game;
  final markdown = '''

# About YaTrix

## The Name
Yet Another Tetris

## What
YaTris is just another Tetris like game. Therefore the name YaTrix = **Y**et **A**nother Tet**ris**.

## How
It's coded in Dart using the Flame-Engine on top of Flutter.

## Why
Tetris is one of the most played games of all time. It was programmed for more than xx devices.
Because I'm ecploring the Flame-Engine, I chose Tetris as a nice challenge to make it run on the 
Flame-Engine.

## Who
I'm a Senior Software developer working as a freelancer since 1986. 
Meanwhile I'm 66 years old and are no longer working fulltime in projects.
But if I'm offered an interesting project, I'm happy to work with other colleagues for a while.

## Runs on
- iOS, search Apple's App Store for YaTrix
- Android, search Google's Play Store
- macOS, download it from GitHub 
- Web, start it right on your browser on Smartphone or Desktop
- Should also run on Linux, but I haven't tested it and you have to dowload the source code from GitHub and build it yourself.
- Should also run on Windows, but the same applies as for linux.

## If there are glitches

In browsers of older devices you will not be able to play smoothly. In this case better install
the native version from Googles Play Store or Apples App Store. 

These versions are also free without ads or in app purchases.

''';

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
            SizedBox(height: 10),
            Row(
              children: [
                OutlinedButton(
                  onPressed: game.router.pop,
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
              'Info',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white60,
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: Markdown(
                //            controller: controller,
                data: markdown,
                selectable: true,
                padding: const EdgeInsets.all(0),
                styleSheet: MarkdownStyleSheet().copyWith(
                  h1Padding: const EdgeInsets.only(top: 12, bottom: 4),
                  h1: const TextStyle(
                    color: Colors.white60,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  h2Padding: const EdgeInsets.only(top: 12, bottom: 4),
                  h2: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white60,
                  ),
                  p: const TextStyle(
                    fontSize: 16,
                    color: Colors.white60,
                  ),
                  listBullet: TextStyle(
                    fontSize: 16,
                    color: Colors.white60,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
