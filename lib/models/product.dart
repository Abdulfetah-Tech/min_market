class Product {

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      price: (json['price'] as num? ?? 0).toDouble(),
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  final String id;
  final String title;
  final double price;
  final String category;
  final String description;

  Product copyWith({
    String? title,
    double? price,
    String? category,
    String? description,
  }) => Product(
      id: id,
      title: title ?? this.title,
      price: price ?? this.price,
      category: category ?? this.category,
      description: description ?? this.description,
    );

  Map<String, dynamic> toJson() => {
      'title': title,
      'price': price,
      'category': category,
      'description': description,
    };
}

class CartItem {

  CartItem({required this.product, required this.quantity});
  final Product product;
  int quantity;

  double get total => product.price * quantity;
}
