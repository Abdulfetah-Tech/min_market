// Cart use cases

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../products/domain/entities/product.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class GetCartUseCase {

  GetCartUseCase(this._repository);
  final CartRepository _repository;

  Future<Result<Cart>> call() async => _repository.getCart();
}

class AddToCartUseCase {

  AddToCartUseCase(this._repository);
  final CartRepository _repository;

  Future<Result<Cart>> call(CartItem item) async {
    if (item.quantity <= 0) {
      return const Left(ValidationFailure(
        message: 'Quantity must be greater than 0',
        fieldErrors: {'quantity': 'Quantity must be greater than 0'},
      ));
    }
    return _repository.addItem(item);
  }
}

class UpdateCartQuantityUseCase {

  UpdateCartQuantityUseCase(this._repository);
  final CartRepository _repository;

  Future<Result<Cart>> call(String productId, int quantity) async {
    if (quantity < 0) {
      return const Left(ValidationFailure(
        message: 'Quantity cannot be negative',
        fieldErrors: {'quantity': 'Quantity cannot be negative'},
      ));
    }
    return _repository.updateQuantity(productId, quantity);
  }
}

class RemoveFromCartUseCase {

  RemoveFromCartUseCase(this._repository);
  final CartRepository _repository;

  Future<Result<Cart>> call(String productId) async => _repository.removeItem(productId);
}

class ClearCartUseCase {

  ClearCartUseCase(this._repository);
  final CartRepository _repository;

  Future<Result<Cart>> call() async => _repository.clear();
}