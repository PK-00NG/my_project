import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Row(
          children: [
            Text(
              'CATTLE LIST',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            )
          ],
        ),
      ),
    );
  }
}
