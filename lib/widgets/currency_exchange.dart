import 'package:flutter/material.dart';
import 'package:flutter_task/utils/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CurrencyExchangeTile extends StatelessWidget {
  final String fromFlag;
  final String fromCurrency;
  final String toFlag;
  final String toCurrency;
  final String exchangeRate;

  const CurrencyExchangeTile({
    required this.fromFlag,
    required this.fromCurrency,
    required this.toFlag,
    required this.toCurrency,
    required this.exchangeRate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundImage: AssetImage(fromFlag), radius: 15),
                const SizedBox(width: 8),
                Text(fromCurrency, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              ],
            ),
            const Row(
              mainAxisSize: MainAxisSize.min, // Prevents extra space
              children: [FaIcon(FontAwesomeIcons.arrowRightArrowLeft, color: AppColors.textPrimary, size: 20)],
            ),
            Row(
              children: [
                Text(exchangeRate, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                const SizedBox(width: 8),
                CircleAvatar(backgroundImage: AssetImage(toFlag), radius: 15),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
