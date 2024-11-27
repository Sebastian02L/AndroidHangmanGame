import 'package:flutter/material.dart';
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
          Positioned.fill(
            child: Image.asset(
              'assets/Gifs/HungManBackground01.gif',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Text(
                          'RANKINg',
                          style: TextStyle(
                            fontSize: 40,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.blue[700]!,
                          ),
                        ),
                        Text(
                          'RANKINg',
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.2,
                  decoration: BoxDecoration(color: Colors.blue),
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
                                'aaaa - 0'
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
        ],
      ),
    );
  }
}
