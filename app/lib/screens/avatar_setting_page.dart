import 'package:flutter/material.dart';

class AvatarSettingPage extends StatefulWidget {
  const AvatarSettingPage({super.key});

  @override
  _AvatarSettingPageState createState() => _AvatarSettingPageState();
}

class _AvatarSettingPageState extends State<AvatarSettingPage> {
  String selectedAvatar = 'Avatar 1'; // Default selected avatar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF124037),
      appBar: AppBar(
        title: const Text("Avatar Setting", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal.shade800,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 400,
            decoration: BoxDecoration(
              color: Colors.teal.shade700,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Avatar Settings",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 20),

                // Dropdown for Avatar Selection
                _buildDropdown("Select Avatar", ['Avatar 1', 'Avatar 2', 'Avatar 3'], selectedAvatar, (value) {
                  setState(() => selectedAvatar = value);
                }),

                const SizedBox(height: 20),

                // Placeholder for avatar preview (can be replaced with actual images)
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.teal.shade500,
                  ),
                  child: Center(
                    child: Text(
                      selectedAvatar,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Confirm Button
                ElevatedButton(
                  onPressed: () {
                    // Handle avatar setting confirmation
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[900],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Save Avatar', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widget for Dropdowns
  Widget _buildDropdown(String label, List<String> items, String selectedItem, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$label:", style: const TextStyle(fontSize: 16, color: Colors.white)),
          DropdownButton<String>(
            value: selectedItem,
            dropdownColor: Colors.teal.shade800,
            style: const TextStyle(color: Colors.white),
            onChanged: (String? newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
