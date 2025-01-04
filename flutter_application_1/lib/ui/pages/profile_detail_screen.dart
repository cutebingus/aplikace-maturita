import 'package:flutter/material.dart';
import 'package:flutter_application_1/globals.dart';

class ProfileDetailScreen extends StatefulWidget {
  @override
  _ProfileDetailScreenState createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String _goal = "maintain";

  int _calculateCalories() {
    int weight = int.tryParse(_weightController.text) ?? 0;
    int height = int.tryParse(_heightController.text) ?? 0;
    int baseCalories = (10 * weight) + (6 * height) + 500;

    if (_goal == "gain") {
      return baseCalories + 300;
    } else if (_goal == "lose") {
      return baseCalories - 300;
    } else {
      return baseCalories;
    }
  }

  void _saveDetails() {
    if (_formKey.currentState?.validate() ?? false) {
      userName.value = _nameController.text.isEmpty ? "David" : _nameController.text;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Údaje byly úspěšně uloženy!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9),
      appBar: AppBar(
        title: Text(
          "Upravit profil",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFFE9E9E9),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage("assets/user.jpg"),
                      backgroundColor: Colors.grey[300],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(Icons.edit, color: Colors.black),
                          onPressed: () {
                            // Logika pro změnu profilové fotky
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Zadejte jméno",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.5,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Zadejte váhu (kg)",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.5,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Zadejte výšku (cm)",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.5,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              
              
Text(
  "Vyberte cíl:",
  style: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
  ),
),
SizedBox(height: 10),
Column(
  children: [
    RadioListTile(
      title: Text("Přibrat"),
      value: "gain",
      groupValue: _goal,
      onChanged: (value) {
        setState(() {
          _goal = value.toString();
        });
      },
    ),
    RadioListTile(
      title: Text("Zhubnout"),
      value: "lose",
      groupValue: _goal,
      onChanged: (value) {
        setState(() {
          _goal = value.toString();
        });
      },
    ),
    RadioListTile(
      title: Text("Udržet váhu"),
      value: "maintain",
      groupValue: _goal,
      onChanged: (value) {
        setState(() {
          _goal = value.toString();
        });
      },
    ),
  ],
),


              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
  onPressed: () {
    if (_formKey.currentState?.validate() ?? false) {
      int calorieGoal = _calculateCalories();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Váš kalorický cíl: $calorieGoal kcal"),
        ),
      );
    }
  },
  child: Text("Spočítat kalorický cíl"),
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF200087), // Barva tlačítka
    foregroundColor: Colors.white, // Barva textu
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
),
SizedBox(height: 10),
ElevatedButton(
  onPressed: _saveDetails,
  child: Text("Uložit údaje"),
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF200087), // Barva tlačítka
    foregroundColor: Colors.white, // Barva textu
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
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
