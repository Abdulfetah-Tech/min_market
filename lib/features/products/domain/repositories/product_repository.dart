// Product repository interface - defines contract for data access

import '../../../../core/core.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  /// Get all products
  Future<Result<List<Product>>> getProducts();

  /// Get a single product by ID
  Future<Result<Product>> getProduct(String id);

  /// Create a new product
  Future<Result<Product>> createProduct(Product product);

  /// Update an existing product
  Future<Result<Product>> updateProduct(Product product);

  /// Delete a product by ID
  Future<Result<void>> deleteProduct(String id);

  /// Search products by query
  Future<Result<List<Product>>> searchProducts(String query);

  /// Get products by category
  Future<Result<List<Product>>> getProductsByCategory(String category);
}