class CountryRate {
  final String countryName;
  final String currencyCode;
  final String countryFlag;
  final double minAmount;
  final double maxAmount;
  final double foreignCurrencyMinAmount;
  final double foreignCurrencyMaxAmount;
  final double transferFeesGBP;
  final double rate;

  CountryRate({
    required this.countryName,
    required this.currencyCode,
    required this.countryFlag,
    required this.minAmount,
    required this.maxAmount,
    required this.foreignCurrencyMinAmount,
    required this.foreignCurrencyMaxAmount,
    required this.transferFeesGBP,
    required this.rate,
  });

  factory CountryRate.fromJson(Map<String, dynamic> json) {
    return CountryRate(
      countryName: json['countryName'] as String,
      currencyCode: json['currencyCode'] as String,
      countryFlag: json['countryFlag'] as String,
      minAmount: (json['minAmount'] as num).toDouble(),
      maxAmount: (json['maxAmount'] as num).toDouble(),
      foreignCurrencyMinAmount: (json['foreignCurrencyMinAmount'] as num).toDouble(),
      foreignCurrencyMaxAmount: (json['foreignCurrencyMaxAmount'] as num).toDouble(),
      transferFeesGBP: (json['transferFeesGBP'] as num).toDouble(),
      rate: (json['rate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'countryName': countryName,
      'currencyCode': currencyCode,
      'countryFlag': countryFlag,
      'minAmount': minAmount,
      'maxAmount': maxAmount,
      'foreignCurrencyMinAmount': foreignCurrencyMinAmount,
      'foreignCurrencyMaxAmount': foreignCurrencyMaxAmount,
      'transferFeesGBP': transferFeesGBP,
      'rate': rate,
    };
  }
}
