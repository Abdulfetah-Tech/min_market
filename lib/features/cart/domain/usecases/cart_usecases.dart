// Cart use cases

import 'package:fpdart/fpdart.dart';

import '../entities/cart.dart';
import '../repositories/cart_repository.dart';
import 'package:min_market/features/products/domain/entities/product.dart';
import 'package:min_market/core/error/failures.dart';

class GetCartUseCase {
  final CartRepository _repository;

  GetCartUseCase(this._repository);

  Future<Result<Cart>> call() async {
    return _repository.getCart();
  }
}

class AddToCartUseCase {
  final CartRepository _repository;

  AddToCartUseCase(this._repository);

  Future<Result<Cart>> call(CartItem item) async {
    if (item.quantity <= 0) {
      return Left(ValidationFailure(
        message: 'Quantity must be greater than 0',
        fieldErrors: {'quantity': 'Quantity must be greater than 0'},
      ));
    }
    return _repository.addItem(item);
  }
}

class UpdateCartQuantityUseCase {
  final CartRepository _repository;

  UpdateCartQuantityUseCase(this._repository);

  Future<Result<Cart>> call(String productId, int quantity) async {
    if (quantity < 0) {
      return Left(ValidationFailure(
        message: 'Quantity cannot be negative',
        fieldErrors: {'quantity': 'Quantity cannot be negative'},
      ));
    }
    return _repository.updateQuantity(productId, quantity);
  }
}

class RemoveFromCartUseCase {
  final CartRepository _repository;

  RemoveFromCartUseCase(this._repository);

  Future<Result<Cart>> call(String productId) async {
    return _repository.removeItem(productId);
  }
}

class ClearCartUseCase {
  final CartRepository _repository;

  ClearCartUseCase(this._repository);

  Future<Result<Cart>> call() async {
    return _repository.clear();
  }
}