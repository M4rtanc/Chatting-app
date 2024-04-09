//import 'package:chat_app/models/app_user.dart';
import 'package:chat_app/models/app_user.dart';
import 'package:chat_app/services/authentication_service.dart';
import 'package:chat_app/services/app_user_service.dart';
import 'package:chat_app/shared/ioc_container.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../shared/const.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final AuthenticationService _auth = AuthenticationService();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Registration"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(BIG_PADDING),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: MEDIUM_PADDING,
                      ),
                      child: TextField(
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.withOpacity(OPACITY),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintText: "Username"),
                          controller: _usernameController),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: MEDIUM_PADDING,
                      ),
                      child: TextField(
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.withOpacity(OPACITY),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintText: "Email"),
                          controller: _emailController),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: MEDIUM_PADDING,
                        ),
                        child: TextFormField(
                            autovalidateMode: AutovalidateMode.always,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.withOpacity(OPACITY),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "Password"),
                            validator: (value) {
                              if (value != null && value != "" && value.length < 6) {
                                return "Password must have at least 6 characters";
                              }
                              if (value != null && value != "" && !value.contains(RegExp(r"[A-Z]"))) {
                                return "Password must contain at least 1 UPPER CASE character A-Z";
                              }
                              if (value != null && value != "" && !value.contains(RegExp(r"[0-9]"))) {
                                return "Password must contain at least 1 number 0-9";
                              }
                              return null;
                            },
                            controller: _passwordController)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: MEDIUM_PADDING,
                      ),
                      child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.withOpacity(OPACITY),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintText: "Confirm password"),
                          validator: (value) {
                            if (_passwordController.text != _confirmPasswordController.text) {
                              print("validator value: $value");
                              return "Passwords are different";
                            }
                            return null;
                          },
                          controller: _confirmPasswordController),
                    ),
                    Expanded(child: Container()),
                    FilledButton(
                        style: const ButtonStyle(
                          backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.grey),
                        ),
                        onPressed: _sigUp,
                        child: const Text("Register")),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }

  void _sigUp() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    final userService = get<AppUserService>();

    if (!_isValid(_passwordController.text) ||
        _passwordController.text != _confirmPasswordController.text) {
      const failureSnackBar = SnackBar(
        content: Text("New password is not valid or is not confirmed correctly"),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(failureSnackBar);
      return;
    }

    try {
      var user = await _auth.signUpWithEmailAndPassword(email, password);
      if (user != null) {
        userService.createAppUser(AppUser(username: username, email: email));
        const successSnackBar = SnackBar(
          content: Text("Account successfully created"),
          backgroundColor: Colors.green,
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
          Navigator.pop(context);
        }
        print("user succesfully created");
      }
    } catch (e) {
      final errorSnackBar = SnackBar(
        content: Text("$e"),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
      }
    }
  }

  bool _isValid(String password) {
    if (password == "" ||
        (password.length >= 6 &&
            password.contains(RegExp(r"[A-Z]")) &&
            password.contains(RegExp(r"[0-9]"))
        )) {
      return true;
    }
    return false;
  }
}
