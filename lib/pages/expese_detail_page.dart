import 'package:flutter/material.dart';
import 'package:grow/database/firebase.dart';

class TransactionDetailPage extends StatefulWidget {
  final String category;
  final int amount;
  final DateTime date;
  final String userId;
  final String transactionId;

  const TransactionDetailPage({
    super.key,
    required this.category,
    required this.amount,
    required this.date,
    required this.userId,
    required this.transactionId,
  });

  @override
  _TransactionDetailPageState createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  late TextEditingController _categoryController;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController(text: widget.category);
    _amountController = TextEditingController(text: widget.amount.toString());
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            Text(
              'Date: ${widget.date.toString()}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await _firebaseService.updateTransaction(
                        userId: widget.userId,
                        transactionId: widget.transactionId,
                        category: _categoryController.text,
                        amount: int.parse(_amountController.text),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Transaction updated successfully'),
                        ),
                      );
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to update transaction: $e'),
                        ),
                      );
                    }
                  },
                  child: const Text('Update'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await _firebaseService.deleteTransaction(
                        userId: widget.userId,
                        transactionId: widget.transactionId,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Transaction deleted successfully')),
                      );
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Failed to delete transaction: $e')),
                      );
                    }
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
