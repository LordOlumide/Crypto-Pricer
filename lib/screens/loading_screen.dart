import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bitcoin_ticker_reloaded/services/data_hub.dart';
import 'package:bitcoin_ticker_reloaded/screens/price_screen.dart';
import 'error_screen.dart';
import 'package:bitcoin_ticker_reloaded/storage.dart';

class LoadingScreen extends StatefulWidget {
  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  Future<void> getRatesAndPush() async {
    // try to get the rates
    // if it fails, it will return -1 for SocketException
    // and -errorCode for other errors
    Map<String, double> rates = await DataHub().getInitialRates();

    if (rates["btcRate"]! >= 0) {
      // This means the rate is correct and everything worked.
      // So push to price screen
      if (mounted) {
        // useless check that probably will never trigger
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return PriceScreen(initialRates: rates);
        }));
      } else {
        pushToErrorScreen(error: "Pushing to PriceScreen failed because not "
            "mounted. This should be impossible.");
      }

    } else if (rates.values.contains(-1)) {
      // This means SocketException so push to error screen
        pushToErrorScreen(
            error: "Error getting data. "
                "Check your internet connection and try again"
        );
    } else if (errorCodes.containsValue(-rates['btcRate']!)){ // TODO: Fix this error
      // This means an internet error from storage.errorCodes happened
      // Return the error that happened.
      int error = -rates["btcRate"]!.toInt();
      pushToErrorScreen(error: "${errorCodes[error]}");
    } else {
      // unknown Error occurred
      pushToErrorScreen(error: "Unknown Error occurred. Debug Data: $rates");
    }
  }

  pushToErrorScreen({String error = ''}) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return ErrorScreen(error: error);
    }));
  }

  @override
  void initState() {
    super.initState();
    getRatesAndPush();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        image: const DecorationImage(
          image: AssetImage("assets/bitcoin_chart.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: const Center(
        child: SpinKitThreeBounce(
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}
