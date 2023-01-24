import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../components/simple_button_widget.dart';
import '../constants/app_sizes.dart';
import '../tetris_game.dart';

class InfoPage extends StatelessWidget {
  InfoPage({super.key, required this.game});

  final TetrisGame game;
  final markdown = '''

# About YaTriX

## What
YaTriX is just another Tetris like game. Therefore the name YaTrix = **Y**et **A**nother Tet**ris**.

## How
This version is quite similar to all other Tetris-Clones: 

  Just try to fill full rows by moving the falling blocks left or right.

When a block touches any other block or the floor, you have half a second to move it to another position.
After that, it splits up in the containing squares and is fixed. 

For the high score your points are calculated like this: 
- Each filled row counts 200 points.
- The earlier you drop the block with the down button, the more points you get.

On desktop you can control the game also with the arrow keys on the keyboard.

## Two-Player-Mode
You can play against another player if you both have an internet connection.
These are the steps to setup a connection:
- The first player activates the Two-Player-Mode and then selects the 2-Player-Server.
- Then she taps **Start Server** and tells the second player her ServerId.
- The second player copies the received ServerId in his clipboard.
- Then he also activates the Two-Player-Mode and taps "Connect".
- Both players should now see the message 'connection opened'
- If you open the **Play** screen you should see a green cloud on the top.

To start a game: 
- The player, who started the server, tries to start the game as usual.
- There is not yet a block dropping, but a message 'Are you Ready?'
- The second player gets a dialog with the button **Start the Game**.
- If he taps this button the blocks begin to drop on both screens.

You see your own filling level on the left bar and your peer's level on the right.
 

## The Mosaic
The mosaic page came up as a by-product. 
Here you can select the falling blocks as you like.
On Desktop choose the keys S, Z, J, L, T, O and I on the keyboard

## Why
Tetris is one of the most played games of all time. 
According to Wikipedia, it has been sold more than 425 million times and was programmed for more than 65 platforms. 
Look up Wikipedia to read more about this fascinating game.
Because I'm exploring Dart, Flutter and Flame-Engine, I chose Tetris as a nice challenge to make it run on the 
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
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: Container(
        color: const Color.fromARGB(255, 20, 20, 20),
        padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            gapH12,
            Row(
              children: [
                BackButtonWidget(onTapped: game.router.pop),
              ],
            ),
            gapH32,
            Text(
              'Info',
              style: textTheme.headline4,  
            ),
            gapH24,
            Expanded(
              child: Markdown(
                //            controller: controller,
                data: markdown,
                selectable: true,
                padding: const EdgeInsets.all(0),
                styleSheet: MarkdownStyleSheet().copyWith(
                  h1Padding: const EdgeInsets.only(top: 12, bottom: 4),
                  h1: textTheme.headline4,
                  h2Padding: const EdgeInsets.only(top: 12, bottom: 4),
                  h2: textTheme.headline5,
                  p: textTheme.bodyText1,
                  listBullet: textTheme.bodyText1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
