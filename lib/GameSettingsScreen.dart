import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'GameScreen.dart';
import 'main.dart';

class GameSettingsUI extends StatefulWidget {
  const GameSettingsUI({super.key});

  @override
  State<GameSettingsUI> createState() => _GameSettingsUIState();
}

class _GameSettingsUIState extends State<GameSettingsUI> {
  String? selectedCategory;
  String? selectedMode;

  final TextEditingController playerNameController = TextEditingController();

  @override
  void dispose() {
    playerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<String> options = [
      "Animales",
      "Colores",
      "Deportes",
      "Profesiones",
      "Países",
      "Todas"
    ];

    var appState = context.watch<GameState>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      PlayAudio("Click.mp3", 0);
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back, size: 30.0),
                    style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      color: theme.colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Ajustes de la partida",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22, color: theme.colorScheme.onPrimary),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildSectionTitle(theme, "Nombre del jugador"),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: playerNameController,
                      decoration: InputDecoration(
                        labelText: "Nombre del jugador",
                        hintText: "Ingrese su nombre...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildSectionTitle(theme, "Categoría de las palabras"),
                  DropdownButton(
                    value: selectedCategory,
                    hint: Text("Seleccione una categoría...",
                        style: TextStyle(fontSize: 20)),
                    items: options.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(fontSize: 20)),
                      );
                    }).toList(),
                    onChanged: selectedMode != "Marathon"? (String? newValue) {
                      setState(() {
                        selectedCategory = newValue;
                        changeWords(selectedCategory, appState);
                      });
                    } : null,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildSectionTitle(theme, "Modo de juego"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildModeButton(
                        theme,
                        () {
                          PlayAudio("Click.mp3", 0);
                          setState(() {
                            selectedMode = "Fast";
                          });
                        },
                        "Fast",
                        "Rápido",
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      buildModeButton(
                        theme,
                        () {
                          PlayAudio("Click.mp3", 0);
                          setState(() {
                            selectedMode = "Marathon";
                            selectedCategory = "Todas";
                            changeWords(selectedCategory, appState);
                          });
                        },
                        "Marathon",
                        "Maratón",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    PlayAudio("Click.mp3", 0);
                    String playerName = playerNameController.text;

                    if (playerName != null &&
                        selectedCategory != null &&
                        selectedMode != null) {
                      appState.setPlayerName(playerName);
                      appState.setSelectedCategory(selectedCategory);
                      appState.setSelectedMode(selectedMode);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GameUI()),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("¡Comenzar Partida!",
                        style: TextStyle(
                            fontSize: 24, color: theme.colorScheme.primary)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(ThemeData theme, String text) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              color: theme.colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22, color: theme.colorScheme.onPrimary)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildModeButton(ThemeData theme, void Function() onPressed, String type, String text) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedMode == type ? Colors.grey[400] : null,
        side: selectedMode == type
            ? BorderSide(color: theme.colorScheme.primary, width: 5)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text,
            style: TextStyle(fontSize: 20, color: theme.colorScheme.primary)),
      ),
    );
  }
}

void changeWords(String? category, GameState state) async{
  if (category == "Todas") {
    state.words = await helper.getWords();
  }else{
    state.words = await helper.getWordsByCategory(category);
  }
}
