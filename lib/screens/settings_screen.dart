import 'package:flutter/material.dart';
import 'package:pond_defender_mini/data/user_progress.dart';
import 'package:pond_defender_mini/game/managers/audio_manager.dart';
import 'package:pond_defender_mini/widgets/jelly_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _musicEnabled;
  late bool _sfxEnabled;

  @override
  void initState() {
    super.initState();
    _musicEnabled = UserProgress().isMusicEnabled;
    _sfxEnabled = UserProgress().isSfxEnabled;
  }

  @override
  Widget build(BuildContext context) {
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
            color: Colors.black.withValues(alpha: 0.5),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Header with back button
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
                          'Settings',
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
                      const SizedBox(width: 48), // Balance the back button
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),

                        // Audio Settings Panel
                        _buildPanel(
                          title: 'Audio',
                          child: Column(
                            children: [
                              // Music Toggle
                              _buildToggleRow(
                                label: 'Music',
                                subtitle: 'Background music',
                                value: _musicEnabled,
                                onChanged: (value) async {
                                  setState(() => _musicEnabled = value);
                                  await UserProgress().setMusicEnabled(value);
                                  AudioManager.onMusicSettingChanged(value);
                                },
                              ),

                              const SizedBox(height: 16),
                              Divider(
                                color: Colors.white.withValues(alpha: 0.2),
                                height: 1,
                              ),
                              const SizedBox(height: 16),

                              // SFX Toggle
                              _buildToggleRow(
                                label: 'Sound Effects',
                                subtitle: 'Tap & splash sounds',
                                value: _sfxEnabled,
                                onChanged: (value) async {
                                  setState(() => _sfxEnabled = value);
                                  await UserProgress().setSfxEnabled(value);
                                  if (value) {
                                    AudioManager.playTap();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // AquaKnow (How to Play) Panel
                        _buildPanel(
                          title: 'AquaKnow',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow(
                                title: 'Your Goal',
                                description:
                                    'Protect your koi fish from hungry animals trying to catch them!',
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                title: 'How to Play',
                                description:
                                    'Tap the water to create ripples. These waves push enemies away from your fish.',
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                title: 'Enemies',
                                description:
                                    '🦝 Raccoons - Slow but heavy\n🦆 Ducks - Fast but easy to push\n🦅 Herons - Tap their shadow to scare them away!',
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                title: 'Tips',
                                description:
                                    '• Watch your ripple energy gauge\n• Prioritize enemies closest to fish\n• Earn 3 stars by losing no fish!',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Privacy Policy Panel
                        _buildPanel(
                          title: 'Privacy Policy',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4ECDC4)
                                          .withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Image.asset(
                                      'assets/images/logo.png',
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text(
                                      'Pond Defender',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '🔒 Your Privacy Matters',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4ECDC4),
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Pond Defender is a completely offline game. We do not collect, store, or share any personal data.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                        height: 1.5,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      '• No internet connection required\n• No account registration needed\n• No personal information collected\n• All game progress stored locally on your device',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white60,
                                        height: 1.6,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Play with peace of mind! 🐟',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),

                // Back button
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
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

  Widget _buildPanel({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3436).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4ECDC4),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildToggleRow({
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: const Color(0xFF4ECDC4), // Updated from activeColor
          activeTrackColor: const Color(0xFF4ECDC4).withValues(alpha: 0.5),
          inactiveThumbColor: Colors.grey[400],
          inactiveTrackColor: Colors.grey[600],
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.75),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
