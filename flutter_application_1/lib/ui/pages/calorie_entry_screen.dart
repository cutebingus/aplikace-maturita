import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/meal.dart';
import 'package:flutter_application_1/food_api_service.dart';

class CalorieEntryScreen extends StatefulWidget {
  @override
  _CalorieEntryScreenState createState() => _CalorieEntryScreenState();
}

class _CalorieEntryScreenState extends State<CalorieEntryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FoodApiService _foodApiService = FoodApiService();
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> _selectedFoods = []; // Vybraná jídla
  bool _isLoading = false;
  Timer? _debounce;

  void _searchFood() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vyhledávací pole je prázdné.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _searchResults.clear();
    });

    try {
      final results = await _foodApiService.searchFood(query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Chyba při načítání dat: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchTextChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchFood();
    });
  }

  void _toggleFoodSelection(Map<String, dynamic> food) {
    setState(() {
      if (_selectedFoods.contains(food)) {
        _selectedFoods.remove(food);
      } else {
        _selectedFoods.add(food);
      }
    });
  }

void _saveSelectedFoods() {
  for (var food in _selectedFoods) {
    mealsNotifier.value = [
      ...mealsNotifier.value,
      Meal(
        mealTime: "Anytime", // Nastavit čas dle potřeby
        name: food['food']['label'] ?? "Unknown",
        imagePath: food['food']['image'] ?? "",
        kiloCaloriesBurnt: (food['food']['nutrients']['ENERC_KCAL'] ?? 0).toString(),
        timeTaken: "10", // Nastavit čas dle potřeby
        preparation: "N/A", // Příprava dle potřeby
        ingredients: ["Placeholder ingredient"], // Doplňte podle potřeby
      )
    ];
  }

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Vybraná jídla byla uložena!")),
  );
  Navigator.pop(context);
}


  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search and record food',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white, // Bílé pozadí jako na hlavní stránce
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: const Color(0xFFE9E9E9), // Šedé pozadí jako v původní verzi
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search food',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1.5,
                  ),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.black, size: 28),
              ),
              style: const TextStyle(fontSize: 18),
              onChanged: _onSearchTextChanged,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final food = _searchResults[index]['food'];
                        final isSelected = _selectedFoods.contains(_searchResults[index]);

                        return ListTile(
                          title: Text(
                            food['label'] ?? 'Unknown food',
                            style: const TextStyle(fontSize: 16),
                          ),
                          subtitle: Text(
                            "Kalorie: ${food['nutrients']['ENERC_KCAL']?.toStringAsFixed(2) ?? 'Neznámé'} kcal",
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          leading: food['image'] != null
                              ? Image.network(
                                  food['image'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.fastfood),
                          trailing: IconButton(
                            icon: Icon(
                              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                              color: isSelected ? Colors.green : Colors.grey,
                            ),
                            onPressed: () {
                              _toggleFoodSelection(_searchResults[index]);
                            },
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSelectedFoods,
              child: const Text("Save Selected Foods"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF200087), // Fialová barva tlačítka
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
