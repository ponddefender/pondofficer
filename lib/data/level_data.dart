class LevelData {
  final int levelId;
  final int duration;
  final double spawnRate;
  final List<String> enemyTypes;
  final int fishCount;

  const LevelData({
    required this.levelId,
    required this.duration,
    required this.spawnRate,
    required this.enemyTypes,
    required this.fishCount,
  });
}

const levels = [
  // Learning phase (Levels 1-3): Gentle introduction with slow spawns
  LevelData(levelId: 1, duration: 30, spawnRate: 8.0, enemyTypes: ['raccoon'], fishCount: 5),
  LevelData(levelId: 2, duration: 35, spawnRate: 7.0, enemyTypes: ['raccoon'], fishCount: 5),
  LevelData(levelId: 3, duration: 40, spawnRate: 6.0, enemyTypes: ['raccoon'], fishCount: 6),
  // Intermediate phase (Levels 4-6): Introduce new enemies, moderate difficulty
  LevelData(levelId: 4, duration: 45, spawnRate: 5.0, enemyTypes: ['raccoon', 'duck'], fishCount: 6),
  LevelData(levelId: 5, duration: 50, spawnRate: 4.5, enemyTypes: ['raccoon', 'duck'], fishCount: 7),
  LevelData(levelId: 6, duration: 50, spawnRate: 4.0, enemyTypes: ['duck', 'heron'], fishCount: 7),
  // Advanced phase (Levels 7-10): Full challenge with all enemy types
  LevelData(levelId: 7, duration: 60, spawnRate: 3.5, enemyTypes: ['raccoon', 'duck', 'heron'], fishCount: 8),
  LevelData(levelId: 8, duration: 60, spawnRate: 3.0, enemyTypes: ['raccoon', 'duck'], fishCount: 8),
  LevelData(levelId: 9, duration: 75, spawnRate: 2.5, enemyTypes: ['raccoon', 'duck', 'heron'], fishCount: 9),
  LevelData(levelId: 10, duration: 60, spawnRate: 2.0, enemyTypes: ['raccoon', 'duck', 'heron'], fishCount: 10),
];