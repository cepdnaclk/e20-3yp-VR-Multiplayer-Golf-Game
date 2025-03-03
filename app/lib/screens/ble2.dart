import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  BluetoothDevice? _device;
  BluetoothConnection? _connection;
  String dataToSend = "";
  String sensorData = "";  // Received data (we will update this)

  List<BluetoothDevice> _devicesList = [];
  bool isConnecting = false;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  void _initBluetooth() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;
    setState(() {});

    FlutterBluetoothSerial.instance.onStateChanged().listen((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    // Fetch paired devices
    _devicesList = await FlutterBluetoothSerial.instance.getBondedDevices();
    setState(() {});
  }

  // Connect to device and start listening for sensor data
  void _connectToDevice(BluetoothDevice device) async {
    setState(() {
      isConnecting = true;
      _device = device;
    });

    try {
      BluetoothConnection.toAddress(_device!.address).then((connection) {
        setState(() {
          _connection = connection;
          isConnected = true;
          isConnecting = false;
        });
        print('✅ Connected to the device');

        // After successful connection, start listening for sensor data
        _listenToSensorData();
      }).catchError((error) {
        print('❌ Connection failed: $error');
        setState(() {
          isConnecting = false;
          isConnected = false;
        });
      });
    } catch (e) {
      print('❌ Cannot connect, error: $e');
      setState(() {
        isConnecting = false;
      });
    }
  }

  // Listen to incoming sensor data
  void _listenToSensorData() {
    _connection!.input!.listen((data) {
      String receivedData = utf8.decode(data);

      setState(() {
        sensorData += receivedData;  // Append data (sensor might send data in chunks)
      });

      print("📡 Received data: $receivedData");
    }).onDone(() {
      // Handle disconnection
      print('❌ Disconnected from device');
      setState(() {
        isConnected = false;
        _connection = null;
      });
    });
  }

  // Send data to the device
  void _sendData(String data) {
    if (_connection != null && _connection!.isConnected) {
      _connection!.output.add(utf8.encode(data));
      print("📤 Data sent: $data");
    } else {
      print("⚠️ Connection not established");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Bluetooth HC-05 Controller')),
        body: Column(
          children: [
            Text(
              'Bluetooth Status: ${_bluetoothState.toString().split('.')[1]}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text('Available Devices:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _devicesList.length,
                itemBuilder: (context, index) {
                  final device = _devicesList[index];
                  return ListTile(
                    title: Text(device.name ?? "Unknown Device"),
                    subtitle: Text(device.address),
                    trailing: ElevatedButton(
                      onPressed: isConnecting
                          ? null
                          : () => _connectToDevice(device),
                      child: isConnecting
                          ? CircularProgressIndicator()
                          : Text(isConnected && _device?.address == device.address
                              ? "Connected"
                              : "Connect"),
                    ),
                  );
                },
              ),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Send Data'),
              onChanged: (value) {
                setState(() {
                  dataToSend = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () => _sendData(dataToSend),
              child: Text('Send'),
            ),
            SizedBox(height: 20),
            Text(
              'Sensor Data:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 150,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: SingleChildScrollView(
                child: Text(
                  sensorData.isEmpty ? "No data received yet" : sensorData,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(child: Container()),  // Just to fill space
          ],
        ),
      ),
    );
  }
}
