import 'package:flutter/material.dart';

class DeviceConnectionPage extends StatelessWidget {
  const DeviceConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850], // Dark grey background
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // Adjust width as needed
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.teal[800], // Dark teal background
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context); // Navigate back
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Device Connection',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Connecting bluetooth devices ......',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              _buildConnectionItem(
                label: 'Hand band contacting.',
                connected: false, // Replace with actual connection status
              ),
              const SizedBox(height: 10),
              _buildConnectionItem(
                label: 'Golf stick connecting.',
                connected: false, // Replace with actual connection status
              ),
              const SizedBox(height: 10),
              _buildConnectionItem(
                label: 'Headset connecting.',
                connected: false, // Replace with actual connection status
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/vr_golf_logo.png', // Replace with your logo asset path
                        width: 150,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'VR GOLF\nMULTIPLAYER',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
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

  Widget _buildConnectionItem({
    required String label,
    required bool connected,
  }) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.teal[600], // Lighter teal for item background
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: connected ? Colors.green : Colors.grey, // Green if connected, grey otherwise
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }
}