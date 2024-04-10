import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grow/database/firebase.dart';

class TopUpPage extends StatelessWidget {
  const TopUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _amountController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Enter Amount'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Get the entered amount from the TextFormField
                int amount = int.tryParse(_amountController.text) ??
                    0; // Ensure amount is of type double

                // Get the current user's ID
                String userId = FirebaseAuth.instance.currentUser!.uid;

                // Call the FirebaseService method to top up the balance
                await FirebaseService().topUpBalance(userId, amount);

                // Navigate back to the previous page after topping up
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
