import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/globals.dart';
import 'package:flutter_application_1/model/profile.dart';
import 'package:flutter_application_1/storage_manger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';

import '../../database_service.dart';

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
  final ImagePicker picker = ImagePicker();
  String? imagePath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final profile = await DatabaseService().fetchProfile();
      if (profile != null) {
        setState(() {
          _nameController.text = profile.name;
          _weightController.text = profile.weight.toString();
          _heightController.text = profile.height.toString();
          _goal = profile.goal ?? "maintain";
          imagePath = profile.imagePath;
          userName.value = profile.name;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveDetails() async {
    if (_formKey.currentState?.validate() ?? false) {
      userName.value =
          _nameController.text.isEmpty ? "David" : _nameController.text;

      String? cacheImg;
      if (imagePath != null) {
        cacheImg = await moveToCachePath(imagePath!);
      }

      int calories = Profile.calculateCaloriesFromValues(
        weight: double.tryParse(_weightController.text) ?? 0,
        height: double.tryParse(_heightController.text) ?? 0,
        goal: _goal,
      ).toInt();
      try {
        int caloriesLeft = Profile.calculateCaloriesFromValues(
          weight: double.tryParse(_weightController.text) ?? 0,
          height: double.tryParse(_heightController.text) ?? 0,
          goal: _goal,
        ).toInt();

        int carbsLeft = Profile.calculateCarbs(
          calories: calories.toDouble(),
          carbsRatio: 0.5,
        ).toInt();

        int fatLeft = Profile.calculateFat(
          calories: calories.toDouble(),
          fatRatio: 0.3,
        ).toInt();

        int proteinLeft = Profile.calculateProtein(
          calories: calories.toDouble(),
          proteinRatio: 0.2,
        ).toInt();

        (DatabaseService.instance).insertProfile(Profile(
          name: _nameController.text,
          weight: double.tryParse(_weightController.text) ?? 0,
          height: double.tryParse(_heightController.text) ?? 0,
          goal: _goal,
          imagePath: cacheImg,
          caloriesLeft: calories,
          carbsLeft: carbsLeft,
          fatLeft: fatLeft,
          proteinLeft: proteinLeft,
          caloriesGoal: calories,
          carbsGoal: carbsLeft,
          fatGoal: fatLeft,
          proteinGoal: proteinLeft,
        ));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("The data has been successfully saved!")),
        );
      } catch (e) {
        print("Error saving profile: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("An error occurred while saving the data."),
          ),
        );
      }
    }
  }

  void _resetForm() {
    setState(() {
      _nameController.clear();
      _weightController.clear();
      _heightController.clear();
      _goal = "maintain";
      imagePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9),
      appBar: AppBar(
        title: const Text(
          "Edit profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        actions: [],
        backgroundColor: const Color(0xFFE9E9E9),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: imagePath != null
                            ? FileImage(File(imagePath!))
                            : AssetImage("assets/user.jpg") as ImageProvider,
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

                              _pickImage();
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
                    labelText: "Entry name",
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
                    labelText: "Entry weight (kg)",
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
                    labelText: "Entry height (cm)",
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
                  "Select a goal:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    RadioListTile(
                      title: Text("Gain weight"),
                      value: "gain",
                      groupValue: _goal,
                      onChanged: (value) {
                        setState(() {
                          _goal = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Lose weight"),
                      value: "lose",
                      groupValue: _goal,
                      onChanged: (value) {
                        setState(() {
                          _goal = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Maintain weight"),
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
                            double calorieGoal =
                                Profile.calculateCaloriesFromValues(
                              weight:
                                  double.tryParse(_weightController.text) ?? 0,
                              height:
                                  double.tryParse(_heightController.text) ?? 0,
                              goal: _goal,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Your calorie goal: ${calorieGoal.toStringAsFixed(2)} kcal"),
                              ),
                            );
                          }
                        },
                        child: Text("Calculate calorie goal"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF200087),
                          // Barva tlačítka
                          foregroundColor: Colors.white,
                          // Barva textu
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _saveDetails,
                        child: Text("Save data"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF200087),
                          // Barva tlačítka
                          foregroundColor: Colors.white,
                          // Barva textu
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
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
      ),
    );
  }

  void _pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Zde by se měla provést logika pro uložení obrázku

      setState(() {
        // Zde by se měla provést logika pro změnu profilové fotky
        imagePath = image.path;
      });
    }
  }
}