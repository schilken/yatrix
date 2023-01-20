import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/peer_notifier.dart';
import '../tetris_game.dart';

class GamePage extends ConsumerWidget {
  GamePage({super.key});

  late TetrisGame game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<PeerState>(
      peerNotifier,
      (previous, next) {
        game.handlePeerCommand(
            next.message, next.isEnabled); // TODO(as) only for easier testing
      },
    );
    return GameWidget(
      game: game = TetrisGame(widgetRef: ref),
      loadingBuilder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
