import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../data/api_config/app_logger.dart';

Future<void> loadEnvFile({String path = ".env"}) async {
  try {
    await dotenv.load(fileName: path);
  } catch (e) {
    AppLogger.log(e);
  }
}

class EnvironmentVariables {
  EnvironmentVariables({
    this.apiBaseUrl = "",
    this.clientKey = "",
    this.agent = "",
    this.versionName = "",
    this.apiTimeoutInSeconds = 0,
    this.tokenValidityInMinutes = 10,
  });

  String apiBaseUrl;
  String clientKey;
  String agent;
  String versionName;
  int apiTimeoutInSeconds;
  int tokenValidityInMinutes;
}
