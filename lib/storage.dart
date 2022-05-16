

Map<int, String> errorCodes = {
  400: "Bad Request -- There is something wrong with your request",
  401: "Unauthorized -- Your API key is wrong",
  403: "Forbidden -- Your API key doesn't have enough privileges to access this resource",
  429: "Too many requests -- You have exceeded your API key rate limits",
  550: "No data -- You requested specific single item that we don't have at this moment"
};

bool ratesAreCorrect(uncheckedRates) {
  if (uncheckedRates["btcRate"]! >= 0) {
    // Everything worked normally, return true
    return true;
  } else {return false;}
}

checkErrorAndReturnErrorString(errorRates) {
  // Checks the rates. If errors, return the error string to be pushed
  if (errorRates.values.contains(-1)) {
    // This means SocketException so push to error screen
    return "Error getting data."
        " Check your internet connection and try again";
  } else if (errorCodes.containsKey(-errorRates["btcRate"]!)) {
    // This means an internet error from storage.errorCodes happened
    // Return the error that happened.
    int error = -errorRates["btcRate"]!.toInt();
    return "${errorCodes[error]}";
  } else {
    // unknown Error occurred
    return "Unknown Error occurred. Debug Data: $errorRates";
  }
}