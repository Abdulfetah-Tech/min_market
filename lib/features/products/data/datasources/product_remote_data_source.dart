// Remote data source for products - API communication

import 'package:fpdart/fpdart.dart';

import '../../domain/entities/product.dart';
import '../dtos/product_dto.dart';
import 'package:min_market/core/core.dart';

abstract class ProductRemoteDataSource {
  Future<Result<List<Product>>> getProducts();
  Future<Result<Product>> getProduct(String id);
  Future<Result<Product>> createProduct(Product product);
  Future<Result<Product>> updateProduct(Product product);
  Future<Result<void>> deleteProduct(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient _apiClient;

  ProductRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<List<Product>>> getProducts() async {
    return _apiClient.get<ProductsResponseDto>(
      '',
      parser: (data) => ProductsResponseDto.fromJson(data as Map<String, dynamic>),
    ).then((result) => result.map(
      (response) => response.products.map(_dtoToEntity).toList(),
    ));
  }

  @override
  Future<Result<Product>> getProduct(String id) async {
    return _apiClient.get<ProductDto>(
      '/$id',
      parser: (data) => ProductDto.fromJson(data as Map<String, dynamic>),
    ).then((result) => result.map(_dtoToEntity));
  }

  @override
  Future<Result<Product>> createProduct(Product product) async {
    final dto = ProductCreateDto(
      title: product.title,
      price: product.price,
      category: product.category,
      description: product.description,
      imageUrl: product.imageUrl,
    );

    return _apiClient.post<ProductDto>(
      '/add',
      data: dto.toJson(),
      parser: (data) => ProductDto.fromJson(data as Map<String, dynamic>),
    ).then((result) => result.map(_dtoToEntity));
  }

  @override
  Future<Result<Product>> updateProduct(Product product) async {
    final numericId = int.tryParse(product.id);
    if (numericId == null) {
      return Left(ValidationFailure(
        message: 'Invalid product ID',
        fieldErrors: {'id': 'Product ID must be numeric for API'},
      ));
    }

    final dto = ProductCreateDto(
      title: product.title,
      price: product.price,
      category: product.category,
      description: product.description,
      imageUrl: product.imageUrl,
    );

    return _apiClient.put<ProductDto>(
      '/$numericId',
      data: dto.toJson(),
      parser: (data) => ProductDto.fromJson(data as Map<String, dynamic>),
    ).then((result) => result.map(_dtoToEntity));
  }

  @override
  Future<Result<void>> deleteProduct(String id) async {
    final numericId = int.tryParse(id);
    if (numericId == null) {
      return Left(ValidationFailure(
        message: 'Invalid product ID',
        fieldErrors: {'id': 'Product ID must be numeric for API'},
      ));
    }

    return _apiClient.delete('/$numericId');
  }

  Product _dtoToEntity(ProductDto dto) {
    return Product(
      id: dto.id.toString(),
      title: dto.title,
      price: dto.price.toDouble(),
      category: dto.category,
      description: dto.description,
      imageUrl: dto.imageUrl,
      rating: dto.rating?.toDouble(),
      reviewCount: dto.reviewCount,
      inStock: dto.inStock ?? true,
      createdAt: dto.createdAt != null ? DateTime.tryParse(dto.createdAt!) : null,
      updatedAt: dto.updatedAt != null ? DateTime.tryParse(dto.updatedAt!) : null,
    );
  }
}