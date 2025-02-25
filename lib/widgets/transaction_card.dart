
import 'package:flutter/material.dart';
import 'package:flutter_task/utils/app_colors.dart';

class TransactionCard extends StatelessWidget {
  final String name;
  final String date;
  final String amount;
  final String convertedAmount;
  final String transactionId;

  TransactionCard({
    required this.name,
    required this.date,
    required this.amount,
    required this.convertedAmount,
    required this.transactionId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0.5,
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$date | Pending",
              style: const TextStyle(color: AppColors.textHint, fontWeight: FontWeight.w400, fontSize: 15),
            ),
            Text(
              transactionId,
              style: const TextStyle(color: AppColors.textHint, fontWeight: FontWeight.w400, fontSize: 15),
            ),
          ],
        ),
        trailing: SizedBox(
          width: 125,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                amount,
                style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(convertedAmount, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15.5), maxLines: 2),
            ],
          ),
        ),
      ),
    );
  }
}