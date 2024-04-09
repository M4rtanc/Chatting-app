import 'package:chat_app/pages/users_page.dart';
import 'package:chat_app/pages/registration_page.dart';
import 'package:chat_app/services/authentication_service.dart';
import 'package:flutter/material.dart';

import '../shared/const.dart';
import '../shared/ioc_container.dart';
import 'edit_profile_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthenticationService _auth = AuthenticationService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Chat app"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(BIG_PADDING),
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
                        hintText: "Email"),
                    controller: _emailController),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: MEDIUM_PADDING,
                  ),
                  child: TextField(
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
                      controller: _passwordController)),
              Expanded(child: Container()),
              FilledButton(onPressed: _sigIn, child: const Text("Login")),
              FilledButton(
                  style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.grey),
                  ),
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegistrationPage()),
                      ),
                  child: const Text("Registration")),
            ],
          ),
        ));
  }

  void _sigIn() async {
    print("Login tapped");

    String email = _emailController.text;
    String password = _passwordController.text;

    await _auth.signInWithEmailAndPassword(email, password).then((user) async {
      if (user != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const UsersPage()));
        return;
      }
      print("User not found!");
    }).catchError((error) {
      final failureSnackBar = SnackBar(
        content: Text(error.toString()),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(failureSnackBar);
      return;
    });
  }
}
