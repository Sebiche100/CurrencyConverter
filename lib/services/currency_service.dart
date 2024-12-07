class CurrencyService {
  static Future<String?> convertCurrency(
      String amount, String fromCurrency, String toCurrency) async {
    await Future.delayed(Duration(seconds: 2));
    if (fromCurrency == 'EUR' && toCurrency == 'USD') {
      return (double.parse(amount) * 1.1).toStringAsFixed(2);
    } else if (fromCurrency == 'USD' && toCurrency == 'EUR') {
      return (double.parse(amount) * 0.9).toStringAsFixed(2);
    }
    return null;
  }
}
