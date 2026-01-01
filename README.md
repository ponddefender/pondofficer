# 🐟 Pond Defender mini

A casual arcade game where you protect koi fish from hungry predators by creating ripples in the pond.

## 🎮 Game Overview

**Pond Defender** is a zen-like arcade game where you act as the guardian spirit of a koi pond. Tap the water to create ripples that push away hungry animals trying to catch your fish!

### Core Gameplay
- **Observe** enemies entering the pond
- **React** by tapping to create ripples
- **Survive** by keeping at least one fish safe until time runs out

## 🛠️ Tech Stack

- **Framework:** Flutter 3.38.5
- **Game Engine:** Flame 1.34
- **Audio:** flame_audio 2.11
- **State Management:** Provider
- **Persistence:** SharedPreferences

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point
├── game/
│   ├── pond_defender_game.dart  # Main Flame game class
│   ├── components/              # Game entities
│   │   ├── fish_component.dart
│   │   ├── enemy_component.dart
│   │   ├── ripple_component.dart
│   │   └── background_component.dart
│   └── managers/                # Game systems
│       ├── level_manager.dart
│       ├── audio_manager.dart
│       └── spawn_manager.dart
├── screens/                     # Flutter UI screens
├── widgets/                     # Reusable UI components
├── providers/                   # State management
├── data/                        # Level configs & save data
└── theme/                       # Design system
```

## 🎨 Assets

### Images (`assets/images/`)
| File | Description |
|------|-------------|
| `pond_background.png` | Water texture background |
| `lily_pads.png` | Decorative lily pads |
| `fish_gold.png` | Premium golden koi skin |
| `fish_orange_frame1-4.png` | Orange koi animation frames |
| `enemy_duck.png` | Duck enemy sprite |
| `enemy_raccoon.png` | Raccoon enemy sprite |
| `enemy_heron_shadow.png` | Heron shadow silhouette |
| `ui_button_play.png` | Green play button |
| `ui_button_pause.png` | Red pause button |
| `ui_wooden_panel.png` | UI panel background |
| `ui_ripple_gauge.png` | Ripple cooldown indicator |

### Audio (`assets/audio/`)
| File | Description |
|------|-------------|
| `bgm_pond_zen.mp3` | Background music loop |
| `sfx_splash.mp3` | Water tap sound |
| `sfx_tap.mp3` | UI tap feedback |
| `sfx_duck_quack.mp3` | Duck sound |
| `sfx_level_complete.mp3` | Victory jingle |
| `sfx_game_over.mp3` | Defeat sound |

### Fonts
- **Sniglet** (Headlines) - Soft, balloon-like
- **Comfortaa** (Body) - Geometric, rounded

## 🚀 Getting Started

### Local Development

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Run the app:**
   ```bash
   flutter run
   ```

3. **Build for release:**
   ```bash
   flutter build appbundle  # Android AAB
   flutter build apk        # Android APK
   flutter build ios        # iOS
   ```

---

## 🔐 Build Pipeline (GitHub Actions)

This project includes an automated CI/CD pipeline for building signed Android releases.

### Quick Start

1. **Generate Keystore** (run locally):
   ```powershell
   # Windows
   .\scripts\generate_keystore.ps1
   
   # macOS/Linux
   ./scripts/generate_keystore.sh
   ```

2. **Add GitHub Secrets:**
   | Secret Name | Description |
   |-------------|-------------|
   | `HOMYENS_KEYSTORE_BASE64` | Base64 encoded keystore |
   | `HOMYENS_STORE_PASSWORD` | Keystore password |
   | `HOMYENS_KEY_PASSWORD` | Key password |
   | `HOMYENS_KEY_ALIAS` | Key alias |

3. **Trigger Build:**
   - Push to `main`, `master`, or `develop`
   - Or manually trigger from Actions tab

4. **Download Artifacts:**
   - `pond-defender-apk` - Signed APK
   - `pond-defender-aab` - Signed AAB (for Play Store)

### Security Guarantees

✅ **Keystore script does NOT collect:**
- System information
- User/account data
- IP addresses
- Location data

✅ **GitHub workflow:**
- Never prints secrets in logs
- Deletes keystore after build
- Uses GitHub's secret masking

📚 **Full documentation:** [`docsfile/BUILD_PIPELINE.md`](docsfile/BUILD_PIPELINE.md)

---

## 📚 Documentation

- [`docsfile/gamegdd.md`](docsfile/gamegdd.md) - Game Design Document
- [`docsfile/designGuides.md`](docsfile/designGuides.md) - Design Language System
- [`docsfile/implementationplan.md`](docsfile/implementationplan.md) - Development Roadmap
- [`docsfile/BUILD_PIPELINE.md`](docsfile/BUILD_PIPELINE.md) - Build Pipeline Guide

## 🎯 Development Status

| Phase | Focus | Status |
|-------|-------|--------|
| 1 | Project Setup | ✅ Complete |
| 2 | Core Mechanics | ✅ Complete |
| 3 | Entities & AI | ✅ Complete |
| 4 | UI Integration | ✅ Complete |
| 5 | Level System | ✅ Complete |
| 6 | Polish & Audio | ✅ Complete |
| 7 | Build Pipeline | ✅ Complete |

## 🔒 Privacy

This app is **completely offline** and does not collect any user data:
- No internet connection required
- No account registration
- No personal information collected
- All progress stored locally on device

## 📄 License

This project is for personal/educational use.
