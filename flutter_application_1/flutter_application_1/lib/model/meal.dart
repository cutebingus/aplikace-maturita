class Meal {
  final String mealTime, name, imagePath, kiloCaloriesBurnt, timeTaken, preparation;
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

final meals = [
  Meal(
    mealTime: "BREAKFAST",
    name: "Fruit Granola",
    kiloCaloriesBurnt: "271",
    timeTaken: "10",
    //Food Image
    imagePath: "assets/fruit_granola.jpg",
    ingredients: [
      "1 cup of granola",
      "1 banana",
      "1/2 cup of raisins",
      "1 tbsp of honey",
    ],
    preparation: '''Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Elementum tempus egestas sed sed risus pretium quam. Platea dictumst quisque sagittis purus sit. Senectus et netus et malesuada fames ac turpis egestas sed. ...''',
  ),
  Meal(
    mealTime: "DINNER",
    name: "Pesto Pasta",
    kiloCaloriesBurnt: "612",
    timeTaken: "15",
    imagePath: "assets/pesto_pasta.jpg",
    ingredients: [
      "1 cup of granola",
      "1 banana",
      "1/2 cup of raisins",
      "1 tbsp of honey",
    ],
    preparation: '''Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Elementum tempus egestas sed sed risus pretium quam. Platea dictumst quisque sagittis purus sit. Senectus et netus et malesuada fames ac turpis egestas sed. ...''',
  ),
  Meal(
    mealTime: "SNACK",
    name: "Keto Snack",
    kiloCaloriesBurnt: "414",
    timeTaken: "16",
    imagePath: "assets/keto_snack.jpg",
    ingredients: [
      "1 cup of granola",
      "1 banana",
      "1/2 cup of raisins",
      "1 tbsp of honey",
    ],
    preparation: '''Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Elementum tempus egestas sed sed risus pretium quam. Platea dictumst quisque sagittis purus sit. Senectus et netus et malesuada fames ac turpis egestas sed. ...''',
  ),
];
