// Cart BLoC events

import 'package:equatable/equatable.dart';

import 'package:min_market/features/products/domain/entities/product.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCartEvent extends CartEvent {
  const LoadCartEvent();
}

class AddToCartEvent extends CartEvent {
  final CartItem item;

  const AddToCartEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class UpdateQuantityEvent extends CartEvent {
  final String productId;
  final int quantity;

  const UpdateQuantityEvent(this.productId, this.quantity);

  @override
  List<Object?> get props => [productId, quantity];
}

class RemoveFromCartEvent extends CartEvent {
  final String productId;

  const RemoveFromCartEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}