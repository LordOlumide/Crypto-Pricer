

Map<int, String> errorCodes = {
  400: "Bad Request -- There is something wrong with your request",
  401: "Unauthorized -- Your API key is wrong",
  403: "Forbidden -- Your API key doesn't have enough privileges to access this resource",
  429: "Too many requests -- You have exceeded your API key rate limits",
  550: "No data -- You requested specific single item that we don't have at this moment"
};