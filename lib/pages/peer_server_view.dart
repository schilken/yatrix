import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_sizes.dart';
import '../providers/providers.dart';

class PeerServerView extends ConsumerWidget {
  const PeerServerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final peerServerState = ref.watch(peerServerNotifier);
    return Column(
      children: [
        if (peerServerState.serverState == ServerState.notStarted) ...[
          Text(
            'You are the server. Start the server and tell your player buddy the Server ID.',
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
        if (peerServerState.serverState == ServerState.starting ||
            peerServerState.serverState == ServerState.listening ||
            peerServerState.serverState == ServerState.connected)
          Text(
            peerServerState.message,
            style: textTheme.headline6,
          ),
        gapH8,
        if (peerServerState.serverState == ServerState.starting ||
            peerServerState.serverState == ServerState.listening)
          const CircularProgressIndicator(),
        gapH24,
        if (peerServerState.serverState == ServerState.listening ||
            peerServerState.serverState == ServerState.connected)
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
