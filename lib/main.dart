import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/app.dart';
import 'package:my_project/simple_bloc_observer.dart';
import 'package:user_repository/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();

  final userRepository = FirebaseUserRepo();

  runApp(
    RepositoryProvider<UserRepository>(
      create: (context) => userRepository,
      child: MyApp(userRepository),
    ),
  );
}
