import 'networking.dart';

class DataHub {

  NetworkHelper networkHelper = NetworkHelper();

  Future<double> getRate({
    required String coin,
    required int approximation,
    required String fiat,
  }) async {
    var responseData = await networkHelper.getResponse(
      cryptoCoin: coin,
      fiatCurrency: fiat,
    );
    double rate = responseData["rate"];
    return double.parse(rate.toStringAsFixed(approximation));
  }

  Future<Map<String, double>> getInitialRates() async {
    double btc = await getRate(coin: "BTC", approximation: 6, fiat: "USD");
    double eth = await getRate(coin: "ETH", approximation: 4, fiat: "USD");
    double ltc = await getRate(coin: "LTC", approximation: 3, fiat: "USD");
    // print('$btc \n $eth \n $ltc');
    return {"btcRate": btc, "ethRate": eth, "ltcRate": ltc};
  }

}