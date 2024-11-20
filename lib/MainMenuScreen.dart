import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MenuPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HAnGMaN GAME',
          textAlign: TextAlign.center,
        ),

      ),
    body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

              ElevatedButton(
                  onPressed: () {
                    // Acción para el primer botón
                  },
                  child: Text('JUGAR'),
                ),
            SizedBox(height: 20), // Espacio entre los botones

              ElevatedButton(
                    onPressed: () {
                      // Acción para el segundo botón
                    },
                    child: Text('RANKING'),
                  ),
            SizedBox(height: 20), // Espacio entre los botones

              ElevatedButton(
                    onPressed: () {
                      // Acción para el tercer botón
                    },
                    child: Text('SALIR'),
                  ),

          ],
        ),
      ),
    );
  }
}