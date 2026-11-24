// Cart BLoC states

import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../domain/entities/cart.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {

  const CartLoaded(this.cart);
  final Cart cart;

  int get itemCount => cart.itemCount;
  double get total => cart.total;
  bool get isEmpty => cart.isEmpty;
  bool get isNotEmpty => cart.isNotEmpty;

  @override
  List<Object?> get props => [cart];
}

class CartError extends CartState {

  const CartError({
    required this.failure,
    this.cachedCart,
  });
  final Failure failure;
  final Cart? cachedCart;

  @override
  List<Object?> get props => [failure, cachedCart];
}

class CartActionLoading extends CartState {

  const CartActionLoading(this.productId);
  final String productId;

  @override
  List<Object?> get props => [productId];
}