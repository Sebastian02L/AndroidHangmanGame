import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Clase que representa el estado del juego con las variables que necesitamos y gestiona la partida
class GameManager extends ChangeNotifier{
  //Variables
  var words = List.of(["Tomate"]);
  var currentWord;
  var puntuation = 0;
  var currentRound = 0;

  //Actualiza la puntuacion del jugador
  void UpdatePuntuation(int points){
    puntuation = points;
    notifyListeners();
  }

  //Actualiza el numero de rondas
  void UpdateRound(){
    puntuation += 1;
    notifyListeners();
  }

  //Metodo llamado al comienzo de cada ronda para obtener la palabra
  String GetNextWord(){
    currentWord = words.removeAt(0);
    return currentWord;
  }

  //Devuelve la palabra actual
  String GetCurrentWord(){
    return currentWord;
  }

  //Comprueba si la letra pulsada es correcta
  bool IsCharacterCorrect(String char){
   return currentWord.contains(char);
  }



}


//Widget que contiene toda la interfaz de la pantalla de juego
class GameUI extends StatelessWidget {
  const GameUI({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<GameManager>();
    return Scaffold(
      body: Container( //Lo encerramos todo en un container para poner un padding superior
        padding: EdgeInsets.only(top: 20.0),
        child: Center( //Todos los elementos de la UI estarán centrados en la pantalla
            child: Column(
              children: [

                //Parte superior de la interfaz, las cards de puntuacion y numero de palabras
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible( //Flexible permite que el widget sea responsivo, indicando en flex cuanto tiene que ocupar
                        flex: 1,
                        child: WordsCounter(counter: appState.currentRound)),
                    Flexible(
                        flex: 1,
                        child: SizedBox(child: Padding(padding: EdgeInsets.all(10)))),
                    Flexible(
                        flex: 3,
                        child: PuntuationCard(puntuation: appState.puntuation)),
                  ],
                ),
                SizedBox(height: 20),
                //Zona donde aparece el muñeco
                Flexible(
                    flex : 1,
                    child: GamePlaceHolder()
                ),
                SizedBox(height: 20),
                //Caja donde se intenta adivinar la palabra
                Flexible(
                    flex : 1,
                    child: WordBox()
                ),
                SizedBox(height: 20),
                Keyboard()
              ],
          ),
        )
      )
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
  String? totalWords;
  WordsCounter({super.key, required this.counter, this.totalWords = "∞"});

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
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
        child: AspectRatio(
            aspectRatio: 1, //Se asegura de que la relacion de aspecto del hijo sea 1
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: Text("Imagen"),
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
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: SizedBox(
                  height: 100,
                  child: Center(
                    child: Text(SetUpWord())
                  )
                )
        )
    );
  }

  //Consigue los caracteres de la palabra a adivinar y muestra los guiones en la Card
  String SetUpWord(){
    int characters = GameManager().GetNextWord().length;
    String word = "";

    for(int i = 0; i < characters; i++){
      word +="_ ";
    }

    return word;
  }
}

//Widget para crear los botones del teclado
class KeyboardButton extends StatelessWidget{
  final String letter;
  KeyboardButton({super.key, required this.letter});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Padding(padding: EdgeInsets.all(2),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey
          ),
          onPressed: (){ GetLetter(); },
          child: Center(child: Text(letter)),
        ),
      )
    );
  }

  //Metodo que se ejecuta al pulsar el boton, el
  String GetLetter(){
    return letter;
  }
}

//Widget que crea los botones del teclado
class Keyboard extends StatelessWidget{
  Keyboard({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}