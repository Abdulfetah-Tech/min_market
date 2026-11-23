// Products BLoC events - using equatable for value equality

import 'package:equatable/equatable.dart';

import '../../domain/entities/product.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductsEvent extends ProductsEvent {
  const LoadProductsEvent();
}

class LoadProductEvent extends ProductsEvent {
  final String productId;

  const LoadProductEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

class CreateProductEvent extends ProductsEvent {
  final Product product;

  const CreateProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class UpdateProductEvent extends ProductsEvent {
  final Product product;

  const UpdateProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class DeleteProductEvent extends ProductsEvent {
  final String productId;

  const DeleteProductEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

class SearchProductsEvent extends ProductsEvent {
  final String query;

  const SearchProductsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadProductsByCategoryEvent extends ProductsEvent {
  final String category;

  const LoadProductsByCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class RefreshProductsEvent extends ProductsEvent {
  const RefreshProductsEvent();
}