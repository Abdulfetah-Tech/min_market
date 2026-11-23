// Product use cases - business logic layer

import 'package:fpdart/fpdart.dart';

import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'package:min_market/core/error/failures.dart';

/// Use case for getting all products
class GetProductsUseCase {
  final ProductRepository _repository;

  GetProductsUseCase(this._repository);

  Future<Result<List<Product>>> call() async {
    return _repository.getProducts();
  }
}

/// Use case for getting a single product
class GetProductUseCase {
  final ProductRepository _repository;

  GetProductUseCase(this._repository);

  Future<Result<Product>> call(String id) async {
    if (id.trim().isEmpty) {
      return Left(ValidationFailure(
        message: 'Product ID is required',
        fieldErrors: {'id': 'Product ID is required'},
      ));
    }
    return _repository.getProduct(id);
  }
}

/// Use case for creating a product
class CreateProductUseCase {
  final ProductRepository _repository;

  CreateProductUseCase(this._repository);

  Future<Result<Product>> call(Product product) async {
    // Validate product
    final validationError = _validateProduct(product);
    if (validationError != null) {
      return Left(validationError);
    }
    return _repository.createProduct(product);
  }

  ValidationFailure? _validateProduct(Product product) {
    final errors = <String, String>{};

    if (product.title.trim().isEmpty) {
      errors['title'] = 'Title is required';
    }

    if (product.price <= 0) {
      errors['price'] = 'Price must be greater than 0';
    }

    if (product.category.trim().isEmpty) {
      errors['category'] = 'Category is required';
    }

    if (product.description.trim().isEmpty) {
      errors['description'] = 'Description is required';
    }

    if (errors.isNotEmpty) {
      return ValidationFailure(
        message: 'Product validation failed',
        fieldErrors: errors,
      );
    }

    return null;
  }
}

/// Use case for updating a product
class UpdateProductUseCase {
  final ProductRepository _repository;

  UpdateProductUseCase(this._repository);

  Future<Result<Product>> call(Product product) async {
    if (product.id.trim().isEmpty) {
      return Left(ValidationFailure(
        message: 'Product ID is required',
        fieldErrors: {'id': 'Product ID is required'},
      ));
    }

    final validationError = _validateProduct(product);
    if (validationError != null) {
      return Left(validationError);
    }

    return _repository.updateProduct(product);
  }

  ValidationFailure? _validateProduct(Product product) {
    final errors = <String, String>{};

    if (product.title.trim().isEmpty) {
      errors['title'] = 'Title is required';
    }

    if (product.price <= 0) {
      errors['price'] = 'Price must be greater than 0';
    }

    if (product.category.trim().isEmpty) {
      errors['category'] = 'Category is required';
    }

    if (product.description.trim().isEmpty) {
      errors['description'] = 'Description is required';
    }

    if (errors.isNotEmpty) {
      return ValidationFailure(
        message: 'Product validation failed',
        fieldErrors: errors,
      );
    }

    return null;
  }
}

/// Use case for deleting a product
class DeleteProductUseCase {
  final ProductRepository _repository;

  DeleteProductUseCase(this._repository);

  Future<Result<void>> call(String id) async {
    if (id.trim().isEmpty) {
      return Left(ValidationFailure(
        message: 'Product ID is required',
        fieldErrors: {'id': 'Product ID is required'},
      ));
    }
    return _repository.deleteProduct(id);
  }
}

/// Use case for searching products
class SearchProductsUseCase {
  final ProductRepository _repository;

  SearchProductsUseCase(this._repository);

  Future<Result<List<Product>>> call(String query) async {
    if (query.trim().isEmpty) {
      return _repository.getProducts();
    }
    return _repository.searchProducts(query.trim());
  }
}

/// Use case for getting products by category
class GetProductsByCategoryUseCase {
  final ProductRepository _repository;

  GetProductsByCategoryUseCase(this._repository);

  Future<Result<List<Product>>> call(String category) async {
    if (category.trim().isEmpty) {
      return _repository.getProducts();
    }
    return _repository.getProductsByCategory(category.trim());
  }
}