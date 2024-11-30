import 'package:dadm_practica2/GameSettingsScreen.dart';
import 'package:dadm_practica2/ResultScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
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

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/Gifs/VideoLetras4.gif',
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // Título del juego
                  Padding(
                    padding: EdgeInsets.fromLTRB(screenWidth * 0.03, screenHeight * 0.05, screenWidth * 0.03, 0),
                    child: _buildTitle(),
                  ),

                  const SizedBox(height: 20),

                  // Botones del menú
                  _buildMenuButtons(screenWidth, screenHeight),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 8, color: Colors.black),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              'HANGMAN',
              style: GoogleFonts.permanentMarker(fontSize: 40),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildSkullIcon(),
                Text(
                  'GAME',
                  style: GoogleFonts.permanentMarker(fontSize: 40),
                ),
                _buildSkullIcon(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkullIcon() {
    return Image.asset(
      'assets/Images/skull.png',
      height: 40,
      width: 40,
    );
  }

  Widget _buildMenuButtons(double screenWidth, double screenHeight) {
    return Column(
      children: [
        // Botón JUGAR
        GenericButton(
          buttonName: 'JUGAR',
          widthFactor: 0.6,
          heightFactor: 0.1,
          onPressed: () {
            PlayAudio("Click.mp3", 0);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GameSettingsUI()),
            );
          },
        ),
        const SizedBox(height: 20),
        // Botón RANKING
        GenericButton(
          buttonName: 'RANKING',
          widthFactor: 0.5,
          heightFactor: 0.1,
          onPressed: () {
            PlayAudio("Click.mp3", 0);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Ranking()),
            );
          },
        ),
        const SizedBox(height: 20),
        // Botón SALIR
        if (!kIsWeb) // si no es ejecutado en web
          GenericButton(
            buttonName: 'SALIR',
            widthFactor: 0.9,
            heightFactor: 0.1,
            onPressed: () {
              PlayAudio("Click.mp3", 0);
              if (Platform.isAndroid || Platform.isIOS) {
                SystemNavigator.pop();
              } else {
                exit(0);
              }
            },
          ),
        // Imagen calavera
        const SizedBox(height: 10),
        Image.asset(
          'assets/Images/skull.png',
          height: screenHeight * 0.3,
          width: screenWidth * 0.3,
        ),
      ],
    );
  }
}

class GenericButton extends StatelessWidget {
  final String buttonName;
  final double widthFactor;
  final double heightFactor;
  final VoidCallback onPressed;

  GenericButton({
    Key? key,
    required this.buttonName,
    required this.widthFactor,
    required this.heightFactor,
    required this.onPressed,
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
        onPressed: onPressed,
        child: Text(
          buttonName,
          style: GoogleFonts.permanentMarker(fontSize: 30),
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
