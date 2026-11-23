// Local data source for products - caching and offline support

import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/product.dart';
import 'package:min_market/core/core.dart';

abstract class ProductLocalDataSource {
  Future<Result<List<Product>>> getCachedProducts();
  Future<Result<void>> cacheProducts(List<Product> products);
  Future<Result<void>> cacheProduct(Product product);
  Future<Result<void>> removeCachedProduct(String id);
  Future<Result<void>> clearCache();
  Future<Result<DateTime?>> getLastCacheTime();
  Future<Result<void>> setLastCacheTime(DateTime time);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static const String _cacheKey = 'cached_products';
  static const String _lastCacheTimeKey = 'products_last_cache_time';

  final SharedPreferences _prefs;

  ProductLocalDataSourceImpl(this._prefs);

  @override
  Future<Result<List<Product>>> getCachedProducts() async {
    try {
      final jsonString = _prefs.getString(_cacheKey);
      if (jsonString == null || jsonString.isEmpty) {
        return const Right([]);
      }

      final List<dynamic> jsonList = jsonDecode(jsonString);
      final products = jsonList
          .map((json) => _jsonToEntity(json as Map<String, dynamic>))
          .toList();
      return Right(products);
    } catch (e, stackTrace) {
      return Left(CacheFailure(
        message: 'Failed to read cached products: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> cacheProducts(List<Product> products) async {
    try {
      final jsonString = jsonEncode(
        products.map(_entityToJson).toList(),
      );
      await _prefs.setString(_cacheKey, jsonString);
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(CacheFailure(
        message: 'Failed to cache products: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> cacheProduct(Product product) async {
    final result = await getCachedProducts();
    return result.flatMap((products) {
      final existingIndex = products.indexWhere((p) => p.id == product.id);
      if (existingIndex >= 0) {
        products[existingIndex] = product;
      } else {
        products.insert(0, product);
      }
      return cacheProducts(products) as Either<Failure, void>;
    });
  }

  @override
  Future<Result<void>> removeCachedProduct(String id) async {
    final result = await getCachedProducts();
    return result.flatMap((products) {
      final updated = products.where((p) => p.id != id).toList();
      return cacheProducts(updated) as Either<Failure, void>;
    });
  }

  @override
  Future<Result<void>> clearCache() async {
    try {
      await _prefs.remove(_cacheKey);
      await _prefs.remove(_lastCacheTimeKey);
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(CacheFailure(
        message: 'Failed to clear cache: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<DateTime?>> getLastCacheTime() async {
    try {
      final timestamp = _prefs.getInt(_lastCacheTimeKey);
      if (timestamp == null) return const Right(null);
      return Right(DateTime.fromMillisecondsSinceEpoch(timestamp));
    } catch (e, stackTrace) {
      return Left(CacheFailure(
        message: 'Failed to get last cache time: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> setLastCacheTime(DateTime time) async {
    try {
      await _prefs.setInt(_lastCacheTimeKey, time.millisecondsSinceEpoch);
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(CacheFailure(
        message: 'Failed to set last cache time: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  Product _jsonToEntity(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['reviewCount'] as int?,
      inStock: json['inStock'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> _entityToJson(Product product) {
    return {
      'id': product.id,
      'title': product.title,
      'price': product.price,
      'category': product.category,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'rating': product.rating,
      'reviewCount': product.reviewCount,
      'inStock': product.inStock,
      'createdAt': product.createdAt?.toIso8601String(),
      'updatedAt': product.updatedAt?.toIso8601String(),
    };
  }
}