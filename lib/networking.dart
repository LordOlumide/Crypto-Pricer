import 'package:http/http.dart' as http;
import 'package:bitcoin_ticker_reloaded/secrets/keys.dart';
import 'dart:convert';

String coinAPIAddress = "https://rest.coinapi.io/v1/exchangerate";

Map<int, String> errorCodes = {
  400: "Bad Request -- There is something wrong with your request",
  401: "Unauthorized -- Your API key is wrong",
  403: "Forbidden -- Your API key doesn't have enough privileges to access this resource",
  429: "Too many requests -- You have exceeded your API key rate limits",
  550: "No data -- You requested specific single item that we don't have at this moment"
};

class NetworkHelper {
  Future<dynamic> getResponse(
      {required String cryptoCoin, required String fiatCurrency}) async {

    try {
      Uri url =
          Uri.parse('$coinAPIAddress/$cryptoCoin/$fiatCurrency?apikey=$apikey');

      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        var data = response.body;
        var decodedData = jsonDecode(data);
        // print(decodedData.runtimeType);
        return decodedData;
      } else {
        return errorCodes[response.statusCode];
      }
    } catch (e) {
      return e;
    }
  }
}
