import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'networking.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String dropdownMenuValue = currenciesList[19];

  double BTCRate = 0;

  Future<double> getRate({
    required String coin,
    required int approximation,
  }) async {
    NetworkHelper networkHelper = NetworkHelper();
    var responseData = await networkHelper.getResponse(
      cryptoCoin: coin,
      fiatCurrency: dropdownMenuValue,
    );
    double rate = responseData["rate"];
    return double.parse(rate.toStringAsFixed(approximation));
  }

  Future<void> getBTCRate() async {
    double x = await getRate(coin: "BTC", approximation: 5);
    print(x);
    BTCRate = x;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getBTCRate();
    print(BTCRate);

    Widget androidDropdown() {
      List<DropdownMenuItem<String>> items = [];
      for (int i = 0; i < currenciesList.length; i++) {
        items.add(
          DropdownMenuItem(
            value: currenciesList[i],
            child: Text(currenciesList[i]),
          ),
        );
      }
      return DropdownButton(
        value: dropdownMenuValue,
        items: items,
        onChanged: (String? selectedValue) {
          setState(() {
            dropdownMenuValue = selectedValue!;
          });
        },
      );
    }

    Widget iosPicker() {
      return CupertinoPicker(
        squeeze: 1.2,
        itemExtent: 25.0,
        magnification: 1.2,
        onSelectedItemChanged: (value) {
          dropdownMenuValue = currenciesList[value];
        },
        children: currenciesList.map((e) => Text(e)).toList(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = ${BTCRate} ${dropdownMenuValue}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 ETH = ? USD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 LTC = ? USD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 30.0),
            height: 150.0,
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
