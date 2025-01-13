class Profile {
  int? id;
  String name;
  double weight;
  double height;
  String? goal;
  String? imagePath;
  int caloriesGoal;
  int proteinGoal = -1;
  int carbsGoal = -1;
  int fatGoal = -1;
  int caloriesLeft = -1;
  int proteinLeft = -1;
  int carbsLeft = -1;
  int fatLeft = -1;


  Profile({
    this.id,
    required this.name,
    required this.weight,
    required this.height,
    this.goal,
    this.imagePath,
    this.caloriesGoal = -1,
    this.proteinGoal = -1,
    this.carbsGoal = -1,
    this.fatGoal = -1,
    this.proteinLeft = -1,
    this.carbsLeft = -1,
    this.caloriesLeft = -1,
    this.fatLeft = -1,
  });

  double calculateCalories() {
    double baseCalories = (10 * weight) + (6 * height) + 500;

    if (goal == "gain") {
      return baseCalories + 300;
    } else if (goal == "lose") {
      return baseCalories - 300;
    } else {
      return baseCalories;
    }
  }

  static double calculateProtein({
    required double calories,
    required double proteinRatio, 
  }) {
    double proteinCalories = calories * proteinRatio;
    return proteinCalories / 4; 
  }

  static double calculateFat({
    required double calories,
    required double fatRatio, 
  }) {
    double fatCalories = calories * fatRatio;
    return fatCalories / 9; 
  }

  static double calculateCarbs({
    required double calories,
    required double carbsRatio, 
  }) {
    double carbsCalories = calories * carbsRatio;
    return carbsCalories / 4; 
  }

  static double calculateCaloriesFromValues({
    required double weight,
    required double height,
    required String goal,
  }) {
    double baseCalories = (10 * weight) + (6 * height) + 500;

    if (goal == "gain") {
      return baseCalories + 300;
    } else if (goal == "lose") {
      return baseCalories - 300;
    } else {
      return baseCalories;
    }
  }


  static fromMap(Map<String, Object?> first) {
    return Profile(
      id: first['id'] as int,
      name: first['name'] as String,
      weight: first['weight'] as double,
      height: first['height'] as double,
      goal: first['goal'] as String?,
      imagePath: first['imagePath'] as String?,
      caloriesGoal: first['caloriesGoal'] as int,
      carbsGoal: first['carbsGoal'] as int,
      proteinGoal: first['proteinGoal'] as int,
      fatGoal: first['fatGoal'] as int,
      carbsLeft: first['carbsLeft'] as int,
      proteinLeft: first['proteinLeft'] as int,
      fatLeft: first['fatLeft'] as int,
      caloriesLeft: first['caloriesLeft'] as int,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'weight': weight,
      'height': height,
      'goal': goal,
      'imagePath': imagePath,
      'caloriesGoal': caloriesGoal,
      'carbsGoal': carbsGoal,
      'proteinGoal': proteinGoal,
      'fatGoal': fatGoal,
      'carbsLeft': carbsLeft,
      'proteinLeft': proteinLeft,
      'fatLeft': fatLeft,
      'caloriesLeft': caloriesLeft,
    };
  }

  static Profile? empty() {
    return Profile(
      name: "",
      weight: 0,
      height: 0,
    );
  }

  static bool isProfileEmpty(Profile profile) {
    return profile.name.isEmpty || profile.weight == 0 || profile.height == 0;
  }

}