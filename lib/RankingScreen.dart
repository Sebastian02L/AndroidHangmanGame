import 'package:dadm_practica2/MainMenuScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'main.dart';

List<Map<String, dynamic>>? top3;

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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: screenWidth * 0.7, // Ancho para la caja
                    height: screenHeight * 0.13, // Alto
                    decoration: BoxDecoration(
                      color: Colors.white, // Fondo blanco
                      border: Border.all(
                        width: 8, // Grosor del borde
                        color: Colors.black, // Color del borde
                      ),
                      borderRadius:
                          BorderRadius.circular(15), // Borde redondeado
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      // Espaciado dentro de la caja
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Centrado horizontal
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // Centrado vertical
                        children: <Widget>[
                          Text(
                            'RANKING',
                            style: TextStyle(
                                fontFamily: 'PermanentMarker',
                                fontSize: 32), // Tamaño  para la caja
                          ),
                          SizedBox(width: 10),
                          // Espacio entre el texto y el ícono
                          Icon(
                            Icons.emoji_events_outlined,
                            color: Colors.black,
                            size: 32.0, // Tamaño para el ícono
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 9,
                      color: Colors.black, // Borde negro
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.01),
                    // Ajusta el espacio superior
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '3 mejores puntuaciones',
                                style: TextStyle(
                                  fontFamily: 'PermanentMarker',
                                  fontSize: 20,
                                  color: Colors.black, // Texto en negro
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 7,
                                    color: Colors
                                        .black, // Borde negro para cada ítem
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  title: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      getPosition(index),
                                      style: TextStyle(
                                        fontFamily: 'PermanentMarker',
                                        fontSize: 20,
                                        color: Colors.black, // Texto en negro
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        // Imagen de la calavera debajo de las puntuaciones
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 25.0),
                            // Espacio entre la imagen y los bordes
                            child: Image.asset(
                              'assets/Images/skull.png',
                              // Ruta de la imagen de la calavera
                              width: screenWidth * 0.8,
                              // Tamaño ajustado a la pantalla
                              height: screenHeight * 0.1,
                              // Tamaño ajustado a la pantalla
                              fit: BoxFit.contain, // Ajuste de la imagen
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            // Ajusta la posición vertical del botón
            left: 20,
            // Ajusta la posición horizontal del botón
            width: screenWidth * 0.2,
            height: screenHeight * 0.09,
            child: ElevatedButton(
              onPressed: () {
                PlayAudio("Click.mp3", 0);
                // Navigar al Menú Principal
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MenuPrincipal()), // Asegúrate de tener este widget definido
                );
              },
              child: Text('<',
                  style: TextStyle(
                    fontFamily: 'PermanentMarker',
                    fontSize: 30,
                    color: Colors.black,
                  )),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                shadowColor: Colors.black,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  side: BorderSide(
                    width: 7.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String getPosition(int index) {
  if (index >= top3!.length) {
    return "Sin datos almacenados.";
  } else {
    var name = top3?[index]["name"];
    if (name == "") name = "Desconocido";
    var points = "${top3![index]["points"]}pts";
    return (name + " - " + points);
  }
}

void getTop3() async {
  //Se llama desde la pantalla de resultados, según se actualiza la tabla, para que ya esté cargado el ránking al abrir esta pestaña
  top3 = await helper.getTop3Ranking();
}
