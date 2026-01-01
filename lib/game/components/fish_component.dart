import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:pond_defender_mini/data/user_progress.dart';
import 'package:pond_defender_mini/game/components/enemy_component.dart';
import 'package:pond_defender_mini/game/pond_defender_game.dart';

class FishComponent extends SpriteAnimationComponent
    with HasGameReference<PondDefenderGame>, CollisionCallbacks {
  final Random _random = Random();
  late Vector2 _targetPosition;
  final double _speed = 50.0;
  late Timer _wanderTimer;
  bool _isScared = false;

  FishComponent({super.position})
      : super(
          size: Vector2.all(48), // Adjust size as needed
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load animation frames based on selected skin
    final selectedSkin = UserProgress().selectedSkin;
    final List<Sprite> sprites;

    if (selectedSkin == FishSkin.gold) {
      // Gold fish uses single static sprite (no animation frames available)
      final goldSprite = await game.loadSprite('fish_gold.png');
      sprites = [goldSprite, goldSprite, goldSprite, goldSprite];
    } else {
      // Default orange fish with animation
      sprites = [
        await game.loadSprite('fish_orange_frame1.png'),
        await game.loadSprite('fish_orange_frame2.png'),
        await game.loadSprite('fish_orange_frame3.png'),
        await game.loadSprite('fish_orange_frame4.png'),
      ];
    }

    animation = SpriteAnimation.spriteList(
      sprites,
      stepTime: 0.25, // 4 FPS
      loop: true,
    );

    // Add collision hitbox
    add(CircleHitbox());

    // Initialize wander behavior
    _pickNewTarget();
    _wanderTimer = Timer(2.0, onTick: _pickNewTarget, repeat: true);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_isScared) return;

    _wanderTimer.update(dt);

    // Move towards target
    final direction = (_targetPosition - position).normalized();
    position += direction * _speed * dt;

    // Rotate towards direction (smoothly or instantly)
    // Angle 0 is right, so we use atan2
    angle = atan2(direction.y, direction.x);

    // Bounce off screen edges (soft bounce logic handled by picking new target if close to edge?)
    // Or explicit bounce:
    if (position.x <= 0 ||
        position.x >= game.size.x ||
        position.y <= 0 ||
        position.y >= game.size.y) {
      _pickNewTarget(); // Pick a new target inside bounds immediately
      // Clamp position to stay inside
      position.x = position.x.clamp(0, game.size.x);
      position.y = position.y.clamp(0, game.size.y);
    }
  }

  void _pickNewTarget() {
    // Pick a random point on the screen
    final screenWidth = game.size.x;
    final screenHeight = game.size.y;
    
    // Add some padding so they don't hug the edge too much
    final padding = 50.0;
    
    double targetX = padding + _random.nextDouble() * (screenWidth - 2 * padding);
    double targetY = padding + _random.nextDouble() * (screenHeight - 2 * padding);
    
    _targetPosition = Vector2(targetX, targetY);

    // Squash & Stretch Effect on direction change
    // Reset scale first (keeping direction flip from elsewhere if any, but we rotate via angle so scale.x/y should be 1.0)
    scale = Vector2.all(1.0);
    add(
      ScaleEffect.by(
        Vector2(1.2, 0.8), // Stretch length, squash width
        EffectController(
          duration: 0.2, 
          reverseDuration: 0.2, 
          curve: Curves.easeInOut
        )
      )
    );
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is EnemyComponent) {
        // Handle collision with enemy
        _getScaredAndDespawn();
    }
  }

  void _getScaredAndDespawn() {
    if (_isScared) return;
    _isScared = true;
    
    // Simple "scared" effect: scale down/fade out or speed away
    // Plan says: Fish plays "scared" animation -> removes from game
    
    add(
      ScaleEffect.to(
        Vector2.zero(),
        EffectController(duration: 0.5),
        onComplete: () {
          removeFromParent();
          // Decrement fish count in game
           game.onFishLost();
        },
      ),
    );
  }
}
