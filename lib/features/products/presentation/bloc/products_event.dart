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

  const LoadProductEvent(this.productId);
  final String productId;

  @override
  List<Object?> get props => [productId];
}

class CreateProductEvent extends ProductsEvent {

  const CreateProductEvent(this.product);
  final Product product;

  @override
  List<Object?> get props => [product];
}

class UpdateProductEvent extends ProductsEvent {

  const UpdateProductEvent(this.product);
  final Product product;

  @override
  List<Object?> get props => [product];
}

class DeleteProductEvent extends ProductsEvent {

  const DeleteProductEvent(this.productId);
  final String productId;

  @override
  List<Object?> get props => [productId];
}

class SearchProductsEvent extends ProductsEvent {

  const SearchProductsEvent(this.query);
  final String query;

  @override
  List<Object?> get props => [query];
}

class LoadProductsByCategoryEvent extends ProductsEvent {

  const LoadProductsByCategoryEvent(this.category);
  final String category;

  @override
  List<Object?> get props => [category];
}

class RefreshProductsEvent extends ProductsEvent {
  const RefreshProductsEvent();
}