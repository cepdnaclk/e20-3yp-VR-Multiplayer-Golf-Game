import 'package:flutter/material.dart';
import 'code_create_page.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({super.key});

  @override
  _CreateRoomPageState createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  String selectedFilter = 'Beginner';
  String selectedGameType = 'Beginner';
  String selectedCourse = 'Beginner';
  int selectedPlayers = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF124037),
      appBar: AppBar(
        title: const Text("Create Room", style: TextStyle(color: Colors.white)),
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
                  "Create Room",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 20),

                // Dropdown for Filters
                _buildDropdown("Filter", ['Beginner', 'Intermediate', 'Advanced'], selectedFilter, (value) {
                  setState(() => selectedFilter = value);
                }),

                // Dropdown for Game Type
                _buildDropdown("Game Type", ['Beginner', 'Intermediate', 'Advanced'], selectedGameType, (value) {
                  setState(() => selectedGameType = value);
                }),

                // Dropdown for Courses
                _buildDropdown("Course", ['Beginner', 'Intermediate', 'Advanced'], selectedCourse, (value) {
                  setState(() => selectedCourse = value);
                }),

                const SizedBox(height: 10),

                // Player Selection
                _buildMaxPlayersSelection(),

                const SizedBox(height: 20),

                // Confirm Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade900,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CodeCreatePage()),
                    );
                  },
                  child: const Text("Confirm", style: TextStyle(color: Colors.white, fontSize: 16)),
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

  // Helper Widget for Max Players Selection
  Widget _buildMaxPlayersSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Max Players:", style: TextStyle(fontSize: 16, color: Colors.white)),
        for (int i = 2; i <= 4; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(
                "$i",
                style: TextStyle(color: selectedPlayers == i ? Colors.white : Colors.teal.shade900),
              ),
              selected: selectedPlayers == i,
              selectedColor: Colors.teal.shade900,
              backgroundColor: Colors.white,
              onSelected: (bool selected) {
                setState(() {
                  selectedPlayers = i;
                });
              },
            ),
          ),
      ],
    );
  }
}
