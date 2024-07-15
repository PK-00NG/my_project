import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_project/Screens/Pages/auth/components/my_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  bool signUpRequired = false;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Lenght = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(CupertinoIcons.mail_solid),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please fill in this field';
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                        .hasMatch(val)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  }
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: const Icon(CupertinoIcons.lock_fill),
                  OnChanged: (val) {
                    if(val!.contains(RegExp(r'[A-Z]'))) {
                      setState(() {
                        containsUpperCase = true;
                      });
                    } else {
                      setState(() {
                        containsUpperCase = false;
                      });
                    }
                    if(val.contains(RegExp(r'[a-z]'))) {
                      setState(() {
                        containsLowerCase = true;
                      });
                    } else {
                      setState(() {
                        containsLowerCase = false;
                      });
                    }
                    if(val.contains(RegExp(r'0-9'))) {
                      setState(() {
                        containsNumber = true;
                      });
                    } else {
                      setState(() {
                        containsNumber = false;
                      });
                    }
                    if(val.contains(RegExp(r'^(?=.*?[!@#\$&*~`)\%\-(_=+;:,.<>/?"[{\}]\[^]).{8,}$'))) {
                      setState(() {
                        containsSpecialChar = true;
                      });
                    } else {
                      setState(() {
                        containsSpecialChar = false;
                      });
                    }
                    if (val.length >= 8) {
                      setState(() {
                        contains8Lenght = true;
                      });
                    } else {
                      setState(() {
                        contains8Lenght = false;
                      });
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                        if(obscurePassword) {
                          iconPassword = CupertinoIcons.eye_fill;
                        } else {
                          iconPassword = CupertinoIcons.eye_slash_fill;
                        }
                      });
                    },
                    icon: Icon(iconPassword),
                  ),
                  validator: (val) {
                    if(val!.isEmpty) {
                      return 'Please fill in this field';
                    } else if(!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_=+;:,.<>/?"[{\}]\[^]).{8,}$').hasMatch(val)) {
                      return 'Please enter a valid password';
                    }
                    return null;
                  }
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "• 1 uppercase",
                        style: TextStyle(
                          color: containsUpperCase
                            ? Colors.lightGreen
                            : Theme.of(context).colorScheme.onBackground
                        ),
                      ),
                      Text(
                        "• 1 lowercase",
                        style: TextStyle(
                          color: containsLowerCase
                            ? Colors.lightGreen
                            : Theme.of(context).colorScheme.onBackground
                        ),
                      ),
                      Text(
                        "• 1 number",
                        style: TextStyle(
                          color: containsNumber
                            ? Colors.lightGreen
                            : Theme.of(context).colorScheme.onBackground
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "• 1 special character",
                        style: TextStyle(
                          color: containsSpecialChar
                            ? Colors.lightGreen
                            : Theme.of(context).colorScheme.onBackground
                        ),
                      ),
                      Text(
                        "• 8 minimum character",
                        style: TextStyle(
                          color: contains8Lenght
                            ? Colors.lightGreen
                            : Theme.of(context).colorScheme.onBackground
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: MyTextField(
                  controller: nameController, 
                  hintText: 'Name', 
                  obscureText: false, 
                  keyboardType: TextInputType.name,
                  prefixIcon: const Icon(CupertinoIcons.person_fill),
                  validator: (val) {
                    if(val!.isEmpty) {
                      return 'Please fill in this field';
                    } else if(val.length > 30) {
                      return 'Name too long';
                    }
                    return null;
                  }
                ),
              ),
              
          ],
        )),
    )
  }
}
