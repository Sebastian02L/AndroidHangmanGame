// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'Database/csv_loader.dart';
import 'Database/database_helper.dart';
import 'GameScreen.dart';
import 'GameSettingsScreen.dart';
import 'MainMenuScreen.dart';
import 'RankingScreen.dart';
import 'ResultScreen.dart';
import 'ResultScreen.dart';
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

typedef ShakeCallback = void Function();
final DatabaseHelper helper = DatabaseHelper();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final AudioPlayer sfxPlayer = AudioPlayer();
final AudioPlayer screamPlayer = AudioPlayer();
final AudioPlayer musicPlayer = AudioPlayer();
final List<AudioPlayer> players = [sfxPlayer, screamPlayer];
final random = Random();

//Punto de inicio de nuestra aplicacion
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  try {
    // Carga los datos desde el archivo CSV a la base de datos
    await loadWordsFromCSV();
    print("Datos cargados exitosamente.");
  } catch (e) {
    print("Error al cargar los datos: $e");
  }
  getTop3(); //Se carga el ránking
  PlayMusic("MainMusic.mp3");

  //Después de haber cargado los datos, indicamos la orientacion deseada y iniciamos la app
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    //DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameState(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: "Hangman Game",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MenuPrincipal(),
      ),
    );
  }
}

//Clase que representa el estado del juego
class GameState extends ChangeNotifier {
  String? playerName;
  String? selectedCategory;
  String? selectedMode;

  void setPlayerName(String? value){
    playerName = value;
  }

  void setSelectedCategory(String? value){
    selectedCategory = value;
  }

  void setSelectedMode(String? value){
    selectedMode = value;
    if(selectedMode == "Marathon"){
      marathonMode = true;
    }
  }

  //Lista de fotos:
  final List<String> images = [
    'assets/Images/image1.png',
    'assets/Images/image2.png',
    'assets/Images/image3.png',
    'assets/Images/image4.png',
    'assets/Images/image5.png',
    'assets/Images/image6.png',
    'assets/Images/image7.png',
    'assets/Images/image8.png',
  ];

  //Variables de acelerómetro:
  var canShake = true;
  var warningText = "";

  //Lista de palabras a adivinar
  var words;
  //Variable que define los dos modos de juego
  bool marathonMode = false;

  //Variables de la interfaz
  var puntuation = 0;
  var numErrors = 0;
  var totalErrors = 0;
  var currentRound = 1;
  String maxRounds = "";
  var currentTime = 0; //Tiempo de la partida para el modo Maraton
  var currentStreak = 0;
  var highestStreak = 0;

  //Indica si debe preparar una nueva partida
  var setUpMatch = true;

  //Variables de la partida
  var currentWord;  //Cadena a adivinar
  var hiddenWord; //Cadena que se muestra en la UI
  bool canUseKeyboard = false; //Activa o desactiva los botones del teclado

  //Listas que almacenaran las letras usadas, tanto las correctas como las incorrectas
  List<String> correctChars = [""];
  List<String> incorrectChars = [""];

  //Constantes de la partida
  final MARATHON_MODE_TIME = 180;
  final MARATHON_MODE_MAX_ROUNDS = "∞";
  final NORMAL_MODE_MAX_ROUNDS = "10";
  final MAX_ERRORS = 7;

  //En Flutter las cadenas de texto son inmutables, es decir, no podemos acceder a un char y cambiarlo directamente,
  //para ello utilizamos un buffer.
  StringBuffer buffer = StringBuffer();

  //////////////////// METODOS PARA GESTIONAR LA PARTIDA ////////////////////

  //Prepara la partida con la configuracion aplicada en la pantalla de configuracion
  void SetUpGame() {
    if(marathonMode){
      maxRounds = MARATHON_MODE_MAX_ROUNDS;
      currentTime = MARATHON_MODE_TIME;

      SetUpRound();
      setUpMatch = false;
      //Iniciar el temporizador. Cada segundo se actualizara el tiempo.
      Timer.periodic(Duration(seconds: 1), (timer) {UpdateTimer(timer) ;});
    }
    else {
      maxRounds = NORMAL_MODE_MAX_ROUNDS;

      SetUpRound();
      setUpMatch = false;
    }
  }

  //Se llama cada segundo y actualiza el tiempo de la partida
  void UpdateTimer(Timer timer){
    currentTime -= 1;
    UpdateUI();
    if(currentTime <= 0){
      FinishMatch();
    }

    //Esto detiene el temporizador una vez que se pierde en el modo maraton
    if(numErrors >= MAX_ERRORS){
      timer.cancel();
    }

    if(currentTime == 0){
      timer.cancel();
    }
  }

  //Prepara las rondas del juego
  void SetUpRound() {
      currentWord = words[0].toLowerCase();
      words.removeAt(0);

      int characters = currentWord.length;
      String word = "";

      //Crea la cadena de texto oculta segun el numero de letras
      for (int i = 0; i < characters; i++) {
        word += "_";
      }

      hiddenWord = word;
      numErrors = 0;
      canUseKeyboard = true;
      incorrectChars.clear();
      correctChars.clear();

      print("Ronda preparada");
    }

  //Comprueba si la letra pulsada es correcta o incorrecta
  void IsCharacterCorrect(String char) {
    if (currentWord.contains(char) && !hiddenWord.contains(char)) {
      //Muestra la letra en la cadena oculta
      SwapLetter(char);
      currentStreak++;
      correctChars.add(char);
      PlayAudio("Correct.mp3", 0);
    }
    else if(!currentWord.contains(char)){
      numErrors++;
      totalErrors++;
      puntuation -= 5;
      if(puntuation < 0) {
        puntuation = 0;
      }
      if(currentStreak > highestStreak){
        highestStreak = currentStreak;
      }
      currentStreak = 0;
      incorrectChars.add(char);
      if(char != '_') PlayAudio("Wrong.mp3", 0); //Que no suene si agitas el móvil
      if(random.nextBool()){
        PlayAudio("Grito1.mp3", 1);
      }
      else{
        PlayAudio("Grito2.mp3", 1);
      }
    }

    //Comprobamos si ya ha perdido todas sus "vidas"
    if(numErrors >= MAX_ERRORS){
      //Se detiene el temporizador
      print("Numero maximo de errores alcanzados");
      FinishMatch();
    }

    //Comprobamos si ha adivinado toda la palabra
    if(CheckWinCondition()){
      canUseKeyboard = false;
      currentRound += 1;
      puntuation += 100;

      if(marathonMode){
        Timer(Duration(milliseconds: 10), () {
          SetUpRound();
          UpdateUI();
        }); //Se pasa rápido a la siguiente pregunta
      }
      else if(currentRound <= int.parse(maxRounds)){
        Timer(Duration(milliseconds: 2000), () {
          SetUpRound();
          UpdateUI();
        });
      }
      else{
        print("Rondas completadas");
        FinishMatch();
      }
    }
    //Actualiza el contenido de la UI independientemente de si ha acertado o no
    UpdateUI();
  }

  //Se encarga de mostrar las letras correcta en la cadena oculta
  void SwapLetter(String letter){

    for(int i = 0; i < currentWord.length; i++){
      //Si coincide la letra pulsada con la letra iterada, escribimos en su posicion la letra pulsada
      if(currentWord[i] == letter){
        buffer.write(letter);
      }
      //En caso contrario, escribimos lo que ya tiene en esa posicion la cadena oculta
      else
      {
        buffer.write(hiddenWord[i]);
      }
    }
    hiddenWord = buffer.toString();

    //Limpiamos el buffer de cara al siguiente uso del metodo
    buffer.clear();
  }

  //Comprueba si ha adivinado la palabra
  bool CheckWinCondition(){
    return hiddenWord == currentWord;
  }

  Image GetImage(){
    return Image.asset(images[numErrors]);
  }

  //Resetea los valores por defecto de cara a iniciar nuevas partidas.
  //IMPORTANTE: Suponiendo que al acabar una partida, se pasa a la pantalla de resultados y se hace lo siguiente:
  //1) Mostrar los resultados 2) Subirlos al ranking de la BD, este metodo debe llamarse DESPUES de subirlo a la BD.
  void ResetGameplayValues(){
    puntuation = 0;
    numErrors = 0;
    totalErrors = 0;
    currentRound = 1;
    maxRounds = "";
    setUpMatch = true;
    canUseKeyboard = false;
    currentWord = "";
    hiddenWord = "";
    highestStreak = 0;
    correctChars.clear();
    incorrectChars.clear();
    warningText = "";
  }

  //Se llama al terminar la partida de cualquier manera
  void FinishMatch(){
    canUseKeyboard = false;
    print("Ha terminado la partida");
    helper.insertRanking(playerName, puntuation);
    getTop3(); //Llama a la función de la pestaña de ránking para que actualice ya el top3
    Timer(Duration(milliseconds: 1000), () {GoToResults();});
  }

  void GoToResults(){
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => ResultUI()),
    );
  }

  ////// METODOS PARA ACTUALIZAR LA INTERFAZ //////
  void UpdateUI(){
    notifyListeners();
  }

  //
  bool? CheckButtonStatus(String character){
    //Comprobamos si la letra es usada es correcta y por ende la ponemos de verde
    if(correctChars.contains(character)){
      return true;
    }
    //Comprobamos si la letra usada es incorrecta y por ende la ponemos rojo
    else if(incorrectChars.contains(character)){
      return false;
    }
    else {
      return null;
    }
  }
}

class AccelerometerHandler {
  final double shakeThreshold;
  final ShakeCallback onShake;

  AccelerometerHandler({this.shakeThreshold = 15.0, required this.onShake});

  void startListening() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      double magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (magnitude > shakeThreshold) {
        onShake();
      }
    });
  }
}

void PlayAudio(String fileName, int playerIndex) async {
  await players[playerIndex].stop();
  await players[playerIndex].play(AssetSource('Audio/$fileName'));
}

void PlayMusic(String fileName) async{
  await musicPlayer.setReleaseMode(ReleaseMode.loop);
  await musicPlayer.play(AssetSource('Audio/$fileName'));
}
