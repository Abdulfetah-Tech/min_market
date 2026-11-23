// Local storage abstraction using shared_preferences and flutter_secure_storage

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:min_market/core/error/failures.dart';

/// Keys for secure storage
class SecureStorageKeys {
  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String biometricEnabled = 'biometric_enabled';
}

/// Keys for shared preferences
class PrefKeys {
  static const String cartItems = 'cart_items';
  static const String recentlyViewed = 'recently_viewed';
  static const String themeMode = 'theme_mode';
  static const String language = 'language';
  static const String onboardingComplete = 'onboarding_complete';
  static const String lastSyncTime = 'last_sync_time';
}

/// Secure storage wrapper for sensitive data
class SecureStorage {
  SecureStorage._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
    wOptions: WindowsOptions(),
  );

  static Future<Result<void>> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      return const Right<Failure, void>(null);
    } catch (e, stackTrace) {
      return Left<Failure, void>(CacheFailure(
        message: 'Failed to write secure storage: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  static Future<Result<String?>> read(String key) async {
    try {
      final value = await _storage.read(key: key);
      return Right<Failure, String?>(value);
    } catch (e, stackTrace) {
      return Left<Failure, String?>(CacheFailure(
        message: 'Failed to read secure storage: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  static Future<Result<void>> delete(String key) async {
    try {
      await _storage.delete(key: key);
      return const Right<Failure, void>(null);
    } catch (e, stackTrace) {
      return Left<Failure, void>(CacheFailure(
        message: 'Failed to delete secure storage: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  static Future<Result<void>> deleteAll() async {
    try {
      await _storage.deleteAll();
      return const Right<Failure, void>(null);
    } catch (e, stackTrace) {
      return Left<Failure, void>(CacheFailure(
        message: 'Failed to clear secure storage: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  static Future<Result<bool>> containsKey(String key) async {
    try {
      final value = await _storage.read(key: key);
      return Right<Failure, bool>(value != null);
    } catch (e, stackTrace) {
      return Left<Failure, bool>(CacheFailure(
        message: 'Failed to check secure storage key: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }
}

/// Shared preferences wrapper for non-sensitive data
class AppPreferences {
  AppPreferences._();

  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get _instance {
    if (_prefs == null) {
      throw StateError('AppPreferences not initialized. Call initialize() first.');
    }
    return _prefs!;
  }

  // String operations
  static Future<Result<void>> setString(String key, String value) async {
    try {
      await _instance.setString(key, value);
      return const Right<Failure, void>(null);
    } catch (e, stackTrace) {
      return Left<Failure, void>(CacheFailure(
        message: 'Failed to set string: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  static String? getString(String key) {
    return _instance.getString(key);
  }

  // Bool operations
  static Future<Result<void>> setBool(String key, bool value) async {
    try {
      await _instance.setBool(key, value);
      return const Right<Failure, void>(null);
    } catch (e, stackTrace) {
      return Left<Failure, void>(CacheFailure(
        message: 'Failed to set bool: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return _instance.getBool(key) ?? defaultValue;
  }

  // Int operations
  static Future<Result<void>> setInt(String key, int value) async {
    try {
      await _instance.setInt(key, value);
      return const Right<Failure, void>(null);
    } catch (e, stackTrace) {
      return Left<Failure, void>(CacheFailure(
        message: 'Failed to set int: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  static int getInt(String key, {int defaultValue = 0}) {
    return _instance.getInt(key) ?? defaultValue;
  }

  // Double operations
  static Future<Result<void>> setDouble(String key, double value) async {
    try {
      await _instance.setDouble(key, value);
      return const Right<Failure, void>(null);
    } catch (e, stackTrace) {
      return Left<Failure, void>(CacheFailure(
        message: 'Failed to set double: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  static double getDouble(String key, {double defaultValue = 0.0}) {
    return _instance.getDouble(key) ?? defaultValue;
  }

  // String list operations
  static Future<Result<void>> setStringList(String key, List<String> value) async {
    try {
      await _instance.setStringList(key, value);
      return const Right<Failure, void>(null);
    } catch (e, stackTrace) {
      return Left<Failure, void>(CacheFailure(
        message: 'Failed to set string list: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  static List<String> getStringList(String key) {
    return _instance.getStringList(key) ?? [];
  }

  // Remove operations
  static Future<Result<void>> remove(String key) async {
    try {
      await _instance.remove(key);
      return const Right<Failure, void>(null);
    } catch (e, stackTrace) {
      return Left<Failure, void>(CacheFailure(
        message: 'Failed to remove key: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  static Future<Result<void>> clear() async {
    try {
      await _instance.clear();
      return const Right<Failure, void>(null);
    } catch (e, stackTrace) {
      return Left<Failure, void>(CacheFailure(
        message: 'Failed to clear preferences: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  static bool containsKey(String key) {
    return _instance.containsKey(key);
  }

  static Set<String> getKeys() {
    return _instance.getKeys();
  }
}

/// JSON storage helper for complex objects
class JsonStorage {
  JsonStorage._();

  static Future<Result<void>> writeJson(String key, Map<String, dynamic> json) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, json.toString()); // Simplified - use jsonEncode in real app
      return const Right<Failure, void>(null);
    } catch (e, stackTrace) {
      return Left<Failure, void>(CacheFailure(
        message: 'Failed to write JSON: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  static Map<String, dynamic>? readJson(String key) {
    final prefs = SharedPreferences.getInstance().then((p) => p.getString(key));
    // In real implementation, use jsonDecode
    return null;
  }
}