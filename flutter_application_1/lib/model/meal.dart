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

// Prázdný seznam jídel
final List<Meal> meals = [];
