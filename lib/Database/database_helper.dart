import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'hangman.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE words(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word TEXT NOT NULL,
        category TEXT NOT NULL
      )
    ''');
  }

  // Método para insertar palabras con categoría
  Future<int> insertWord(String word, String category) async {
    final db = await database;
    return await db.insert('words', {
      'word': word,
      'category': category,
    });
  }

  // Método para obtener todas las palabras
  Future<List<Map<String, dynamic>>> getWords() async {
    final db = await database;
    return await db.query('words');
  }

  //Método para
  Future<bool> checkIfWordExists(String palabra) async {
    final db = await _instance.database;
    final result = await db.query(
      'words',
      where: 'word = ?',
      whereArgs: [palabra],
    );

    // Si la longitud del resultado es mayor que 0, significa que la palabra existe
    return result.isNotEmpty;
  }
}
