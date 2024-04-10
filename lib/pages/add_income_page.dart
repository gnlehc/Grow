import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grow/database/firebase.dart';

class AddIncome extends StatelessWidget {
  const AddIncome({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Income'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Enter Amount'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                int amount = int.tryParse(amountController.text) ?? 0;

                String userId = FirebaseAuth.instance.currentUser!.uid;

                await FirebaseService().topUpBalance(userId, amount);

                Navigator.pop(context);
              },
              child: const Text('Confirm Top Up'),
            ),
          ],
        ),
      ),
    );
  }
}
