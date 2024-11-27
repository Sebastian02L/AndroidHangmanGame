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

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//Punto de inicio de nuestra aplicacion
void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Carga los datos desde el archivo CSV a la base de datos
    await loadWordsFromCSV();
    print("Datos cargados exitosamente.");
  } catch (e) {
    print("Error al cargar los datos: $e");
  }

  // Ahora ejecuta la aplicación después de haber cargado los datos.
  runApp(const MyApp());
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
        ),
        home: MenuPrincipal(),
      ),
    );
  }
}

//Clase que representa el estado del juego
class GameState extends ChangeNotifier {
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

  //Lista de palabras a adivinar
  var words;
  var username = "";
  //Variable que define los dos modos de juego
  bool MarathonMode = true;

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
  final MARATHON_MODE_TIME = 120;
  final MARATHON_MODE_MAX_ROUNDS = "∞";
  final NORMAL_MODE_MAX_ROUNDS = "10";
  final MAX_ERRORS = 7;

  //En Flutter las cadenas de texto son inmutables, es decir, no podemos acceder a un char y cambiarlo directamente,
  //para ello utilizamos un buffer.
  StringBuffer buffer = StringBuffer();

  //////////////////// METODOS PARA GESTIONAR LA PARTIDA ////////////////////

  //Prepara la partida con la configuracion aplicada en la pantalla de configuracion
  void SetUpGame() {
    //Solo debe ejecutarse una vez al iniciar la partida
    if(setUpMatch){
      if(MarathonMode){
        maxRounds = MARATHON_MODE_MAX_ROUNDS;
        currentTime = MARATHON_MODE_TIME;

        //Obtenemos la lista de palabras de la BD que aun no existe. Usamos estas de prueba
        words = List.of(["Tomate", "Casa", "Almendra", "Casita", "Mesa", "Esporas", "Galleta", "Queso", "Pimienta", "Pera"]);
        SetUpRound();
        setUpMatch = false;
        //Iniciar el temporizador. Cada segundo se actualizara el tiempo.
        Timer.periodic(Duration(seconds: 1), (timer) {UpdateTimer(timer) ;});
      }
      else {
        maxRounds = NORMAL_MODE_MAX_ROUNDS;

        //Obtenemos la lista de palabras de la BD que aun no existe
        words = List.of(["Tomate", "Casa", "Almendra", "Casita", "Mesa", "Esporas", "Galleta", "Queso", "Pimienta", "Pera"]);
        SetUpRound();
        setUpMatch = false;
      }
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
    }
    else if(!currentWord.contains(char)){
      numErrors++;
      totalErrors++;
      if(currentStreak > highestStreak){
        highestStreak = currentStreak;
      }
      currentStreak = 0;
      incorrectChars.add(char);
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

      if(MarathonMode){
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
    MarathonMode = true;
    setUpMatch = true;
    canUseKeyboard = false;
    currentWord = "";
    hiddenWord = "";
    highestStreak = 0;
    correctChars.clear();
    incorrectChars.clear();
  }

  //Se llama al terminar la partida de cualquier manera
  void FinishMatch(){
    canUseKeyboard = false;
    print("Ha terminado la partida");
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



/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var history = <WordPair>[];

  GlobalKey? historyListKey;

  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? current;
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // The container for the current page, with its background color
    // and subtle switching animation.
    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            // Use a more mobile-friendly layout with BottomNavigationBar
            // on narrow screens.
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite),
                        label: 'Favorites',
                      ),
                    ],
                    currentIndex: selectedIndex,
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                )
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text('Favorites'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: HistoryListView(),
          ),
          SizedBox(height: 10),
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    Key? key,
    required this.pair,
  }) : super(key: key);

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: AnimatedSize(
          duration: Duration(milliseconds: 200),
          // Make sure that the compound word wraps correctly when the window
          // is too narrow.
          child: MergeSemantics(
            child: Wrap(
              children: [
                Text(
                  pair.first,
                  style: style.copyWith(fontWeight: FontWeight.w200),
                ),
                Text(
                  pair.second,
                  style: style.copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        Expanded(
          // Make better use of wide windows with a grid.
          child: GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              childAspectRatio: 400 / 80,
            ),
            children: [
              for (var pair in appState.favorites)
                ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.delete_outline, semanticLabel: 'Delete'),
                    color: theme.colorScheme.primary,
                    onPressed: () {
                      appState.removeFavorite(pair);
                    },
                  ),
                  title: Text(
                    pair.asLowerCase,
                    semanticsLabel: pair.asPascalCase,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class HistoryListView extends StatefulWidget {
  const HistoryListView({Key? key}) : super(key: key);

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  /// Needed so that [MyAppState] can tell [AnimatedList] below to animate
  /// new items.
  final _key = GlobalKey();

  /// Used to "fade out" the history items at the top, to suggest continuation.
  static const Gradient _maskingGradient = LinearGradient(
    // This gradient goes from fully transparent to fully opaque black...
    colors: [Colors.transparent, Colors.black],
    // ... from the top (transparent) to half (0.5) of the way to the bottom.
    stops: [0.0, 0.5],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    appState.historyListKey = _key;

    return ShaderMask(
      shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
      // This blend mode takes the opacity of the shader (i.e. our gradient)
      // and applies it to the destination (i.e. our animated list).
      blendMode: BlendMode.dstIn,
      child: AnimatedList(
        key: _key,
        reverse: true,
        padding: EdgeInsets.only(top: 100),
        initialItemCount: appState.history.length,
        itemBuilder: (context, index, animation) {
          final pair = appState.history[index];
          return SizeTransition(
            sizeFactor: animation,
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  appState.toggleFavorite(pair);
                },
                icon: appState.favorites.contains(pair)
                    ? Icon(Icons.favorite, size: 12)
                    : SizedBox(),
                label: Text(
                  pair.asLowerCase,
                  semanticsLabel: pair.asPascalCase,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
*/