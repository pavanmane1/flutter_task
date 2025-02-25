import 'package:flutter/material.dart';
import 'package:flutter_task/model/country.dart';
import 'package:flutter_task/model/country_rate_data.dart';
import 'package:flutter_task/services/services.dart';

class CountryProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Country> _countries = [];
  List<CountryRate> _countryRates = [];
  bool _isLoading = false;
  String? _errorMessage; // Store API error messages

  List<Country> get countries => _countries;
  List<CountryRate> get countryRates => _countryRates;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage; // Getter for error message

  // Method to clear error message after displaying it
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> fetchCountries(String clientID, String branchID, String countryID) async {
    _isLoading = true;
    _errorMessage = null; // Reset error message
    notifyListeners();

    try {
      _countries = await _apiService.fetchCountries(clientID, branchID, countryID);
    } catch (error) {
      _countries = [];
      _errorMessage = "Error fetching countries: $error"; // Store error message
      print(_errorMessage);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCountryRates(
    String clientID,
    String countryID,
    String paymentTypeID,
    String deliveryTypeID,
    String paymentDepositTypeID,
    String currencyCode,
    String branchID,
    String baseCurrencyID,
  ) async {
    _isLoading = true;
    _errorMessage = null; // Reset error message
    notifyListeners();

    try {
      _countryRates = await _apiService.fetchCheckRatesListCountry(
        clientID,
        countryID,
        paymentTypeID,
        paymentDepositTypeID,
        deliveryTypeID,
        currencyCode,
        branchID,
        baseCurrencyID,
      );
    } catch (error) {
      _countryRates = [];
      _errorMessage = "Error fetching country rates: $error"; // Store error message
      print(_errorMessage);
    }

    _isLoading = false;
    notifyListeners();
  }
}
