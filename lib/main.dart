// Mini Market - Production-grade Flutter e-commerce app
// Refactored with Clean Architecture, BLoC, Repository pattern, and offline-first support

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'core/core.dart';
import 'features/cart/cart_injection.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/products/presentation/bloc/products_bloc.dart';
import 'features/products/products_injection.dart';
import 'router.dart';

final GetIt sl = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await initializeDependencies();
  await registerFeatureDependencies(
    registerProducts: registerProductsDependencies,
    registerCart: registerCartDependencies,
  );

  // Initialize app preferences
  await AppPreferences.initialize();

  // Initialize Talker for logging
  final talker = sl<Talker>();

  // Set up global error handlers
  FlutterError.onError = (details) {
    talker.error('Flutter Error', details.exception, details.stack);
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    talker.error('Platform Error', error, stack);
    return true;
  };

  // Set BLoC observer
  Bloc.observer = sl<AppBlocObserver>();

  runApp(const MiniMarketApp());
}

class MiniMarketApp extends StatelessWidget {
  const MiniMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide explicit viewport constraints for Flutter web
    final view = window.physicalSize / window.devicePixelRatio;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ProductsBloc>()),
        BlocProvider(create: (context) => sl<CartBloc>()),
      ],
      child: SizedBox(
        width: view.width,
        height: view.height,
        child: MaterialApp.router(
          title: AppConfig.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          routerConfig: routes,
          builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(
                  MediaQuery.of(context).textScaler.scale(1).clamp(0.8, 1.3),
                ),
              ),
              child: child!,
            ),
        ),
      ),
    );
  }
}