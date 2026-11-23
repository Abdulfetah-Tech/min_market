// Cart domain entities

import 'package:equatable/equatable.dart';

import 'package:min_market/features/products/domain/entities/product.dart';

class Cart extends Equatable {
  const Cart({
    required this.items,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final List<CartItem> items;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get total => items.fold(0.0, (sum, item) => sum + item.total);

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  Cart copyWith({
    String? id,
    List<CartItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Cart(
      id: id ?? this.id,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, items, createdAt, updatedAt];
}