import 'package:flutter/material.dart';
import 'package:pond_defender_mini/data/user_progress.dart';
import 'package:pond_defender_mini/game/managers/audio_manager.dart';
import 'package:pond_defender_mini/widgets/jelly_button.dart';

class AquariumScreen extends StatefulWidget {
  const AquariumScreen({super.key});

  @override
  State<AquariumScreen> createState() => _AquariumScreenState();
}

class _AquariumScreenState extends State<AquariumScreen>
    with SingleTickerProviderStateMixin {
  late FishSkin _selectedSkin;
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _selectedSkin = UserProgress().selectedSkin;

    // Floating animation for fish preview
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalStars = UserProgress().getTotalStars();

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/pond_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Semi-transparent overlay
          Container(
            color: Colors.black.withValues(alpha: 0.4),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            'assets/images/fish_orange_frame1.png',
                            width: 32,
                            height: 32,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Aquarium',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.black45,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Stars counter
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Colors.white, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              '$totalStars',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Fish Preview
                Expanded(
                  flex: 2,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _floatAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _floatAnimation.value),
                          child: child,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF006994).withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          _getFishAsset(_selectedSkin),
                          width: 120,
                          height: 120,
                        ),
                      ),
                    ),
                  ),
                ),

                // Selected skin name
                Text(
                  _selectedSkin.displayName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black45,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Fish Selection Grid
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: FishSkin.values.length,
                      itemBuilder: (context, index) {
                        final skin = FishSkin.values[index];
                        final isUnlocked = UserProgress().isSkinUnlocked(skin);
                        final isSelected = _selectedSkin == skin;

                        return _buildSkinCard(
                          skin: skin,
                          isUnlocked: isUnlocked,
                          isSelected: isSelected,
                          totalStars: totalStars,
                        );
                      },
                    ),
                  ),
                ),

                // Back button
                Padding(
                  padding: const EdgeInsets.only(bottom: 40, top: 16),
                  child: JellyButton(
                    onPressed: () => Navigator.pop(context),
                    color: const Color(0xFF4ECDC4),
                    child: const Text('BACK'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkinCard({
    required FishSkin skin,
    required bool isUnlocked,
    required bool isSelected,
    required int totalStars,
  }) {
    return GestureDetector(
      onTap: isUnlocked
          ? () async {
              AudioManager.playTap();
              setState(() => _selectedSkin = skin);
              await UserProgress().setSelectedSkin(skin);
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4ECDC4).withValues(alpha: 0.8)
              : const Color(0xFF2D3436).withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.2),
            width: isSelected ? 3 : 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4ECDC4).withValues(alpha: 0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            // Fish image
            Center(
              child: Opacity(
                opacity: isUnlocked ? 1.0 : 0.4,
                child: Image.asset(
                  _getFishAsset(skin),
                  width: 64,
                  height: 64,
                ),
              ),
            ),

            // Skin name at bottom
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Text(
                skin.displayName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isUnlocked
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ),

            // Lock overlay for locked skins
            if (!isUnlocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock_rounded,
                        color: Colors.white70,
                        size: 32,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$totalStars / ${skin.starsRequired}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            // Checkmark for selected skin
            if (isSelected && isUnlocked)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Color(0xFF4ECDC4),
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getFishAsset(FishSkin skin) {
    switch (skin) {
      case FishSkin.orange:
        return 'assets/images/fish_orange_frame1.png';
      case FishSkin.gold:
        return 'assets/images/fish_gold.png';
    }
  }
}
