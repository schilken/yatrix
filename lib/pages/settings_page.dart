// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants/app_sizes.dart';
import '../custom_widgets/custom_widgets.dart';
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
        color: const Color.fromARGB(255, 20, 20, 20),
        padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 30),
        child: Column(
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
            StyledSlider(
              label: 'Background Music Volume',
              value: settings.musicVolume,
              onChanged: (double newMusicVolume) {
                game.setBackgroundMusicVolume(newMusicVolume);
                ref
                    .read(settingsNotifier.notifier)
                    .setMusicVolume(newMusicVolume);
              },
            ), 
            gapH24,
            StyledSlider(
              label: 'Sound EffectsVolume',
              value: settings.soundEffectsVolume,
              onChanged: (double newSoundEffectsVolume) {
                game.setSoundEffectsVolume(newSoundEffectsVolume);
                ref
                    .read(settingsNotifier.notifier)
                    .setSoundEffectsVolume(newSoundEffectsVolume);
              },
            ), 
            gapH24,
            StyledSlider(
              label: 'Velocity (${settings.velocity})',
              value: (settings.velocity.toDouble() - 50) / 250,
              onChanged: (double normalizedVelocity) {
                final newVelocity = 50 + normalizedVelocity * 250;
                game.setVelocity(newVelocity.toInt());
                ref
                    .read(settingsNotifier.notifier)
                    .setVelocity(newVelocity.toInt());
              },
            ),             
            gapH24,
            StyledSwitch(
              label: 'Show FPS',
              value: ref.read(settingsNotifier).showFps,
              onChanged: (value) {
                ref.read(settingsNotifier.notifier).setShowFps(value);
                game.showFps = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}



