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
    return Scaffold(
      backgroundColor: const Color(0xFF2A6F6F), // Background color from wireframe
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Centers in the middle of the screen
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/vr_golf_logo.png',
              width: 200,
            ),
            const SizedBox(height: 20),
            const Text(
              "VR GOLF\nMULTIPLAYER",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            const Text(
              "LOADING...",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
