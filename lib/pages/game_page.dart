import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../custom_widgets/responsive_center.dart';
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
          next.message,
          next.isEnabled,
          next.isServer,
        ); // TODO(as) only for easier testing
      },
    );
    return Container(
      color: Colors.black,
      child: ResponsiveCenter(
        maxContentWidth: 500,
        child: GameWidget(
          game: game = TetrisGame(widgetRef: ref),
          loadingBuilder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
