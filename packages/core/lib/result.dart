import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
sealed class Result<T> with _$Result<T> {
  const factory Result.success(T value) = _Success<T>;
  const factory Result.failure(String message) = _Failure<T>;
  const factory Result.unauthorized() = _Unauthorized<T>;
}
