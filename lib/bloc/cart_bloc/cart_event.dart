part of 'cart_bloc.dart';

abstract class CartEvent {}

class AddToCartEvent extends CartEvent {
  final Product product;
  final int quantity;

  AddToCartEvent(this.product, this.quantity);
}

class RemoveFromCart extends CartEvent {
  final String productId;

  RemoveFromCart(this.productId);
}

class ClearCart extends CartEvent {}
