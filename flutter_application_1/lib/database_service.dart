import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._();
  static Database? _database;

  DatabaseService._();

  factory DatabaseService() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'foods.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE foods (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            calories INTEGER,
            protein REAL,
            carbs REAL,
            fat REAL
          )
        ''');
      },
    );
  }

  Future<void> insertFood(Map<String, dynamic> food) async {
    final db = await database;
    await db.insert('foods', food);
  }

  Future<List<Map<String, dynamic>>> fetchFoods() async {
    final db = await database;
    return await db.query('foods');
  }
}
