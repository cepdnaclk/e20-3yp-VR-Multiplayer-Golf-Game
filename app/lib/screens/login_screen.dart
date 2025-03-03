import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A6F6F), // Background color from the wireframe
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,  // Important to avoid stretching
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/vr_golf_logo.png',
              width: 200,
            ),
            SizedBox(height: 20),
            Text(
              "VR GOLF\nMULTIPLAYER",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: () {
                // Implement Google Sign-In
              },
              icon: Image.asset(
                'assets/images/google_icon.png',
                width: 24,
                height: 24,
              ),
              label: Text("Sign in with Google"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
