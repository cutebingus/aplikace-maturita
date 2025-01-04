import 'package:flutter/material.dart';
import 'package:flutter_application_1/food_api_service.dart';

class CalorieEntryScreen extends StatefulWidget {
  @override
  _CalorieEntryScreenState createState() => _CalorieEntryScreenState();
}

class _CalorieEntryScreenState extends State<CalorieEntryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FoodApiService _foodApiService = FoodApiService();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  void _searchFood() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _foodApiService.searchFood(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Chyba při načítání dat: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9),
      appBar: AppBar(
        title: Text(
          'Vyhledat a zapsat jídlo',
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
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Vyhledat jídlo',
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
                prefixIcon: Icon(Icons.search, color: Colors.black, size: 28),
              ),
              style: TextStyle(fontSize: 18),
              onSubmitted: (_) => _searchFood(),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final item = _searchResults[index]['food'];
                        return ListTile(
                          title: Text(
                            item['label'] ?? '',
                            style: TextStyle(fontSize: 16),
                          ),
                          subtitle: Text(
                            "Kalorie: ${item['nutrients']['ENERC_KCAL']?.toStringAsFixed(2) ?? 'Neznámé'} kcal",
                          ),
                          leading: item['image'] != null
                              ? Image.network(
                                  item['image'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.fastfood),
                          onTap: () {
                            // Možnost přidat jídlo k dennímu příjmu
                          },
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
