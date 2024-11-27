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
  Future<List<String>> getWords() async {
    final db = await database;
    final result = await db.query('words',orderBy: 'RANDOM()');
    List<String> words = result.map((row) => row['word'] as String).toList(); // Se convierte en una lista de strings
    return words;
  }

  Future<List<String>> getWordsByCategory(String category) async{
    final db = await database;
    final result = await db.query(
      'words',
      columns: ['word'],  // Solo seleccionamos la columna 'palabra'
      where: 'category = ?', // Filtro por la categoría
      whereArgs: [category], // El valor de la categoría a buscar
      orderBy: 'RANDOM()', // Se aleatoriza el orden de las palabras de la categoría
      limit: 10,
    );

    List<String> words = result.map((row) => row['word'] as String).toList(); // Se convierte en una lista de strings
    return words;
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
