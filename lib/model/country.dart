class Country {
  final String popularCountry;
  final String flag;
  final String countryFlag;
  final String countryCode;
  final String ISOCode;
  final String countryID;
  final String countryName;
  final String countryCurrency;
  final String preferredFlag;
  Country({
    required this.popularCountry,
    required this.flag,
    required this.countryFlag,
    required this.countryCode,
    required this.ISOCode,
    required this.countryID,
    required this.countryName,
    required this.countryCurrency,
    required this.preferredFlag,
  });
  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      popularCountry: json['popularCountry'] ?? '',
      flag: json['flag'] ?? '',
      countryFlag: json['countryFlag'],
      countryCode: json['countryCode'],
      ISOCode: json['ISOCode'],
      countryID: json['countryID'],
      countryName: json['countryName'],
      countryCurrency: json['countryCurrency'],
      preferredFlag: json['preferredFlag'],
    );
  }
  @override
  String toString() {
    return 'Country(countryName: $countryName, countryID: $countryID, countryCode: $countryCode, countryCurrency: $countryCurrency, ISOCode: $ISOCode, flag: $flag)';
  }
}
