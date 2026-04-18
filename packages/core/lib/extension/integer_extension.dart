import 'package:intl/intl.dart';

extension IntExtensions on int {
  String get toDecimalFormat {
    return NumberFormat.decimalPattern().format(this);
  }
}
