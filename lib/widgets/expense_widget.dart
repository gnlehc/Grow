import 'package:flutter/material.dart';
import 'package:grow/pages/expese_detail_page.dart';

class TransactionItem extends StatelessWidget {
  final String title;
  final String date;
  final int amount;
  final String userId;
  final String transactionId;

  const TransactionItem({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.userId,
    required this.transactionId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionDetailPage(
              category: title,
              amount: amount.toInt(),
              date: DateTime.parse(date),
              userId: userId,
              transactionId: transactionId,
            ),
          ),
        );
      },
      child: ListTile(
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
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
