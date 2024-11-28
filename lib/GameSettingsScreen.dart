import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameSettingsUI extends StatefulWidget {
  @override
  State<GameSettingsUI> createState() => _GameSettingsUIState();
}

class _GameSettingsUIState extends State<GameSettingsUI> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<String> options = [
      "Animales",
      "Colores",
      "Deportes",
      "Profesiones",
      "Países"
    ];

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Icon(Icons.arrow_back, size: 30.0),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      color: theme.colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text("Ajustes de la partida",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30, color: theme.colorScheme.onPrimary),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      color: theme.colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Text("Categoría de las palabras",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30, color: theme.colorScheme.onPrimary)
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            DropdownButton(
              value: selectedCategory,
              hint: Text("Seleccione una categoría...",
                  style: TextStyle(fontSize: 25)
              ),
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,
                      style: TextStyle(fontSize: 25)
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
              },
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      color: theme.colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Text("Modo de juego",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30, color: theme.colorScheme.onPrimary)
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: (){},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Rápido",
                          style: TextStyle(fontSize: 30, color: theme.colorScheme.primary)
                      ),
                    ),
                ),
                SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: (){},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Maratón",
                        style: TextStyle(fontSize: 30, color: theme.colorScheme.primary)
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      color: theme.colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Text("Nombre del jugador",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30, color: theme.colorScheme.onPrimary)
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 400,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Nombre del jugador",
                      hintText: "Ingrese su nombre...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50,),
            ElevatedButton(
                onPressed: (){},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("¡Comenzar Partida!",
                      style: TextStyle(fontSize: 30, color: theme.colorScheme.primary)
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
