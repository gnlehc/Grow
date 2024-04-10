import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grow/database/firebase.dart';
import 'package:grow/pages/add_transaction_page.dart';
import 'package:grow/pages/login_page.dart';
import 'package:grow/pages/add_income_page.dart';
import 'package:grow/widgets/transaction_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Stream<int> _balanceStream;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _transactionStream;
  late String _userEmail = '';
  late final String _username = _userEmail.split('@').first.trim();
  late String _userId = '';

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _userId = currentUser.uid;
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
        backgroundColor: Colors.white,
        title: Text(
          'Hi $_username!',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
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
              Card(
                color: Colors.white,
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 50),
                      backgroundColor: Colors.blue, // Adjust color as needed
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddIncome()),
                      );
                    },
                    child: const Text(
                      'Add Income',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 50),
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddTransactionPage()),
                      );
                    },
                    child: const Text(
                      'Add Expense',
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
                        final transactionId = data.docs[index].id;

                        return TransactionItem(
                          title: category,
                          date: date?.toString() ?? '',
                          amount: amount.toInt(),
                          userId: _userId,
                          transactionId: transactionId,
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
