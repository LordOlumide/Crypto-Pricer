import 'dart:io';

import 'networking.dart';
import 'package:bitcoin_ticker_reloaded/storage.dart';

class DataHub {
  NetworkHelper networkHelper = NetworkHelper();

  // using negative errorStatusCode values as return value on error
  // -1 is SocketException, -2 for unknown error,
  // and -errorCodes for known internet error
  Future<double> getRate({
    required String coin,
    required int approximation,
    required String fiat,
  }) async {
    var responseData = await networkHelper.getResponse(
      cryptoCoin: coin,
      fiatCurrency: fiat,
    );
    // if responseData is an internet Error,
    // set the rate double to the error code
    if (errorCodes.containsValue(responseData)) {
      int errorCode =
          errorCodes.keys.firstWhere((key) => errorCodes[key] == responseData);
      // print(errorCode);
      return -errorCode.toDouble();
    }
    // else if response is a SocketException, pass the exception forward intact
    else if (responseData.runtimeType == SocketException) {
      return -1;
    }
    // else, the response is correct. Return it.
    else if (responseData['btcRate'] >= 0) {
      double rate = responseData["rate"];
      return double.parse(rate.toStringAsFixed(approximation));
    }
    // unknown error occurred
    else {
      return -2;
    }
  }

  Future<Map<String, double>> getInitialRates() async {
    double btc = await getRate(coin: "BTC", approximation: 5, fiat: "USD");
    double eth = await getRate(coin: "ETH", approximation: 4, fiat: "USD");
    double ltc = await getRate(coin: "LTC", approximation: 3, fiat: "USD");
    return {"btcRate": btc, "ethRate": eth, "ltcRate": ltc};
  }

  Future<Map<String, double>> getRefreshedRates({required String fiat}) async {
    double btc = await getRate(coin: "BTC", approximation: 5, fiat: fiat);
    double eth = await getRate(coin: "ETH", approximation: 4, fiat: fiat);
    double ltc = await getRate(coin: "LTC", approximation: 3, fiat: fiat);
    return {"btcRate": btc, "ethRate": eth, "ltcRate": ltc};
  }
}
