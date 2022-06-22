class Failure implements Exception {
  final String message;
  final int? code;
  final Exception? exception;

  Failure({
    required this.message,
    this.code,
    this.exception,
  });

  @override
  String toString() =>
      'Failure(message: $message, code: $code, exception: $exception)';
}

/*
try {
}
on DioError catch(e) {
if(e.error is SocketException)
throw Failure(
message: 'No internet connection',
exception: e,
)
throw Failure(
message: e.response?.statusMessage ?? 'Something went wrong',
code: e.response?.statusCode,

}
 */
