// Cart repository implementation

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/entities/cart.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';

class CartRepositoryImpl implements CartRepository {

  CartRepositoryImpl(this._localDataSource);
  final CartLocalDataSource _localDataSource;
  Cart? _cachedCart;

  @override
  Future<Result<Cart>> getCart() async {
    if (_cachedCart != null) {
      return Right(_cachedCart!);
    }

    final result = await _localDataSource.getCart();
    return result.map((cart) {
      _cachedCart = cart;
      return cart;
    });
  }

  @override
  Future<Result<Cart>> addItem(CartItem item) async {
    final cartResult = await getCart();
    if (cartResult.isLeft()) {
      return Left(cartResult.failureOrNull!);
    }

    final cart = cartResult.valueOrNull!;
    final existingIndex = cart.items.indexWhere(
      (i) => i.product.id == item.product.id,
    );

    Cart updatedCart;
    if (existingIndex >= 0) {
      final existingItem = cart.items[existingIndex];
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity,
      );
      final updatedItems = [
        ...cart.items.sublist(0, existingIndex),
        updatedItem,
        ...cart.items.sublist(existingIndex + 1),
      ];
      updatedCart = cart.copyWith(
        items: updatedItems,
        updatedAt: DateTime.now(),
      );
    } else {
      updatedCart = cart.copyWith(
        items: [...cart.items, item],
        updatedAt: DateTime.now(),
      );
    }

    _cachedCart = updatedCart;
    final saveResult = await _localDataSource.saveCart(updatedCart);
    return saveResult.map((_) => updatedCart);
  }

  @override
  Future<Result<Cart>> updateQuantity(String productId, int quantity) async {
    final cartResult = await getCart();
    if (cartResult.isLeft()) {
      return Left(cartResult.failureOrNull!);
    }

    final cart = cartResult.valueOrNull!;
    final existingIndex = cart.items.indexWhere(
      (i) => i.product.id == productId,
    );

    if (existingIndex == -1) {
      return const Left(NotFoundFailure(
        message: 'Product not found in cart',
      ));
    }

    Cart updatedCart;
    if (quantity <= 0) {
      final updatedItems = [
        ...cart.items.sublist(0, existingIndex),
        ...cart.items.sublist(existingIndex + 1),
      ];
      updatedCart = cart.copyWith(
        items: updatedItems,
        updatedAt: DateTime.now(),
      );
    } else {
      final existingItem = cart.items[existingIndex];
      final updatedItem = existingItem.copyWith(quantity: quantity);
      final updatedItems = [
        ...cart.items.sublist(0, existingIndex),
        updatedItem,
        ...cart.items.sublist(existingIndex + 1),
      ];
      updatedCart = cart.copyWith(
        items: updatedItems,
        updatedAt: DateTime.now(),
      );
    }

    _cachedCart = updatedCart;
    final saveResult = await _localDataSource.saveCart(updatedCart);
    return saveResult.map((_) => updatedCart);
  }

  @override
  Future<Result<Cart>> removeItem(String productId) async {
    final cartResult = await getCart();
    if (cartResult.isLeft()) {
      return Left(cartResult.failureOrNull!);
    }

    final cart = cartResult.valueOrNull!;
    final updatedItems = cart.items
        .where((i) => i.product.id != productId)
        .toList();

    final updatedCart = cart.copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );

    _cachedCart = updatedCart;
    final saveResult = await _localDataSource.saveCart(updatedCart);
    return saveResult.map((_) => updatedCart);
  }

  @override
  Future<Result<Cart>> clear() async {
    const emptyCart = Cart(items: []);
    _cachedCart = emptyCart;
    final saveResult = await _localDataSource.saveCart(emptyCart);
    return saveResult.map((_) => emptyCart);
  }

  @override
  Future<Result<void>> saveCart(Cart cart) async {
    _cachedCart = cart;
    return _localDataSource.saveCart(cart);
  }
}