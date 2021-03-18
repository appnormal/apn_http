import 'package:apn_http/apn_http.dart';
import 'package:apn_http/src/error_messages.dart';
import 'package:dio/dio.dart';

import 'models.dart';

extension DioErrorExtension on DioError {
  ErrorResponse get toErrorResponse {
    final defaultError = ErrorResponse.fromMessage(dioErrorMessages[0]!);
    if (response == null) return defaultError;

    final resp = response!;

    if (resp.statusCode == 422) {
      return ErrorResponse.fromMap(resp.data);
    }

    if (dioErrorMessages.containsKey(resp.statusCode)) {
      return ErrorResponse.fromMessage(dioErrorMessages[resp.statusCode]!);
    }

    return defaultError;
  }
}
