import 'package:flutter/material.dart';
import 'package:flutter_task/model/country.dart';
import 'package:flutter_task/provider/auth_provider.dart';
import 'package:flutter_task/provider/getcurrencyData_provider.dart';
import 'package:provider/provider.dart';

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
