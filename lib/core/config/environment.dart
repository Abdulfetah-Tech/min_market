// Environment configuration using --dart-define
// Usage: flutter run --dart-define=ENVIRONMENT=development
//        flutter build apk --dart-define=ENVIRONMENT=production

import 'package:flutter/foundation.dart';

enum Environment {
  development,
  staging,
  production,
}

class AppConfig {
  AppConfig._();

  static late final Environment environment;
  static late final String apiBaseUrl;
  static late final String apiTimeout;
  static late final bool enableLogging;
  static late final String appName;

  static void initialize() {
    const envString = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
    environment = Environment.values.firstWhere(
      (e) => e.name == envString,
      orElse: () => Environment.development,
    );

    switch (environment) {
      case Environment.development:
        apiBaseUrl = const String.fromEnvironment('API_BASE_URL', defaultValue: 'https://dummyjson.com/products');
        apiTimeout = const String.fromEnvironment('API_TIMEOUT', defaultValue: '30000');
        enableLogging = true;
        appName = 'Mini Market Dev';
        break;
      case Environment.staging:
        apiBaseUrl = const String.fromEnvironment('API_BASE_URL', defaultValue: 'https://dummyjson.com/products');
        apiTimeout = const String.fromEnvironment('API_TIMEOUT', defaultValue: '30000');
        enableLogging = true;
        appName = 'Mini Market Staging';
        break;
      case Environment.production:
        apiBaseUrl = const String.fromEnvironment('API_BASE_URL', defaultValue: 'https://dummyjson.com/products');
        apiTimeout = const String.fromEnvironment('API_TIMEOUT', defaultValue: '15000');
        enableLogging = false;
        appName = 'Mini Market';
        break;
    }

    if (kDebugMode) {
      debugPrint('Environment: $environment');
      debugPrint('API Base URL: $apiBaseUrl');
      debugPrint('API Timeout: $apiTimeout');
      debugPrint('Enable Logging: $enableLogging');
    }
  }

  static bool get isDevelopment => environment == Environment.development;
  static bool get isStaging => environment == Environment.staging;
  static bool get isProduction => environment == Environment.production;
}