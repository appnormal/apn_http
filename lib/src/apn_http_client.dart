library apn_http;

import 'dart:io';

import 'package:apn_http/src/error_messages.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

typedef RestClientBuilder<T> = T Function(Dio dio);

class ApnHttpClient<T> {
  final dio = new Dio();
  final String baseUrl;
  final Map<String, dynamic>? headers;
  final RestClientBuilder<T> clientBuilder;
  final bool isDebug;

  late T client;

  ValueSetter<Dio>? onDioReady;

  ApnHttpClient({
    required this.clientBuilder,
    required this.baseUrl,
    this.headers,
    this.isDebug = false,
    this.onDioReady,
    Map<int, String>? errorMessages,
  }) {
    // * Add all custom errorMessages
    if (errorMessages != null) {
      dioErrorMessages.addEntries(errorMessages.entries);
    }

    // * Base URL
    dio.options.baseUrl = baseUrl;

    // * Timeouts
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 20000;

    // * Default headers
    dio.options.headers['Accept'] = 'application/json';

    if (!kIsWeb) {
      // * Locale name is nl_NL (languageCode_countryCode) or sometimes only 'nl' (observed on iOS)
      final localeNameParts = Platform.localeName.split('_');
      if (localeNameParts.isNotEmpty) {
        dio.options.headers['Accept-Language'] = localeNameParts[0].toLowerCase();
      }
    }

    headers?.forEach((key, value) {
      dio.options.headers[key] = value;
    });

    // * If there is a callback to extend it, call it
    if (onDioReady != null) {
      onDioReady!(dio);
    }

    client = clientBuilder(dio);
  }

  void setHeader(String key, String? value) {
    if (value == null) {
      dio.options.headers.remove(key);
    } else {
      dio.options.headers[key] = value;
    }

    client = clientBuilder(dio);
  }

  void setAdapter(HttpClientAdapter adapter) {
    dio.httpClientAdapter = adapter;
    client = clientBuilder(dio);
  }

  void setErrorMessages(Map<int, String> errorMessages) {
    dioErrorMessages = errorMessages;
  }
}