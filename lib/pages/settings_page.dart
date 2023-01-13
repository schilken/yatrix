import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../tetris_game.dart';

class SettingsPage extends ConsumerStatefulWidget {
  SettingsPage({super.key, required this.game});
  TetrisGame game;

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  late TextEditingController _textEditingController;
  late ScrollController _scrollController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _scrollController = ScrollController();
    _focusNode = FocusNode();
    _textEditingController.text = ref.read(settingsNotifier).remotePeerId;
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsNotifier);
    _textEditingController.text = settings.remotePeerId;
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
                  onPressed: () => widget.game.router.pop(),
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
              'Settings',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white60,
              ),
            ),
            SizedBox(height: 32),
            Row(
              children: [
                Text(
                  'Enable Peer Server',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white60,
                  ),
                ),
                Spacer(),
                Switch(
                  // This bool value toggles the switch.
                  value: ref.read(settingsNotifier).activatePeerServer,
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
                        .read(settingsNotifier.notifier)
                        .setActivatePeerServer(value);
                    widget.game.showFps = value;
                  },
                ),
              ],
            ),
            if (!ref.watch(settingsNotifier).activatePeerServer) ...[
              Text(
                'If you want to connect to your player buddy\'s server, enter their Id here.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white60,
                ),
              ),
              SizedBox(height: 8),
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
              SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  widget.game.isGameOver = false;
                  ref
                      .read(settingsNotifier.notifier)
                      .connect(remotePeerId: _textEditingController.text);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white60,
                  side: const BorderSide(color: Colors.white60),
                ),
                child: Text('Connect'),
              ),
            ],
            if (ref.watch(settingsNotifier).activatePeerServer)
              Text(
                'You are the server. Tell your player buddy this Server ID: ${ref.watch(settingsNotifier).localPeerId}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white60,
                ),
              ),
            SizedBox(height: 24),
            Text(
              'Background Music Volume',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white60,
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: 250.0,
              child: Slider(
                value: settings.musicVolume,
                label: '${settings.musicVolume * 10}',
                divisions: 10,
                thumbColor: Colors.white54,
                activeColor: Colors.white70,
                onChanged: (double newMusicVolume) {
                  widget.game.setBackgroundMusicVolume(newMusicVolume);
                  ref
                      .read(settingsNotifier.notifier)
                      .setMusicVolume(newMusicVolume);
                },
              ),
            ),
            Text(
              'Sound EffectsVolume',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white60,
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: 250.0,
              child: Slider(
                value: settings.soundEffectsVolume,
                label: '${settings.soundEffectsVolume * 10}',
                divisions: 10,
                thumbColor: Colors.white54,
                activeColor: Colors.white70,
                onChanged: (double newSoundEffectsVolume) {
                  widget.game.setSoundEffectsVolume(newSoundEffectsVolume);
                  ref
                      .read(settingsNotifier.notifier)
                      .setSoundEffectsVolume(newSoundEffectsVolume);
                },
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Text(
                  'Show FPS',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white60,
                  ),
                ),
                Spacer(),
                Switch(
                  // This bool value toggles the switch.
                  value: ref.read(settingsNotifier).showFps,
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
                    ref.read(settingsNotifier.notifier).setShowFps(value);
                    widget.game.showFps = value;
                  },
                ),
              ],
            ),
            SizedBox(height: 24),

          ],
        ),
      ),
    );
  }
}
