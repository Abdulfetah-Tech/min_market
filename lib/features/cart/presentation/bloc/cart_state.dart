// Cart BLoC states

import 'package:equatable/equatable.dart';

import '../../domain/entities/cart.dart';
import 'package:min_market/core/core.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final Cart cart;

  const CartLoaded(this.cart);

  int get itemCount => cart.itemCount;
  double get total => cart.total;
  bool get isEmpty => cart.isEmpty;
  bool get isNotEmpty => cart.isNotEmpty;

  @override
  List<Object?> get props => [cart];
}

class CartError extends CartState {
  final Failure failure;
  final Cart? cachedCart;

  const CartError({
    required this.failure,
    this.cachedCart,
  });

  @override
  List<Object?> get props => [failure, cachedCart];
}

class CartActionLoading extends CartState {
  final String productId;

  const CartActionLoading(this.productId);

  @override
  List<Object?> get props => [productId];
}