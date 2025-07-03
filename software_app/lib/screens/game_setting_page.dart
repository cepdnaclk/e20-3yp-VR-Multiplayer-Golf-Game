import 'package:flutter/material.dart';

class GameSettingPage extends StatefulWidget {
  const GameSettingPage({super.key});

  @override
  _GameSettingPageState createState() => _GameSettingPageState();
}

class _GameSettingPageState extends State<GameSettingPage> {
  double _voiceChatVolume = 0.5; // Initial volume for voice chat
  double _gameSoundVolume = 0.5; // Initial volume for game sound

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF124037), // Dark Green Background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back Button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context); // Navigate back
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Title
              const Text(
                'Game Setting',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              // Game Setting Content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E3A32), // Dark Green Box
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sound:',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildVolumeSlider(
                        label: 'Voice chat',
                        value: _voiceChatVolume,
                        onChanged: (value) {
                          setState(() {
                            _voiceChatVolume = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildVolumeSlider(
                        label: 'Game sound',
                        value: _gameSoundVolume,
                        onChanged: (value) {
                          setState(() {
                            _gameSoundVolume = value;
                          });
                        },
                      ),
                      // Add more game settings here
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVolumeSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Slider(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.teal[400],
            inactiveColor: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}