import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../tetris_game.dart';

class PeerPage extends ConsumerWidget {
  PeerPage({super.key, required this.game});
  TetrisGame game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final peerAsyncState = ref.watch(peerNotifier);
    final isActive = peerAsyncState.hasValue
        ? peerAsyncState?.value?.activatePeerServer ?? false
        : false;
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
                  value: isActive,
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
                    ref
                        .read(peerNotifier.notifier)
                        .setActivatePeerServer(value);
                    game.showFps = value;
                  },
                ),
              ],
            ),
            SizedBox(height: 12),
            if (!isActive) PeerClientSection(),
            if (isActive)
              Text(
                'You are the server. Tell your player buddy this Server ID: ${peerAsyncState?.value?.localPeerId ?? ""}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white60,
                ),
              ),
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
    final peerConnectState = ref.watch(peerConnectNotifier);
    return Column(children: [
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
      SizedBox(height: 24),
      if (peerConnectState.connectState == ConnectState.notConnected)
        OutlinedButton(
          onPressed: () {
            ref
                .read(peerConnectNotifier.notifier)
                .connect(remotePeerId: _textEditingController.text);
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white60,
            side: const BorderSide(color: Colors.white60),
          ),
          child: Text('Connect'),
        ),
      if (peerConnectState.connectState == ConnectState.connecting ||
          peerConnectState.connectState == ConnectState.connected)
        Text(
          peerConnectState.message,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white60,
          ),
        ),
      SizedBox(height: 24),
      if (peerConnectState.connectState == ConnectState.connected)
        OutlinedButton(
          onPressed: () {
            ref.read(peerConnectNotifier.notifier).disConnect();
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
