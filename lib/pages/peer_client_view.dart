import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yatrix/components/id_input_widget.dart';

import '../helpers/app_sizes.dart';
import '../providers/providers.dart';

class PeerClientView extends ConsumerStatefulWidget {
  const PeerClientView({super.key});

  @override
  ConsumerState<PeerClientView> createState() => _PeerClientViewState();
}

class _PeerClientViewState extends ConsumerState<PeerClientView> {
  int _serverId = 0;

  @override
  void initState() {
    super.initState();
  }

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
            'If you want to connect to your player buddy\'s server, put their ID onto the clipboard and press the connect button.',
            style: textTheme.headline6,
          ),
          gapH24,
          // IdInputWidget(
          //   initialValue: int.parse(peerClientState.remotePeerId),
          //   onChanged: (value) => _serverId = value,
          // ),
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
          OutlinedButton(
            onPressed: () {
              ref
                  .read(peerClientNotifier.notifier)
                  .connect();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white60,
              side: const BorderSide(color: Colors.white60),
            ),
            child: const Text('Connect'),
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
          OutlinedButton(
            onPressed: () {
              ref.read(peerNotifier.notifier).setIsEnabled(false);
              ref.read(peerClientNotifier.notifier).disConnect();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white60,
              side: const BorderSide(color: Colors.white60),
            ),
            child: const Text('Disconnect'),
          ),

      ],
    );
  }
}
