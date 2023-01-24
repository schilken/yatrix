// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants/app_sizes.dart';
import '../custom_widgets/simple_button_widget.dart';
import '../custom_widgets/styled_textfield.dart';
import '../providers/providers.dart';
import '../tetris_game.dart';

class SettingsPage extends ConsumerWidget {
  SettingsPage({super.key, required this.game});
  TetrisGame game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sliderTheme = Theme.of(context).sliderTheme;
    final textTheme = Theme.of(context).textTheme;
    final settings = ref.watch(settingsNotifier);
    return Material(
      child: Container(
        color: const Color.fromARGB(255, 20, 20, 20),
        padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 30),
        child: Column(
//          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            gapH12,
            Row(
              children: [
                BackButtonWidget(onTapped: game.router.pop),
              ],
            ),
            gapH32,
            Text(
              'Settings',
              style: textTheme.headline4,
            ),
            gapH48,
            StyledTextField(
              initialValue: settings.nickname,
              hintText: 'Enter Your Nickname',
              onChanged: ref.read(settingsNotifier.notifier).setNickname,
            ),
            gapH24,

            Text(
              'Background Music Volume',
              style: textTheme.headline5,
            ),
            SizedBox(
              width: 250.0,
              child: Slider(
                value: settings.musicVolume,
                label: '${settings.musicVolume * 10}',
                divisions: 10,
                thumbColor: sliderTheme.thumbColor,
                activeColor: sliderTheme.activeTrackColor,
                onChanged: (double newMusicVolume) {
                  game.setBackgroundMusicVolume(newMusicVolume);
                  ref
                      .read(settingsNotifier.notifier)
                      .setMusicVolume(newMusicVolume);
                },
              ),
            ),
            gapH24,
            Text(
              'Sound EffectsVolume',
              style: textTheme.headline5,
            ),
            SizedBox(
              width: 250.0,
              child: Slider(
                value: settings.soundEffectsVolume,
                label: '${settings.soundEffectsVolume * 10}',
                divisions: 10,
                thumbColor: sliderTheme.thumbColor,
                activeColor: sliderTheme.activeTrackColor,
                onChanged: (double newSoundEffectsVolume) {
                  game.setSoundEffectsVolume(newSoundEffectsVolume);
                  ref
                      .read(settingsNotifier.notifier)
                      .setSoundEffectsVolume(newSoundEffectsVolume);
                },
              ),
            ),
            gapH24,
            Text(
              'Velocity',
              style: textTheme.headline5,
            ),
            SizedBox(
              width: 250.0,
              child: Slider(
                value: settings.velocity.toDouble(),
                label: '${settings.velocity}',
                divisions: 10,
                min: 50,
                max: 300,
                thumbColor: sliderTheme.thumbColor,
                activeColor: sliderTheme.activeTrackColor,
                onChanged: (double newVelocity) {
                  game.setVelocity(newVelocity.toInt());
                  ref
                      .read(settingsNotifier.notifier)
                      .setVelocity(newVelocity.toInt());
                },
              ),
            ),
            gapH24,
            Row(
              children: [
                Text(
                  'Show FPS',
                  style: textTheme.headline5,
                ),
                const Spacer(),
                Switch(
                  // This bool value toggles the switch.
                  value: ref.read(settingsNotifier).showFps,
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



