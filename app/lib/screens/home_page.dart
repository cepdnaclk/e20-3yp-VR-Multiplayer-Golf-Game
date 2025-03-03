import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF124037), // Dark Green Background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left Section (Menu Buttons)
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E3A32), // Dark Green Box
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Welcome  ...User1...",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildMenuButton('assets/images/create_room.png', "Create Room"),
                      _buildMenuButton('assets/images/join_room.png', "Join Room"),
                      _buildMenuButton('assets/images/avatar_setting.png', "Avatar Setting"),
                      _buildMenuButton('assets/images/game_setting.png', "Game Setting"),
                      _buildMenuButton('assets/images/help.png', "Help"),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Right Section (Game Logo)
              Expanded(
                flex: 3,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/vr_golf_logo.png',
                        width: 250,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "VR GOLF MULTIPLAYER",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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

  // Helper Widget for Buttons
  Widget _buildMenuButton(String imagePath, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal.shade700,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () {}, // TODO: Add navigation
        icon: Image.asset(imagePath, width: 24, height: 24),
        label: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
