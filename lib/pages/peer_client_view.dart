import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants/app_sizes.dart';
import '../custom_widgets/custom_widgets.dart';
import '../providers/providers.dart';

class PeerClientView extends ConsumerStatefulWidget {
  const PeerClientView({super.key});

  @override
  ConsumerState<PeerClientView> createState() => _PeerClientViewState();
}

class _PeerClientViewState extends ConsumerState<PeerClientView> {

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final peerClientState = ref.watch(peerClientNotifier);
    final isError = peerClientState.clientState == ClientState.error;
    final isNotConnected =
        peerClientState.clientState == ClientState.notConnected ||
            peerClientState.clientState == ClientState.error;
    final isConnecting = peerClientState.clientState == ClientState.connecting;
    final isConnected = peerClientState.clientState == ClientState.connected;
    return Column(
      children: [
        if (isNotConnected) ...[
          Text(
            "If you want to connect to your fellow player's server, "
            'copy his ServerId to the clipboard '
            'and press the "Connect" button.',
            style: textTheme.headline6,
          ),
          gapH24,
        ],
        if (isError) ...[
          gapH8,
          Text(
            peerClientState.message,
            style: textTheme.headline6?.copyWith(color: Colors.red),
          ),
        ],
        gapH24,
        if (isNotConnected)
          StyledButton(
            label: 'Connect',
            onPressed: () => ref
                  .read(peerClientNotifier.notifier)
                  .connect(),
          ),
        if (isConnecting || isConnected)
          Text(
            peerClientState.message,
            style: textTheme.headline6,
          ),
        gapH8,
        if (isConnecting)
          const CircularProgressIndicator(),
        gapH24,
        if (isConnecting || isConnected)
          StyledButton(
            label: 'Disconnect',
            onPressed: () {
              ref.read(peerNotifier.notifier).enableTwoPlayerMode(false);
              ref.read(peerClientNotifier.notifier).disConnect();
            },
          ),

      ],
    );
  }
}
