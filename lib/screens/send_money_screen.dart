import 'package:flutter/material.dart';
import 'package:flutter_task/model/country.dart';
import 'package:flutter_task/model/country_rate_data.dart';
import 'package:flutter_task/provider/getcurrencyData_provider.dart';
import 'package:flutter_task/utils/app_colors.dart';
import 'package:flutter_task/widgets/currency_dropdown.dart';
import 'package:flutter_task/widgets/currency_rate_list_dropdown.dart';
import 'package:provider/provider.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  TextEditingController sendingAmountController = TextEditingController();
  TextEditingController recipientGetsController = TextEditingController();
  String exchangeRate = '0.00';
  String transferFees = '0.00';
  String totalAmountToPay = '0.00';
  String sendingCountryCode = '';
  String recipientCountryCode = '';
  List<Country> countries = [];
  List<CountryRate> countryRateList = [];
  Country? selectedForSender;
  CountryRate? selectedForRecipent;

  @override
  void initState() {
    super.initState();
    sendingAmountController.addListener(_updateCalculations);
  }

  @override
  void dispose() {
    sendingAmountController.removeListener(_updateCalculations);
    super.dispose();
  }

  void _updateCalculations() {
    double sendingAmount = double.tryParse(sendingAmountController.text) ?? 0.0;
    double rate = selectedForRecipent?.rate ?? 0.0;
    double fees = selectedForRecipent?.transferFeesGBP ?? 0.0;

    double recipientAmount = sendingAmount * rate;
    double total = sendingAmount + fees;

    setState(() {
      recipientGetsController.text = recipientAmount.toStringAsFixed(2);
      exchangeRate = rate.toStringAsFixed(2);
      transferFees = fees.toStringAsFixed(2);
      totalAmountToPay = "${total.toStringAsFixed(2)} $sendingCountryCode";
      recipientCountryCode = selectedForRecipent?.currencyCode ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final countryProvider = Provider.of<CountryProvider>(context);
    final country = countryProvider.countries;
    final ratesDetails = countryProvider.countryRates;
    countries = country;
    countryRateList = ratesDetails;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(height: 5),
                    walletCard("assets/images/flags/CAD.png", "0.00", "CAD", onAddFunds: () {}, onWithdraw: () {}),
                    walletCard("assets/images/flags/ngn.png", "0.00", "NGN", onAddFunds: () {}, onWithdraw: () {}),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Padding(padding: EdgeInsets.only(left: 15), child: Text("Sending Amount")),
                  CurrencyDropdown(
                    countries: countries,
                    selectedCountry: selectedForSender,
                    onChanged: (Country? value) {
                      setState(() {
                        selectedForSender = value;
                        sendingCountryCode = value!.countryCurrency;
                      });
                      _updateCalculations();
                    },
                    controller: sendingAmountController,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 15), child: Text("Recipient Gets")),
                  CurrencyListDropdown(
                    countries: countryRateList,
                    selectedCountry: selectedForRecipent,
                    onChanged: (CountryRate? value) {
                      setState(() {
                        selectedForRecipent = value;
                      });
                      _updateCalculations();
                    },
                    controller: recipientGetsController,
                  ),
                  Container(
                    height: 40,
                    margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: AppColors.cardBackground,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 2.1,
                          spreadRadius: 1.0,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total Amount To pay", style: TextStyle(fontWeight: FontWeight.w500)),
                          Text(totalAmountToPay, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 90,
                    width: 500,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: AppColors.cardBackground,
                    ),
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 5),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 55, top: 15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Transfer Fees", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              Text(
                                "$transferFees $sendingCountryCode",
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Exchange Rate", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              Text(
                                "$exchangeRate $recipientCountryCode",
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: SizedBox(
                      width: 500,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0544CA),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'send money',
                          style: TextStyle(
                            color: Color.fromARGB(221, 230, 223, 223),
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget walletCard(
    String imgPath,
    String amount,
    String countryName, {
    required VoidCallback onAddFunds,
    required VoidCallback onWithdraw,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: SizedBox(
        height: 200,
        width: 300,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0544CA),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                CircleAvatar(
                  backgroundImage: AssetImage(imgPath),
                  backgroundColor: const Color.fromARGB(255, 228, 231, 238),
                  radius: 25,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Wallet Balance",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  "$countryName $amount",
                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: onAddFunds,
                      child: const Text(
                        '+Funds wallet',
                        style: TextStyle(color: Color(0xFF0544CA), fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0544CA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.white, width: 1),
                        ),
                      ),
                      onPressed: onWithdraw,
                      child: const Text('Withdraw', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
