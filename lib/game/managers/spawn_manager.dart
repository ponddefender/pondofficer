import 'dart:math';

import 'package:flame/components.dart';
import 'package:pond_defender_mini/game/components/enemy_component.dart';
import 'package:pond_defender_mini/game/components/fish_component.dart';
import 'package:pond_defender_mini/game/pond_defender_game.dart';

class SpawnManager extends Component with HasGameReference<PondDefenderGame> {
  late Timer _spawnTimer;
  final Random _random = Random();
  double spawnRate;
  final List<String> enemyTypes;

  SpawnManager({
    this.spawnRate = 4.0,
    required this.enemyTypes,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _spawnTimer = Timer(spawnRate, onTick: _spawnEnemy, repeat: true);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _spawnTimer.update(dt);
  }

  void _spawnEnemy() {
    if (enemyTypes.isEmpty) return;

    // 1. Pick Enemy Type from allowed list
    final typeString = enemyTypes[_random.nextInt(enemyTypes.length)];
    EnemyType type;
    
    switch (typeString) {
      case 'raccoon':
        type = EnemyType.raccoon;
        break;
      case 'duck':
        type = EnemyType.duck;
        break;
      case 'heron':
        type = EnemyType.heron;
        break;
      default:
        type = EnemyType.raccoon;
    }

    // 2. Handle Heron Special Case (needs target)
    if (type == EnemyType.heron) {
      final fishList = game.children.query<FishComponent>();
      if (fishList.isEmpty) return; // No fish to target
      
      final targetFish = fishList.elementAt(_random.nextInt(fishList.length));
      final heron = EnemyComponent(
        position: targetFish.position.clone(),
        type: EnemyType.heron,
      );
      heron.setTarget(targetFish);
      game.add(heron);
      return;
    }

    // 3. Pick Spawn Position (Random Edge)
    Vector2 spawnPos;
    final size = game.size;
    final edge = _random.nextInt(4); // 0: top, 1: right, 2: bottom, 3: left
    
    switch (edge) {
      case 0: // Top
        spawnPos = Vector2(_random.nextDouble() * size.x, -50);
        break;
      case 1: // Right
        spawnPos = Vector2(size.x + 50, _random.nextDouble() * size.y);
        break;
      case 2: // Bottom
        spawnPos = Vector2(_random.nextDouble() * size.x, size.y + 50);
        break;
      case 3: // Left
        spawnPos = Vector2(-50, _random.nextDouble() * size.y);
        break;
      default:
        spawnPos = Vector2.zero();
    }

    // 4. Add Enemy
    game.add(EnemyComponent(position: spawnPos, type: type));
  }
}
