import 'package:flutter/material.dart';
import 'package:grow/pages/home_page.dart';
import 'package:grow/pages/register_page.dart';

import '../database/firebase.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLogin = false;
  String email = '';
  String password = '';
  final FirebaseService _auth = FirebaseService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
        title: const Text('Login'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset('assets/grow.png', width: 160, height: 120),
            const SizedBox(
              height: 20,
            ),
            isLogin
                ? Container()
                : TextFormField(
                    key: const ValueKey('email'),
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter your email';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      setState(() {
                        email = value!;
                      });
                    },
                  ),
            const SizedBox(height: 20.0),
            TextFormField(
              key: const ValueKey('password'),
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your password';
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                setState(() {
                  password = value!;
                });
              },
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                      horizontal: 160.0, vertical: 16.0)),
                  backgroundColor: MaterialStateProperty.all(Colors.black)),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  var result = await _auth.signIn(email, password);
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  scaffoldMessenger.showSnackBar(SnackBar(
                    backgroundColor:
                        result != null ? Colors.green[600] : Colors.red,
                    content: Text(result != null
                        ? "Login Success"
                        : 'Sign-in failed. Please check your credentials and try again.'),
                  ));
                  if (result != null) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Home()));
                  }
                }
              },
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
                onTap: () {
                  // Navigator.pushNamed(context, '/register');
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Register()));
                },
                child: RichText(
                    text: const TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "Don't have an account yet? ",
                      style: TextStyle(color: Color.fromARGB(255, 30, 30, 30))),
                  TextSpan(
                    text: "Register here",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.underline),
                  ),
                ])))
          ]),
        ),
      ),
    );
  }
}
