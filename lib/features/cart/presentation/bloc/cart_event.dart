// Cart BLoC events

import 'package:equatable/equatable.dart';

import '../../../products/domain/entities/product.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCartEvent extends CartEvent {
  const LoadCartEvent();
}

class AddToCartEvent extends CartEvent {

  const AddToCartEvent(this.item);
  final CartItem item;

  @override
  List<Object?> get props => [item];
}

class UpdateQuantityEvent extends CartEvent {

  const UpdateQuantityEvent(this.productId, this.quantity);
  final String productId;
  final int quantity;

  @override
  List<Object?> get props => [productId, quantity];
}

class RemoveFromCartEvent extends CartEvent {

  const RemoveFromCartEvent(this.productId);
  final String productId;

  @override
  List<Object?> get props => [productId];
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}