import 'package:flutter/material.dart';

class WalletCards extends StatelessWidget {
  final String currency;
  final String imgPath;

  WalletCards({required this.currency, required this.imgPath});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 0.5,
        color: Colors.white, // Set white background for the Card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Optional: Adds rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // Stack to position text above the CircleAvatar
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: const Text(
                      "Wallet",
                      style: TextStyle(
                        color: Colors.black, // White text color
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage(imgPath),
                    backgroundColor: const Color.fromARGB(255, 228, 231, 238),
                    radius: 18,
                  ),
                ],
              ),

              const SizedBox(width: 5),

              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(currency, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
