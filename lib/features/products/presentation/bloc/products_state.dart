// Products BLoC states - using equatable for value equality

import 'package:equatable/equatable.dart';

import '../../domain/entities/product.dart';
import 'package:min_market/core/core.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {
  final bool isFirstLoad;

  const ProductsLoading({this.isFirstLoad = true});

  @override
  List<Object?> get props => [isFirstLoad];
}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final bool hasReachedEnd;

  const ProductsLoaded({
    required this.products,
    this.hasReachedEnd = true,
  });

  @override
  List<Object?> get props => [products, hasReachedEnd];
}

class ProductsError extends ProductsState {
  final Failure failure;
  final List<Product>? cachedProducts;

  const ProductsError({
    required this.failure,
    this.cachedProducts,
  });

  @override
  List<Object?> get props => [failure, cachedProducts];
}

class ProductLoaded extends ProductsState {
  final Product product;

  const ProductLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductLoading extends ProductsState {
  final bool isFirstLoad;

  const ProductLoading({this.isFirstLoad = true});

  @override
  List<Object?> get props => [isFirstLoad];
}

class ProductError extends ProductsState {
  final Failure failure;
  final Product? cachedProduct;

  const ProductError({
    required this.failure,
    this.cachedProduct,
  });

  @override
  List<Object?> get props => [failure, cachedProduct];
}

class ProductActionLoading extends ProductsState {
  final String productId;

  const ProductActionLoading(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ProductActionSuccess extends ProductsState {
  final Product product;
  final String message;

  const ProductActionSuccess(this.product, this.message);

  @override
  List<Object?> get props => [product, message];
}

class ProductActionError extends ProductsState {
  final Failure failure;
  final String productId;

  const ProductActionError(this.failure, this.productId);

  @override
  List<Object?> get props => [failure, productId];
}