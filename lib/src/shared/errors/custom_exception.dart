class CustomException implements Exception {
  final String message;
  final int? statusCode;

  CustomException(this.message, {this.statusCode});
}
