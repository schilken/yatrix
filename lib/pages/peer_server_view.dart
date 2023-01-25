import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants/app_sizes.dart';
import '../custom_widgets/custom_widgets.dart';
import '../providers/providers.dart';

class PeerServerView extends ConsumerWidget {
  const PeerServerView({super.key});

void _onShare(BuildContext context, WidgetRef ref) {
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
    final isStarting = peerServerState.serverState == ServerState.starting;
    final isListening = peerServerState.serverState == ServerState.listening;
    final isConnected = peerServerState.serverState == ServerState.connected;

    return Column(
      children: [
        if (peerServerState.serverState == ServerState.notStarted) ...[
          Text(
            'Start the server and send the message containing your serverId to your fellow player. '
            "You'll find it on the clipboard. "
            'Use phone, email, iMessage, or whatever. ',
            style: textTheme.headline6,
          ),
          gapH24,
          if (peerServerState.serverState == ServerState.notStarted)
            StyledButton(
              label: 'Start Server',
              onPressed: ref.read(peerServerNotifier.notifier).start,
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
          StyledButton(
            label: 'Share ServerId',
            onPressed: () => _onShare(context, ref),
          ),
        ],
        gapH24,
        if (isListening || isConnected)
          StyledButton(
            label: 'Stop Server',
            onPressed: () {
              ref.read(peerServerNotifier.notifier).stop();
              ref.read(peerNotifier.notifier).enableTwoPlayerMode(false);
            },
          ),
      ],
    );
  }
}
