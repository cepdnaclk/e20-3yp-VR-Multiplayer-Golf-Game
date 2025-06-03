import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'device_connection_page.dart';

class HomePage extends StatelessWidget {
  final String username;

  const HomePage({super.key, this.username = "User"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.42, 1.0],
            colors: [Color(0xFF051412), Color(0xFF0B7F72), Color(0xFF2E7B71)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Back button (top-left like DeviceConnectionPage)
              Positioned(
                left: 10,
                top: 10,
                child: IconButton(
                  icon: Image.asset(
                    'assets/images/back_button.png',
                    width: 24,
                    height: 24,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DeviceConnectionPage(),
                      ),
                    );
                  },
                ),
              ),

              // Main content
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/vr_golf_logo.png', width: 220),
                    const SizedBox(height: 30),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E3A32),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          _menuItem(
                            context,
                            'assets/images/create_room.png',
                            "Create Room",
                            '/createRoom',
                          ),
                          _menuItem(
                            context,
                            'assets/images/join_room.png',
                            "Join Room",
                            '/joinRoom',
                          ),
                          _menuItem(
                            context,
                            'assets/images/help.png',
                            "Help",
                            '/help',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    String iconPath,
    String label,
    String route,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Image.asset(iconPath, width: 36, height: 36),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00CDB9),
                foregroundColor: Colors.black,
                elevation: 4,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, route);
              },
              child: Text(
                label,
                style: GoogleFonts.salsa(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
