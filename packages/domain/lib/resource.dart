import 'package:freezed_annotation/freezed_annotation.dart';

part 'resource.freezed.dart';

@freezed
sealed class Resource<T> with _$Resource<T> {
  const factory Resource.data({required T data}) = _Data<T>;
  const factory Resource.inProgress() = _InProgress<T>;
  const factory Resource.unauthorized() = _Unauthorized<T>;
  const factory Resource.error({required String message}) = _Error<T>;
}
