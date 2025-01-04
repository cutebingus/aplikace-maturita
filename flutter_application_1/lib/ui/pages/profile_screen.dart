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
    final width = MediaQuery.of(context).size.width; // ziskani sirky obrazovky
    final today = DateTime.now(); // aktualni datum a cas

    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9), // barva pozadi obrazovky
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)), // zakulaceni horniho okraje
        child: BottomNavigationBar(
          iconSize: 40, // velikost ikon v navigacnim panelu
          selectedIconTheme: IconThemeData(
            color: const Color(0xFF200087), // barva vybrane ikony
          ),
          unselectedIconTheme: IconThemeData(
            color: Colors.black12, // barva nevybranych ikon
          ),
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 9.0), // odsazeni ikony
                child: Icon(Icons.home), // ikona pro domovskou obrazovku
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
              CalorieEntryScreen(),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0); // animace zprava
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
      );
    },
    child: Icon(Icons.search),
  ),
  label: "",
),



              
BottomNavigationBarItem(
  icon: GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => ProfileDetailScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(-1.0, 0.0); // Animace zleva doprava
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
    child: Icon(Icons.person),
  ),
  label: "",
),





          ],
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
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal, // posouvani seznamu horizontalne
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 32, // mezera na zacatku seznamu
                          ),
                          for (int i = 0; i < meals.length; i++) // cyklus pro vykresleni karet
                            MealCard(meal: meals[i]), // vykresleni jednotlivych karet jidel
                        ],
                      ),
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
    return CustomPaint(
      painter: RadialPainter(progress), // volani tridy pro vykresleni progress baru
      child: Container(
        height: height, // vyska progress baru
        width: width, // sirka progress baru
        child: Center(
          child: RichText(
            textAlign: TextAlign.center, // zarovnani textu na stred
            text: TextSpan(
              children: [
                TextSpan(
                  text: "1731", // hodnota kalorii
                  style: TextStyle(
                    fontSize: 32, // velikost pisma
                    fontWeight: FontWeight.w700, // tloustka pisma
                    color: const Color(0xFF200087), // barva pisma
                  ),
                ),
                TextSpan(
                  text: "\n", // odradkovani
                ),
                TextSpan(
                  text: "kcal left", // popis progress baru
                  style: TextStyle(
                    fontSize: 18, // velikost pisma
                    fontWeight: FontWeight.w500, // tloustka pisma
                    color: const Color(0xFF200087), // barva pisma
                  ),
                ),
              ],
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
  final Meal meal; // informace o jidle

  const MealCard({
    Key? key,
    required this.meal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealDetailScreen(meal: meal), // navigace na detail jidel
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(
          right: 20, // mezera napravo
          bottom: 10, // mezera dole
        ),
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(20)), // zakulaceni karty
          elevation: 4, // stin karty
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // zarovnani obsahu na zacatek
            mainAxisSize: MainAxisSize.max, // maximalni velikost obsahu
            children: <Widget>[
              Flexible(
                fit: FlexFit.tight, // rozlozeni obsahu karty
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)), // zakulaceni obrazku
                  child: Image.asset(
                    meal.imagePath, // cesta k obrazku
                    width: 160, // sirka obrazku
                    fit: BoxFit.fitHeight, // uprava obrazku na vysku
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight, // rozlozeni obsahu karty
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0), // odsazeni textu
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // zarovnani textu doleva
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // rozlozeni textu
                    children: [
                      SizedBox(height: 5), // mezera
                      Text(
                        meal.mealTime, // cas jidla
                        style: const TextStyle(
                          fontWeight: FontWeight.w500, // tloustka pisma
                          fontSize: 17, // velikost pisma
                          color: Colors.blueGrey, // barva textu
                        ),
                      ),
                      Text(
                        meal.name, // nazev jidla
                        style: const TextStyle(
                          fontWeight: FontWeight.w700, // tloustka pisma
                          fontSize: 18, // velikost pisma
                          color: Colors.black, // barva textu
                        ),
                      ),
                      Text(
                        '${meal.kiloCaloriesBurnt} kcal', // pocet kalorii
                        style: const TextStyle(
                          fontWeight: FontWeight.w500, // tloustka pisma
                          fontSize: 15, // velikost pisma
                          color: Colors.blueGrey, // barva textu
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.access_time, // ikona casu
                            size: 15, // velikost ikony
                            color: Colors.black12, // barva ikony
                          ),
                          SizedBox(
                            width: 4, // mezera
                          ),
                          Text(
                            "${meal.timeTaken} min", // cas pripravy
                            style: const TextStyle(
                              fontWeight: FontWeight.w500, // tloustka pisma
                              fontSize: 14, // velikost pisma
                              color: Colors.blueGrey, // barva textu
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16), // mezera
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
