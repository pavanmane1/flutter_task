class AppConfig {
  static const bool isProduction = true;

  static String get baseUrl {
    return isProduction ? "https://currencyexchangesoftware.eu" : "https://dev.currencyexchangesoftware.eu/api";
  }
}
