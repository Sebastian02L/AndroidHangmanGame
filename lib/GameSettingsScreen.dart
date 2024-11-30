import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'GameScreen.dart';
import 'main.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


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
      backgroundColor: Colors.grey[350],
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
                    child: Text('<',
                        style: GoogleFonts.permanentMarker(
                          fontSize: 25,
                          color: Colors.black,
                        )),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      shadowColor: Colors.black,
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        side: BorderSide(
                          width: 5.0,
                          color: Colors.black, // Borde negro
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Fondo blanco
                        border: Border.all(
                          color: Colors.black, // Borde negro
                          width: 7, // Grosor del borde
                        ),
                        borderRadius: BorderRadius.circular(10), // Bordes redondeados
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Ajustes de la partida",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.permanentMarker(
                              fontSize: 23, color: Colors.black),
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
                  // Título "Nombre del jugador"
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Fondo blanco
                      border: Border.all(
                        color: Colors.black, // Borde negro
                        width: 7.0, // Grosor del borde
                      ),
                      borderRadius: BorderRadius.circular(10), // Bordes redondeados
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Nombre del jugador",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.permanentMarker(
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // Añadir espacio entre el título y la caja de texto
                  SizedBox(height: 5), // Ajusta este valor según el espacio que desees
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: playerNameController,
                      decoration: InputDecoration(
                        labelText: "Ingrese su nombre...",
                        hintText: "Ingrese su nombre...",
                        filled: true, // Fondo blanco
                        fillColor: Colors.white, // Fondo blanco para la caja de texto
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2.0), // Borde negro
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2.0), // Borde negro cuando está enfocado
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2.0), // Borde negro cuando está habilitado
                        ),
                      ),
                      style: GoogleFonts.permanentMarker(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Título "Categoría de las palabras"
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Fondo blanco
                      border: Border.all(
                        color: Colors.black, // Borde negro
                        width: 7.0, // Grosor del borde
                      ),
                      borderRadius: BorderRadius.circular(10), // Bordes redondeados
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Categoría de las palabras",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.permanentMarker(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // Añadir espacio entre el título y el dropdown
                  SizedBox(height: 5),
                  // Dropdown para seleccionar la categoría
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white, // Fondo blanco
                      border: Border.all(
                        color: Colors.black, // Borde negro
                        width: 2.0, // Grosor del borde
                      ),
                      borderRadius: BorderRadius.circular(10), // Bordes redondeados
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      hint: Text(
                        "Seleccione una categoría...",
                        style: GoogleFonts.permanentMarker(fontSize: 15),
                      ),
                      items: options.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: GoogleFonts.permanentMarker(fontSize: 20),
                          ),
                        );
                      }).toList(),
                      onChanged: selectedMode != "Marathon" ? (String? newValue) {
                        setState(() {
                          selectedCategory = newValue;
                          changeWords(selectedCategory, appState);
                        });
                      } : null,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Caja blanca con bordes negros para el título
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Fondo blanco
                      border: Border.all(
                        color: Colors.black, // Borde negro
                        width: 7.0, // Grosor del borde
                      ),
                      borderRadius: BorderRadius.circular(10), // Bordes redondeados
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Modo de juego",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.permanentMarker(
                        fontSize: 22,
                        color: Colors.black, // Texto negro
                      ),
                    ),
                  ),
                  SizedBox(height: 5), // Espaciado entre el título y los botones
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
                        "Normal",
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
            SizedBox(height: 2),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(1), // Sombra negra
                        spreadRadius: 1, // Extensión de la sombra
                        blurRadius: 1, // Ligero desenfoque para suavizar
                        offset: Offset(5, 7), // Desplazamiento de la sombra
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15), // Bordes redondeados
                  ),
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
                      child: Text(
                        "¡Comenzar Partida!",
                        style: GoogleFonts.permanentMarker(
                          fontSize: 24,
                          color: Colors.black, // Texto en negro
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      //primary: Colors.white, // Fondo blanco
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Bordes redondeados
                        side: BorderSide(
                          color: Colors.black, // Borde negro
                          width: 7.0, // Grosor del borde
                        ),
                      ),
                      elevation: 0, // Elevación desactivada para que solo use boxShadow
                    ),
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
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.permanentMarker(
                      fontSize: 22, color: Colors.black),
                ),
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
            ? BorderSide(color: Colors.black, width: 5)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: GoogleFonts.permanentMarker(
              fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }
}

void changeWords(String? category, GameState state) async {
  if (category == "Todas") {
    state.words = await helper.getWords();
  } else {
    state.words = await helper.getWordsByCategory(category);
  }
}

