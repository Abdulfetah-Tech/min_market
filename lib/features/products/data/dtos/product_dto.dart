// Product DTO for API serialization

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ProductDto {
  const ProductDto({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.description,
    this.imageUrl,
    this.rating,
    this.reviewCount,
    this.inStock,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      id: json['id'],
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['reviewCount'] as int?,
      inStock: json['inStock'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  final dynamic id; // Can be int or String from API
  final String title;
  final num price;
  final String category;
  final String description;
  final String? imageUrl;
  final num? rating;
  final int? reviewCount;
  final bool? inStock;
  final String? createdAt;
  final String? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'inStock': inStock,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

@JsonSerializable()
class ProductsResponseDto {
  const ProductsResponseDto({
    required this.products,
    this.total = 0,
    this.skip = 0,
    this.limit = 0,
  });

  factory ProductsResponseDto.fromJson(Map<String, dynamic> json) {
    return ProductsResponseDto(
      products: (json['products'] as List<dynamic>)
          .map((e) => ProductDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      skip: json['skip'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
    );
  }

  final List<ProductDto> products;
  final int total;
  final int skip;
  final int limit;

  Map<String, dynamic> toJson() {
    return {
      'products': products.map((e) => e.toJson()).toList(),
      'total': total,
      'skip': skip,
      'limit': limit,
    };
  }
}

@JsonSerializable()
class ProductCreateDto {
  const ProductCreateDto({
    required this.title,
    required this.price,
    required this.category,
    required this.description,
    this.imageUrl,
  });

  factory ProductCreateDto.fromJson(Map<String, dynamic> json) {
    return ProductCreateDto(
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  final String title;
  final num price;
  final String category;
  final String description;
  final String? imageUrl;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}