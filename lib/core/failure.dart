import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

class Failure implements Exception {
  final String message;
  final int? code;
  final Exception? exception;

  Failure({
    required this.message,
    this.code,
    this.exception,
  });

  static Failure handleExceptions(e) {
    try {
      throw e;
    } on DioError catch (e) {
      if (e.error is TimeoutException) {
        throw Failure(
          message: 'Connection timed out, please try again.',
          code: e.response?.statusCode,
          exception: e,
        );
      }
      if (e.error is SocketException) {
        throw Failure(
          message: 'No internet connection',
          code: e.response?.statusCode,
          // exception: e,
        );
      }
      throw Failure(
        message: 'Something went wrong!',
        code: e.response?.statusCode,
        exception: e,
      );
    }
  }

  @override
  String toString() =>
      'Failure(message: $message, code: $code, exception: $exception)';
}
