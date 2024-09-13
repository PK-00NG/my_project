import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/components/my_text_field.dart';
import 'package:user_repository/user_repository.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  bool _isEmailFocused = false;

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isEmailFocused = _emailFocus.hasFocus;
    });
  }

  @override
  void dispose() {
    _emailFocus.removeListener(_onFocusChange);
    _emailFocus.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forget Password')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(Icons.email),
                focusNode: _emailFocus,
                isFocused: _isEmailFocused,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(val)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Reset Password'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context
                        .read<UserRepository>()
                        .resetPassword(emailController.text)
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Password reset email sent. Check your inbox.')),
                      );
                      Navigator.pop(context);
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Failed to send reset email: $error')),
                      );
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
