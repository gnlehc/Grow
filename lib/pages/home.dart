import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
        title: const Text('E-Wallet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut().then((value) =>
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Login())));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Balance',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '\$1,234.56',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 30, 30, 30))),
                onPressed: () {},
                child: const Text('Top Up'),
              ),
              const SizedBox(height: 16),
              ListView(
                shrinkWrap: true, // Add this line
                children: [
                  TransactionItem(
                    title: 'Restaurant',
                    date: 'Today',
                    amount: '-\$45.67',
                  ),
                  TransactionItem(
                    title: 'Online Shopping',
                    date: 'Yesterday',
                    amount: '-\$89.99',
                  ),
                  // Add more transaction items here
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String title;
  final String date;
  final String amount;

  TransactionItem(
      {required this.title, required this.date, required this.amount});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.amber,
        child: Icon(Icons.shopping_cart, color: Colors.white),
      ),
      title: Text(title),
      subtitle: Text(date),
      trailing: Text(
        amount,
        style: TextStyle(
          color: amount.startsWith('-') ? Colors.red : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Stream<List<User>> getUser() => FirebaseFirestore.instance
//     .collection('users')
//     .snapshots()
//     .map((event) => event.docs.map((e) => User.fromjson(e.data())).toList());
