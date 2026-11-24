// Service locator for dependency injection using get_it
// This replaces direct instantiation and static singletons

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../config/environment.dart';
import '../network/api_client.dart';
import 'bloc_observer.dart';

final GetIt sl = GetIt.instance;

/// Initialize all dependencies
Future<void> initializeDependencies() async {
  // Core
  await _initCore();

  // Storage
  await _initStorage();

  // Network
  _initNetwork();

  // Features will be registered in their respective modules
  // await _initFeatures();
}

Future<void> _initCore() async {
  // Environment config
  AppConfig.initialize();

  // Talker for logging
  final talker = TalkerFlutter.init();
  sl.registerSingleton<Talker>(talker);

  // BLoC observer
  sl.registerSingleton<AppBlocObserver>(AppBlocObserver(talker));
}

Future<void> _initStorage() async {
  // SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // AppPreferences will be initialized with the prefs instance
  // Local storage instances are static - no registration needed
}

void _initNetwork() {
  // API Client
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      talker: sl<Talker>(),
    ),
  );
}

/// Register feature-specific dependencies
/// Call this after core dependencies are initialized
Future<void> registerFeatureDependencies({
  required void Function() registerProducts,
  required void Function() registerCart,
}) async {
  registerProducts();
  registerCart();
}

/// Reset all dependencies (useful for testing)
void resetDependencies() {
  sl.reset();
}