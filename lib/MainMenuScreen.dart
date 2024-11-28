import 'package:dadm_practica2/GameSettingsScreen.dart';
import 'package:dadm_practica2/ResultScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:gif/gif.dart';

//https://pub.dev/documentation/animated_glitch/latest/topics/Without%20shader-topic.html
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart'; // Importar para kIsWeb
import 'package:gif/gif.dart';
import 'dart:io';
import 'GameScreen.dart';
import 'RankingScreen.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main.dart';


class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({Key? key}) : super(key: key);

  @override
  _MenuPrincipalState createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
<<<<<<< Updated upstream
=======

//  late GifController _gifController;
>>>>>>> Stashed changes

  @override
  void initState() {
    super.initState();

    // Inicializa el AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(); // Looping para la animación
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
<<<<<<< Updated upstream
          // GIF de fondo de pantalla
          Positioned.fill(
            child: Image.asset(
              'assets/Gifs/VideoLetras4.gif',
=======
          // Widget que muestra el GIF de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/Gifs/HungManBackground01.gif',
>>>>>>> Stashed changes
              fit: BoxFit.cover, // Para que ocupe toda la pantalla
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
<<<<<<< Updated upstream
                // CAJA Y TITULO
                Padding(
                  padding: EdgeInsets.fromLTRB(screenWidth*0.03, screenHeight*0.05 ,screenWidth*0.03 ,0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      // linea del borde del box
                      border: Border.all(
                        width: 8,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'HANGMAN',
                            style: GoogleFonts.permanentMarker(fontSize: 40),
                            /*TextStyle(
                              fontSize: 40,
                            ),*/

                          ),

                          //ROW para que sea icono texto icono
                          Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/Images/skull.png',
                              height: 40,
                              width: 40,
                              //'assets/Images/image1.png',
                            ),
                            /*
                            Icon(
                            Icons.cruelty_free,
                            color: Colors.black,
                            size: 24.0,
                            semanticLabel: 'Text to announce in accessibility modes',
                            ),*/
                            Text(
                              'GAME',
                              style: GoogleFonts.permanentMarker(fontSize: 40),
                            ),
                            /*Icon(
                            Icons.flutter_dash,
                            color: Colors.black,
                            size: 36.0,
                            ),
                            */
                            Image.asset(
                              'assets/Images/skull.png',
                              height: 40,
                              width: 40,
                              //'assets/Images/image1.png',
                            ),

                            ]

                          ),
                        ],
                      ),
=======
                Container(
                  //height: screenHeight * 0.2,
                  child: Center(
                    child: Stack(
                      // Usamos Stack para superponer los textos
                      alignment: Alignment.center,
                      children: [
                        Text(
                          'HAnGMaN GAME',
                          style: TextStyle(
                            fontSize: 40,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.blue[700]!,
                          ),
                        ),
                        Text(
                          'HAnGMaN GAME', // Relleno del texto de arriba
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
>>>>>>> Stashed changes
                    ),
                  ),
                ),
/*
                // ESPACIADO
                const SizedBox(height: 20),
                // BOTON JUGAR
                Container(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.1,
                  child: ElevatedButton(
                    onPressed: () {
                      // Acción para jugar
                      Navigator.push(
                        context,
<<<<<<< Updated upstream
                        MaterialPageRoute(builder: (context) => const GameUI()),
=======
                        MaterialPageRoute(
                            builder: (context) => const GameSettingsUI()),
>>>>>>> Stashed changes
                      );
                    },
                    child: const Text('JUGAR'),
                  ),
                ),
                // ESPACIADO
                const SizedBox(height: 20),
                // BOTON RANKING
                Container(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.1,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.9), // Shadow color with opacity
                        spreadRadius: 1, // Spread value
                        blurRadius: 0, // Blur value
                        offset: Offset(5, 7), // Offset (horizontal, vertical)
                      ),
                    ],
                  ),


                  child: ElevatedButton(
                    onPressed: () {
                      // Acción para ranking
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Ranking()),
                      );
                    },

                    child: const Text('RANKING'),
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.blue, //specify the button's elevation color
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)
                        ),
                      side: BorderSide(
                        width: 5.0,
                        color: Colors.black,
                         //buttons Material shadow
                      ),


                      ),
                    ),
                  ),
                ),
                // ESPACIADO
                const SizedBox(height: 20),
<<<<<<< Updated upstream
                if (!kIsWeb) // Comprobar si está ejecutando en Chrome, si es así, no muestra el botón
                // BOTON SALIR
                  Container(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.1,
=======
                //if (Platform.isAndroid || Platform.isIOS)
                if (!kIsWeb) //comprobar si esta ejecutando en chrome, si es asi, no muestra el boton
                  Container(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.2,
>>>>>>> Stashed changes
                    child: ElevatedButton(
                      onPressed: () {
                        // Acción para salir
                        if (Platform.isAndroid || Platform.isIOS) {
<<<<<<< Updated upstream
                          // si está en Android/iOS, cierra
                          SystemNavigator.pop(); // Se recomienda usar esto para cerrar la aplicación
                        } else {
                          // si está en desktop, pone pestaña en negro
                          Navigator.pop(context);
=======
                          //si está en android/ios, cierra
                          // En Android y iOS
                          SystemNavigator
                              .pop(); // Se recomienda usar esto para cerrar la aplicación
                        } else {
                          //si está en desktop, pone pestaña en negro
                          // En Web y otras plataformas
                          Navigator.pop(
                              context); // Vuelve a la pantalla anterior o puedes usar Navigator.of(context).maybePop();
>>>>>>> Stashed changes
                        }
                      },
                      child: const Text('SALIR'),
                    ),
                  ),
<<<<<<< Updated upstream
*/
                //////////////////////////////////////////////
                const SizedBox(height: 20),

                GenericButton(
                  buttonName: 'JUGAR',
                  widthFactor: 0.4,
                  heightFactor: 0.1,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GameUI()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                GenericButton(
                  buttonName: 'RANKING',
                  widthFactor: 0.4,
                  heightFactor: 0.1,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Ranking()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                if (!kIsWeb)
                  GenericButton(
                    buttonName: 'SALIR',
                    widthFactor: 0.4,
                    heightFactor: 0.1,
                    onPressed: () {
                      // Acción para salir
                      if (Platform.isAndroid || Platform.isIOS) {
                        // si está en Android/iOS, cierra
                        print('ESTOYENANDROID');
                        SystemNavigator.pop(); // Se recomienda usar esto para cerrar la aplicación
                      } else {
                        // si está en desktop, pone pestaña en negro
                        print('ESTOYENOTRACOSA');
                        exit(0);
                        //Navigator.pop(context);
                      }
                    },
                  ),
                //////////////////////////////////////////////

                //IMAGEN CALAVERA
                const SizedBox(height: 10),
                Container(
                  child: Image.asset(
                    'assets/Images/skull.png',
                    height: screenHeight*0.3,
                    width: screenWidth*0.3,
                    //'assets/Images/image1.png',
                  ),
                )

=======
>>>>>>> Stashed changes
              ],
            ),

          ),
        ],
      ),
    );
  }
}




class GenericButton extends StatelessWidget {
  final String buttonName;
  final double widthFactor; // Cambié el tipo de int a double para mayor precisión
  final double heightFactor; // Cambié el tipo de int a double para mayor precisión
  final VoidCallback onPressed; // Función que se ejecutará cuando se presione el botón

  GenericButton({
    Key? key,
    required this.buttonName,
    required this.widthFactor,
    required this.heightFactor,
    required this.onPressed, // Requiere la función onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * widthFactor,
      height: MediaQuery.of(context).size.height * heightFactor,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.9),
            spreadRadius: 1,
            blurRadius: 0,
            offset: Offset(5, 7),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed, // Asigna la función onPressed pasada como parámetro
        child: Text(
          buttonName,
          style: GoogleFonts.permanentMarker(fontSize: 40), // Asegurar que la fuente sea la correcta
        ),
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.blue,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            side: BorderSide(
              width: 5.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}