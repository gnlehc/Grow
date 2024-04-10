import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grow/database/firebase.dart';
import 'package:grow/pages/add_transaction_page.dart';
import 'package:grow/pages/login_page.dart';
import 'package:grow/pages/top_up_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Stream<int> _balanceStream;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _transactionStream;
  late String _userEmail = '';
  late final String _username = _userEmail.split('@').first.trim();

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _balanceStream = _createBalanceStream(currentUser.uid);
      _transactionStream = _createTransactionStream(currentUser.uid);
      _userEmail = currentUser.email ?? '';
    }
  }

  Stream<int> _createBalanceStream(String userId) async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 2));
      yield await FirebaseService().getBalance(userId);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _createTransactionStream(
      String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
        title: const Text(
          'Ledger',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              } catch (e) {
                print('Error signing out: $e');
              }
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
              Text(
                'Hi $_username!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Balance',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      StreamBuilder<int>(
                        stream: _balanceStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final balance = snapshot.data ?? 0;
                            return Text(
                              // '\$$balance',
                              'Rp. $balance',
                              style: TextStyle(
                                fontSize: 24,
                                color: balance >= 0 ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // Adjust as needed
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 65),
                      backgroundColor:
                          Colors.blueGrey[900], // Adjust color as needed
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TopUpPage()),
                      );
                    },
                    child: const Text(
                      'Top Up',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 40),
                      backgroundColor: Colors.blueGrey[900],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddTransactionPage()),
                      );
                    },
                    child: const Text(
                      'Add Transaction',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _transactionStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final data = snapshot.data;
                    if (data == null || data.docs.isEmpty) {
                      return const Text('No transactions yet.');
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.docs.length,
                      itemBuilder: (context, index) {
                        final transaction = data.docs[index].data();
                        final category = transaction['category'];
                        final date =
                            (transaction['date'] as Timestamp?)?.toDate();
                        final amount = transaction['amount'];
                        return TransactionItem(
                          title: category,
                          date: date?.toString() ?? '',
                          amount: amount.toString(),
                        );
                      },
                    );
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

class TransactionItem extends StatelessWidget {
  final String title;
  final String date;
  final String amount;

  const TransactionItem({
    required this.title,
    required this.date,
    required this.amount,
  });

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
        'Rp. $amount',
        style: const TextStyle(
          color: Colors.red,
          // color: amount.startsWith('-') ? Colors.red : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
