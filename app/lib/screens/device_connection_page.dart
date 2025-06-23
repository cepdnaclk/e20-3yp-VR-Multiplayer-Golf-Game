import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/bluetooth_service.dart';
import 'home_page.dart';
import 'login_screen.dart';

class DeviceConnectionPage extends StatefulWidget {
  const DeviceConnectionPage({super.key});

  @override
  _DeviceConnectionPageState createState() => _DeviceConnectionPageState();
}

class _DeviceConnectionPageState extends State<DeviceConnectionPage> {
  bool espConnected = false;
  String userName = 'Player';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      if (args != null && args.containsKey('name')) {
        setState(() => userName = args['name']);
      }
    });
    _connectToESP32();
  }

  Future<void> _connectToESP32() async {
    await _requestPermissions();

    try {
      await BluetoothService().connectToESP32();
      setState(() => espConnected = true);

      if (mounted) {
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      print("Error connecting to ESP32: $e");
    }
  }

  Future<void> _requestPermissions() async {
    await Permission.bluetooth.request();
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothScan.request();
    await Permission.locationWhenInUse.request();
  }

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
              // Back button
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
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
              ),

              // Help button
              Positioned(
                right: 10,
                top: 10,
                child: TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFF0B7F72),
                        title: const Text(
                          "Help",
                          style: TextStyle(color: Colors.white),
                        ),
                        content: const Text(
                          "Please ensure your VR device is powered on and nearby. If the connection fails, try restarting the app.",
                          style: TextStyle(color: Colors.white),
                        ),
                        actions: [
                          TextButton(
                            child: const Text(
                              "OK",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Image.asset(
                    'assets/images/help_icon.png',
                    width: 24,
                    height: 24,
                  ),
                  label: const Text(
                    'Help',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

              // Main content
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/vr_golf_logo.png', width: 220),
                    const SizedBox(height: 40),

                    Text(
                      "Welcome, $userName!",
                      style: GoogleFonts.salsa(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 40),

                    espConnected
                        ? Image.asset(
                            'assets/images/ok_icon.png',
                            width: 48,
                            height: 48,
                          )
                        : const CircularProgressIndicator(color: Colors.white),

                    const SizedBox(height: 20),

                    Text(
                      espConnected
                          ? "Device Connected"
                          : "Device Connecting ...",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
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
}
