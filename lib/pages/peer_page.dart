import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../tetris_game.dart';


class PeerPage extends ConsumerWidget {
  PeerPage({super.key, required this.game});
  TetrisGame game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final peerState = ref.watch(peerNotifier);
    final peerConnectState = ref.watch(peerClientNotifier);
    final peerServerState = ref.watch(peerServerNotifier);
    final isEnabled = peerState.isEnabled;
    final isServer = peerState.isServer;
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
              'Two-Players Configuration',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white60,
              ),
            ),
            SizedBox(height: 48),
            ...[
            Row(
              children: [
                Text(
                    'Two-Player Mode',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white60,
                    ),
                  ),
                  Spacer(),
                  Switch(
                    // This bool value toggles the switch.
                    value: peerState.isEnabled,
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
                      ref.read(peerNotifier.notifier).setIsEnabled(value);
                    },
                  ),
                ],
              ),
            ],
            SizedBox(height: 12),
            if (isEnabled &&
                peerConnectState.clientState == ClientState.notConnected &&
                peerServerState.serverState == ServerState.notStarted) ...[
              Row(
                children: [
                  Text(
                    'Acticate Two-Player-Server',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white60,
                  ),
                ),
                Spacer(),
                Switch(
                  // This bool value toggles the switch.
                    value: isServer,
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
                      ref.read(peerNotifier.notifier).setIsServer(value);
                  },
                ),
              ],
            ),
            ],
            SizedBox(height: 12),
            if (isEnabled && !isServer) PeerClientView(),
            if (isEnabled && isServer) PeerServerView()
          ],
        ),
      ),
    );
  }
}

class PeerClientView extends ConsumerStatefulWidget {
  const PeerClientView({super.key});

  @override
  ConsumerState<PeerClientView> createState() => _PeerClientViewState();
}

class _PeerClientViewState extends ConsumerState<PeerClientView> {
  late TextEditingController _idEditingController;
  late TextEditingController _messageEditingController;
  late ScrollController _scrollController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _idEditingController = TextEditingController();
    _messageEditingController = TextEditingController();
    _scrollController = ScrollController();
    _focusNode = FocusNode();
    _idEditingController.text = ''; //ref.read(peerNotifier).remotePeerId;
  }

  @override
  Widget build(BuildContext context) {
    final peerClientState = ref.watch(peerClientNotifier);
    return Column(children: [
      if (peerClientState.clientState == ClientState.notConnected ||
          peerClientState.clientState == ClientState.error) ...[
      Text(
        'If you want to connect to your player buddy\'s server, enter their Id here.',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white60,
        ),
      ),
      SizedBox(height: 24),
      TextField(
          controller: _idEditingController,
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
      if (peerClientState.clientState == ClientState.error) ...[
        SizedBox(height: 8),
        Text(
          peerClientState.message,
          style: TextStyle(
            fontSize: 16,
            color: Colors.red,
          ),
        ),
      ],
      SizedBox(height: 24),
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
          child: Text('Connect'),
        ),
      if (peerClientState.clientState == ClientState.connecting ||
          peerClientState.clientState == ClientState.connected)
        Text(
          peerClientState.message,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white60,
          ),
        ),
      SizedBox(height: 8),
      if (peerClientState.clientState == ClientState.connecting)
        CircularProgressIndicator(),
      SizedBox(height: 24),
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
          child: Text('Disconnect'),
        ),

      if (peerClientState.clientState == ClientState.connected) ...[
        SizedBox(height: 24),
        TextField(
          controller: _messageEditingController,
          focusNode: _focusNode,
          autofocus: true,
          autocorrect: false,
          cursorColor: Colors.white60,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white60,
          ),
          decoration: InputDecoration(
            hintText: 'Enter your message',
            hintStyle: const TextStyle(
              fontSize: 14,
              color: Colors.white60,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white60),
            ),
          ),
        ),
        SizedBox(height: 12),
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
          child: Text('Send message to Peer'),
        ),
      ],

    ]);
  }
}

class PeerServerView extends ConsumerWidget {
  const PeerServerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final peerServerState = ref.watch(peerServerNotifier);
    return Column(children: [
      if (peerServerState.serverState == ServerState.notStarted) ...[
        Text(
          'You are the server. Start the server and tell your player buddy the Server ID.',
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
          onPressed: () {
            ref.read(peerServerNotifier.notifier).stop();
            ref.read(peerNotifier.notifier).setIsEnabled(false);
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white60,
            side: const BorderSide(color: Colors.white60),
          ),
          child: Text('Stop Server'),
        ),
    ]);
  }
}
