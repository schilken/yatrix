import 'package:flutter/foundation.dart';

class ErrorReportingService {
  ErrorReportingService();

  Future<void> recordFlutterError(FlutterErrorDetails flutterErrorDetails) {
    return logFlutterError(flutterErrorDetails);
  }

  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    bool fatal = false,
  }) async {
    print('recordError $exception $stack');
  }

  Future<void> logFlutterError(FlutterErrorDetails flutterErrorDetails) async {
    print('logFlutterError $flutterErrorDetails');
  }
}
