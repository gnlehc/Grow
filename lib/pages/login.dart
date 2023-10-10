import 'package:flutter/material.dart';
import 'package:grow/pages/home.dart';
import 'package:grow/pages/register.dart';
import '../Auth/firebase.dart';

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
                // final scaffoldMessanger = ScaffoldMessenger.of(context);

                // final result = await _auth.signIn(
                //     _emailController.text, _passwordController.text);
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  isLogin
                      ? _auth.signIn(email, password)
                      : 'There is no account that match these credentials';
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const Home();
                  }));
                }
                // scaffoldMessanger.showSnackBar(SnackBar(
                //     backgroundColor: Colors.green[100],
                //     content: Text(
                //       result != null ? "Login Success" : "Login Failed",
                //     )));
              },
              child: const Text("Login"),
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
