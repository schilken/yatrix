import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/app_sizes.dart';
import '../providers/providers.dart';

class PeerServerView extends ConsumerWidget {
  const PeerServerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final peerServerState = ref.watch(peerServerNotifier);
    final isNotConnected =
        peerServerState.serverState == ServerState.notStarted ||
            peerServerState.serverState == ServerState.error;
    final isStarting = peerServerState.serverState == ServerState.starting;
    final isListening = peerServerState.serverState == ServerState.listening;
    final isConnected = peerServerState.serverState == ServerState.connected;

    return Column(
      children: [
        if (peerServerState.serverState == ServerState.notStarted) ...[
          Text(
            'Start the server and tell your player buddy the Server ID. '
            'You will find it also on the clipboard.',
            style: textTheme.headline6,
          ),
          gapH24,
          if (peerServerState.serverState == ServerState.notStarted)
            OutlinedButton(
              onPressed: ref.read(peerServerNotifier.notifier).start,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white60,
                side: const BorderSide(color: Colors.white60),
              ),
              child: const Text('Start Server'),
            ),
        ],
        if (isStarting || isListening || isConnected)
          Text(
            '${peerServerState.message} ${peerServerState.localPeerId}',
            style: textTheme.headline6,
          ),
        gapH8,
        if (isStarting || isListening)
          const CircularProgressIndicator(),
        gapH24,
        if (isListening || isConnected)
          OutlinedButton(
            onPressed: () {
              ref.read(peerServerNotifier.notifier).stop();
              ref.read(peerNotifier.notifier).setIsEnabled(false);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white60,
              side: const BorderSide(color: Colors.white60),
            ),
            child: const Text('Stop Server'),
          ),
      ],
    );
  }
}
