// Products BLoC states - using equatable for value equality

import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../domain/entities/product.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {

  const ProductsLoading({this.isFirstLoad = true});
  final bool isFirstLoad;

  @override
  List<Object?> get props => [isFirstLoad];
}

class ProductsLoaded extends ProductsState {

  const ProductsLoaded({
    required this.products,
    this.hasReachedEnd = true,
  });
  final List<Product> products;
  final bool hasReachedEnd;

  @override
  List<Object?> get props => [products, hasReachedEnd];
}

class ProductsError extends ProductsState {

  const ProductsError({
    required this.failure,
    this.cachedProducts,
  });
  final Failure failure;
  final List<Product>? cachedProducts;

  @override
  List<Object?> get props => [failure, cachedProducts];
}

class ProductLoaded extends ProductsState {

  const ProductLoaded(this.product);
  final Product product;

  @override
  List<Object?> get props => [product];
}

class ProductLoading extends ProductsState {

  const ProductLoading({this.isFirstLoad = true});
  final bool isFirstLoad;

  @override
  List<Object?> get props => [isFirstLoad];
}

class ProductError extends ProductsState {

  const ProductError({
    required this.failure,
    this.cachedProduct,
  });
  final Failure failure;
  final Product? cachedProduct;

  @override
  List<Object?> get props => [failure, cachedProduct];
}

class ProductActionLoading extends ProductsState {

  const ProductActionLoading(this.productId);
  final String productId;

  @override
  List<Object?> get props => [productId];
}

class ProductActionSuccess extends ProductsState {

  const ProductActionSuccess(this.product, this.message);
  final Product product;
  final String message;

  @override
  List<Object?> get props => [product, message];
}

class ProductActionError extends ProductsState {

  const ProductActionError(this.failure, this.productId);
  final Failure failure;
  final String productId;

  @override
  List<Object?> get props => [failure, productId];
}