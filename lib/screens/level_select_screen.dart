import 'package:flutter/material.dart';
import 'package:pond_defender_mini/data/user_progress.dart';
import 'package:pond_defender_mini/game/managers/audio_manager.dart';
import 'package:pond_defender_mini/screens/game_screen.dart';

class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({super.key});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  // Use FutureBuilder or init state to load data?
  // Since UserProgress is async on writes but synchronous on reads after init, 
  // we need to make sure it's initialized.
  // Actually UserProgress methods are synchronous reads except init/writes?
  // Let's check UserProgress implementation...
  // getLevelStars and isLevelUnlocked are synchronous in my implementation.
  // However, SharedPreferences.getInstance is async.
  // We should initialize UserProgress in main.dart or SplashScreen.
  
  @override
  void initState() {
    super.initState();
    // Force refresh or ensure loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                'assets/images/fish_orange_frame1.png',
                width: 28,
                height: 28,
              ),
            ),
          ),
        ),
        title: Text(
          'Select Level',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/pond_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.85, // Taller for stars
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 10,
            itemBuilder: (context, index) {
              final level = index + 1;
              final isUnlocked = UserProgress().isLevelUnlocked(level);
              final stars = UserProgress().getLevelStars(level);
              
              return GestureDetector(
                onTap: () {
                  if (isUnlocked) {
                    AudioManager.playTap();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameScreen(levelId: level),
                      ),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/ui_wooden_panel.png'),
                      fit: BoxFit.contain,
                    ),
                    // Optional: Dim if locked
                    color: isUnlocked ? null : Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10), // Approximate for panel
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Level Number or Lock
                      Expanded(
                        child: Center(
                          child: !isUnlocked
                              ? Icon(Icons.lock, color: Colors.brown[800], size: 32)
                              : Text(
                                  '$level',
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                        color: const Color(0xFF5D4037),
                                      ),
                                ),
                        ),
                      ),
                      
                      // Star Rating (Only if unlocked)
                      if (isUnlocked)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (i) {
                              return Icon(
                                i < stars ? Icons.star : Icons.star_border,
                                size: 16,
                                color: i < stars ? Colors.amber : Colors.brown[300],
                              );
                            }),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
