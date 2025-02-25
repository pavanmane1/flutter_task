import 'package:flutter/material.dart';
import 'package:flutter_task/model/country.dart';
import 'package:flutter_task/utils/app_colors.dart';

class CurrencyDropdown extends StatelessWidget {
  final List<Country> countries;
  final Country? selectedCountry;
  final ValueChanged<Country?> onChanged;
  final TextEditingController controller;

  const CurrencyDropdown({
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
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "0.00",
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {}, // Triggered by controller's listener
            ),
          ),
          SizedBox(
            width: 150,
            child: DropdownButton<Country>(
              value: selectedCountry,
              isExpanded: true,
              items:
                  countries.map((Country country) {
                    return DropdownMenuItem<Country>(
                      value: country,
                      child: Row(
                        children: [
                          Text(country.countryCurrency),
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
