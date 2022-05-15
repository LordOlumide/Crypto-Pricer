import 'package:bitcoin_ticker_reloaded/screens/loading_screen.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  String error;

  ErrorScreen({Key? key, this.error = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[800],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Something went wrong. \nError: $error',
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return LoadingScreen();
                  }));
                },
                child: Text('Retry'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF6C6161)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
