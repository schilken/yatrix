import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../tetris_game.dart';

class SettingsPage extends ConsumerWidget {
  SettingsPage({super.key, required this.game});
  TetrisGame game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
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
                  onPressed: () => game.router.pop(),
                  child: Text('<'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white60,
                    side: BorderSide(color: Colors.white60),
                  ),
                ),
              ],
            ),
            SizedBox(height: 48),
            Text(
              'Settings',
              style: textTheme.headline4,
            ),
            SizedBox(height: 48),
            Text(
              'Background Music Volume',
              style: textTheme.headline5,
            ),
            SizedBox(height: 12),
            SizedBox(
              width: 250.0,
              child: Slider(
                value: settings.musicVolume,
                label: '${settings.musicVolume * 10}',
                divisions: 10,
                // thumbColor: Colors.white54,
                // activeColor: Colors.white70,
                onChanged: (double newMusicVolume) {
                  game.setBackgroundMusicVolume(newMusicVolume);
                  ref
                      .read(settingsNotifier.notifier)
                      .setMusicVolume(newMusicVolume);
                },
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Sound EffectsVolume',
              style: textTheme.headline5,
            ),
            SizedBox(height: 12),
            SizedBox(
              width: 250.0,
              child: Slider(
                value: settings.soundEffectsVolume,
                label: '${settings.soundEffectsVolume * 10}',
                divisions: 10,
                // thumbColor: Colors.white54,
                // activeColor: Colors.white70,
                onChanged: (double newSoundEffectsVolume) {
                  game.setSoundEffectsVolume(newSoundEffectsVolume);
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
                  style: textTheme.headline5,
                ),
                Spacer(),
                Switch(
                  // This bool value toggles the switch.
                  value: ref.read(settingsNotifier).showFps,
                  // inactiveThumbColor: Colors.white24,
                  // inactiveTrackColor: Colors.white24,
                  // thumbColor: MaterialStateProperty.resolveWith<Color>(
                  //     (Set<MaterialState> states) {
                  //   if (states.contains(MaterialState.selected)) {
                  //     return Colors.white70;
                  //   }
                  //   return Colors.grey;
                  // }),
                  // trackColor: MaterialStateProperty.resolveWith<Color>(
                  //     (Set<MaterialState> states) {
                  //   return Colors.grey.shade600;
                  // }),
                  onChanged: (value) {
                    ref.read(settingsNotifier.notifier).setShowFps(value);
                    game.showFps = value;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
