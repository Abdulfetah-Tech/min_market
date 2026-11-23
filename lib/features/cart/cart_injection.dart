// Cart feature dependency injection

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:min_market/core/core.dart';
import 'data/cart_data.dart';
import 'domain/cart_domain.dart';

final GetIt sl = GetIt.instance;

void registerCartDependencies() {
  // Data source
  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(sl<SharedPreferences>()),
  );

  // Repository
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(sl<CartLocalDataSource>()),
  );

  // Use cases
  sl.registerLazySingleton<GetCartUseCase>(
    () => GetCartUseCase(sl<CartRepository>()),
  );

  sl.registerLazySingleton<AddToCartUseCase>(
    () => AddToCartUseCase(sl<CartRepository>()),
  );

  sl.registerLazySingleton<UpdateCartQuantityUseCase>(
    () => UpdateCartQuantityUseCase(sl<CartRepository>()),
  );

  sl.registerLazySingleton<RemoveFromCartUseCase>(
    () => RemoveFromCartUseCase(sl<CartRepository>()),
  );

  sl.registerLazySingleton<ClearCartUseCase>(
    () => ClearCartUseCase(sl<CartRepository>()),
  );
}