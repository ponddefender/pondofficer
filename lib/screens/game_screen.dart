import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pond_defender_mini/data/user_progress.dart';
import 'package:pond_defender_mini/game/pond_defender_game.dart';
import 'package:pond_defender_mini/widgets/game_hud.dart';
import 'package:pond_defender_mini/widgets/pause_menu.dart';

class GameScreen extends StatefulWidget {
  final int levelId;
  const GameScreen({super.key, this.levelId = 1});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late PondDefenderGame _game;
  bool _isPaused = false;
  bool _isGameOver = false;
  bool _isVictory = false;
  int _starsEarned = 0;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    _game = PondDefenderGame(
      levelId: widget.levelId,
      onGameOver: () {
        setState(() {
          _isGameOver = true;
          _isVictory = false;
        });
      },
      onLevelComplete: (stars) async {
        setState(() {
          _isGameOver = true;
          _isVictory = true;
          _starsEarned = stars;
        });
        
        // Save Progress
        await UserProgress().saveLevelStars(widget.levelId, stars);
        // Unlock next level (if exists)
        if (widget.levelId < 10) { // Max 10 levels
            await UserProgress().unlockLevel(widget.levelId + 1);
        }
      },
    );
    _isPaused = false;
    _isGameOver = false;
    _isVictory = false;
    _starsEarned = 0;
  }

  void _pauseGame() {
    if (_isGameOver) return;
    setState(() {
      _isPaused = true;
    });
    _game.pauseEngine();
  }

  void _resumeGame() {
    setState(() {
      _isPaused = false;
    });
    _game.resumeEngine();
  }

  void _restartGame() {
    setState(() {
       // Re-create game instance to restart
       _initGame();
    });
  }
  
  void _nextLevel() {
      if (widget.levelId < 10) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => GameScreen(levelId: widget.levelId + 1),
            ),
          );
      } else {
          // All levels done
          Navigator.pop(context); // Go to level select
      }
  }

  void _goHome() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Game Layer
          GameWidget(game: _game),

          // HUD Layer
          if (!_isPaused && !_isGameOver)
            GameHud(
              game: _game,
              onPause: _pauseGame,
            ),

          // Pause Menu Layer
          if (_isPaused)
            Container(
              color: Colors.black.withValues(alpha: 0.4),
              child: PauseMenu(
                onResume: _resumeGame,
                onRestart: _restartGame,
                onHome: _goHome,
              ),
            ),

          // Game Over / Victory Layer
          if (_isGameOver)
            GameOverOverlay(
              isVictory: _isVictory,
              stars: _starsEarned,
              onRestart: _isVictory ? _nextLevel : _restartGame, // Use Next Level if victory
              onHome: _goHome,
            ),
        ],
      ),
    );
  }
}
