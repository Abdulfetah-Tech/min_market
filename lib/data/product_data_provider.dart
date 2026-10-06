import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';
import 'market_store.dart';

class ProductDataProvider {
  static const String baseUrl = 'https://dummyjson.com/products';
  final http.Client _client;
  final List<Product> _localProducts = [];

  ProductDataProvider({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Product>> getProducts() async {
    try {
      final response = await _client.get(Uri.parse("$baseUrl?limit=0"));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final products = body['products'] as List<dynamic>;

        final result = <Product>[];
        result.addAll(_localProducts);

        for (final product in products) {
          final p = Product.fromJson(product as Map<String, dynamic>);
          final localIndex = _localProducts.indexWhere((lp) => lp.id == p.id);
          if (localIndex != -1) {
            continue;
          }
          result.add(p);
        }

        return result;
      }
    } catch (_) {
      // Fallback to local / MarketStore when offline or on network failure
    }

    final fallback = <Product>[..._localProducts];
    for (final mp in MarketStore.products) {
      if (!fallback.any((p) => p.id == mp.id)) {
        fallback.add(mp);
      }
    }
    return fallback;
  }

  Future<Product> getProduct(String id) async {
    final localIndex = _localProducts.indexWhere((p) => p.id == id);
    if (localIndex != -1) {
      return _localProducts[localIndex];
    }

    final numericId = int.tryParse(id);
    if (numericId != null) {
      try {
        final response = await _client.get(Uri.parse('$baseUrl/$numericId'));
        if (response.statusCode == 200) {
          return Product.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>,
          );
        }
      } catch (_) {}
    }

    final marketProduct = MarketStore.findProduct(id);
    if (marketProduct != null) {
      return marketProduct;
    }

    throw Exception('Product not found');
  }

  Future<Product> addProduct(Product product) async {
    Product createdProduct = product;
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/add'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(product.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final parsed = Product.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
        createdProduct = product.copyWith(
          title: parsed.title.isNotEmpty ? parsed.title : product.title,
        );
      }
    } catch (_) {
      // Keep createdProduct
    }

    _localProducts.insert(0, createdProduct);
    MarketStore.addProduct(createdProduct);
    return createdProduct;
  }

  Future<Product> updateProduct(Product product) async {
    final numericId = int.tryParse(product.id);
    if (numericId != null) {
      try {
        await _client.put(
          Uri.parse('$baseUrl/$numericId'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(product.toJson()),
        );
      } catch (_) {}
    }

    final localIndex = _localProducts.indexWhere((p) => p.id == product.id);
    if (localIndex != -1) {
      _localProducts[localIndex] = product;
    } else {
      _localProducts.insert(0, product);
    }
    MarketStore.updateProduct(product);
    return product;
  }

  Future<void> deleteProduct(String id) async {
    final numericId = int.tryParse(id);
    if (numericId != null) {
      try {
        await _client.delete(
          Uri.parse('$baseUrl/$numericId'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
        );
      } catch (_) {}
    }

    _localProducts.removeWhere((p) => p.id == id);
    MarketStore.deleteProduct(id);
  }
}

// Alternative approach using Dio, a REST client package that provides the same
// basic functionality as http for making API requests, handling JSON, and
// managing request/response lifecycle in a more feature-rich way.
//
// To install it:
//   flutter pub add dio
//
// You can comment out the http section above and uncomment this Dio section to
// compare both implementations side by side.

// import 'package:dio/dio.dart';
// import 'package:min_market/models/product.dart';

// final dio = Dio(
//   BaseOptions(
//     baseUrl: 'https://dummyjson.com/products',
//     headers: {'Content-Type': 'application/json; charset=UTF-8'},
//   ),
// );

// class ProductDataProvider {
//   ProductDataProvider();

//   Future<Product> addProduct(Product product) async {
//     final response = await dio.post("/add", data: product.toJson());

//     if (response.statusCode != 200 && response.statusCode != 201) {
//       throw Exception(_errorMessage(response.data));
//     }

//     return Product.fromJson(response.data as Map<String, dynamic>);
//   }

//   Future<Product> updateProduct(Product product) async {
//     final response = await dio.put("/${product.id}", data: product.toJson());

//     if (response.statusCode != 200 && response.statusCode != 201) {
//       throw Exception(_errorMessage(response.data));
//     }

//     return Product.fromJson(response.data as Map<String, dynamic>);
//   }

//   Future<void> deleteProduct(int productId) async {
//     final response = await dio.delete("/$productId");

//     if (response.statusCode != 204 && response.statusCode != 200) {
//       throw Exception(_errorMessage(response.data));
//     }
//   }

//   Future<Product> getProduct(int productId) async {
//     final response = await dio.get("/$productId");

//     if (response.statusCode != 200) {
//       throw Exception(_errorMessage(response.data));
//     }

//     return Product.fromJson(response.data as Map<String, dynamic>);
//   }

//   Future<List<Product>> getProducts() async {
//     final response = await dio.get("");

//     if (response.statusCode != 200) {
//       throw Exception(_errorMessage(response.data));
//     }

//     final products = response.data['products'] as List<dynamic>;

//     final List<Product> result = [];
//     for (final product in products) {
//       result.add(Product.fromJson(product as Map<String, dynamic>));
//     }

//     return result;
//   }

//   String _errorMessage(Response<dynamic> response) {
//     try {
//       final body = response.data;
//       if (body is Map<String, dynamic> && body['message'] is String) {
//         return body['message'] as String;
//       }
//     } catch (_) {}

//     return 'The server said ${response.statusCode}.';
//   }
// }
