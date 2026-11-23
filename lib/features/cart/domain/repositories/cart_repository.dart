// Cart repository interface

import 'package:fpdart/fpdart.dart';

import '../entities/cart.dart';
import 'package:min_market/features/products/domain/entities/product.dart';
import 'package:min_market/core/error/failures.dart';

abstract class CartRepository {
  /// Get current cart
  Future<Result<Cart>> getCart();

  /// Add item to cart
  Future<Result<Cart>> addItem(CartItem item);

  /// Update item quantity
  Future<Result<Cart>> updateQuantity(String productId, int quantity);

  /// Remove item from cart
  Future<Result<Cart>> removeItem(String productId);

  /// Clear cart
  Future<Result<Cart>> clear();

  /// Save cart for persistence
  Future<Result<void>> saveCart(Cart cart);
}