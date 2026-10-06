part of 'product_bloc.dart';

abstract class ProductEvent {}

class ProductCreateEvent extends ProductEvent {
  final Product product;

  ProductCreateEvent(this.product);
}

class ProductUpdateEvent extends ProductEvent {
  final Product product;

  ProductUpdateEvent(this.product);
}

class DeleteProductEvent extends ProductEvent {
  final String productId;

  DeleteProductEvent(this.productId);
}

class GetProductsEvent extends ProductEvent {}

class GetProductEvent extends ProductEvent {
  final String productId;

  GetProductEvent(this.productId);
}
