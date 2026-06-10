import 'package:x_flutter_core_models/src/domain/failure/failure.dart';

/// Standard response model for all data layers.
///
/// Use [DataResponse] as the return type for repositories and data sources.
sealed class DataResponse<T> {
  const DataResponse();

  /// Creates a successful response containing [data].
  const factory DataResponse.success(T data) = DataResponseSuccess<T>;

  /// Creates a failed response containing [failure].
  const factory DataResponse.failure(Failure failure) = DataResponseFailure<T>;
}

/// A successful [DataResponse] containing the requested [data].
class DataResponseSuccess<T> extends DataResponse<T> {
  final T data;
  const DataResponseSuccess(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DataResponseSuccess<T> && other.data == data);

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'DataResponseSuccess{data: $data}';
}

/// A failed [DataResponse] containing a [failure] reason.
class DataResponseFailure<T> extends DataResponse<T> {
  final Failure failure;
  const DataResponseFailure(this.failure);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DataResponseFailure<T> && other.failure == failure);

  @override
  int get hashCode => failure.hashCode;

  @override
  String toString() => 'DataResponseFailure{failure: $failure}';
}
