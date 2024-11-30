import 'package:dadm_practica2/GameSettingsScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'RankingScreen.dart';
import 'main.dart';
import 'GameScreen.dart';
import 'MainMenuScreen.dart';

//Widget que contiene toda la interfaz de la pantalla de juego
class ResultUI extends StatelessWidget {
  const ResultUI({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<GameState>();
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 20),
                  ResultCard(text: "Puntos:", value: appState.puntuation),
                  ResultCard(text: "Palabras adivinadas:", value: appState.currentRound - 1),
                  ResultCard(text: "Número de fallos:", value: appState.totalErrors),
                  ResultCard(text: "Racha de aciertos más larga:", value: appState.highestStreak),
                  GenericButton(buttonName: "VOLVER A JUGAR", widthFactor: 0.9, heightFactor: 0.1,
                    onPressed: () {
                      PlayAudio("Click.mp3", 0);
                      appState.ResetGameplayValues();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GameSettingsUI()),
                      );
                    },
                  ),
                  GenericButton(buttonName: "VOLVER AL MENÚ", widthFactor: 0.9, heightFactor: 0.1,
                    onPressed: () {
                      PlayAudio("Click.mp3", 0);
                      appState.ResetGameplayValues();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MenuPrincipal()),
                      );
                    },
                  ),
                  SizedBox(height: 40)
                ],
              )
          )
        )
    );
  }
}

class ResultCard extends StatelessWidget {
  final int value;
  final String text;

  const ResultCard({super.key, required this.text, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5), // Bordes redondeados
        side: BorderSide(
          color: Colors.black, // Borde negro
          width: 6.0, // Grosor del borde
        ),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$text",
              style: GoogleFonts.permanentMarker(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            Text(
              "$value",
              style: GoogleFonts.permanentMarker(
                fontSize: 35,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
