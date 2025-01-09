import 'package:intl/intl.dart';

class Meal {
  final String mealTime;
  final String name;
  final String imagePath;
  final String kiloCaloriesBurnt;
  final String timeTaken;
  final String preparation;
  final List<String> ingredients;

  Meal({
    required this.mealTime,
    required this.name,
    required this.imagePath,
    required this.kiloCaloriesBurnt,
    required this.timeTaken,
    required this.preparation,
    required this.ingredients,
  });
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
