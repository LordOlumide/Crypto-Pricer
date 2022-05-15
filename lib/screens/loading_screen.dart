import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bitcoin_ticker_reloaded/services/data_hub.dart';
import 'package:bitcoin_ticker_reloaded/screens/price_screen.dart';
import 'error_screen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future<void> getBTCRateAndPush() async {
    try {
      DataHub dataHub = DataHub();
      Map<String, double> rates = await dataHub.getInitialRates();
      if (mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return PriceScreen(initialRates: rates);
        }));
      } else {
        pushToErrorScreen();
      }
    } catch (e) {
      pushToErrorScreen(error: '$e');
    }
  }

  pushToErrorScreen({String error = ''}) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) {
          return ErrorScreen(error: error);
        }));
  }

  @override
  void initState() {
    super.initState();
    getBTCRateAndPush();
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
