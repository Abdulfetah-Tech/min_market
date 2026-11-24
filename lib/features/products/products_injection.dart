// Products feature dependency injection

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/core.dart';
import 'data/products_data.dart';
import 'domain/products_domain.dart';
import 'presentation/bloc/products_bloc.dart';

final GetIt sl = GetIt.instance;

void registerProductsDependencies() {
  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl<ApiClient>()),
  );

  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(sl<SharedPreferences>()),
  );

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      sl<ProductRemoteDataSource>(),
      sl<ProductLocalDataSource>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(sl<ProductRepository>()),
  );

  sl.registerLazySingleton<GetProductUseCase>(
    () => GetProductUseCase(sl<ProductRepository>()),
  );

  sl.registerLazySingleton<CreateProductUseCase>(
    () => CreateProductUseCase(sl<ProductRepository>()),
  );

  sl.registerLazySingleton<UpdateProductUseCase>(
    () => UpdateProductUseCase(sl<ProductRepository>()),
  );

  sl.registerLazySingleton<DeleteProductUseCase>(
    () => DeleteProductUseCase(sl<ProductRepository>()),
  );

  sl.registerLazySingleton<SearchProductsUseCase>(
    () => SearchProductsUseCase(sl<ProductRepository>()),
  );

  sl.registerLazySingleton<GetProductsByCategoryUseCase>(
    () => GetProductsByCategoryUseCase(sl<ProductRepository>()),
  );

  // BLoC
  sl.registerLazySingleton<ProductsBloc>(
    () => ProductsBloc(
      getProductsUseCase: sl<GetProductsUseCase>(),
      getProductUseCase: sl<GetProductUseCase>(),
      createProductUseCase: sl<CreateProductUseCase>(),
      updateProductUseCase: sl<UpdateProductUseCase>(),
      deleteProductUseCase: sl<DeleteProductUseCase>(),
      searchProductsUseCase: sl<SearchProductsUseCase>(),
      getProductsByCategoryUseCase: sl<GetProductsByCategoryUseCase>(),
    ),
  );
}