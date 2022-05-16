import 'package:http/http.dart' as http;
import 'package:bitcoin_ticker_reloaded/secrets/keys.dart';
import 'dart:convert';
import 'package:bitcoin_ticker_reloaded/storage.dart';

String coinAPIAddress = "https://rest.coinapi.io/v1/exchangerate";

class NetworkHelper {
  /// Sends http requests and return the formatted response,
  /// error, or (in this application,
  /// one of the error codes stored in storage.dart).

  Future<dynamic> getResponse(
      {required String cryptoCoin, required String fiatCurrency}) async {

    try {
      Uri url =
          Uri.parse('$coinAPIAddress/$cryptoCoin/$fiatCurrency?apikey=$apikey');

      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        var data = response.body;
        var decodedData = jsonDecode(data);
        return decodedData;
      } else {
        // Returns error string from storage.errorCodes if internet error
        return errorCodes[response.statusCode];
      }
    } catch (e) {
      return e;
    }
  }

}

