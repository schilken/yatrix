# YaTriX

Yet Another Tetris Clone, made with Flutter and Flame-Engine.

## Getting Started

- Have an installation of Flutter version 3.3.x or later
- Clone this repo.
- flutter pub get
- Run in Chrome:
`flutter run -d Chrome`

Build for deployment:
`flutter build web --web-renderer canvaskit`

Deploy to web server: copy contents of folder build/web:


## A tiny teaser

Running the game in a local browser

<img src="assets_for_readme/yatrix_menu.gif"/>

<img src="assets_for_readme/yatrix.gif"/>


## Online Web Version
You can play the game here:[https://schilken.de/yatrix](https://schilken.de/yatrix)

## The Two-Player Mode

See the Info-Page in the app for a step-by-step guide.

Or this video:

https://user-images.githubusercontent.com/2171717/215270024-50eb1cd0-2dc8-4bbe-8b25-cc1d3f2df9fc.mp4

You see YaTriX as a macOS app on the left. Here I start the server-mode and wait for a connection. The serverId is copied to the clipboard.

The web version of YaTriX is running in a Safari browser to the right.
Here I connect to the serverId found on the clipboard.

A two-player game can only be initiated by the server. 
The client then gets a dialog displayed, on which he can start the game on both sides at the same time and with the same squence of blocks.

## By the Way
The two-player mode is implemented using the [peerdart package](https://github.com/MuhammedKpln/peerdart), 
which in turn uses the package [flutter_webrtc](https://github.com/flutter-webrtc/flutter-webrtc).

A special thanks goes to the developers of these packages – and of course to all participants in the flutter ecosystem

