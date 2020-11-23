import 'package:apn_http/apn_http.dart';
import 'package:apn_http/src/error_messages.dart';
import 'package:dio/dio.dart';

import 'models.dart';

extension DioErrorExtension on DioError {
  ErrorResponse get toErrorResponse {
    if (response != null) {
      if (response.statusCode == 422) {
        return ErrorResponse.fromMap(response.data);
      }

      if (dioErrorMessages.containsKey(response.statusCode)) {
        return ErrorResponse.fromMessage(dioErrorMessages[response.statusCode]!);
      }
    }

    return ErrorResponse.fromMessage(dioErrorMessages[0]!);
  }
}
