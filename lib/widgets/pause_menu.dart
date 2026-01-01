import 'package:flutter/material.dart';
import 'package:pond_defender_mini/game/managers/audio_manager.dart';
import 'package:pond_defender_mini/widgets/jelly_button.dart';

class PauseMenu extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onHome;

  const PauseMenu({
    super.key,
    required this.onResume,
    required this.onRestart,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 300,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/ui_wooden_panel.png'),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'PAUSED',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: const Color(0xFF5D4037),
                  ),
            ),
            const SizedBox(height: 30),
            JellyButton(
              onPressed: onResume,
              child: const Text('RESUME'),
            ),
            const SizedBox(height: 16),
            JellyButton(
              onPressed: onRestart,
              color: const Color(0xFF4ECDC4),
              child: const Text('RESTART'),
            ),
            const SizedBox(height: 16),
            JellyButton(
              onPressed: onHome,
              color: const Color(0xFFFF9F43),
              child: const Text('HOME'),
            ),
          ],
        ),
      ),
    );
  }
}

class GameOverOverlay extends StatefulWidget {
  final bool isVictory;
  final int stars;
  final VoidCallback onRestart;
  final VoidCallback onHome;

  const GameOverOverlay({
    super.key,
    required this.isVictory,
    this.stars = 0,
    required this.onRestart,
    required this.onHome,
  });

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
    });
    
    _animations = _controllers.map((controller) {
      return CurvedAnimation(parent: controller, curve: Curves.elasticOut);
    }).toList();

    if (widget.isVictory) {
      _playStarAnimations();
    }
  }

  Future<void> _playStarAnimations() async {
    // Wait a bit before starting
    await Future.delayed(const Duration(milliseconds: 300));
    
    for (int i = 0; i < widget.stars; i++) {
      if (!mounted) return;
      _controllers[i].forward();
      AudioManager.playTap();
      await Future.delayed(const Duration(milliseconds: 400));
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          width: 320,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/images/ui_wooden_panel.png'),
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.isVictory ? 'Level Cleared!' : 'GAME OVER',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: const Color(0xFF5D4037),
                      fontWeight: FontWeight.bold,
                      fontSize: widget.isVictory ? 28 : 32,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (widget.isVictory) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                     // If index < stars, it's a collected star (animated)
                     // If index >= stars, it's an empty star (static)
                     if (index < widget.stars) {
                        return ScaleTransition(
                          scale: _animations[index],
                          child: const Icon(Icons.star, size: 48, color: Colors.amber),
                        );
                     } else {
                        return const Icon(Icons.star_border, size: 48, color: Colors.amber);
                     }
                  }),
                ),
                const SizedBox(height: 20),
              ] else ...[
                 const Text(
                   "Out of Fish!",
                   style: TextStyle(fontSize: 18, color: Color(0xFF5D4037)),
                 ),
                 const SizedBox(height: 20),
              ],
              
              JellyButton(
                onPressed: widget.onRestart,
                child: Text(widget.isVictory ? 'NEXT LEVEL' : 'TRY AGAIN'), 
              ),
              const SizedBox(height: 16),
              JellyButton(
                onPressed: widget.onHome,
                color: const Color(0xFFFF9F43),
                child: const Text('HOME'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
