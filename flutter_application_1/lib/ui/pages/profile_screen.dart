import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/food_api_service.dart';
import 'package:flutter_application_1/model/meal.dart';
import 'package:flutter_application_1/ui/pages/meal_detail_screen.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:intl/intl.dart';
import 'package:flutter_application_1/ui/pages/calorie_entry_screen.dart';
import 'package:flutter_application_1/ui/pages/profile_detail_screen.dart';
import 'package:flutter_application_1/globals.dart';

import '../../database_service.dart';
import '../../model/profile.dart';

// trida pro hlavni profilovou obrazovku
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Profile? userProfile;
  double totalCalories = 0;
  int consumedCalories = 0;
  int remainingCalories = 0;
  int consumedProtein = 0;
  int consumedCarbs = 0;
  int consumedFat = 0;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final profile = await DatabaseService.instance.fetchProfile();
      if (profile != null) {
        setState(() {
          userProfile = profile;
          consumedCalories =
              userProfile!.caloriesGoal - userProfile!.caloriesLeft;
          consumedProtein = userProfile!.proteinGoal - userProfile!.proteinLeft;
          consumedCarbs = userProfile!.carbsGoal - userProfile!.carbsLeft;
          consumedFat = userProfile!.fatGoal - userProfile!.fatLeft;
          totalCalories = userProfile!.caloriesGoal.toDouble();
          remainingCalories = userProfile!.caloriesLeft;
        });

        _findMealsForDay();
      } else {
        setState(() {
          userProfile = Profile.empty();
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height; // ziskani vysky obrazovky
    //final width = MediaQuery.of(context).size.width; // ziskani sirky obrazovky
    final today = DateTime.now(); // aktualni datum a cas

    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9), // barva pozadi obrazovky

      bottomNavigationBar: Container(
        color: const Color(0xFFE9E9E9), // Šedé pozadí za navigačním panelem
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          // Zaoblený navigační panel
          child: BottomNavigationBar(
            iconSize: 40,
            // Velikost ikon
            backgroundColor: Colors.white,
            // Bílé pozadí navigačního baru
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
                  child:
                      const Icon(Icons.home), // Ikona pro domovskou obrazovku
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: GestureDetector(
                  onTap: () async {
                    if (Profile.isProfileEmpty(userProfile!)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please create a profile first",
                          ),
                        ),
                      );
                    }

                    await Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          if (Profile.isProfileEmpty(userProfile!)) {
                            return ProfileDetailScreen();
                          }

                          return CalorieEntryScreen();
                        },
                        // Navigace na "Calorie Entry Screen"
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0); // Animace zprava
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

                    _loadProfileData();
                  },
                  child: const Icon(Icons.search), // Ikona pro vyhledávání
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ProfileDetailScreen(),
                        // Navigace na profilový detail
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin =
                              Offset(1.0, 0.0); // Animace zprava doleva
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
                    _loadProfileData();
                  },
                  child: const Icon(Icons.person), // Ikona profilu
                ),
                label: "",
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: userProfile == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(40), // zakulaceni dolni casti
                    ),
                    child: Container(
                      color: Colors.white, // barva pozadi casti
                      padding: const EdgeInsets.only(
                          top: 40, left: 32, right: 16, bottom: 10), // odsazeni
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // zarovnani textu doleva
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "${DateFormat("EEEE").format(today)}, ${DateFormat("d MMMM").format(today)}", // datum a den
                              style: TextStyle(
                                fontWeight: FontWeight.w400, // tloustka pisma
                                fontSize: 18, // velikost pisma
                              ),
                            ),
                            subtitle: Text(
                              "Hello " + (userProfile?.name ?? "there") + "!",
                              // dynamické zobrazení jména
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 26,
                                color: Colors.black,
                              ),
                            ),

                            trailing: ClipOval(
                                child: userProfile?.imagePath != null &&
                                        userProfile!.imagePath!.isNotEmpty
                                    ? Image.file(
                                        File(userProfile!.imagePath!),
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        "assets/user.jpg",
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      )), // profilova fotka
                          ),
                          SizedBox(
                            height: 10, // mezera mezi elementy
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // zarovnani elementu na zacatek
                            children: <Widget>[
                              RadialProgress(
                                remainingCalories: remainingCalories.toInt(),
                                width: height * 0.19,
                                height: height * 0.19,
                                progress: totalCalories > 0
                                    ? consumedCalories / totalCalories
                                    : 0,
                              ),
                              SizedBox(width: 20),
                              // mezera mezi progress barem a textem
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // zarovnani textu na zacatek
                                  children: <Widget>[
                                    IngredientProgress(
                                      ingredient: "protein",
                                      progress: userProfile!.proteinGoal > 0
                                          ? consumedProtein /
                                              userProfile!.proteinGoal
                                          : 0,
                                      progressColor: Colors.green,
                                      leftAmount: (userProfile!.proteinGoal -
                                              consumedProtein)
                                          .clamp(0, double.infinity)
                                          .toDouble(),
                                      totalAmount:
                                          userProfile!.proteinGoal.toDouble(),
                                    ),

                                    SizedBox(
                                        height: 10), // mezera mezi elementy
                                    IngredientProgress(
                                      ingredient: "carbs",
                                      progress: userProfile!.carbsGoal > 0
                                          ? consumedCarbs /
                                              userProfile!.carbsGoal
                                          : 0,
                                      progressColor: Colors.red,
                                      leftAmount: (userProfile!.carbsGoal -
                                              consumedCarbs)
                                          .clamp(0, double.infinity)
                                          .toDouble(),
                                      totalAmount:
                                          userProfile!.carbsGoal.toDouble(),
                                    ),
                                    SizedBox(height: 10),
                                    IngredientProgress(
                                      ingredient: "fat",
                                      progress: userProfile!.fatGoal > 0
                                          ? consumedFat / userProfile!.fatGoal
                                          : 0,
                                      progressColor: Colors.yellow,
                                      leftAmount:
                                          (userProfile!.fatGoal - consumedFat)
                                              .clamp(0, double.infinity)
                                              .toDouble(),
                                      totalAmount:
                                          userProfile!.fatGoal.toDouble(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Text(
                            "Goal Calories : ${userProfile!.caloriesGoal}",
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          SizedBox(height: 10),

                        ],
                      ),
                    ),
                  ),



                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    height: height, // vyska druhe casti
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // zarovnani elementu doleva
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
                            valueListenable: mealsNotifier,
                            builder: (context, meals, child) {
                              return GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // Number of items per row
                                  crossAxisSpacing: 10, // Space between columns
                                  mainAxisSpacing: 10, // Space between rows
                                  childAspectRatio:
                                      0.9, // Adjust based on your card design
                                ),
                                itemCount: meals.length,
                                itemBuilder: (context, index) {
                                  final width =
                                      MediaQuery.of(context).size.width;
                                  return MealCard(
                                    meal: meals[index],
                                    width: width,
                                    onTap: () {
                                      _loadProfileData();
                                    }, // Pass width if necessary
                                  );
                                },
                                padding: const EdgeInsets.all(10),
                                // Optional: Add padding around the grid
                                shrinkWrap: true,
                                // Use if inside a scrollable parent
                                physics:
                                    const NeverScrollableScrollPhysics(), // Disable internal scrolling
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 100),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }

  _findMealsForDay() async {
    List<Meal>? mealsMap = await DatabaseService.instance.fetchFoods();

    if (mealsMap == null) {
      return;
    }

    mealsNotifier.value = mealsMap;
  }
}

// trida pro radialni progress bar
class RadialProgress extends StatelessWidget {
  final double height, width, progress;
  final int remainingCalories;

  const RadialProgress({
    Key? key,
    required this.height,
    required this.width,
    required this.progress,
    required this.remainingCalories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      // Zabrání zbytečnému překreslení
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
                    text: "${remainingCalories.toInt()}",
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

    Offset center =
        Offset(size.width / 2, size.height / 2); // stred progress baru
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
    print("Progress: $progress");

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
                      borderRadius: BorderRadius.circular(5),
                      // zakulaceni progress baru
                      color: Colors.grey[300], // barva pozadi progress baru
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: progress > 1 ? 1 : progress,
                    // procentualni delka progress baru
                    child: Container(
                      height: 10, // vyska progress baru
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        // zakulaceni progress baru
                        color: progressColor, // barva progress baru
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10), // mezera mezi progress barem a textem
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // zarovnani textu doleva
              children: [
                Text(
                  "${leftAmount.toInt()}g left",
                  // zobrazeni zbyvajiciho mnozstvi
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                Text(
                  "of ${totalAmount.toInt()}g", // zobrazeni celkoveho mnozstvi
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
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
  Function? onTap;

  MealCard({Key? key, required this.meal, required this.width, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealDetailScreen(meal: meal),
          ),
        );
        if (onTap != null) {
          onTap!();
        }
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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: meal.imagePath != null &&
                      meal.imagePath!.startsWith("http")
                  ? Image.network(
                      meal.imagePath!,
                      height: 100,
                      width: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.0),
                        child: Image.asset(
                          'assets/hladovec.jpg',
                          height: 100,
                          width:
                              160 - (width * 0.0), // Úprava šířky pro padding
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
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "${(meal.kiloCaloriesBurnt ?? 0).toStringAsFixed(1)} kcal",
                      // Přidání maximální hodnoty jako desetinné číslo
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Delete Meal"),
                            content: const Text(
                                "Are you sure you want to delete this meal?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await DatabaseService.instance
                                      .deleteMeal(meal);
                                  if (onTap != null) {
                                    onTap!();
                                  }
                                  Navigator.pop(context);
                                },
                                child: const Text("Delete"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.delete,
                      size: 16,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}