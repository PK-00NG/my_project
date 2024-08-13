import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/app.dart';
import 'package:my_project/simple_bloc_observer.dart';
import 'package:user_repository/user_repository.dart';
/* import 'package:my_project/Screens/Pages/ListPage.dart'; */

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp(FirebaseUserRepo()));
}
