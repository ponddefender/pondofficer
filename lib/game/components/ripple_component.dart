import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:pond_defender_mini/game/components/enemy_component.dart';
import 'package:pond_defender_mini/game/managers/audio_manager.dart';
import 'package:pond_defender_mini/game/pond_defender_game.dart';

class RippleComponent extends CircleComponent with HasGameReference<PondDefenderGame> {
  final double forceStrength = 500.0; // Adjustable force
  final double rippleRadius = 150.0; // Effective radius

  RippleComponent({required Vector2 position})
      : super(
          position: position,
          radius: 100, // Visual base radius (will scale to 150)
          anchor: Anchor.center,
          paint: Paint()
            ..color = Colors.white.withValues(alpha: 0.6)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Play sound
    AudioManager.playSplash();

    scale = Vector2.zero();

    // Expand animation: Scale 0 -> 1.5x (Visual radius reaches 150)
    add(
      ScaleEffect.to(
        Vector2.all(1.5),
        EffectController(duration: 0.5, curve: Curves.easeOut),
      ),
    );

    // Fade out animation
    add(
      OpacityEffect.fadeOut(
        EffectController(duration: 0.5, curve: Curves.easeOut),
        onComplete: () => removeFromParent(),
      ),
    );
    
    // Apply Physics Push
    _applyPushForce();
  }

  void _applyPushForce() {
    // Find all enemies
    final enemies = game.children.whereType<EnemyComponent>();

    for (final enemy in enemies) {
      final distance = position.distanceTo(enemy.position);

      // Check if within effective radius
      if (distance < rippleRadius) {
        // Calculate direction
        final direction = (enemy.position - position).normalized();
        
        // Calculate force
        // Formula: velocity += direction * force / weight
        // I will delegate the velocity change to the enemy
        enemy.applyForce(direction * forceStrength);
      }
    }
  }
}
