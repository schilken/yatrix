import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_sizes.dart';
import '../providers/providers.dart';

class PeerClientView extends ConsumerStatefulWidget {
  const PeerClientView({super.key});

  @override
  ConsumerState<PeerClientView> createState() => _PeerClientViewState();
}

class _PeerClientViewState extends ConsumerState<PeerClientView> {
  late TextEditingController _idEditingController;
  late TextEditingController _messageEditingController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _idEditingController = TextEditingController();
    _messageEditingController = TextEditingController();
    _focusNode = FocusNode();
    _idEditingController.text = ''; //ref.read(peerNotifier).remotePeerId;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final peerClientState = ref.watch(peerClientNotifier);
    return Column(
      children: [
        if (peerClientState.clientState == ClientState.notConnected ||
            peerClientState.clientState == ClientState.error) ...[
          Text(
            'If you want to connect to your player buddy\'s server, enter their Id here.',
            style: textTheme.headline6,
          ),
          gapH24,
          TextField(
            controller: _idEditingController,
            focusNode: _focusNode,
            autofocus: true,
            autocorrect: false,
            cursorColor: Colors.white60,
            keyboardType: TextInputType.number,
            style: textTheme.headline5,
            decoration: InputDecoration(
              hintText: 'Enter ID of your Server',
              hintStyle: textTheme.bodyText1,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white60),
              ),
            ),
          ),
        ],
        if (peerClientState.clientState == ClientState.error) ...[
          gapH8,
          Text(
            peerClientState.message,
            style: textTheme.headline6?.copyWith(color: Colors.red),
          ),
        ],
        gapH24,
        if (peerClientState.clientState == ClientState.notConnected ||
            peerClientState.clientState == ClientState.error)
          OutlinedButton(
            onPressed: () {
              ref
                  .read(peerClientNotifier.notifier)
                  .connect(remotePeerId: _idEditingController.text);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white60,
              side: const BorderSide(color: Colors.white60),
            ),
            child: const Text('Connect'),
          ),
        if (peerClientState.clientState == ClientState.connecting ||
            peerClientState.clientState == ClientState.connected)
          Text(
            peerClientState.message,
            style: textTheme.headline6,
          ),
        gapH8,
        if (peerClientState.clientState == ClientState.connecting)
          const CircularProgressIndicator(),
        gapH24,
        if (peerClientState.clientState == ClientState.connected ||
            peerClientState.clientState == ClientState.connecting)
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
        if (peerClientState.clientState == ClientState.connected) ...[
          gapH24,
          TextField(
            controller: _messageEditingController,
            focusNode: _focusNode,
            autofocus: true,
            autocorrect: false,
            cursorColor: Colors.white60,
            style: textTheme.bodyText1,
            decoration: InputDecoration(
              hintText: 'Enter your message',
              hintStyle: textTheme.bodyText1,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white60),
              ),
            ),
          ),
          gapH12,
          OutlinedButton(
            onPressed: () {
              ref
                  .read(peerServiceProvider)
                  .sendMessage(_messageEditingController.text);
              _messageEditingController.text = '';
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white60,
              side: const BorderSide(color: Colors.white60),
            ),
            child: const Text('Send message to Peer'),
          ),
        ],
      ],
    );
  }
}
