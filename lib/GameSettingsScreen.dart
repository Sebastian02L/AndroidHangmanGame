import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameSettingsUI extends StatefulWidget{
  @override
  State<GameSettingsUI> createState() => _GameSettingsUIState();
}

class _GameSettingsUIState extends State<GameSettingsUI> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(color: theme.colorScheme.onPrimary);
    final List<String> options = ["Animales", "Colores", "Deportes", "Profesiones", "Países"];

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                    onPressed: (){},
                    child: Icon(Icons.arrow_back, size: 20.0),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Card(
                      color: theme.colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text("Ajustes de la partida", style: style.copyWith(fontSize: 20)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Card(
              color: theme.colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text("Categoría de las palabras", style: style.copyWith(fontSize: 20)),
              ),
            ),
            DropdownButton(
                value: selectedCategory,
                hint: Text("Seleccione una categoría...", style: style.copyWith(fontSize: 20, color: Colors.black)),
                items: options.map<DropdownMenuItem<String>>((String value){return DropdownMenuItem<String>(value: value, child: Text(value, style: style.copyWith(fontSize: 20, color: Colors.black)),);}).toList(),
                onChanged: (String? newValue){setState(() {
                  selectedCategory = newValue;
                });},
            ),
          ],
        ),
      ),
    );
  }
}