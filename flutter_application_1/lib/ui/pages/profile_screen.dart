import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/meal.dart';
import 'package:flutter_application_1/ui/pages/meal_detail_screen.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:intl/intl.dart';
import 'package:flutter_application_1/ui/pages/calorie_entry_screen.dart';
import 'package:flutter_application_1/ui/pages/profile_detail_screen.dart';
import 'package:flutter_application_1/globals.dart';



// trida pro hlavni profilovou obrazovku
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height; // ziskani vysky obrazovky
    //final width = MediaQuery.of(context).size.width; // ziskani sirky obrazovky
    final today = DateTime.now(); // aktualni datum a cas

    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9), // barva pozadi obrazovky
     
     bottomNavigationBar: Container(
  color: const Color(0xFFE9E9E9), // Šedé pozadí za navigačním panelem
  child: ClipRRect(
    borderRadius: const BorderRadius.vertical(top: Radius.circular(40)), // Zaoblený navigační panel
    child: BottomNavigationBar(
      iconSize: 40, // Velikost ikon
      backgroundColor: Colors.white, // Bílé pozadí navigačního baru
      selectedIconTheme: const IconThemeData(
        color: Color(0xFF200087), // Barva vybrané ikony
      ),
      unselectedIconTheme: const IconThemeData(
        color: Colors.black12, // Barva nevybraných ikon
      ),
      items: [
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(top: 9.0), // Odsazení ikony
            child: const Icon(Icons.home), // Ikona pro domovskou obrazovku
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      CalorieEntryScreen(), // Navigace na "Calorie Entry Screen"
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0); // Animace zprava
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
            },
            child: const Icon(Icons.search), // Ikona pro vyhledávání
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
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
            },
            child: const Icon(Icons.person), // Ikona profilu
          ),
          label: "",
        ),
      ],
    ),
  ),
),

      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0, // umisteni prvni casti nahore
            height: height * 0.37, // nastaveni vysky prvni casti
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(40), // zakulaceni dolni casti
              ),
              child: Container(
                color: Colors.white, // barva pozadi casti
                padding: const EdgeInsets.only(top: 40, left: 32, right: 16, bottom: 10), // odsazeni
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // zarovnani textu doleva
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "${DateFormat("EEEE").format(today)}, ${DateFormat("d MMMM").format(today)}", // datum a den
                        style: TextStyle(
                          fontWeight: FontWeight.w400, // tloustka pisma
                          fontSize: 18, // velikost pisma
                        ),
                      ),
                      subtitle: ValueListenableBuilder<String>(
  valueListenable: userName,
  builder: (context, value, child) {
    return Text(
      "Hello $value", // dynamické zobrazení jména
      style: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 26,
        color: Colors.black,
      ),
    );
  },
),

                      trailing: ClipOval(child: Image.asset("assets/user.jpg")), // profilova fotka
                    ),
                    SizedBox(
                      height: 10, // mezera mezi elementy
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start, // zarovnani elementu na zacatek
                      children: <Widget>[
                        RadialProgress(
                          width: height * 0.19, // sirka radialniho progress baru
                          height: height * 0.19, // vyska radialniho progress baru
                          progress: 0.7, // procentualni hodnota progress baru
                        ),
                        SizedBox(width: 20), // mezera mezi progress barem a textem
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // zarovnani textu na zacatek
                            children: <Widget>[
                              IngredientProgress(
                                ingredient: "protein", // nazev slozky
                                progress: 0.3, // procentualni hodnota progress baru
                                progressColor: Colors.green, // barva progress baru
                                leftAmount: 72, // zbyvajici mnozstvi
                                totalAmount: 100, // celkove mnozstvi
                              ),
                              SizedBox(height: 10), // mezera mezi elementy
                              IngredientProgress(
                                ingredient: "carbs",
                                progress: 0.2,
                                progressColor: Colors.red,
                                leftAmount: 252,
                                totalAmount: 300,
                              ),
                              SizedBox(height: 10),
                              IngredientProgress(
                                ingredient: "fat",
                                progress: 0.1,
                                progressColor: Colors.yellow,
                                leftAmount: 61,
                                totalAmount: 70,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: height * 0.38, // umisteni druhe casti
            left: 0,
            right: 0,
            child: Container(
              height: height, // vyska druhe casti
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // zarovnani elementu doleva
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                      left: 32,
                      right: 16,
                    ),
                    child: Text(
                      "meals for the day", // nadpis sekce
                      style: const TextStyle(
                        color: Colors.blueGrey, // barva textu
                        fontSize: 16, // velikost pisma
                        fontWeight: FontWeight.w700, // tloustka pisma
                      ),
                    ),
                  ),
                 Expanded(
  child: ValueListenableBuilder<List<Meal>>(
    valueListenable: mealsNotifier, // Listener na jídelní seznam
    builder: (context, meals, child) {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: meals.length,
        itemBuilder: (context, index) {
          final width = MediaQuery.of(context).size.width; // Získání šířky obrazovky
          return MealCard(meal: meals[index], width: width); // Předání parametru width
        },
      );
    },
  ),
),


                  SizedBox(height: 300), // mezera pod seznamem
                  Expanded(
                    child: Container(
                      color: Colors.blueAccent, // barva spodni casti
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


// trida pro radialni progress bar
class RadialProgress extends StatelessWidget {
  final double height, width, progress;

  const RadialProgress({
    Key? key,
    required this.height,
    required this.width,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary( // Zabrání zbytečnému překreslení
      child: CustomPaint(
        painter: RadialPainter(progress),
        child: SizedBox(
          height: height,
          width: width,
          child: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "1731",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF200087),
                    ),
                  ),
                  TextSpan(text: "\n"),
                  TextSpan(
                    text: "kcal left",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF200087),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



// trida pro vykresleni radialniho progress baru
class RadialPainter extends CustomPainter {
  final double progress;

  RadialPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 10 // tloustka progress baru
      ..color = Color(0xFF200087) // barva progress baru
      ..style = PaintingStyle.stroke // vykresleni pouze okraje
      ..strokeCap = StrokeCap.round; // zakulaceni koncu progress baru

    Offset center = Offset(size.width / 2, size.height / 2); // stred progress baru
    double relativeProgress = 360 * progress; // vypocet uhlu progress baru

    canvas.drawArc(
      Rect.fromCenter(
        center: center, // stred kruznice
        width: size.width, // sirka kruznice
        height: size.height, // vyska kruznice
      ),
      math.radians(-90), // pocatecni uhel
      math.radians(-relativeProgress), // uhel progress baru
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // vzdy prekresli canvas
  }
}

// trida pro zobrazeni progressu slozek
class IngredientProgress extends StatelessWidget {
  final String ingredient; // nazev slozky
  final double progress; // progress slozky
  final Color progressColor; // barva progress baru
  final double leftAmount; // mnozstvi zbyvajici slozky
  final double totalAmount; // celkove mnozstvi slozky

  const IngredientProgress({
    Key? key,
    required this.ingredient,
    required this.progress,
    required this.progressColor,
    required this.leftAmount,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // zarovnani textu doleva
      children: <Widget>[
        Text(
          ingredient.toUpperCase(), // zobrazeni nazvu slozky
          style: TextStyle(
            fontSize: 14, // velikost pisma
            fontWeight: FontWeight.w700, // tloustka pisma
          ),
        ),
        SizedBox(height: 5), // mezera
        Row(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 10, // vyska progress baru
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5), // zakulaceni progress baru
                      color: Colors.grey[300], // barva pozadi progress baru
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: progress, // procentualni delka progress baru
                    child: Container(
                      height: 10, // vyska progress baru
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5), // zakulaceni progress baru
                        color: progressColor, // barva progress baru
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10), // mezera mezi progress barem a textem
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // zarovnani textu doleva
              children: [
                Text(
                  "${leftAmount.toInt()}g left", // zobrazeni zbyvajiciho mnozstvi
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                Text(
                  "of ${totalAmount.toInt()}g", // zobrazeni celkoveho mnozstvi
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// trida pro jednotlive karty jidel
class MealCard extends StatelessWidget {
  final Meal meal;
  final double width;

  const MealCard({Key? key, required this.meal, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealDetailScreen(meal: meal),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 20, bottom: 10),
        width: 160, // Nastavíme šířku karty
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: meal.imagePath.isNotEmpty && meal.imagePath.startsWith("http")
                  ? Image.network(
                      meal.imagePath,
                      height: 100,
                      width: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.0),
                        child: Image.asset(
                          'assets/hladovec.jpg',
                          height: 100,
                          width: 160 - (width * 0.0), // Úprava šířky pro padding
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.0),
                      child: Image.asset(
                        'assets/hladovec.jpg',
                        height: 100,
                        width: 160 - (width * 0.0), // Úprava šířky pro padding
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                meal.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                 "${(double.tryParse(meal.kiloCaloriesBurnt) ?? 0).toStringAsFixed(1)} kcal", // Přidání maximální hodnoty jako desetinné číslo
        style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}