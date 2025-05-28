import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String username;

  const HomePage({super.key, this.username = "User"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A6F6F), // Dark Green Background
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
                      Text(
                        "Welcome, $username!",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildMenuButton(context, 'assets/images/create_room.png', "Create Room", '/createRoom'),
                      _buildMenuButton(context, 'assets/images/join_room.png', "Join Room", '/joinRoom'),
                      _buildMenuButton(context, 'assets/images/avatar_setting.png', "Avatar Setting", '/avatarSettings'),
                      _buildMenuButton(context, 'assets/images/game_setting.png', "Game Setting", '/gameSettings'),
                      _buildMenuButton(context, 'assets/images/help.png', "Help", '/help'),
                      const SizedBox(height: 20),
                      _buildBackButton(context),
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

  // Helper Widget for Menu Buttons
  Widget _buildMenuButton(BuildContext context, String imagePath, String text, String route) {
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
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        icon: Image.asset(imagePath, width: 24, height: 24),
        label: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  // Back Button
  Widget _buildBackButton(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade700,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: () {
        Navigator.pop(context); // Goes back to the previous screen
      },
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      label: const Text(
        "Back",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
