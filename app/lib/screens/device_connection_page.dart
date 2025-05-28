// import 'package:flutter/material.dart';
// import 'home_page.dart';

// class DeviceConnectionPage extends StatefulWidget {
//   const DeviceConnectionPage({super.key});

//   @override
//   _DeviceConnectionPageState createState() => _DeviceConnectionPageState();
// }

// class _DeviceConnectionPageState extends State<DeviceConnectionPage> {
//   bool handBandConnected = false;
//   bool golfStickConnected = false;
//   bool headsetConnected = false;
//   bool allConnected = false;

//   String userName = 'Player'; // Default

//   @override
//   void initState() {
//     super.initState();
//     _simulateConnection();
//   }

//   Future<void> _simulateConnection() async {
//     // Simulate delay for each device connection
//     await Future.delayed(const Duration(seconds: 1));
//     setState(() => handBandConnected = true);

//     await Future.delayed(const Duration(seconds: 1));
//     setState(() => golfStickConnected = true);

//     await Future.delayed(const Duration(seconds: 1));
//     setState(() {
//       headsetConnected = true;
//       allConnected = true;
//     });

//     // Navigate to HomePage if all connected
//     if (mounted && allConnected) {
//       await Future.delayed(const Duration(seconds: 1));
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const HomePage()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final args = ModalRoute.of(context)?.settings.arguments as Map?;
//     if (args != null && args.containsKey('name')) {
//       userName = args['name'];
//     }

//     return Scaffold(
//       backgroundColor: const Color(0xFF2A6F6F),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
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
//             const SizedBox(height: 10),
//             Text(
//               "Welcome, $userName!",
//               style: const TextStyle(
//                 fontSize: 20,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 30),
//             _buildConnectionItem("Hand band connecting..", handBandConnected),
//             const SizedBox(height: 15),
//             _buildConnectionItem("Golf stick connecting..", golfStickConnected),
//             const SizedBox(height: 15),
//             _buildConnectionItem("Headset connecting..", headsetConnected),
//             const SizedBox(height: 30),
//             allConnected
//                 ? const Icon(Icons.check_circle, size: 50, color: Colors.green)
//                 : const CircularProgressIndicator(color: Colors.white),
//             const SizedBox(height: 10),
//             Text(
//               allConnected ? "ALL DEVICES CONNECTED" : "CONNECTING...",
//               style: const TextStyle(color: Colors.white, fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildConnectionItem(String label, bool connected) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(label, style: const TextStyle(fontSize: 18, color: Colors.white)),
//         const SizedBox(width: 10),
//         Icon(
//           connected ? Icons.check_circle : Icons.sync,
//           color: connected ? Colors.green : Colors.white,
//         ),
//       ],
//     );
//   }
// }

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home_page.dart';

class DeviceConnectionPage extends StatefulWidget {
  const DeviceConnectionPage({super.key});

  @override
  _DeviceConnectionPageState createState() => _DeviceConnectionPageState();
}

class _DeviceConnectionPageState extends State<DeviceConnectionPage> {
  bool espConnected = false;
  BluetoothConnection? _connection;
  String userName = 'Player';
  List<String> espMessages = [];

  @override
  void initState() {
    super.initState();
    _connectToESP32();
  }

  Future<void> _connectToESP32() async {
    await _requestPermissions();

    // Simulate loading
    await Future.delayed(const Duration(seconds: 1));

    try {
      List<BluetoothDevice> devices =
          await FlutterBluetoothSerial.instance.getBondedDevices();

      final espDevice = devices.firstWhere(
        (device) => device.name?.startsWith("ESP32") ?? false,
        orElse: () => throw Exception("ESP32 not found. Make sure it's paired."),
      );

      _connection = await BluetoothConnection.toAddress(espDevice.address);
      print('Connected to the ESP32');

      setState(() => espConnected = true);

      _connection!.input!.listen((Uint8List data) {
        final received = utf8.decode(data);
        final lines = received.split('\n');
        for (var line in lines) {
          if (line.trim().isNotEmpty) {
            print('ESP32: ${line.trim()}');
            setState(() => espMessages.add("ESP32: ${line.trim()}"));
          }
        }
      });

      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
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
  void dispose() {
    _connection?.dispose();
    super.dispose();
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
            Image.asset('assets/images/vr_golf_logo.png', width: 200),
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
            _buildConnectionItem("ESP32 connecting..", espConnected),
            const SizedBox(height: 30),
            espConnected
                ? const Icon(Icons.check_circle, size: 50, color: Colors.green)
                : const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 10),
            Text(
              espConnected ? "DEVICE CONNECTED" : "CONNECTING...",
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
        Text(label, style: const TextStyle(fontSize: 18, color: Colors.white)),
        const SizedBox(width: 10),
        Icon(
          connected ? Icons.check_circle : Icons.sync,
          color: connected ? Colors.green : Colors.white,
        ),
      ],
    );
  }
}
