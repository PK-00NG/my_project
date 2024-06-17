import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_project/Screens/Pages/ListPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cattle Weight',
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.lightBlue,
            appBarTheme: AppBarTheme(backgroundColor: Colors.amber)),
        home: HomePage());
  }
}
