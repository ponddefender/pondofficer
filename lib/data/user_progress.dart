import 'package:shared_preferences/shared_preferences.dart';

// Available fish skins
enum FishSkin {
  orange('Orange Koi', 'fish_orange', 0),
  gold('Golden Koi', 'fish_gold', 15); // Requires 15 total stars to unlock

  final String displayName;
  final String assetPrefix;
  final int starsRequired;

  const FishSkin(this.displayName, this.assetPrefix, this.starsRequired);
}

class UserProgress {
  static const String _keyPrefix = 'level_';
  static const String _keyMusicEnabled = 'music_enabled';
  static const String _keySfxEnabled = 'sfx_enabled';
  static const String _keySelectedSkin = 'selected_skin';

  // Singleton instance
  static final UserProgress _instance = UserProgress._internal();
  factory UserProgress() => _instance;
  UserProgress._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    // Ensure level 1 is always unlocked
    if (!isLevelUnlocked(1)) {
      await unlockLevel(1);
    }
  }

  // === Level Progress ===
  bool isLevelUnlocked(int levelId) {
    return _prefs.getBool('$_keyPrefix${levelId}_unlocked') ?? false;
  }

  int getLevelStars(int levelId) {
    return _prefs.getInt('$_keyPrefix${levelId}_stars') ?? 0;
  }

  Future<void> unlockLevel(int levelId) async {
    await _prefs.setBool('$_keyPrefix${levelId}_unlocked', true);
  }

  Future<void> saveLevelStars(int levelId, int stars) async {
    // Only save if better score
    final currentStars = getLevelStars(levelId);
    if (stars > currentStars) {
      await _prefs.setInt('$_keyPrefix${levelId}_stars', stars);
    }
  }

  // Get total stars earned across all levels
  int getTotalStars() {
    int total = 0;
    for (int i = 1; i <= 10; i++) {
      total += getLevelStars(i);
    }
    return total;
  }

  // === Audio Settings ===
  bool get isMusicEnabled => _prefs.getBool(_keyMusicEnabled) ?? true;
  bool get isSfxEnabled => _prefs.getBool(_keySfxEnabled) ?? true;

  Future<void> setMusicEnabled(bool enabled) async {
    await _prefs.setBool(_keyMusicEnabled, enabled);
  }

  Future<void> setSfxEnabled(bool enabled) async {
    await _prefs.setBool(_keySfxEnabled, enabled);
  }

  // === Fish Skins ===
  FishSkin get selectedSkin {
    final skinName = _prefs.getString(_keySelectedSkin);
    if (skinName == null) return FishSkin.orange;
    try {
      return FishSkin.values.firstWhere((s) => s.name == skinName);
    } catch (_) {
      return FishSkin.orange;
    }
  }

  Future<void> setSelectedSkin(FishSkin skin) async {
    await _prefs.setString(_keySelectedSkin, skin.name);
  }

  bool isSkinUnlocked(FishSkin skin) {
    return getTotalStars() >= skin.starsRequired;
  }

  List<FishSkin> get unlockedSkins {
    return FishSkin.values.where((s) => isSkinUnlocked(s)).toList();
  }

  // Debug helper
  Future<void> clearProgress() async {
    await _prefs.clear();
    await unlockLevel(1);
  }
}
