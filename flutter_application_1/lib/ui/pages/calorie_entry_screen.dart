import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/food_api_service.dart';
import 'package:flutter_application_1/ui/pages/profile_detail_screen.dart';


class CalorieEntryScreen extends StatefulWidget {
  @override
  _CalorieEntryScreenState createState() => _CalorieEntryScreenState();
}

class _CalorieEntryScreenState extends State<CalorieEntryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FoodApiService _foodApiService = FoodApiService();
  List<Map<String, dynamic>> _searchResults = [];
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
    if (results.isNotEmpty) {
      setState(() {
        _searchResults = results;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Žádné výsledky nenalezeny.")),
      );
    }
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
          'Vyhledat a zapsat jídlo',
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
        color: const Color(0xFFE9E9E9), // Stejná tmavě šedá jako na profile_screen.dart
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Vyhledat jídlo',
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9E9E9), // Stejná šedá jako pozadí
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: _searchResults.isEmpty
                          ? const Center(
                              child: Text(
                                'Žádné výsledky k zobrazení',
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final item = _searchResults[index]['food'];
                                return ListTile(
                                  title: Text(
                                    item['label'] ?? 'Neznámé jídlo',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    "Kalorie: ${item['nutrients']['ENERC_KCAL']?.toStringAsFixed(2) ?? 'Neznámé'} kcal",
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                  leading: item['image'] != null
                                      ? Image.network(
                                          item['image'],
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(Icons.fastfood),
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            '${item['label']} přidáno k dennímu příjmu.'),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFFE9E9E9), // Šedé pozadí za zaoblením
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)), // Zaoblený BottomNavigationBar
          child: BottomNavigationBar(
            iconSize: 40,
            backgroundColor: Colors.white, // Bílé pozadí navigačního baru
            selectedIconTheme: const IconThemeData(
              color: Color(0xFF200087), // Modrá barva pro vybranou ikonu (stejně jako Home)
            ),
            unselectedIconTheme: const IconThemeData(
              color: Colors.black12, // Barva nevybraných ikon
            ),
            currentIndex: 1, // Indikuje, že jsme na stránce "search"
            onTap: (index) {
              if (index == 0) {
                Navigator.pop(context); // Navigace zpět na domovskou obrazovku
              } else if (index == 2) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ProfileDetailScreen(), // Navigace na profilový detail
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0); // Animace zprava doleva
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "", // Odstranění textu
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "", // Odstranění textu
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "", // Odstranění textu
              ),
            ],
          ),
        ),
      ),
    );
  }
}
