import 'package:flutter/material.dart';
import 'package:flutter_task/model/country.dart';
import 'package:flutter_task/provider/auth_provider.dart';
import 'package:flutter_task/provider/getcurrencyData_provider.dart';
import 'package:flutter_task/utils/app_colors.dart';
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

class CountrySearchTile extends StatefulWidget {
  final String initialCountryFlag;
  final String initialCountryName;
  final Function(Country) onSearchPressed;

  const CountrySearchTile({
    Key? key,
    required this.initialCountryFlag,
    required this.initialCountryName,
    required this.onSearchPressed,
  }) : super(key: key);

  @override
  _CountrySearchTileState createState() => _CountrySearchTileState();
}

class _CountrySearchTileState extends State<CountrySearchTile> {
  late String countryFlag;
  late String countryName;
  TextEditingController searchController = TextEditingController();
  List<Country> filteredCountries = [];

  @override
  void initState() {
    super.initState();
    countryFlag = widget.initialCountryFlag;
    countryName = widget.initialCountryName;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(countryFlag),
                  backgroundColor: const Color.fromARGB(255, 228, 231, 238),
                  radius: 18,
                ),
                const SizedBox(width: 10),
                Text(countryName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),

            // Search Icon Button
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey, size: 30),
              onPressed: () async {
                await _fetchAndShowCountryDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchAndShowCountryDialog(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final countryProvider = Provider.of<CountryProvider>(context, listen: false);

    if (authProvider.userData != null) {
      await countryProvider.fetchCountries(
        authProvider.userData!.clientID,
        authProvider.userData!.branchID,
        authProvider.userData!.countryID,
      );
    }

    _showCountryDialog(context);
  }

  void _showCountryDialog(BuildContext context) {
    final countryProvider = Provider.of<CountryProvider>(context, listen: false);
    final countryList = countryProvider.countries;
    final isLoading = countryProvider.isLoading;

    setState(() {
      filteredCountries = countryList;
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Column(
            children: [
              Text("Select a Country", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
            ],
          ),
          content:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                    width: double.maxFinite,
                    height: 300,
                    child: ListView.builder(
                      itemCount: filteredCountries.length,
                      itemBuilder: (context, index) {
                        final country = filteredCountries[index];
                        return ListTile(
                          leading: CircleAvatar(backgroundImage: AssetImage("assets/${country.flag}"), radius: 15),
                          title: Text(country.countryName),
                          subtitle: Text("Country: ${country.countryName} | Currency: ${country.countryCurrency}"),
                          onTap: () {
                            setState(() {
                              countryFlag = "assets/${country.countryFlag}"; // Update flag
                              countryName = country.countryName; // Update name
                            });

                            Navigator.pop(context); // Close dialog
                            widget.onSearchPressed(country); // Pass selected country data
                          },
                        );
                      },
                    ),
                  ),
        );
      },
    );
  }
}

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
