import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothService {
  static final BluetoothService _instance = BluetoothService._internal();
  factory BluetoothService() => _instance;
  BluetoothService._internal();

  BluetoothConnection? _connection;
  final StreamController<String> _dataController = StreamController.broadcast();
  bool _isConnected = false;

  Stream<String> get dataStream => _dataController.stream;
  bool get isConnected => _isConnected;

  Future<void> connectToESP32() async {
    if (_isConnected) return;

    List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance
        .getBondedDevices();

    final espDevice = devices.firstWhere(
      (device) => device.name?.startsWith("ESP32") ?? false,
      orElse: () => throw Exception("ESP32 not found"),
    );

    _connection = await BluetoothConnection.toAddress(espDevice.address);
    _isConnected = true;

    _connection!.input!.listen(
      (Uint8List data) {
        final message = utf8.decode(data);
        final lines = message.split('\n');
        for (var line in lines) {
          if (line.trim().isNotEmpty) {
            _dataController.add(line.trim());
          }
        }
      },
      onDone: () {
        _isConnected = false;
        _dataController.close();
      },
    );
  }

  void dispose() {
    _connection?.dispose();
    _isConnected = false;
    _dataController.close();
  }
}
