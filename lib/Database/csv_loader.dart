import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

import 'database_helper.dart';

Future<void> loadWordsFromCSV() async {
  final dbHelper = DatabaseHelper();

  try {
    // Cargar el archivo desde los assets
    final csvString = await rootBundle.loadString('assets/csv/palabras.csv');

    // Convertir el CSV a una lista de filas
    final fields = const CsvToListConverter(fieldDelimiter: ',', eol: '\n')
        .convert(csvString);

    // Insertar en la base de datos
    for (var row in fields) {
      final palabra = row[0] as String;
      final categoria = row[1] as String;
      if (!await dbHelper.checkIfWordExists(palabra)){
      await dbHelper.insertWord(palabra, categoria);
      }
    }
    print('Datos cargados desde el archivo CSV.');
  } catch (e) {
    print('Error cargando el archivo CSV: $e');
  }
}
