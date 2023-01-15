import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../tetris_game.dart';

final peerSwitchProvider = StateProvider<bool>((ref) {
  return false;
});

class PeerPage extends ConsumerWidget {
  PeerPage({super.key, required this.game});
  TetrisGame game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final peerSwitchState = ref.watch(peerSwitchProvider);
    final peerConnectState = ref.watch(peerClientNotifier);
    final peerServerState = ref.watch(peerServerNotifier);
    return Material(
      child: Container(
        color: Color.fromARGB(255, 20, 20, 20),
        padding: const EdgeInsets.fromLTRB(60.0, 0, 60, 30),
        child: Column(
//          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () => game.router.pop(),
                  child: Text('<'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white60,
                    side: BorderSide(color: Colors.white60),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            Text(
              'Peer Configuration',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white60,
              ),
            ),
            SizedBox(height: 48),
            if (peerConnectState.clientState == ClientState.notConnected &&
                peerServerState.serverState == ServerState.notStarted) ...[
            Row(
              children: [
                Text(
                  'This is the Peer Server',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white60,
                  ),
                ),
                Spacer(),
                Switch(
                  // This bool value toggles the switch.
                    value: peerSwitchState,
                  // inactiveThumbColor: Colors.white24,
                  // inactiveTrackColor: Colors.white24,
                  thumbColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.white70;
                    }
                    return Colors.grey;
                  }),
                  trackColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.grey.shade600;
                  }),
                  onChanged: (value) {
                      ref.read(peerSwitchProvider.notifier).state = value;
                    game.showFps = value;
                  },
                ),
              ],
            ),
            ],
            SizedBox(height: 12),
            if (!peerSwitchState) PeerClientSection() else PeerServerSection()
          ],
        ),
      ),
    );
  }
}

class PeerClientSection extends ConsumerStatefulWidget {
  const PeerClientSection({super.key});

  @override
  ConsumerState<PeerClientSection> createState() => _PeerClientSectionState();
}

class _PeerClientSectionState extends ConsumerState<PeerClientSection> {
  late TextEditingController _textEditingController;
  late ScrollController _scrollController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _scrollController = ScrollController();
    _focusNode = FocusNode();
    _textEditingController.text = ''; //ref.read(peerNotifier).remotePeerId;
  }

  @override
  Widget build(BuildContext context) {
    final peerConnectState = ref.watch(peerClientNotifier);
    return Column(children: [
      if (peerConnectState.clientState == ClientState.notConnected ||
          peerConnectState.clientState == ClientState.error) ...[
      Text(
        'If you want to connect to your player buddy\'s server, enter their Id here.',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white60,
        ),
      ),
      SizedBox(height: 24),
      TextField(
        controller: _textEditingController,
        focusNode: _focusNode,
        autofocus: true,
        autocorrect: false,
        cursorColor: Colors.white60,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white60,
        ),
        decoration: InputDecoration(
          hintText: 'Enter ID of your Server',
          hintStyle: const TextStyle(
            fontSize: 16,
            color: Colors.white60,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white60),
          ),
        ),
      ),
      ],
      if (peerConnectState.clientState == ClientState.error) ...[
        SizedBox(height: 8),
        Text(
          peerConnectState.message,
          style: TextStyle(
            fontSize: 16,
            color: Colors.red,
          ),
        ),
      ],
      SizedBox(height: 24),
      if (peerConnectState.clientState == ClientState.notConnected ||
          peerConnectState.clientState == ClientState.error)
        OutlinedButton(
          onPressed: () {
            ref
                .read(peerClientNotifier.notifier)
                .connect(remotePeerId: _textEditingController.text);
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white60,
            side: const BorderSide(color: Colors.white60),
          ),
          child: Text('Connect'),
        ),
      if (peerConnectState.clientState == ClientState.connecting ||
          peerConnectState.clientState == ClientState.connected)
        Text(
          peerConnectState.message,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white60,
          ),
        ),
      SizedBox(height: 8),
      if (peerConnectState.clientState == ClientState.connecting)
        CircularProgressIndicator(),
      SizedBox(height: 24),
      if (peerConnectState.clientState == ClientState.connected ||
          peerConnectState.clientState == ClientState.connecting)
        OutlinedButton(
          onPressed: () {
            ref.read(peerClientNotifier.notifier).disConnect();
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white60,
            side: const BorderSide(color: Colors.white60),
          ),
          child: Text('Disconnect'),
        ),


    ]);
  }
}

class PeerServerSection extends ConsumerWidget {
  const PeerServerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final peerServerState = ref.watch(peerServerNotifier);
    return Column(children: [
      if (peerServerState.serverState == ServerState.notStarted) ...[
        Text(
          'You are the server. Tell your player buddy this Server ID: ${peerServerState.serverPeerId}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white60,
          ),
        ),
        SizedBox(height: 24),
        if (peerServerState.serverState == ServerState.notStarted)
          OutlinedButton(
            onPressed: ref.read(peerServerNotifier.notifier).start,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white60,
              side: const BorderSide(color: Colors.white60),
            ),
            child: Text('Start Server'),
          ),
      ],
      if (peerServerState.serverState == ServerState.starting ||
          peerServerState.serverState == ServerState.listening ||
          peerServerState.serverState == ServerState.connected)
        Text(
          peerServerState.message,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white60,
          ),
        ),
      SizedBox(height: 8),
      if (peerServerState.serverState == ServerState.starting ||
          peerServerState.serverState == ServerState.listening)
        CircularProgressIndicator(),
      SizedBox(height: 24),
      if (peerServerState.serverState == ServerState.listening ||
          peerServerState.serverState == ServerState.connected)
        OutlinedButton(
          onPressed: ref.read(peerServerNotifier.notifier).stop,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white60,
            side: const BorderSide(color: Colors.white60),
          ),
          child: Text('Stop Server'),
        ),
    ]);
  }
}
