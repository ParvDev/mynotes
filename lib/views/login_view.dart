import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: ListView(
        children: [
          const Icon(
            CupertinoIcons.profile_circled,
            size: 300,
            color: Colors.grey,
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email here',
              contentPadding: EdgeInsets.all(20),
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password here',
              contentPadding: EdgeInsets.all(20),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                final userCredential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                print(userCredential);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  print('User not found');
                } else if (e.code == 'wrong-password') {
                  print('Wrong password');
                }
              }
            },
            child: const Text(
              'Login',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/register/',
                (route) => false,
              );
            },
            child: const Text(
              'Not registered yet? Register here!',
              style: TextStyle(
                fontSize: 23,
              ),
            ),
          )
        ],
      ),
    );
  }
}
