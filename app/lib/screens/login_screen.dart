import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account != null) {
        // Successfully signed in, navigate to device connection page
        Navigator.pushReplacementNamed(context, '/deviceConnection');
      }
    } catch (error) {
      print("Google Sign-In Error: $error");
      // Handle login failure (e.g., show an error message)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Google Sign-In failed. Try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A6F6F), // Background color from the wireframe
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Important to avoid stretching
          mainAxisAlignment: MainAxisAlignment.center,
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
            const SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: () => _handleGoogleSignIn(context), // Trigger sign-in
              icon: Image.asset(
                'assets/images/google_icon.png',
                width: 24,
                height: 24,
              ),
              label: const Text("Sign in with Google"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to HomePage as Guest
                Navigator.pushReplacementNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text("Login as Guest"),
            ),
          ],
        ),
      ),
    );
  }
}
