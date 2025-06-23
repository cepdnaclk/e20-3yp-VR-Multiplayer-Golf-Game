import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeCreatePage extends StatefulWidget {
  const CodeCreatePage({super.key});

  @override
  _CodeCreatePageState createState() => _CodeCreatePageState();
}

class _CodeCreatePageState extends State<CodeCreatePage> {
  final String gameCode = "ABC123"; // Sample game code

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E3A32),
      appBar: AppBar(
        title: const Text("Code Create Page", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal.shade800,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 300,
          decoration: BoxDecoration(
            color: Colors.teal.shade700,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Game ..Name..",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: TextEditingController(text: gameCode),
                  readOnly: true,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade900,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: gameCode));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Game code copied!")),
                  );
                },
                child: const Text("Copy Code", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
