import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Sign Up'),
      ),
      body: ListView(
        children: [
          const Icon(
            Icons.app_registration_rounded,
            size: 300,
            color: Colors.grey,
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                hintText: 'Enter your email here',
                contentPadding: EdgeInsets.all(20)),
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
            height: 20.0,
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                final userCredential =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                print(userCredential);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  print("Weak password");
                } else if (e.code == 'email-already-in-use') {
                  print("email is already in use");
                } else if (e.code == 'invalid-email') {
                  print("Invalid email address");
                }
              }
            },
            child: const Text(
              'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login/',
                (route) => false,
              );
            },
            child: const Text(
              'Already registered? Login here',
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
