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
    await db.execute('''
      CREATE TABLE ranking(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        points TEXT NOT NULL
      )
    ''');
  }

  /////////////////////////////
  //QUERIES DE LA TABLA WORDS
  /////////////////////////////

  // Método para insertar palabras con categoría
  Future<int> insertWord(String? word, String? category) async {
    final db = await database;
    return await db.insert('words', {
      'word': word,
      'category': category,
    });
  }

  // Método para obtener todas las palabras
  Future<List<String>> getWords() async {
    final db = await database;
    final result = await db.query('words',orderBy: 'RANDOM()');

    List<String> words = result.map((row) => row['word'] as String).toList(); // Se convierte en una lista de strings
    return words;
  }

  Future<List<String>> getWordsByCategory(String? categoria) async{
    final db = await database;
    String? queryCategory = "%$categoria%";
    final result = await db.rawQuery(
        "SELECT word FROM words WHERE category like ? ORDER BY RANDOM() LIMIT 10",
        [queryCategory]
    );

    List<String> words = result.map((row) => row['word'] as String).toList(); // Se convierte en una lista de strings
    return words;
  }

  //Método para comprobar si se han añadido nuevas palabras al csv
  Future<bool> checkIfWordExists(String? palabra) async {
    final db = await _instance.database;
    final result = await db.query(
      'words',
      where: 'word = ?',
      whereArgs: [palabra],
    );

    // Si la longitud del resultado es mayor que 0, significa que la palabra existe
    return result.isNotEmpty;
  }

/////////////////////////////
//QUERIES DE LA TABLA RANKING
/////////////////////////////

  Future<int> insertRanking(String? name, String? points) async {
    final db = await database;
    return await db.insert('ranking', {
      'name': name,
      'points': points,
    });
  }

  Future<List<Map<String, dynamic>>> getTop3Ranking() async {
    final db = await database;
    final result = await db.rawQuery("SELECT name, points FROM ranking ORDER BY points DESC LIMIT 3");
    return result.map((row) => {"name": row["name"],"points": row["points"]}).toList();
  }

}
