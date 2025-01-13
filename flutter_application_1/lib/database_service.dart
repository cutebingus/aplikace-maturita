import 'dart:math';
import 'package:flutter_application_1/model/meal.dart';
import 'package:flutter_application_1/model/profile.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  // nastaveni public
  static final DatabaseService instance = DatabaseService._();
  static Database? _database;

  DatabaseService._();

  factory DatabaseService() => instance;

  static Database get database => _database!;

  Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    _database = await _initDatabase();

    // kontrola pulnoci
    await _checkAndResetIfNeeded();
    return _database!;
  }

  void init() async {
    await getDatabase();
  }

  Future<void> _checkAndResetIfNeeded() async {
    final db = await getDatabase();
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);

    // Posledni logged meal time
    final List<Map<String, dynamic>> lastMeal =
        await db.query('foods', orderBy: 'loggedTime DESC', limit: 1);

    if (lastMeal.isNotEmpty) {
      final lastLoggedTime = DateTime.fromMillisecondsSinceEpoch(
          lastMeal.first['loggedTime'] as int);
  // pokud posledni logged meal bylo pred midnight resetuje ceny
      if (lastLoggedTime.isBefore(todayMidnight)) {
        final profile = await fetchProfile();
        if (profile != null) {
          await db.update(
              'profiles',
              {
                'caloriesLeft': profile.caloriesGoal,
                'proteinLeft': profile.proteinGoal,
                'carbsLeft': profile.carbsGoal,
                'fatLeft': profile.fatGoal
              },
              where: 'id = ?',
              whereArgs: [profile.id]);
          print("Reset completed: values reset to goals");
        }
      }
    }
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'foods.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        //
        await db.execute('''
          CREATE TABLE foods (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            loggedTime INTEGER,
            mealTime TEXT,
            name TEXT, 
            imagePath TEXT,
            kiloCaloriesBurnt INTEGER,
            protein REAL,
            carbs REAL,
            fat REAL,
            timeTaken TEXT,
            preparation TEXT,
            ingredients TEXT
            
          )
        ''');

        await db.execute('''
  CREATE TABLE profiles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    weight REAL,
    height REAL,
    goal TEXT,
    imagePath TEXT,
    caloriesGoal INTEGER,
    proteinGoal INTEGER,
    carbsGoal INTEGER,
    fatGoal INTEGER,
    caloriesLeft INTEGER,
    proteinLeft INTEGER,
    carbsLeft INTEGER,
    fatLeft INTEGER
    
  )
''');
      },
    );
  }

  Future<Profile?> fetchProfile() async {
    final db = await getDatabase();
    final result = await db.query('profiles');
    if (result.isEmpty) {
      return null;
    }
    final profile = Profile.fromMap(result.first);
    profile.calculateCalories();
    return profile;
  }

  Future<void> insertProfile(Profile profile) async {
    final db = await getDatabase();
    profile.id = 1;
    if (await existsProfile()) {
      await db.delete('profiles');
    }

    await db.insert('profiles', profile.toMap());
  }

  Future<bool> existsProfile() async {
    final db = await getDatabase();
    final result = await db.query('profiles');
    return result.isNotEmpty;
  }

  Future<void> insertFood(Map<String, dynamic> food) async {
    final db = await getDatabase();
    await db.insert('foods', food);
  }

  Future<List<Meal>?> fetchFoods() async {
    final db = await getDatabase();
    List<Map<String, Object?>> data =
        await db.query('foods', orderBy: 'loggedTime DESC');

    return List.from(data.map((e) => Meal.fromMapSql(e)).toList());
  }

  void logMeal(Meal meal) async {
    int date = DateTime.now().millisecondsSinceEpoch;
    final db = database;

    Profile? profile = await fetchProfile();

    if (profile == null) {
      throw Exception("Profile not found");
    }

    print("Meal logged :: old profile data: ${profile.toMap()}");

    meal.loggedTime = date;

    db.insert('foods', meal.toMap());

    profile.caloriesLeft -= meal.kiloCaloriesBurnt.toInt();
    profile.proteinLeft -= meal.protein.toInt();
    profile.carbsLeft -= meal.carbs.toInt();
    profile.fatLeft -= meal.fat.toInt();
    await db.update('profiles', profile.toMap(),
        where: 'id = ?', whereArgs: [profile.id]);

    print("Meal logged :: new profile data: ${profile.toMap()}");
  }

  Future<void> deleteMeal(Meal meal) async {
    final db = database;
    await db.delete('foods', where: 'id = ?', whereArgs: [meal.id]);

    Profile? profile = await fetchProfile();

    if (profile == null) {
      throw Exception("Profile not found");
    }

    profile.caloriesLeft += meal.kiloCaloriesBurnt.toInt();
    profile.proteinLeft += meal.protein.toInt();
    profile.carbsLeft += meal.carbs.toInt();
    profile.fatLeft += meal.fat.toInt();
    await db.update('profiles', profile.toMap(),
        where: 'id = ?', whereArgs: [profile.id]);
  }
}