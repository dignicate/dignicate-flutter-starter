extension UriExtensions on Uri {
  String get toEncodedString {
    return Uri.encodeFull(toString());
  }
}
