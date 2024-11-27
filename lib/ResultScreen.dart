import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'GameScreen.dart';
import 'MainMenuScreen.dart';

//Widget que contiene toda la interfaz de la pantalla de juego
class ResultUI extends StatelessWidget {
  const ResultUI({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<GameState>();

    return Scaffold(
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ResultCard(text: "Palabras adivinadas:", value: appState.currentRound - 1),
          ResultCard(text: "Número de fallos:", value: appState.totalErrors),
          ResultCard(text: "Racha de letras acertadas más larga:", value: appState.highestStreak),
          NavButton(state: appState, route: GameUI(), text: "VOLVER A JUGAR"),
          NavButton(state: appState, route: MenuPrincipal(), text: "VOLVER AL MENÚ"),
        ],
      )
    )
    );
  }
}

class ResultCard extends StatelessWidget{

  final int value;
  final String text;
  const ResultCard({super.key, required this.text, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5)
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$text"),
              Text("$value")
            ],
          ),
        )
    );
  }
}

class NavButton extends StatelessWidget{
  final GameState state;
  final Widget route;
  final String text;
  const NavButton({super.key, required this.state, required this.route, required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.15,
      child: ElevatedButton(
        onPressed: () {
          state.ResetGameplayValues();
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => route),
          );
        },
        child: Text(text),
      ),
    );
  }
}
