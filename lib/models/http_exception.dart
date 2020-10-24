class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message.toString();
    // return super.toString(); // Instance of HttpException
  }
}