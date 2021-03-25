import 'package:flutter/cupertino.dart';

@immutable
class ErrorResponse {
  final Error error;

  const ErrorResponse({required this.error});

  factory ErrorResponse.fromMap(Map<String, dynamic> data) => ErrorResponse(
        error: Error.fromMap(
          data['error'] as Map<String, dynamic>,
        ),
      );

  factory ErrorResponse.fromMessage(String message) {
    final error = Error(message: message, statusCode: 0);
    return ErrorResponse(error: error);
  }

  @override
  String toString() {
    return "ErrorResponse!:\n\nStatuscode: ${error.statusCode}\n\nError: ${error.message}";
  }
}

class Error {
  final String message;
  final int statusCode;

  const Error({required this.message, required this.statusCode});

  factory Error.fromMap(Map<String, dynamic> data) => Error(
        message: data['message'] as String,
        statusCode: data['status_code'] as int,
      );
}

@immutable
class PaginationInfo {
  final int currentPage;
  final int from;
  final int to;
  final int total;
  final int lastPage;

  const PaginationInfo({
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
    this.from = 0,
    this.to = 0,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) => PaginationInfo(
        currentPage: json['current_page'],
        from: json['from'],
        to: json['to'],
        total: json['total'],
        lastPage: json['last_page'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'current_page': currentPage,
        'from': from,
        'to': to,
        'total': total,
        'last_page': lastPage,
      };

  PaginationInfo clone() => PaginationInfo(
        currentPage: currentPage,
        from: from,
        to: to,
        total: total,
        lastPage: lastPage,
      );

  PaginationInfo copyWith({
    int? currentPage,
    int? from,
    int? to,
    int? total,
    int? lastPage,
  }) =>
      PaginationInfo(
        currentPage: currentPage ?? this.currentPage,
        from: from ?? this.from,
        to: to ?? this.to,
        total: total ?? this.total,
        lastPage: lastPage ?? this.lastPage,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginationInfo &&
          currentPage == other.currentPage &&
          from == other.from &&
          to == other.to &&
          total == other.total &&
          lastPage == other.lastPage;

  @override
  int get hashCode => currentPage.hashCode ^ from.hashCode ^ to.hashCode ^ total.hashCode ^ lastPage.hashCode;
}
