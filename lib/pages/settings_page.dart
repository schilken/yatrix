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
    _textEditingController.text = ref.read(highScoreNotifier).userName;
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsNotifier);
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
            SizedBox(height: 48),
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
                onChanged: (double newSoundEffectsVolume) {
                  widget.game.setSoundEffectsVolume(newSoundEffectsVolume);
                  ref
                      .read(settingsNotifier.notifier)
                      .setSoundEffectsVolume(newSoundEffectsVolume);
                },
              ),
            ),    
          ],
        ),
      ),
    );
  }
}
