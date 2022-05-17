import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../coin_data.dart';
import 'dart:io' show Platform;
import 'package:bitcoin_ticker_reloaded/services/data_hub.dart';
import 'package:bitcoin_ticker_reloaded/screens/error_screen.dart';
import 'package:bitcoin_ticker_reloaded/storage.dart';

class PriceScreen extends StatefulWidget {
  final Map<String, double> initialRates;

  const PriceScreen({required this.initialRates});

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String dropdownMenuValue = currenciesList[currenciesList.indexOf('USD')];

  Map<String, double> rates = {};

  @override
  void initState() {
    super.initState();
    rates = widget.initialRates;
  }

  @override
  Widget build(BuildContext context) {
    pushToErrorScreen({String error = ''}) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return ErrorScreen(error: error);
      }));
    }

    refresh(newValue) async {
      setState(() {
        dropdownMenuValue = '?';
      });
      Map<String, double> tempRates =
          await DataHub().getRefreshedRates(fiat: newValue);
      if (ratesAreCorrect(tempRates)) {
        setState(() {
          dropdownMenuValue = newValue;
          rates = tempRates;
        });
      } else {
        String errorString = checkErrorAndReturnErrorString(tempRates);
        pushToErrorScreen(error: errorString);
      }
    }

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
        onChanged: (String? selectedValue) async {
          refresh(selectedValue);
        },
      );
    }

    Widget iosPicker() {
      return CupertinoPicker(
        squeeze: 1.2,
        itemExtent: 25.0,
        magnification: 1.2,
        onSelectedItemChanged: (value) async {
          refresh(currenciesList[value]);
        },
        children: currenciesList.map((e) => Text(e)).toList(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text('🤑 Coin Ticker'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: Card(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                      '1 BTC = ${rates['btcRate']} $dropdownMenuValue',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
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
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                      '1 ETH = ${rates['ethRate']} $dropdownMenuValue',
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
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                      '1 LTC = ${rates['ltcRate']} $dropdownMenuValue',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              TextButton.icon(
                label: Text('Click to refresh'),
                onPressed: () {
                  refresh(dropdownMenuValue);
                },
                icon: const Icon(
                  Icons.refresh,
                  size: 30.0,
                ),
              ),
            ],
          ),
          // Bottom picker container
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.blue[800],
            child: Platform.isIOS ? iosPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
