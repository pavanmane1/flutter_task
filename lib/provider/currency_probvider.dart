import 'package:flutter/material.dart';
import 'package:flutter_task/model/country.dart';
import 'package:flutter_task/model/country_rate_data.dart';
import 'package:flutter_task/services/services.dart';

class CurrencyProvider with ChangeNotifier {
  final ApiService apiService;
  final TextEditingController sendingAmountController = TextEditingController();
  final TextEditingController recipientGetsController = TextEditingController();

  CurrencyProvider({required this.apiService}) {
    _init();
    sendingAmountController.addListener(_updateCalculations);
  }

  // Private state variables
  List<Country> _countries = [];
  List<CountryRate> _countryRateList = [];
  Country? selectedForSender;
  CountryRate? selectedForRecipient;
  String sendingCountryCode = "";
  String recipientCountryCode = "";
  bool _isLoading = true;

  // Public variables for calculations
  String exchangeRate = "0.00";
  String transferFees = "0.00";
  String totalAmountToPay = "0.00";

  // Public getters
  List<Country> get countries => _countries;
  List<CountryRate> get countryRateList => _countryRateList;
  bool get isLoading => _isLoading;

  // Initialize provider and fetch data
  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.wait([
        fetchCountries("defaultClientID", "defaultBranchID", "defaultCountryID"),
        fetchRatesList(
          "defaultClientID",
          "defaultCountryID",
          "defaultPaymentTypeID",
          "defaultDeliveryTypeID",
          "defaultPaymentDepositTypeID",
          "defaultCurrencyCode",
          "defaultBranchID",
          "defaultBaseCurrencyID",
        ),
      ]);
    } catch (e) {
      print("Error during initialization: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch countries from API
  Future<void> fetchCountries(String clientID, String branchID, String countryID) async {
    _isLoading = true;
    notifyListeners();
    try {
      final fetchedCountries = await apiService.fetchCountries(clientID, branchID, countryID);
      _countries = fetchedCountries;
      if (_countries.isNotEmpty) {
        selectedForSender = _countries.first;
        sendingCountryCode = _countries.first.countryCurrency;
      }
    } catch (error) {
      print("Error fetching countries: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch country rates from API
  Future<void> fetchRatesList(
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
    notifyListeners();
    try {
      final fetchedRates = await apiService.fetchCheckRatesListCountry(
        clientID,
        countryID,
        paymentTypeID,
        deliveryTypeID,
        paymentDepositTypeID,
        currencyCode,
        branchID,
        baseCurrencyID,
      );
      _countryRateList = fetchedRates;
      if (_countryRateList.isNotEmpty) {
        selectedForRecipient = _countryRateList.first;
        recipientCountryCode = _countryRateList.first.currencyCode;
      }
    } catch (error) {
      print("Error fetching country rates: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update calculations based on user input
  void _updateCalculations() {
    double sendingAmount = double.tryParse(sendingAmountController.text) ?? 0.0;
    double rate = selectedForRecipient?.rate ?? 0.0;
    double fees = selectedForRecipient?.transferFeesGBP ?? 0.0;

    double recipientAmount = sendingAmount * rate;
    double total = sendingAmount + fees;

    recipientGetsController.text = recipientAmount.toStringAsFixed(2);
    exchangeRate = rate.toStringAsFixed(2);
    transferFees = fees.toStringAsFixed(2);
    totalAmountToPay = "${total.toStringAsFixed(2)} $sendingCountryCode";

    notifyListeners();
  }

  // Dispose controllers when provider is disposed
  @override
  void dispose() {
    sendingAmountController.removeListener(_updateCalculations);
    sendingAmountController.dispose();
    recipientGetsController.dispose();
    super.dispose();
  }
}
