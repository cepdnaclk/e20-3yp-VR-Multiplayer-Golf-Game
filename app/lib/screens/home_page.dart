// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'device_connection_page.dart';

// class HomePage extends StatelessWidget {
//   final String username;

//   const HomePage({super.key, this.username = "User"});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             stops: [0.0, 0.42, 1.0],
//             colors: [Color(0xFF051412), Color(0xFF0B7F72), Color(0xFF2E7B71)],
//           ),
//         ),
//         child: SafeArea(
//           child: Stack(
//             children: [
//               // Back button (top-left like DeviceConnectionPage)
//               Positioned(
//                 left: 10,
//                 top: 10,
//                 child: IconButton(
//                   icon: Image.asset(
//                     'assets/images/back_button.png',
//                     width: 24,
//                     height: 24,
//                   ),
//                   onPressed: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const DeviceConnectionPage(),
//                       ),
//                     );
//                   },
//                 ),
//               ),

//               // Main content
//               Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Image.asset('assets/images/vr_golf_logo.png', width: 220),
//                     const SizedBox(height: 30),

//                     Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF0E3A32),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Column(
//                         children: [
//                           _menuItem(
//                             context,
//                             'assets/images/create_room.png',
//                             "Create Room",
//                             '/createRoom',
//                           ),
//                           _menuItem(
//                             context,
//                             'assets/images/join_room.png',
//                             "Join Room",
//                             '/joinRoom',
//                           ),
//                           _menuItem(
//                             context,
//                             'assets/images/help.png',
//                             "Help",
//                             '/help',
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _menuItem(
//     BuildContext context,
//     String iconPath,
//     String label,
//     String route,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Image.asset(iconPath, width: 36, height: 36),
//           const SizedBox(width: 16),
//           Expanded(
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF00CDB9),
//                 foregroundColor: Colors.black,
//                 elevation: 4,
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.pushNamed(context, route);
//               },
//               child: Text(
//                 label,
//                 style: GoogleFonts.salsa(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../services/bluetooth_service.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, this.username = "User"});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> receivedMessages = [];

  double vx = 0, vy = 0, vz = 0;
  int? lastTime;
  bool tracking = false;

  List<double> _extractFloatArray(String input) {
    final regex = RegExp(r'-?\d+\.?\d*');
    return regex
        .allMatches(input)
        .map((match) => double.parse(match.group(0)!))
        .toList();
  }

  void _processSensorData(List<double> parsedData) {
    if (parsedData.length < 12) return; // Ensure complete data

    final ax = parsedData[0];
    final ay = parsedData[1];
    final az = parsedData[2];
    final button6 = parsedData[11];

    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (button6 == 1.0 && az >= 8.0 && az <= 10.0) {
      if (!tracking) {
        tracking = true;
        lastTime = currentTime;
        vx = vy = vz = 0;
        print("Tracking started...");
      } else {
        final deltaTime = (currentTime - lastTime!) / 1000.0;
        vx += ax * deltaTime;
        vy += ay * deltaTime;
        vz += az * deltaTime;
        lastTime = currentTime;

        print(
          "Velocity => vx: ${vx.toStringAsFixed(2)}, "
          "vy: ${vy.toStringAsFixed(2)}, "
          "vz: ${vz.toStringAsFixed(2)}",
        );
      }
    } else {
      if (tracking) {
        print(
          "Tracking stopped. Final velocity => "
          "vx: ${vx.toStringAsFixed(2)}, "
          "vy: ${vy.toStringAsFixed(2)}, "
          "vz: ${vz.toStringAsFixed(2)}",
        );
      }
      tracking = false;
      lastTime = null;
    }
  }

  @override
  void initState() {
    super.initState();

    BluetoothService().dataStream.listen((msg) {
      List<double> parsedData = _extractFloatArray(msg);
      _processSensorData(parsedData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A6F6F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E3A32),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome, ${widget.username}!",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildMenuButton(
                        context,
                        'assets/images/create_room.png',
                        "Create Room",
                        '/createRoom',
                      ),
                      _buildMenuButton(
                        context,
                        'assets/images/join_room.png',
                        "Join Room",
                        '/joinRoom',
                      ),
                      _buildMenuButton(
                        context,
                        'assets/images/avatar_setting.png',
                        "Avatar Setting",
                        '/avatarSettings',
                      ),
                      _buildMenuButton(
                        context,
                        'assets/images/game_setting.png',
                        "Game Setting",
                        '/gameSettings',
                      ),
                      _buildMenuButton(
                        context,
                        'assets/images/help.png',
                        "Help",
                        '/help',
                      ),
                      const SizedBox(height: 20),
                      _buildBackButton(context),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/vr_golf_logo.png', width: 250),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String imagePath,
    String text,
    String route,
  ) {
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
        onPressed: () => Navigator.pushNamed(context, route),
        icon: Image.asset(imagePath, width: 24, height: 24),
        label: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade700,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      label: const Text(
        "Back",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
