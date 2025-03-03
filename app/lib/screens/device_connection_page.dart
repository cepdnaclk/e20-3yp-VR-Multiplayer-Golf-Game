import 'package:flutter/material.dart';
import 'home_page.dart'; // Ensure this import is correct

class DeviceConnectionPage extends StatefulWidget {
  const DeviceConnectionPage({super.key});

  @override
  _DeviceConnectionPageState createState() => _DeviceConnectionPageState();
}

class _DeviceConnectionPageState extends State<DeviceConnectionPage> {
  bool handBandConnected = false;
  bool golfStickConnected = false;
  bool headsetConnected = false;
  bool allConnected = false;

  @override
  void initState() {
    super.initState();
    _simulateConnection();
  }

  void _simulateConnection() async {
    // Simulating Bluetooth device connections with delays
    await Future.delayed(const Duration(seconds: 2));
    setState(() => handBandConnected = true);

    await Future.delayed(const Duration(seconds: 2));
    setState(() => golfStickConnected = true);

    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      headsetConnected = true;
      allConnected = true; // All devices connected
    });

    // Navigate to HomePage after a short delay
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A6F6F), // Matching Splash Screen BG
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Centers content
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/vr_golf_logo.png', // Make sure the asset path is correct
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
            const SizedBox(height: 30),
            _buildConnectionItem("Hand band connecting..", handBandConnected),
            const SizedBox(height: 15),
            _buildConnectionItem("Golf stick connecting..", golfStickConnected),
            const SizedBox(height: 15),
            _buildConnectionItem("Headset connecting..", headsetConnected),
            const SizedBox(height: 30),
            allConnected
                ? const Icon(Icons.check_circle, size: 50, color: Colors.green)
                : const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 10),
            Text(
              allConnected ? "ALL DEVICES CONNECTED" : "CONNECTING...",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionItem(String label, bool connected) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Icon(
          connected ? Icons.check_circle : Icons.sync,
          color: connected ? Colors.green : Colors.white,
        ),
      ],
    );
  }
}
