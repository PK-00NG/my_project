import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(CupertinoIcons.arrow_left_to_line),
        ),
        centerTitle: true,
        title: const Text(
          'CATTLE LIST',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
    );
  }
}
