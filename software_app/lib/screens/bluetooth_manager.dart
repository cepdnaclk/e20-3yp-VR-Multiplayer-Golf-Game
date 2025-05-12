// bluetooth_manager.dart
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothManager {
  BluetoothConnection? connection;
  List<BluetoothDevice> pairedDevices = [];

  Future<List<BluetoothDevice>> getBondedDevices() async {
    pairedDevices = await FlutterBluetoothSerial.instance.getBondedDevices();
    return pairedDevices;
  }

  Future<BluetoothConnection?> connectToDevice(String targetName) async {
    for (BluetoothDevice device in pairedDevices) {
      if (device.name == targetName) {
        try {
          connection = await BluetoothConnection.toAddress(device.address);
          print("✅ Connected to $targetName");
          return connection;
        } catch (e) {
          print("❌ Failed to connect to $targetName: $e");
        }
      }
    }
    return null;
  }

  void dispose() {
    connection?.dispose();
    connection = null;
  }
}
