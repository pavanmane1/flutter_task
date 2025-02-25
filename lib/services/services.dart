import 'package:flutter_task/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/country.dart';
import '../model/country_rate_data.dart';

class ApiService {
  Future<List<Country>> fetchCountries(String clientID, String branchID, String countryID) async {
    final url = Uri.parse('${AppConfig.baseUrl}/live/api/country/countrylist');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"clientID": clientID, "branchID": branchID, "countryID": ""}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> data = jsonResponse['data'];
      return data.map((json) => Country.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load countries");
    }
  }

  Future<List<CountryRate>> fetchCheckRatesListCountry(
    String clientID,
    String countryID,
    String paymentTypeID,
    String paymentDepositTypeID,
    String deliveryTypeID,
    String currencyCode,
    String branchID,
    String BaseCurrencyID,
  ) async {
    final url = Uri.parse('${AppConfig.baseUrl}/pilot/api/checkrateslistcountry/checkrateslistcountry');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "clientID": clientID,
        "countryID": countryID,
        "paymentTypeID": paymentTypeID,
        "paymentDepositTypeID": paymentDepositTypeID,
        "deliveryTypeID": deliveryTypeID,
        "currencyCode": currencyCode,
        "branchID": branchID,
        "BaseCurrencyID": BaseCurrencyID,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      if (jsonBody['response'] == true && jsonBody['responseCode'] == '00') {
        final List<dynamic> dataList = jsonBody['data'];
        return dataList.map((item) => CountryRate.fromJson(item)).toList();
      } else {
        throw Exception('API returned error: ${jsonBody['responseCode']}');
      }
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}
