import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameSettingsUI extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(color: theme.colorScheme.onPrimary);

    return Scaffold(
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: theme.colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text("Ajustes de la partida", style: style),
              ),
            ),
          ],
        ),
      ),
    );
  }
}