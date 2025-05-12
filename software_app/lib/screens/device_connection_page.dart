// deviceconnection.dart
import 'package:flutter/material.dart';
import 'bluetooth_manager.dart';
import 'home_page.dart';

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

  String userName = 'Player'; // Default
  final BluetoothManager bluetoothManager = BluetoothManager();

  @override
  void initState() {
    super.initState();
    _initBluetoothAndConnect();
  }

  Future<void> _initBluetoothAndConnect() async {
    await bluetoothManager.getBondedDevices();

    // Update these names as per your HC-05 paired devices
    final handBand = await bluetoothManager.connectToDevice("Hand Band");
    setState(() => handBandConnected = handBand != null);

    final golfStick = await bluetoothManager.connectToDevice("Golf Stick");
    setState(() => golfStickConnected = golfStick != null);

    final headset = await bluetoothManager.connectToDevice("Headset");
    setState(() {
      headsetConnected = headset != null;
      allConnected = handBandConnected && golfStickConnected && headsetConnected;
    });

    if (allConnected && mounted) {
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null && args.containsKey('name')) {
      userName = args['name'];
    }

    return Scaffold(
      backgroundColor: const Color(0xFF2A6F6F),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 10),
            Text(
              "Welcome, $userName!",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w500,
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
