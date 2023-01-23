import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/app_sizes.dart';
import '../providers/providers.dart';

class PeerServerView extends ConsumerWidget {
  const PeerServerView({super.key});

void _onShare(BuildContext context, WidgetRef ref) async {
    // A builder is used to retrieve the context immediately
    // surrounding the ElevatedButton.
    //
    // The context's `findRenderObject` returns the first
    // RenderObject in its descendent tree when it's not
    // a RenderObjectWidget. The ElevatedButton's RenderObject
    // has its position and size after it's built.
    final box = context.findRenderObject() as RenderBox?;
    final rect = box!.localToGlobal(Offset.zero) & box.size;
    ref.read(peerServerNotifier.notifier).shareServerId(rect);
  }

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
            'Start the server and send the displayed ID to your fellow player. '
            'Use phone, email, iMessage, or whatever. '
            'You\'ll also find it on the clipboard.',
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
          SelectableText(
            '${peerServerState.message} ${peerServerState.localPeerId}',
            style: textTheme.headline6,
          ),
        gapH8,
        if (isStarting || isListening) ...[
          const CircularProgressIndicator(),
          gapH12,
          OutlinedButton(
            onPressed: () => _onShare(context, ref),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white60,
              side: const BorderSide(color: Colors.white60),
            ),
            child: const Text('Share ServerId'),
          ),
        ],
        gapH24,
        if (isListening || isConnected)
          OutlinedButton(
            onPressed: () {
              ref.read(peerServerNotifier.notifier).stop();
              ref.read(peerNotifier.notifier).enableTwoPlayerMode(false);
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
