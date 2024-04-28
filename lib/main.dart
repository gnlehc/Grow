import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grow/pages/home_page.dart';
import 'package:grow/pages/login_page.dart';
import 'package:grow/pages/register_page.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasData) {
            return const Home();
          } else {
            return const Login();
          }
        },
      ),
      routes: {
        '/login': (context) {
          if (FirebaseAuth.instance.currentUser != null) {
            return const Home();
          } else {
            return const Login();
          }
        },
        '/register': (context) {
          if (FirebaseAuth.instance.currentUser != null) {
            return const Home();
          } else {
            return const Register();
          }
        },
      },
    );
  }
}
