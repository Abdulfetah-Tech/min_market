// Cart local data source - persistent storage

import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/cart.dart';
import 'package:min_market/features/products/domain/entities/product.dart';
import 'package:min_market/core/error/failures.dart';

abstract class CartLocalDataSource {
  Future<Result<Cart>> getCart();
  Future<Result<void>> saveCart(Cart cart);
  Future<Result<void>> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  static const String _cartKey = 'user_cart';

  final SharedPreferences _prefs;

  CartLocalDataSourceImpl(this._prefs);

  @override
  Future<Result<Cart>> getCart() async {
    try {
      final jsonString = _prefs.getString(_cartKey);
      if (jsonString == null || jsonString.isEmpty) {
        return const Right(Cart(items: []));
      }

      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return Right(_jsonToCart(jsonMap));
    } catch (e, stackTrace) {
      return Left(CacheFailure(
        message: 'Failed to read cart: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> saveCart(Cart cart) async {
    try {
      final jsonString = jsonEncode(_cartToJson(cart));
      await _prefs.setString(_cartKey, jsonString);
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(CacheFailure(
        message: 'Failed to save cart: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> clearCart() async {
    try {
      await _prefs.remove(_cartKey);
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(CacheFailure(
        message: 'Failed to clear cart: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  Cart _jsonToCart(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    final items = itemsJson
        .map((itemJson) => _jsonToCartItem(itemJson as Map<String, dynamic>))
        .toList();

    return Cart(
      id: json['id'] as String?,
      items: items,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  CartItem _jsonToCartItem(Map<String, dynamic> json) {
    final productJson = json['product'] as Map<String, dynamic>;
    final product = Product(
      id: productJson['id'] as String,
      title: productJson['title'] as String,
      price: (productJson['price'] as num).toDouble(),
      category: productJson['category'] as String,
      description: productJson['description'] as String,
      imageUrl: productJson['imageUrl'] as String?,
      rating: (productJson['rating'] as num?)?.toDouble(),
      reviewCount: productJson['reviewCount'] as int?,
      inStock: productJson['inStock'] as bool? ?? true,
      createdAt: productJson['createdAt'] != null
          ? DateTime.tryParse(productJson['createdAt'] as String)
          : null,
      updatedAt: productJson['updatedAt'] != null
          ? DateTime.tryParse(productJson['updatedAt'] as String)
          : null,
    );

    return CartItem(
      product: product,
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> _cartToJson(Cart cart) {
    return {
      'id': cart.id,
      'items': cart.items.map(_cartItemToJson).toList(),
      'createdAt': cart.createdAt?.toIso8601String(),
      'updatedAt': cart.updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> _cartItemToJson(CartItem item) {
    return {
      'product': {
        'id': item.product.id,
        'title': item.product.title,
        'price': item.product.price,
        'category': item.product.category,
        'description': item.product.description,
        'imageUrl': item.product.imageUrl,
        'rating': item.product.rating,
        'reviewCount': item.product.reviewCount,
        'inStock': item.product.inStock,
        'createdAt': item.product.createdAt?.toIso8601String(),
        'updatedAt': item.product.updatedAt?.toIso8601String(),
      },
      'quantity': item.quantity,
    };
  }
}