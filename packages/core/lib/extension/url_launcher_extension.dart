import 'dart:async';
import 'package:core/utils/logger_util.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openExternalBrowser(Uri uri) async {
  logger.d('openExternalBrowser() uri: $uri');
  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $uri');
  }
}
