import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gif/gif.dart';
//https://pub.dev/documentation/animated_glitch/latest/topics/Without%20shader-topic.html
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gif/gif.dart';

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({Key? key}) : super(key: key);

  @override
  _MenuPrincipalState createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late GifController _gifController;


  @override
  void initState() {
    super.initState();

    // Inicializa el AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(); // Looping para la animación

    // Inicializa el GifController
    _gifController = GifController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _gifController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('HAnGMaN GAME')),
      ),
          body: Stack(
          children: [
          // Widget que muestra el GIF de fondo
          Positioned.fill(
          child: Image.asset(
          'assets/HungManBackground01.gif',
          fit: BoxFit.cover, // Para que ocupe toda la pantalla
          ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.2,
                  child: ElevatedButton(
                    onPressed: () {
                      // Acción para jugar
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
                    },
                    child: const Text('RANKING'),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.2,
                  child: ElevatedButton(
                    onPressed: () {
                      // Acción para salir
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
