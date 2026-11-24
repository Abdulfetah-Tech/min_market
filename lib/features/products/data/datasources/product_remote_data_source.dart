// Remote data source for products - API communication

import 'package:fpdart/fpdart.dart';

import '../../../../core/core.dart';
import '../../domain/entities/product.dart';
import '../dtos/product_dto.dart';

abstract class ProductRemoteDataSource {
  Future<Result<List<Product>>> getProducts();
  Future<Result<Product>> getProduct(String id);
  Future<Result<Product>> createProduct(Product product);
  Future<Result<Product>> updateProduct(Product product);
  Future<Result<void>> deleteProduct(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {

  ProductRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Future<Result<List<Product>>> getProducts() async {
    final result = await _apiClient.get<ProductsResponseDto>(
      '',
      parser: (data) {
        try {
          return ProductsResponseDto.fromJson(data as Map<String, dynamic>);
        } catch (e) {
          if (data is Map && data['products'] is List) {
            for (int i = 0; i < (data['products'] as List).length; i++) {
              try {
                ProductDto.fromJson((data['products'] as List)[i] as Map<String, dynamic>);
              } catch (productError) {
                // Log individual product parsing errors for debugging
              }
            }
          }
          rethrow;
        }
      },
    );
    return result.map(
      (response) => response.products.map(_dtoToEntity).toList(),
    );
  }

  @override
  Future<Result<Product>> getProduct(String id) async => _apiClient.get<ProductDto>(
      '/$id',
      parser: (data) => ProductDto.fromJson(data as Map<String, dynamic>),
    ).then((result) => result.map(_dtoToEntity));

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
      return const Left(ValidationFailure(
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
      return const Left(ValidationFailure(
        message: 'Invalid product ID',
        fieldErrors: {'id': 'Product ID must be numeric for API'},
      ));
    }

    return _apiClient.delete('/$numericId');
  }

  Product _dtoToEntity(ProductDto dto) => Product(
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