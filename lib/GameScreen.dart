import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

//Widget que contiene toda la interfaz de la pantalla de juego
class GameUI extends StatelessWidget {
  const GameUI({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<GameState>();

   appState.SetUpGame();

    return Scaffold(
      body: Container( //Lo encerramos todo en un container para poner un padding superior
        padding: EdgeInsets.only(top: 20.0),
        child: Center( //Todos los elementos de la UI estarán centrados en la pantalla
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Parte superior de la interfaz, las cards de puntuacion, numero de rondas, tiempo y los textos
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Textos superiores
                    Flexible( //Flexible permite que el widget sea responsivo, indicando en flex cuanto tiene que ocupar
                        flex: 2,
                        child: TextCard(text: "Round"),
                    ),
                    Flexible(
                        flex: 2,
                        child: SizedBox(child: Padding(padding: EdgeInsets.all(10)))
                    ),
                    Flexible(
                        flex: 6,
                      child: TextCard(text: "Puntuation"),
                    ),
                    Flexible(
                        flex: 2,
                        child: SizedBox(child: Padding(padding: EdgeInsets.all(10)))),
                    Flexible(
                        flex: 2,
                      child: TextCard(text: "Time"),
                    )
                  ],
                ),
                // Cards superiores
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible( //Flexible permite que el widget sea responsivo, indicando en flex cuanto tiene que ocupar
                        flex: 2,
                        child: WordsCounter(counter: appState.currentRound,totalWords: appState.maxRounds)),
                    Flexible(
                        flex: 2,
                        child: SizedBox(child: Padding(padding: EdgeInsets.all(10)))),
                    Flexible(
                        flex: 6,
                        child: PuntuationCard(puntuation: appState.puntuation)),
                    Flexible(
                        flex: 2,
                        child: SizedBox(child: Padding(padding: EdgeInsets.all(10)))),
                    Flexible(
                        flex: 2,
                        child: PuntuationCard(puntuation: appState.currentTime))
                  ],
                ),
                SizedBox(height: 30),
                //Zona donde aparece el muñeco
                Flexible(
                    flex : 2,
                    child: GamePlaceHolder()
                ),
                SizedBox(height: 1),
                //Caja donde se intenta adivinar la palabra
                Flexible(
                    flex : 1,
                    child: WordBox()
                ),
                Flexible(
                    flex: 1,
                    child: Keyboard()
                )
              ],
          ),
        )
      )
    );
  }
}

//Widget para colocar el texto que va encima de los cards de la sona superior de la interfaz
class TextCard extends StatelessWidget{
  final String text;
  const TextCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)
      ),
      child: SizedBox( //El child box creara un padding alrededor del texto
        height: 20,
        child: Center(
          child: Text("$text"),
        ),
      ),
    );
  }
}

//Widget para crear la card de la puntuacion
class PuntuationCard extends StatelessWidget{

  final int puntuation;
  const PuntuationCard({super.key, required this.puntuation});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5)
      ),
      child: SizedBox( //El child box creara un padding alrededor del texto
        height: 50,
        child: Center(
          child: Text("$puntuation"),
        ),
      ),
    );
  }
}

//Widget que crea el cartel donde se muestra el contador de palabras y las palabras que faltan
class WordsCounter extends StatelessWidget{

  final int counter;
  String totalWords;
  WordsCounter({super.key, required this.counter, required this.totalWords});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)
      ),
      child: SizedBox( //El child box creara un padding alrededor del texto
        height: 50,
        child: Center(
          child: Text("$counter / $totalWords"),
        ),
      ),
    );
  }
}

//Aqui deberia estar lo de las imagenes que deben ir pasando o el video que se debe reproducir
class GamePlaceHolder extends StatelessWidget {
  GamePlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<GameState>();

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
        child: AspectRatio(
            aspectRatio: 1, //Se asegura de que la relacion de aspecto del hijo sea 1
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: appState.GetImage()
                )
            )
        )
    );
  }
}

//Widget para gestionar la palabra a adivinar
class WordBox extends StatelessWidget{
  WordBox({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<GameState>();
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: SizedBox(
                  height: 100,
                  width: 500,
                  child: Center(
                    child: Text(appState.hiddenWord, style: TextStyle(letterSpacing: 2.0),)
                  )
                )
        )
    );
  }
}

//Widget para crear los botones del teclado
class KeyboardButton extends StatelessWidget{
  final String letter;
  KeyboardButton({super.key, required this.letter});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<GameState>();
    return Flexible(
      flex: 1,
      child: Padding(padding: EdgeInsets.all(2),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey
          ),
          onPressed: (){
            if(appState.canUseKeyboard){
              appState.IsCharacterCorrect(letter.toLowerCase());
            } else {
              print("teclado desactivado hasta que inicie la siguiente ronda");}
            },
          child: Center(child: Text(letter)),
        ),
      )
    );
  }
}

//Widget que crea los botones del teclado
class Keyboard extends StatelessWidget{
  Keyboard({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              KeyboardButton(letter: "Q"),
              KeyboardButton(letter: "W"),
              KeyboardButton(letter: "E"),
              KeyboardButton(letter: "R"),
              KeyboardButton(letter: "T"),
              KeyboardButton(letter: "Y"),
              KeyboardButton(letter: "U"),
              KeyboardButton(letter: "I"),
              KeyboardButton(letter: "O"),
              KeyboardButton(letter: "P"),
            ],
          ),
          Row(
            children: [
              KeyboardButton(letter: "A"),
              KeyboardButton(letter: "S"),
              KeyboardButton(letter: "D"),
              KeyboardButton(letter: "F"),
              KeyboardButton(letter: "G"),
              KeyboardButton(letter: "H"),
              KeyboardButton(letter: "J"),
              KeyboardButton(letter: "K"),
              KeyboardButton(letter: "L"),
              KeyboardButton(letter: "Ñ"),
            ],
          ),
          Row(
            children: [
              KeyboardButton(letter: "Z"),
              KeyboardButton(letter: "X"),
              KeyboardButton(letter: "C"),
              KeyboardButton(letter: "V"),
              KeyboardButton(letter: "B"),
              KeyboardButton(letter: "N"),
              KeyboardButton(letter: "M")
            ],
          )
        ],
      ),
    );
  }
}