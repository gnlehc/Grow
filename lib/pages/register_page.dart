import 'package:flutter/material.dart';
import 'package:grow/pages/home_page.dart';
import 'package:grow/pages/login_page.dart';

import '../database/firebase.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseService _auth = FirebaseService();

  @override
  void dispose() {
    super.dispose();
    _fullNameController.dispose();
    _usernameController.dispose();
    _telephoneNumController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  String fullName = "";
  String username = "";
  String email = "";
  String password = "";
  String tel = "";
  double balance = 0.00;
  // final FirebaseService _auth = FirebaseService();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _telephoneNumController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKeyReg = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 30, 30, 30),
          title: const Text('Register'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKeyReg,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/grow.png', width: 140, height: 120),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    key: const ValueKey('fullName'),
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your full name';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      setState(() {
                        fullName = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    key: const ValueKey('username'),
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your username';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      setState(() {
                        username = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    key: const ValueKey('telephoneNum'),
                    controller: _telephoneNumController,
                    decoration: const InputDecoration(
                        labelText: 'Telephone Number',
                        border: OutlineInputBorder(),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your telephone number';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      setState(() {
                        tel = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    key: const ValueKey('email'),
                    controller: _emailController,
                    decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                    validator: (value) {
                      if (value!.isEmpty) {
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
                  const SizedBox(height: 12.0),
                  TextFormField(
                    key: const ValueKey('password'),
                    controller: _passwordController,
                    obscureText: true, // Password should be hidden
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password are required';
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
                  const SizedBox(height: 12.0),
                  ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 120.0, vertical: 14.0)),
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 30, 30, 30))),
                    onPressed: () async {
                      final scaffoldMessanger = ScaffoldMessenger.of(context);
                      if (formKeyReg.currentState!.validate()) {
                        formKeyReg.currentState!.save();
                      }
                      var result = await _auth.signUp(
                          email, password, username, tel, fullName);

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Home()));

                      scaffoldMessanger.showSnackBar(SnackBar(
                        backgroundColor: Colors.green[100],
                        content: Text(
                          result != null
                              ? "Register Success"
                              : "Register Failed",
                        ),
                      ));
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  GestureDetector(
                      onTap: () {
                        // Navigator.pushNamed(context, '/login');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Login()));
                      },
                      child: RichText(
                          text: const TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(color: Colors.black)),
                        TextSpan(
                          text: "Login here",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              decoration: TextDecoration.underline),
                        ),
                      ])))
                ],
              ),
            ),
          ),
        ));
  }
}
