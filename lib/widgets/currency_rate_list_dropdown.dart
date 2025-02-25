import 'package:flutter/material.dart';
import 'package:flutter_task/model/country_rate_data.dart';
import 'package:flutter_task/utils/app_colors.dart';

class CurrencyListDropdown extends StatelessWidget {
  final List<CountryRate> countries;
  final CountryRate? selectedCountry;
  final ValueChanged<CountryRate?> onChanged;
  final TextEditingController controller;

  const CurrencyListDropdown({
    super.key,
    required this.countries,
    required this.selectedCountry,
    required this.onChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.all(15),
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
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "0.00",
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: DropdownButton<CountryRate>(
              value: selectedCountry,
              isExpanded: true,
              items:
                  countries.map((CountryRate country) {
                    return DropdownMenuItem<CountryRate>(
                      value: country,
                      child: Row(
                        children: [
                          Text(country.currencyCode),
                          const SizedBox(width: 10),
                          CircleAvatar(radius: 22, backgroundImage: AssetImage("assets/${country.countryFlag}")),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
