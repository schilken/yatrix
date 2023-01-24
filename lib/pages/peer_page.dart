import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants/app_sizes.dart';
import '../custom_widgets/custom_widgets.dart';
import '../providers/providers.dart';
import '../tetris_game.dart';
import 'peer_client_view.dart';
import 'peer_server_view.dart';

class PeerPage extends ConsumerWidget {
  PeerPage({super.key, required this.game});
  TetrisGame game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final peerState = ref.watch(peerNotifier);
    final peerConnectState = ref.watch(peerClientNotifier);
    final peerServerState = ref.watch(peerServerNotifier);
    final isEnabled = peerState.isEnabled;
    final isServer = peerState.isServer;
    return Material(
      child: Container(
        color: const Color.fromARGB(255, 20, 20, 20),
        padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 30),
        child: Column(
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
              'Two-Player Configuration',
              style: textTheme.headline4,
            ),
            gapH48,
            StyledSwitch(
              label: 'Two-Player Mode',
              value: peerState.isEnabled,
              onChanged: (value) {
                ref.read(peerNotifier.notifier).enableTwoPlayerMode(value);
              },
            ),
            gapH12,
            if (isEnabled &&
                peerConnectState.clientState == ClientState.notConnected &&
                peerServerState.serverState == ServerState.notStarted)
              StyledSwitch(
                label: 'Activate 2-Player-Server',
                value: isServer,
                onChanged: ref.read(peerNotifier.notifier).setIsServer,
              ),
            gapH12,
            if (isEnabled && !isServer) const PeerClientView(),
            if (isEnabled && isServer) const PeerServerView()
          ],
        ),
      ),
    );
  }
}
