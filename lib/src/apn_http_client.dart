library apn_http;

import 'package:apn_http/src/dio_formatter.dart';
import 'package:apn_http/src/error_messages.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'dart:convert';
import 'dart:io';

typedef RestClientBuilder<T> = T Function(Dio dio);

class ApnHttpClient<T> {
  final dio = new Dio();
  final String baseUrl;
  final Map<String, dynamic>? headers;
  final RestClientBuilder<T> clientBuilder;
  final bool isDebug;

  late T client;

  HttpClientAdapter? adapter;
  ValueSetter<Dio>? onDioReady;

  ApnHttpClient({
    required this.clientBuilder,
    required this.baseUrl,
    this.headers,
    this.isDebug = false,
    this.onDioReady,
    this.adapter,
    Map<int, String>? errorMessages,
  }) {
    // * Add all custom errorMessages
    if (errorMessages != null) {
      dioErrorMessages.addEntries(errorMessages.entries);
    }

    // * To enable mock adapters on testing
    if (adapter != null) {
      dio.httpClientAdapter = adapter!;
    }

    // * Logging on non production
    if (isDebug) {
      dio.interceptors.add(HttpFormatter());
    }

    // * Json decoding in the background via compute
    dio.transformer = FlutterTransformer();

    // * Base URL
    dio.options.baseUrl = baseUrl;

    // * Timeouts
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 20000;

    // * Default headers
    dio.options.headers['Accept'] = 'application/json';

    if (!kIsWeb) {
      // * Locale name is nl_NL (languageCode_countryCode)
      final localeNameParts = Platform.localeName.split('_');
      if (localeNameParts.length == 2) {
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

/// FlutterTransformer
class FlutterTransformer extends DefaultTransformer {
  FlutterTransformer() : super(jsonDecodeCallback: _parseJson);
}

// Must be top-level function
_parseAndDecode(String response) {
  return jsonDecode(response);
}

_parseJson(String text) {
  return compute(_parseAndDecode, text);
}
