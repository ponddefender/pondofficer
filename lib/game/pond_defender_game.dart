import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pond_defender_mini/data/level_data.dart';
import 'package:pond_defender_mini/game/components/background_component.dart';
import 'package:pond_defender_mini/game/components/fish_component.dart';
import 'package:pond_defender_mini/game/components/ripple_component.dart';
import 'package:pond_defender_mini/game/managers/audio_manager.dart';
import 'package:pond_defender_mini/game/managers/spawn_manager.dart';

class PondDefenderGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  // Ripple Gauge System
  double rippleEnergy = 1.0; // 0.0 to 1.0
  final double rippleCost = 0.15; // Reduced cost for more responsive tapping
  final double rippleRechargeRate = 0.5; // Faster recharge for rapid taps
  late SpriteComponent gaugeIcon;
  
  // Phase 2: Add ScreenHitbox
  late ScreenHitbox screenHitbox;
  
  // Phase 3 & 4: Game State
  int fishRemaining = 0;
  int initialFishCount = 3;
  
  // Level Management
  final int levelId;
  late LevelData levelData;
  double timeRemaining = 30.0;
  bool isGameOver = false;
  bool isVictory = false;

  // Notifiers for HUD
  final ValueNotifier<int> fishCountNotifier = ValueNotifier(3);
  final ValueNotifier<int> timerNotifier = ValueNotifier(30);

  // Callbacks
  final VoidCallback? onGameOver;
  final Function(int stars)? onLevelComplete;

  PondDefenderGame({
    this.levelId = 1,
    this.onGameOver,
    this.onLevelComplete,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load Level Data
    levelData = levels.firstWhere(
      (l) => l.levelId == levelId,
      orElse: () => levels[0],
    );
    
    // Initialize Level Params
    initialFishCount = levelData.fishCount;
    fishRemaining = initialFishCount;
    timeRemaining = levelData.duration.toDouble();
    
    // Update Notifiers
    fishCountNotifier.value = fishRemaining;
    timerNotifier.value = timeRemaining.ceil();

    // Preload audio & Play BGM
    await AudioManager.preloadAll();
    AudioManager.playBgm();

    // 1. Environment
    add(BackgroundComponent());
    
    screenHitbox = ScreenHitbox();
    add(screenHitbox);

    // 4. Ripple Gauge Visual
    final gaugeSprite = await loadSprite('ui_ripple_gauge.png');
    gaugeIcon = SpriteComponent(
      sprite: gaugeSprite,
      anchor: Anchor.bottomCenter,
      position: Vector2(size.x / 2, size.y - 20),
      size: Vector2(64, 64),
      priority: 10,
    );
    add(gaugeIcon);
    
    // Phase 3: Entities
    // Spawn Fish with Staggered Entrance
    for (int i = 0; i < initialFishCount; i++) {
        // Stagger entrance by adding with delay
        final delay = i * 0.2;
        add(
          TimerComponent(
            period: delay,
            removeOnFinish: true,
            onTick: () {
              if (!isGameOver && !isVictory) {
                 add(FishComponent(
                    position: size / 2 + Vector2((i - (initialFishCount/2)) * 60.0, 0),
                 ));
              }
            }
          )
        );
    }
    
    // Spawn Manager
    add(SpawnManager(
      spawnRate: levelData.spawnRate,
      enemyTypes: levelData.enemyTypes,
    ));
  }

  @override
  void onRemove() {
    AudioManager.stopBgm();
    super.onRemove();
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (isGameOver || isVictory) return;

    // 2. The Player (Ripple)
    // Check gauge
    if (rippleEnergy >= rippleCost) {
      // Spawn Ripple
      add(RippleComponent(position: event.localPosition));
      
      // Drain gauge
      rippleEnergy -= rippleCost;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver || isVictory) return;

    // Timer Logic
    timeRemaining -= dt;
    if (timeRemaining <= 0) {
        timeRemaining = 0;
        _checkVictory();
    }
    // Update notifier (integer seconds)
    if (timerNotifier.value != timeRemaining.ceil()) {
        timerNotifier.value = timeRemaining.ceil();
    }

    // 4. Ripple Gauge System - Recharge
    if (rippleEnergy < 1.0) {
      rippleEnergy += rippleRechargeRate * dt;
      if (rippleEnergy > 1.0) rippleEnergy = 1.0;
    }

    // Update Visuals
    if (rippleEnergy < rippleCost) {
      gaugeIcon.paint.color = Colors.white.withValues(alpha: 0.3);
    } else {
      gaugeIcon.paint.color = Colors.white.withValues(alpha: 1.0);
    }
    
    gaugeIcon.position = Vector2(size.x / 2, size.y - 20);
  }

  void onFishLost() {
    fishRemaining--;
    fishCountNotifier.value = fishRemaining;
    
    if (fishRemaining <= 0) {
        _gameOver();
    }
  }

  void _gameOver() {
      if (isGameOver) return;
      isGameOver = true;
      AudioManager.stopBgm(); // Stop BGM on Game Over
      AudioManager.playGameOver();
      pauseEngine();
      onGameOver?.call();
  }

  void _checkVictory() {
      if (isVictory) return;
      if (fishRemaining > 0) {
          isVictory = true;
          AudioManager.stopBgm(); // Stop BGM on Victory
          AudioManager.playLevelComplete();
          pauseEngine();
          
          // Calculate Stars
          // 3 stars = 0 lost
          // 2 stars = 1 lost
          // 1 star = 2+ lost
          final lost = initialFishCount - fishRemaining;
          int stars = 1;
          if (lost == 0) {
            stars = 3;
          } else if (lost == 1) {
            stars = 2;
          }
          
          onLevelComplete?.call(stars);
      } else {
          _gameOver();
      }
  }
}
