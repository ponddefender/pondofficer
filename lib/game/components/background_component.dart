import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:pond_defender_mini/game/pond_defender_game.dart';

class BackgroundComponent extends SpriteComponent with HasGameReference<PondDefenderGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Load background image
    sprite = await game.loadSprite('pond_background.png');
    
    // Set size to match the game screen
    size = game.size;

    // Add lily pads overlay with reduced opacity (underwater effect)
    final lilyPads = SpriteComponent()
      ..sprite = await game.loadSprite('lily_pads.png')
      ..size = game.size
      ..paint.color = const Color.fromRGBO(255, 255, 255, 0.35);
    
    add(lilyPads);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    // Ensure background resizes if screen size changes
    this.size = size;
    // Update children sizes if necessary
    for (final child in children) {
      if (child is PositionComponent) {
        child.size = size;
      }
    }
  }
}
