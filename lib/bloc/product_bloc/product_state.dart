part of 'product_bloc.dart';

abstract class ProductState {}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductError extends ProductState {
  final String errorMessage;

  ProductError(this.errorMessage);
}

final class ProductLoaded extends ProductState {
  final List<Product> products;

  ProductLoaded(this.products);
}

final class SingleProductLoaded extends ProductState {
  final Product product;

  SingleProductLoaded(this.product);
}
