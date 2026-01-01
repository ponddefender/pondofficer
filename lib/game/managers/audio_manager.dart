import 'package:flame_audio/flame_audio.dart';
import 'package:pond_defender_mini/data/user_progress.dart';

class AudioManager {
  static Future<void> preloadAll() async {
    await FlameAudio.audioCache.loadAll([
      'bgm_pond_zen.mp3',
      'sfx_splash.mp3',
      'sfx_tap.mp3',
      'sfx_duck_quack.mp3',
      'sfx_level_complete.mp3',
      'sfx_game_over.mp3',
    ]);
  }

  // === Music Controls ===
  static void playBgm() {
    if (!UserProgress().isMusicEnabled) return;
    FlameAudio.bgm.play('bgm_pond_zen.mp3', volume: 0.6);
  }

  static void stopBgm() {
    FlameAudio.bgm.stop();
  }

  static void pauseBgm() {
    FlameAudio.bgm.pause();
  }

  static void resumeBgm() {
    if (!UserProgress().isMusicEnabled) return;
    FlameAudio.bgm.resume();
  }

  // Called when music setting changes
  static void onMusicSettingChanged(bool enabled) {
    if (enabled) {
      playBgm();
    } else {
      stopBgm();
    }
  }

  // === Sound Effects ===
  static void _playSfx(String file) {
    if (!UserProgress().isSfxEnabled) return;
    FlameAudio.play(file);
  }

  static void playSplash() {
    _playSfx('sfx_splash.mp3');
  }

  static void playTap() {
    _playSfx('sfx_tap.mp3');
  }

  static void playDuckQuack() {
    _playSfx('sfx_duck_quack.mp3');
  }

  static void playLevelComplete() {
    _playSfx('sfx_level_complete.mp3');
  }

  static void playGameOver() {
    _playSfx('sfx_game_over.mp3');
  }
}
