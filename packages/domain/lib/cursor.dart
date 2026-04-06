import 'package:freezed_annotation/freezed_annotation.dart';

part 'cursor.freezed.dart';

@freezed
class Cursor<T> with _$Cursor<T> {
  const factory Cursor.first() = First<T>;
  const factory Cursor.next(T value) = Next<T>;
  const factory Cursor.end() = End<T>;
}

extension CursorX<T> on Cursor<T> {
  T? get value {
    return when(
      first: () => null,
      next: (value) => value,
      end: () => null,
    );
  }

  bool get isFirst {
    return when(
      first: () => true,
      next: (_) => false,
      end: () => false,
    );
  }

  bool get isEnd {
    return when(
      first: () => false,
      next: (_) => false,
      end: () => true,
    );
  }

  bool equals(Cursor<T> cursor) {
    return when(
      first: () => cursor.isFirst,
      next: (value) => cursor.value == value,
      end: () => cursor.isEnd,
    );
  }
}
