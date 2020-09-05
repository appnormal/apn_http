import 'package:json_annotation/json_annotation.dart';

class ErrorResponse {
  ErrorResponse();

  Error error;

  factory ErrorResponse.fromMap(Map<String, dynamic> data) => ErrorResponse()
    ..error = data['error'] == null
        ? null
        : Error.fromMap(data['error'] as Map<String, dynamic>);

  factory ErrorResponse.fromMessage(String message) {
    final error = Error()..message = message;
    return ErrorResponse()..error = error;
  }
}

class Error {
  Error();

  String message;
  int statusCode;

  factory Error.fromMap(Map<String, dynamic> data) => Error()
    ..message = data['message'] as String
    ..statusCode = data['status_code'] as int;
}

@JsonSerializable(explicitToJson: true)
class PaginationInfo {
  PaginationInfo();

  int currentPage;
  int from;
  int to;
  int total;
  int lastPage;

  factory PaginationInfo.fromJson(Map<String, dynamic> json) => PaginationInfo()
    ..currentPage = json['current_page']
    ..from = json['from']
    ..to = json['to']
    ..total = json['total']
    ..lastPage = json['last_page'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'current_page': currentPage,
        'from': from,
        'to': to,
        'total': total,
        'last_page': lastPage,
      };

  PaginationInfo clone() => PaginationInfo()
    ..currentPage = currentPage
    ..from = from
    ..to = to
    ..total = total
    ..lastPage = lastPage;

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
  int get hashCode =>
      currentPage.hashCode ^
      from.hashCode ^
      to.hashCode ^
      total.hashCode ^
      lastPage.hashCode;
}
