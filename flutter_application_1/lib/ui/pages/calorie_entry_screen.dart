import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/pages/profile_detail_screen.dart';

class CalorieEntryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9), // změna barvy pozadí na stejnou jako na hlavní stránce
      appBar: AppBar(
        title: Text(
          'Vyhledat a zapsat jídlo',
          style: TextStyle(
            fontWeight: FontWeight.bold, // tlustší text
            color: Colors.black, // tmavší barva textu
            fontSize: 20, // větší velikost textu
          ),
        ),
        backgroundColor: const Color(0xFFE9E9E9), // změna barvy pozadí za textem
        elevation: 0, // odstranění stínu AppBaru
        iconTheme: IconThemeData(color: Colors.black), // změna barvy ikon v AppBaru
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Vyhledat jídlo',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600, // tlustší text pro popisek
                  fontSize: 18, // větší text
                  color: Colors.black, // tmavší barva
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0), // lehce zakulacené hrany
                  borderSide: BorderSide(
                    color: Colors.black, // barva okraje
                    width: 1.5, // lehce tlustší okraj
                  ),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.black, size: 28), // větší ikona
              ),
              style: TextStyle(
                fontSize: 18, // větší velikost textu uvnitř
              ),
            ),
            SizedBox(height: 20),
            // Další obsah podle potřeby
          ],
        ),
      ),
bottomNavigationBar: ClipRRect(
  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
  child: BottomNavigationBar(
    iconSize: 40,
    selectedIconTheme: IconThemeData(
      color: const Color(0xFF200087),
    ),
    unselectedIconTheme: IconThemeData(
      color: Colors.black12,
    ),
    currentIndex: 1, // Index pro vybranou ikonu
    onTap: (index) {
      if (index == 0) {
        Navigator.pop(context); // Vrací na předchozí stránku
      } else if (index == 2) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ProfileDetailScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0); // Animace zleva doprava
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
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: "",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: "",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person), // Ikona pro otevření ProfileDetailScreen
        label: "",
      ),
    ],
    backgroundColor: Colors.white,
  ),
),

    );
  }
}
