import 'package:flutter/material.dart';
import 'package:pond_defender_mini/game/pond_defender_game.dart';

class GameHud extends StatelessWidget {
  final PondDefenderGame game;
  final VoidCallback onPause;

  const GameHud({
    super.key,
    required this.game,
    required this.onPause,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Fish Count
              ValueListenableBuilder<int>(
                valueListenable: game.fishCountNotifier,
                builder: (context, count, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Text('🐟', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                        Text(
                          '$count/${game.initialFishCount}',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Timer (Comfortaa Bold per Phase 4 plan)
              ValueListenableBuilder<int>(
                valueListenable: game.timerNotifier,
                builder: (context, seconds, child) {
                  return Text(
                    '$seconds',
                    style: const TextStyle(
                          fontFamily: 'Comfortaa',
                          fontWeight: FontWeight.w700,
                          fontSize: 48,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                  );
                },
              ),

              // Pause Button
              GestureDetector(
                onTap: onPause,
                child: Image.asset(
                  'assets/images/ui_button_pause.png',
                  width: 50,
                  height: 50,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
