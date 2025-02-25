import 'package:flutter/material.dart';
import 'package:flutter_task/model/country.dart';
import 'package:flutter_task/provider/auth_provider.dart';
import 'package:flutter_task/provider/getcurrencyData_provider.dart';
import 'package:flutter_task/utils/app_colors.dart';
import 'package:flutter_task/widgets/currency_exchange.dart';
import 'package:flutter_task/widgets/currency_search.dart';
import 'package:flutter_task/widgets/transaction_card.dart';
import 'package:flutter_task/widgets/wallet_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final countryProvider = Provider.of<CountryProvider>(context);
    final userData = authProvider.userData;
    final country = countryProvider.countries[0];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (countryProvider.errorMessage != null) {
        _showErrorSnackbar(context, countryProvider.errorMessage!);
        countryProvider.clearError(); // Clear the error after displaying it
      }
    });
    return Scaffold(
      backgroundColor: AppColors.backgroundMainColor,
      body:
          userData == null
              ? const Center(child: CircularProgressIndicator()) // Show loading if userData is null
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 233, 185, 27),
                                    Color(0xFFFFA500),
                                    Color.fromARGB(255, 233, 185, 27),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              height: 65,
                              width: 300,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Container(
                                      height: 25,
                                      margin: const EdgeInsets.only(left: 50, right: 4),
                                      width: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColors.cardBackground,
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(width: 10),
                                          Text(
                                            "SHARE LINK | INVITE FRIEND TO SEND MONEY | GET REWARD",
                                            style: TextStyle(
                                              color: AppColors.textSecondary,
                                              fontSize: 6,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Text("www.calyx-solution.com", style: TextStyle(fontSize: 10)),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 233, 185, 27),
                                    Color(0xFFFFA500),
                                    Color.fromARGB(255, 233, 185, 27),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              height: 65,
                              width: 400,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WalletCards(currency: userData.currencyCode, imgPath: "assets/${userData.countryFlag}"),
                          WalletCards(currency: "NGN", imgPath: "assets/images/flags/ngn.png"),
                        ],
                      ),
                      const SizedBox(height: 25),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Transfer History", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                          Text(
                            "View All",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.buttonPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TransactionCard(
                        name: "Akash Test",
                        transactionId: "TX45408160",
                        date: "19 Feb 2025",
                        amount: "5.00 GBP",
                        convertedAmount: "9650.00 NGN",
                      ),
                      const SizedBox(height: 10),
                      TransactionCard(
                        name: "Akash Test",
                        transactionId: "TX1279135",
                        date: "19 Feb 2025",
                        amount: "2000.00 GBP",
                        convertedAmount: "3860000.00 NGN",
                      ),
                      const SizedBox(height: 20),
                      const Text("View Rates", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      CountrySearchTile(
                        initialCountryFlag: "assets/${country.flag}",
                        initialCountryName: country.countryName,
                        onSearchPressed: (Country selectedCountry) async {
                          await _fetchAndShowCountryRateDetails(
                            context,
                            selectedCountry.countryID,
                            selectedCountry.countryCurrency,
                          );
                        },
                      ),
                      CurrencyExchangeTile(
                        fromFlag: "assets/${userData.countryFlag}",
                        fromCurrency: "1.00 ${userData.currencyCode}",
                        toFlag:
                            countryProvider.countryRates.isNotEmpty
                                ? "assets/${countryProvider.countryRates[0].countryFlag}"
                                : "assets/images/flags/error.png", // Fallback if empty
                        toCurrency:
                            countryProvider.countryRates.isNotEmpty
                                ? "${countryProvider.countryRates[0].rate} ${countryProvider.countryRates[0].currencyCode}"
                                : "No Rate",
                        exchangeRate:
                            countryProvider.countryRates.isNotEmpty
                                ? "${countryProvider.countryRates[0].rate} ${countryProvider.countryRates[0].currencyCode}"
                                : "No Rate",
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red, duration: const Duration(seconds: 3)));
  }

  Future<void> _fetchAndShowCountryRateDetails(BuildContext context, String countryId, String countryCurrency) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final countryProvider = Provider.of<CountryProvider>(context, listen: false);

    if (authProvider.userData != null) {
      await countryProvider.fetchCountryRates(
        authProvider.userData!.clientID,
        countryId,
        authProvider.userData!.clientID,
        authProvider.userData!.clientID,
        authProvider.userData!.stepComplete,
        countryCurrency,
        authProvider.userData!.branchID,
        authProvider.userData!.currencyID,
      );
    }
  }
}
