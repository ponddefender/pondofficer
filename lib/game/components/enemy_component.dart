import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:pond_defender_mini/game/components/fish_component.dart';
import 'package:pond_defender_mini/game/managers/audio_manager.dart';
import 'package:pond_defender_mini/game/pond_defender_game.dart';

enum EnemyType { raccoon, duck, heron }

class EnemyComponent extends SpriteComponent
    with HasGameReference<PondDefenderGame>, CollisionCallbacks, TapCallbacks {
  final EnemyType type;
  Vector2 velocity = Vector2.zero();
  final double weight;
  final double friction = 0.95;

  // AI State
  FishComponent? _targetFish;
  
  // Heron specific
  late Timer _heronAttackTimer;

  EnemyComponent({
    required Vector2 position,
    required this.type,
  })  : weight = _getWeight(type),
        super(
          position: position,
          size: Vector2.all(64),
          anchor: Anchor.center,
        );

  static double _getWeight(EnemyType type) {
    switch (type) {
      case EnemyType.raccoon:
        return 2.0; // Heavy
      case EnemyType.duck:
        return 0.5; // Light
      case EnemyType.heron:
        return 0.0; // N/A, interactable only via tap
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load sprite based on type
    String spritePath;
    switch (type) {
      case EnemyType.raccoon:
        spritePath = 'enemy_raccoon.png';
        break;
      case EnemyType.duck:
        spritePath = 'enemy_duck.png';
        AudioManager.playDuckQuack(); // Play quack
        break;
      case EnemyType.heron:
        spritePath = 'enemy_heron_shadow.png';
        break;
    }
    sprite = await game.loadSprite(spritePath);

    // Add Hitbox (different for Heron?)
    if (type != EnemyType.heron) {
      add(CircleHitbox());
    } else {
      // Heron needs to be tappable, so it needs a hitbox or checking tap in game
      add(CircleHitbox());
      
      // Heron specific setup
      // Pulsing effect
      add(
        OpacityEffect.to(
          0.5,
          EffectController(
            duration: 0.5,
            reverseDuration: 0.5,
            infinite: true,
          ),
        ),
      );
      
      _heronAttackTimer = Timer(2.0, onTick: _executeHeronAttack);
    }

    if (type == EnemyType.duck) {
        // Duck: Swim across, redirectable
        // Initial velocity towards center or random side
        final center = game.size / 2;
        final direction = (center - position).normalized();
        velocity = direction * 80.0; // Medium speed
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (type == EnemyType.heron) {
       _heronAttackTimer.update(dt);
       if (_targetFish != null && !_targetFish!.isRemoved) {
           position = _targetFish!.position;
       } else if (_targetFish == null || _targetFish!.isRemoved) {
           removeFromParent();
       }
       return; 
    }

    // Raccoon Logic: Chase nearest fish
    if (type == EnemyType.raccoon) {
        _updateRaccoonBehavior(dt);
    }
    
    // Physics application
    position += velocity * dt;
    velocity *= friction;

    // Stop if velocity is very low
    if (velocity.length < 5) {
      // For Raccoon, we want it to keep moving if it has a target
      if (type != EnemyType.raccoon) {
          velocity = Vector2.zero();
      }
    }
    
    // Optional: Face movement direction
    if (velocity.length > 10) {
        if (velocity.x < 0) {
             scale.x = -1.0 * scale.x.abs(); // Flip sprite if moving left, preserve scale magnitude
        } else {
             scale.x = 1.0 * scale.x.abs();
        }
    }
  }

  void _updateRaccoonBehavior(double dt) {
     // Find nearest fish
     FishComponent? nearestFish;
     double minDistance = double.infinity;
     
     game.children.query<FishComponent>().forEach((fish) {
         final distance = position.distanceTo(fish.position);
         if (distance < minDistance) {
             minDistance = distance;
             nearestFish = fish;
         }
     });

     if (nearestFish != null) {
         final direction = (nearestFish!.position - position).normalized();
         
         final desiredVelocity = direction * 40.0; // Slow speed
         final steering = desiredVelocity - velocity;
         velocity += steering * dt * 2.0; // Steering force
     }
  }
  
  void _executeHeronAttack() {
      // Capture the fish
      if (_targetFish != null && !_targetFish!.isRemoved) {
          // Fish captured logic
          _targetFish!.removeFromParent();
           game.onFishLost();
      }
      removeFromParent(); // Heron leaves after attack
  }

  // Allow setting target for Heron
  void setTarget(FishComponent fish) {
      _targetFish = fish;
  }

  void applyForce(Vector2 force) {
    if (type == EnemyType.heron) return; // Heron shadow can't be pushed
    velocity += force / weight;

    // Stretch effect
    add(
      ScaleEffect.by(
        Vector2(1.3, 0.7), 
        EffectController(
          duration: 0.1, 
          reverseDuration: 0.1, 
          curve: Curves.easeInOut
        )
      )
    );

    // Particles (Water Droplets)
    for(int i=0; i<5; i++) {
       game.add(
         DropletComponent(
           position: position.clone(), 
           direction: force.normalized()
         )
       );
    }
  }
  
  @override
  void onTapDown(TapDownEvent event) {
      if (type == EnemyType.heron) {
          // Tap shadow to cancel attack
          removeFromParent();
          // Maybe play a sound or effect
      }
  }
}

class DropletComponent extends CircleComponent {
  final Vector2 direction;
  final Random _random = Random();
  double speed = 200.0;

  DropletComponent({required Vector2 position, required this.direction})
      : super(
          position: position,
          radius: 3,
          paint: Paint()..color = Colors.white.withValues(alpha: 0.8),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Randomize direction slightly
    double angle = atan2(direction.y, direction.x);
    angle += (_random.nextDouble() - 0.5) * 1.0; // +/- 0.5 radians
    final velocity = Vector2(cos(angle), sin(angle)) * (speed * (0.8 + _random.nextDouble() * 0.4));
    
    add(MoveEffect.by(
      velocity * 0.5, // Move for 0.5s
      EffectController(duration: 0.5, curve: Curves.decelerate),
    ));

    add(OpacityEffect.fadeOut(
      EffectController(duration: 0.5),
      onComplete: () => removeFromParent(),
    ));
  }
}
