import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class Meal {
  final int? id;
  final String? mealTime;
  final String name;
  final String? imagePath;
  final double kiloCaloriesBurnt;
  final String? timeTaken;
  final String? preparation;
  final List<String>? ingredients;
  final double protein;
  final double carbs;
  final double fat;
  int? loggedTime = DateTime.now().millisecondsSinceEpoch;

  Meal({
    this.id,
    required this.mealTime,
    required this.name,
    required this.imagePath,
    required this.kiloCaloriesBurnt,
    required this.timeTaken,
    required this.preparation,
    required this.ingredients,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.loggedTime
  });

  static fromMap(Map<String, dynamic> e) {
    // "ENERC_KCAL": 717,
    //           "PROCNT": 0.85,
    //           "FAT": 81.1,
    //           "CHOCDF": 0.06,
    //           "FIBTG": 0
    return Meal(
      mealTime: e.containsKey('mealTime') ? e['mealTime'] as String : null,
      name: e['food']["label"] as String,
      imagePath: e['food']['image'] as String?,
      kiloCaloriesBurnt: e['food']['nutrients']['ENERC_KCAL'],
      fat: e['food']['nutrients']['FAT'] as double,
      carbs: e['food']['nutrients']['CHOCDF'] as double,
      protein: e['food']['nutrients']['PROCNT'] as double,
      timeTaken: e.containsKey('timeTaken') ? e['timeTaken'] as String : null,
      preparation:
          e.containsKey('preparation') ? e['preparation'] as String : null,
      ingredients: e.containsKey('ingredients')
          ? List<String>.from(e['ingredients'])
          : null,
    );
  }

  static fromMapSql(Map<String, dynamic> e) {
    // "ENERC_KCAL": 717,
    //           "PROCNT": 0.85,
    //           "FAT": 81.1,
    //           "CHOCDF": 0.06,
    //           "FIBTG": 0
    return Meal(
      id: e['id'] as int,
      mealTime: e['mealTime'],
      name: e['name'] as String,
      imagePath: e['imagePath'] as String?,
      kiloCaloriesBurnt: e['kiloCaloriesBurnt'].toDouble(),
      fat: e['fat'] as double,
      carbs: e['carbs'] as double,
      protein: e['protein'] as double,
      timeTaken: e['timeTaken'],
      preparation: e['preparation'],
      ingredients: List<String>.from(e['ingredients']??[]),
      loggedTime: e['loggedTime']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mealTime': mealTime,
      'name': name,
      'imagePath': imagePath,
      'kiloCaloriesBurnt': kiloCaloriesBurnt,
      'timeTaken': timeTaken,
      'preparation': preparation,
      'ingredients': ingredients,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'loggedTime': loggedTime
    };
  }
}

// Původní seznam jídel
final List<Meal> meals = [];

// Jídla organizovaná podle dnů
final Map<String, List<Meal>> dailyMeals = {};

// Funkce pro získání aktuálního dne
String getCurrentDay() {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
}

// Funkce pro resetování jídel při změně dne
void resetMealsIfNeeded() {
  final today = getCurrentDay();
  if (!dailyMeals.containsKey(today)) {
    dailyMeals.clear(); // Vymaže předchozí dny
    dailyMeals[today] = []; // Vytvoří nový seznam pro dnešek
  }
}

// Přidání jídla do dnešního seznamu i do původního seznamu
void addMealToToday(Meal meal) {
  resetMealsIfNeeded();
  dailyMeals[getCurrentDay()]?.add(meal);
  meals.add(meal); // Zachování původní funkčnosti
}

// Získání jídel pro aktuální den
List<Meal> getTodayMeals() {
  resetMealsIfNeeded();
  return dailyMeals[getCurrentDay()] ?? [];
}

// ValueNotifier pro správu seznamu jídel
final ValueNotifier<List<Meal>> mealsNotifier = ValueNotifier<List<Meal>>([]);