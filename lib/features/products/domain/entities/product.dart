// Product domain entity - pure Dart, no framework dependencies

import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.description,
    this.imageUrl,
    this.rating,
    this.reviewCount,
    this.inStock = true,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String title;
  final double price;
  final String category;
  final String description;
  final String? imageUrl;
  final double? rating;
  final int? reviewCount;
  final bool inStock;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product copyWith({
    String? id,
    String? title,
    double? price,
    String? category,
    String? description,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    bool? inStock,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      category: category ?? this.category,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      inStock: inStock ?? this.inStock,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );

  @override
  List<Object?> get props => [
        id,
        title,
        price,
        category,
        description,
        imageUrl,
        rating,
        reviewCount,
        inStock,
        createdAt,
        updatedAt,
      ];
}

/// Cart item entity
class CartItem extends Equatable {
  const CartItem({
    required this.product,
    required this.quantity,
  });

  final Product product;
  final int quantity;

  double get total => product.price * quantity;

  CartItem copyWith({
    Product? product,
    int? quantity,
  }) => CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );

  @override
  List<Object?> get props => [product, quantity];
}