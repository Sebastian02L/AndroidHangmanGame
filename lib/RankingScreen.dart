import 'package:dadm_practica2/MainMenuScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class Ranking extends StatefulWidget {
  const Ranking({Key? key}) : super(key: key);

  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;


    return Scaffold(

      body: Stack(
        children: [
          //GIF BACKGROUND
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
                Container(
                  child: Center(
                    child : Padding(
                      padding: EdgeInsets.fromLTRB(0,screenHeight*0.05,0,0),
                      //alignment: Alignment.topCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                           Text(
                            'RANKINg',
                            style: GoogleFonts.permanentMarker(fontSize: 40),
                          ),
                           Icon(
                              Icons.emoji_events_outlined,
                              color: Colors.black,
                              size: 40.0,
                            ),
                      ],
                    ),
                  ),
                ),
                ),

                const SizedBox(height: 30),

                Container(
                  width: screenWidth * 0.6,
                  height: screenHeight * 0.6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // linea del borde del box
                    /*border: Border.all(
                      width: 8,
                      color: Colors.black,
                    ),*/
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text('5 mejores puntuaciones', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            //buscar en el documento donde se guarden las mejores puntuaciones
                            //var pair = appState.favorites[index];
                            return ListTile(
                              title: Text(
                                //pair = texto donde se guarde el ranking
                                // pair,
                                'aaaa - 0',
                                  style: GoogleFonts.permanentMarker
                                    (fontSize: 30,
                                    color: Colors.black,
                                  )
                              ),
                            );
                            },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20, // Ajusta la posición vertical del botón
            left: 20, // Ajusta la posición horizontal del botón
            width: screenWidth * 0.2,
            height: screenHeight * 0.1,
            child: ElevatedButton(
              onPressed: () {
                PlayAudio("Click.mp3", 0);
                // Navigar al Menú Principal
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MenuPrincipal()), // Asegúrate de tener este widget definido
                );
              },
              child: Text(
                  '<',
                  style: GoogleFonts.permanentMarker
                    (fontSize: 40, color: Colors.black,
                  )
              ), // Texto del botón
            ),
          ),
        ],
      ),
    );
  }
}
