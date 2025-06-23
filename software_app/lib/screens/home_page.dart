// import 'package:flutter/material.dart';

// class HomePage extends StatelessWidget {
//   final String username;

//   const HomePage({super.key, this.username = "User"});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF2A6F6F), // Dark Green Background
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Left Section (Menu Buttons)
//               Expanded(
//                 flex: 2,
//                 child: Container(
//                   padding: const EdgeInsets.all(15),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF0E3A32), // Dark Green Box
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Welcome, $username!",
//                         style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(height: 30),
//                       _buildMenuButton(context, 'assets/images/create_room.png', "Create Room", '/createRoom'),
//                       _buildMenuButton(context, 'assets/images/join_room.png', "Join Room", '/joinRoom'),
//                       _buildMenuButton(context, 'assets/images/avatar_setting.png', "Avatar Setting", '/avatarSettings'),
//                       _buildMenuButton(context, 'assets/images/game_setting.png', "Game Setting", '/gameSettings'),
//                       _buildMenuButton(context, 'assets/images/help.png', "Help", '/help'),
//                       const SizedBox(height: 20),
//                       _buildBackButton(context),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 20),
//               // Right Section (Game Logo)
//               Expanded(
//                 flex: 3,
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         'assets/images/vr_golf_logo.png',
//                         width: 250,
//                       ),
//                       const SizedBox(height: 20),
//                       const Text(
//                         "VR GOLF MULTIPLAYER",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper Widget for Menu Buttons
//   Widget _buildMenuButton(BuildContext context, String imagePath, String text, String route) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: ElevatedButton.icon(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.teal.shade700,
//           padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//         ),
//         onPressed: () {
//           Navigator.pushNamed(context, route);
//         },
//         icon: Image.asset(imagePath, width: 24, height: 24),
//         label: Text(
//           text,
//           style: const TextStyle(color: Colors.white, fontSize: 16),
//         ),
//       ),
//     );
//   }

//   // Back Button
//   Widget _buildBackButton(BuildContext context) {
//     return ElevatedButton.icon(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.red.shade700,
//         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//       ),
//       onPressed: () {
//         Navigator.pop(context); // Goes back to the previous screen
//       },
//       icon: const Icon(Icons.arrow_back, color: Colors.white),
//       label: const Text(
//         "Back",
//         style: TextStyle(color: Colors.white, fontSize: 16),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
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
            colors: [Color(0xFF051412), Color(0xFF0B7F72), Color(0xFF00FFDD)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Back button
              Positioned(
                left: 10,
                top: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                    const SizedBox(height: 10),
                    const Text(
                      "VR GOLF\nMULTIPLAYER",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Welcome, $username!",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Button Section
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
                            'assets/images/avatar_setting.png',
                            "Avatar Setting",
                            '/avatarSettings',
                          ),
                          _menuItem(
                            context,
                            'assets/images/game_setting.png',
                            "Game Setting",
                            '/gameSettings',
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
                style: const TextStyle(
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
