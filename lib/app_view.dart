import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/Screens/Pages/home_page/views/main_screen.dart';

import 'package:my_project/blocs/authentication/authentication_bloc.dart';

import 'Screens/Pages/login_page/blocs/sign_in/sign_in_bloc.dart';
import 'Screens/Pages/login_page/views/welcome_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Cattle Weight',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.light(
                background: Colors.grey.shade200,
                onBackground: Colors.black,
                primary: Color(0xFF7B3113),
                onPrimary: Colors.white,
                secondary: Color(0xFFD2B48C),
                onSecondary: Color(0xFFE8CA2C))),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: ((context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return BlocProvider(
                create: (context) => SignInBloc(
                    context.read<AuthenticationBloc>().userRepository),
                child: MainScreen(),
              );
            } else {
              return const WelcomeScreen();
            }
          }),
        ));
  }
}
