import 'package:flutter/material.dart';
import 'package:pond_defender_mini/screens/aquarium_screen.dart';
import 'package:pond_defender_mini/screens/level_select_screen.dart';
import 'package:pond_defender_mini/screens/settings_screen.dart';
import 'package:pond_defender_mini/widgets/jelly_button.dart';
import 'dart:math';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background (Static image)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/pond_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Animated Fish Background
          const _AnimatedFishLayer(),

          // Overlay gradient for readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.4),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Pond Defender',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    shadows: [
                      const Shadow(
                        blurRadius: 4,
                        color: Colors.black45,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                JellyButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LevelSelectScreen()),
                    );
                  },
                  child: const Text('PLAY'),
                ),
                const SizedBox(height: 20),
                JellyButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AquariumScreen(),
                      ),
                    );
                  },
                  color: const Color(0xFFFFD93D),
                  child: const Text('AQUARIUM'),
                ),
                const SizedBox(height: 20),
                JellyButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                  color: const Color(0xFF4ECDC4),
                  child: const Text('SETTINGS'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedFishLayer extends StatefulWidget {
  const _AnimatedFishLayer();

  @override
  State<_AnimatedFishLayer> createState() => _AnimatedFishLayerState();
}

class _AnimatedFishLayerState extends State<_AnimatedFishLayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_FishData> _fishes = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Spawn 5 random fish
    for (int i = 0; i < 5; i++) {
      _fishes.add(_generateRandomFish());
    }
  }

  _FishData _generateRandomFish() {
    return _FishData(
      yPos: 0.1 + _random.nextDouble() * 0.8, // 10% to 90% height
      speed: 0.2 + _random.nextDouble() * 0.3,
      startOffset: _random.nextDouble(),
      scale: 0.8 + _random.nextDouble() * 0.4,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: _fishes.map((fish) {
            // Calculate X position based on time + offset
            final t = (_controller.value * fish.speed + fish.startOffset) % 1.0;
            // Map 0..1 to -ScreenWidth..+ScreenWidth (swim across)
            // Use LayoutBuilder to get constraints if needed, or just use approximate relative positioning
            
            return Positioned(
              top: MediaQuery.of(context).size.height * fish.yPos,
              left: MediaQuery.of(context).size.width * (t * 1.4 - 0.2), // Swim from -20% to 120%
              child: Transform.scale(
                scale: fish.scale,
                child: Image.asset(
                  'assets/images/fish_orange_frame1.png', // Static frame for UI
                  width: 60,
                  height: 60,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _FishData {
  final double yPos;
  final double speed;
  final double startOffset;
  final double scale;

  _FishData({
    required this.yPos,
    required this.speed,
    required this.startOffset,
    required this.scale,
  });
}
