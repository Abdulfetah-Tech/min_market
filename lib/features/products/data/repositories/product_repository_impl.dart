// Product repository implementation - coordinates remote and local data sources

import 'package:fpdart/fpdart.dart';

import '../../../../core/core.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {

  ProductRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );
  final ProductRemoteDataSource _remoteDataSource;
  final ProductLocalDataSource _localDataSource;

  @override
  Future<Result<List<Product>>> getProducts() async {
    // Try to get from cache first for immediate response
    final cachedResult = await _localDataSource.getCachedProducts();
    final cachedProducts = cachedResult.getOrElse((_) => <Product>[]);

    // Try to fetch from remote
    final remoteResult = await _remoteDataSource.getProducts();

    return remoteResult.fold(
      (failure) {
        // If remote fails, return cached data if available
        if (cachedProducts.isNotEmpty) {
          return Right(cachedProducts);
        }
        // If no cache, return the failure
        return Left(failure);
      },
      (remoteProducts) async {
        // Cache the fresh data
        await _localDataSource.cacheProducts(remoteProducts);
        await _localDataSource.setLastCacheTime(DateTime.now());
        return Right(remoteProducts);
      },
    );
  }

  @override
  Future<Result<Product>> getProduct(String id) async {
    // Check cache first
    final cachedResult = await _localDataSource.getCachedProducts();
    final cachedProducts = cachedResult.getOrElse((_) => <Product>[]);
    final cachedProduct = cachedProducts
        .cast<Product?>() // Cast to handle nullable
        .firstWhere((p) => p?.id == id, orElse: () => null);

    // Try remote
    final remoteResult = await _remoteDataSource.getProduct(id);

    return remoteResult.fold(
      (failure) {
        // Return cached if available
        if (cachedProduct != null) {
          return Right(cachedProduct);
        }
        return Left(failure);
      },
      (remoteProduct) async {
        // Cache the fresh product
        await _localDataSource.cacheProduct(remoteProduct);
        return Right(remoteProduct);
      },
    );
  }

  @override
  Future<Result<Product>> createProduct(Product product) async {
    // Optimistic update - add to cache immediately
    await _localDataSource.cacheProduct(product);

    // Try remote
    final remoteResult = await _remoteDataSource.createProduct(product);

    return remoteResult.fold(
      (failure) async {
        // On failure, remove from cache
        await _localDataSource.removeCachedProduct(product.id);
        return Left(failure);
      },
      (remoteProduct) async {
        // Update cache with server response (may have generated ID)
        await _localDataSource.cacheProduct(remoteProduct);
        return Right(remoteProduct);
      },
    );
  }

  @override
  Future<Result<Product>> updateProduct(Product product) async {
    // Optimistic update
    await _localDataSource.cacheProduct(product);

    final remoteResult = await _remoteDataSource.updateProduct(product);

    return remoteResult.fold(
      (failure) async {
        // On failure, could revert to previous state
        // For now, keep optimistic update
        return Left(failure);
      },
      (remoteProduct) async {
        await _localDataSource.cacheProduct(remoteProduct);
        return Right(remoteProduct);
      },
    );
  }

  @override
  Future<Result<void>> deleteProduct(String id) async {
    // Optimistic delete
    await _localDataSource.removeCachedProduct(id);

    final remoteResult = await _remoteDataSource.deleteProduct(id);

    return remoteResult.fold(
      (failure) async {
        // On failure, we can't easily restore - would need to store deleted item
        // For now, just return failure
        return Left(failure);
      },
      (success) async => Right(success),
    );
  }

  @override
  Future<Result<List<Product>>> searchProducts(String query) async {
    final productsResult = await getProducts();
    return productsResult.map(
      (products) => products
          .where((p) =>
              p.title.toLowerCase().contains(query.toLowerCase()) ||
              p.description.toLowerCase().contains(query.toLowerCase()) ||
              p.category.toLowerCase().contains(query.toLowerCase()))
          .toList(),
    );
  }

  @override
  Future<Result<List<Product>>> getProductsByCategory(String category) async {
    final productsResult = await getProducts();
    return productsResult.map(
      (products) => products
          .where((p) => p.category.toLowerCase() == category.toLowerCase())
          .toList(),
    );
  }
}