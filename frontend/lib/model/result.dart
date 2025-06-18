import 'package:json_annotation/json_annotation.dart';

part 'result.g.dart';

/// Generic result wrapper for API responses.
/// Updated to match the unified Finsplore backend response structure.
@JsonSerializable(genericArgumentFactories: true)
class Result<T> {
  final bool success;
  final String? message;
  final T? data;
  final String? errorCode;
  final int? statusCode;
  final DateTime? timestamp;

  Result({
    required this.success,
    this.message,
    this.data,
    this.errorCode,
    this.statusCode,
    this.timestamp,
  });

  factory Result.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ResultFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ResultToJson(this, toJsonT);

  /// Create a successful result
  factory Result.success({
    T? data,
    String? message,
  }) {
    return Result<T>(
      success: true,
      data: data,
      message: message,
      timestamp: DateTime.now(),
    );
  }

  /// Create an error result
  factory Result.error({
    required String message,
    String? errorCode,
    int? statusCode,
  }) {
    return Result<T>(
      success: false,
      message: message,
      errorCode: errorCode,
      statusCode: statusCode,
      timestamp: DateTime.now(),
    );
  }

  /// Create a result from HTTP response
  factory Result.fromResponse({
    required bool success,
    String? message,
    T? data,
    int? statusCode,
  }) {
    return Result<T>(
      success: success,
      message: message,
      data: data,
      statusCode: statusCode,
      timestamp: DateTime.now(),
    );
  }

  /// Check if the result represents success
  bool get isSuccess => success;

  /// Check if the result represents an error
  bool get isError => !success;

  /// Get data or throw if error
  T get dataOrThrow {
    if (isError) {
      throw Exception(message ?? 'Unknown error occurred');
    }
    return data!;
  }

  /// Get data or return default value
  T dataOr(T defaultValue) {
    return isSuccess ? data ?? defaultValue : defaultValue;
  }

  @override
  String toString() {
    return 'Result(success: $success, message: $message, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Result<T> &&
        other.success == success &&
        other.message == message &&
        other.data == data;
  }

  @override
  int get hashCode => success.hashCode ^ message.hashCode ^ data.hashCode;
}
