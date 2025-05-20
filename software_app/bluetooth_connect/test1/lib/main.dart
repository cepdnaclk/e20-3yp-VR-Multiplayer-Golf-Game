import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESP32 Serial Monitor',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BluetoothSerialMonitor(),
    );
  }
}

class BluetoothSerialMonitor extends StatefulWidget {
  const BluetoothSerialMonitor({super.key});

  @override
  _BluetoothSerialMonitorState createState() => _BluetoothSerialMonitorState();
}

class _BluetoothSerialMonitorState extends State<BluetoothSerialMonitor> {
  BluetoothConnection? connection;
  bool isConnected = false;
  List<String> messages = [];
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController(); // ADD THIS

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    await Permission.bluetooth.request();
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothScan.request();
    await Permission.locationWhenInUse.request();
  }

  void connectToDevice(BluetoothDevice device) async {
    try {
      try {
        final conn = await BluetoothConnection.toAddress(device.address);
        print('Connected to ${device.name}');
        connection = conn;
        setState(() => isConnected = true);

        connection!.input!.listen((Uint8List data) {
          final received = utf8.decode(data);
          final lines = received.split('\n');

          for (var line in lines) {
            if (line.trim().isEmpty) continue;
            print('Received: $line');
            setState(() {
              messages.add("ESP32: ${line.trim()}");
              scrollToBottom(); // SCROLL WHEN NEW DATA COMES
            });
          }
        });
      } catch (e) {
        print('Connection error: $e');
      }
    } catch (error) {
      print('Connection error: $error');
    }
  }

  void scrollToBottom() {
    // Ensure it runs after the UI is updated
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void sendMessage(String text) {
    if (connection != null && connection!.isConnected) {
      connection!.output.add(Uint8List.fromList(utf8.encode("$text\r\n")));
      setState(() {
        messages.add("You: $text");
        scrollToBottom(); // ALSO SCROLL WHEN YOU SEND DATA
      });
      controller.clear();
    }
  }

  Future<void> selectAndConnect() async {
    List<BluetoothDevice> devices =
        await FlutterBluetoothSerial.instance.getBondedDevices();

    final espDevice = devices.firstWhere(
      (device) => device.name?.startsWith("ESP32") ?? false,
      orElse: () => throw Exception("ESP32 not found. Make sure it's paired."),
    );

    connectToDevice(espDevice);
  }

  @override
  void dispose() {
    scrollController.dispose(); // DISPOSE CONTROLLER
    connection?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ESP32 Serial Monitor")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            isConnected
                ? Text("Connected ✅", style: TextStyle(color: Colors.green))
                : ElevatedButton(
                    onPressed: selectAndConnect,
                    child: Text("Connect to ESP32"),
                  ),
            Expanded(
              child: ListView.builder(
                controller: scrollController, // CONNECT HERE
                itemCount: messages.length,
                itemBuilder: (_, index) {
                  final msg = messages[index];
                  final isButtonNone = msg.contains("Buttons: None");
                  return ListTile(
                    title: Text(
                      msg,
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 14,
                        color: isButtonNone ? Colors.grey : Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(hintText: "Enter text to send"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => sendMessage(controller.text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
