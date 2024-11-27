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
import 'dart:io' ;
import 'GameScreen.dart';


import 'main.dart';

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({Key? key}) : super(key: key);

  @override
  _MenuPrincipalState createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
//  late GifController _gifController;


  @override
  void initState() {
    super.initState();

    // Inicializa el AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(); // Looping para la animación

    // Inicializa el GifController
//    _gifController = GifController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
//    _gifController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        //title: Center(child: Text('HAnGMaN GAME')),
      ),
          body: Stack(
          children: [
          // Widget que muestra el GIF de fondo
          Positioned.fill(
          child: Image.asset('assets/Gifs/HungManBackground01.gif',
          fit: BoxFit.cover, // Para que ocupe toda la pantalla
          ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Container(
                  //height: screenHeight * 0.2,
                  child: Center(
                    child: Stack( // Usamos Stack para superponer los textos
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
                    ),
                  ),
                ),

                Container(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.2,
                  child: ElevatedButton(
                    onPressed: () {
                      // Acción para jugar
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => const GameUI()),
                      );
                    },
                    child: const Text('JUGAR'),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.2,
                  child: ElevatedButton(
                    onPressed: () {
                      // Acción para ranking
                      /*Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Ranking()),
                      );*/
                    },
                    child: const Text('RANKING'),
                  ),
                ),
                const SizedBox(height: 20),
                //if (Platform.isAndroid || Platform.isIOS)
                  if (!kIsWeb) //comprobar si esta ejecutando en chrome, si es asi, no muestra el boton
                  Container(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.2,

                    child: ElevatedButton(
                      onPressed: () {
                        // Acción para salir
                        if (Platform.isAndroid || Platform.isIOS) {//si está en android/ios, cierra
                          // En Android y iOS
                          SystemNavigator
                              .pop(); // Se recomienda usar esto para cerrar la aplicación
                        } else {//si está en desktop, pone pestaña en negro
                          // En Web y otras plataformas
                          Navigator.pop(
                              context); // Vuelve a la pantalla anterior o puedes usar Navigator.of(context).maybePop();
                        }
                      },
                      child: const Text('SALIR'),
                    ),
                  ),



              ],
            ),
          ),
        ],
      ),
    );
  }
}
