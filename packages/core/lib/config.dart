import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract interface class IConfig {
}

class Config {
  static IConfig _instance = DotEnvConfig();

  static void setInstanceForTesting(IConfig config) {
    _instance = config;
  }
}

class DotEnvConfig implements IConfig {
}
