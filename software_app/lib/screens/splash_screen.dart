// import 'package:flutter/material.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(seconds: 3), () {
//       Navigator.pushReplacementNamed(context, '/login');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(
//         0xFF2A6F6F,
//       ), // Background color from wireframe
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min, // Centers in the middle of the screen
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Image.asset('assets/images/vr_golf_logo.png', width: 200),
//             const SizedBox(height: 20),
//             const Text(
//               "VR GOLF\nMULTIPLAYER",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 32,
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             const CircularProgressIndicator(color: Colors.white),
//             const SizedBox(height: 10),
//             const Text("LOADING...", style: TextStyle(color: Colors.white)),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/vr_golf_logo.png',
                width: screenWidth * 0.6,
              ),
              SizedBox(height: screenHeight * 0.06),
              SizedBox(
                width: screenWidth * 0.3,
                height: screenWidth * 0.3 * 0.1,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                "LOADING...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.045,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
