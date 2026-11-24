// Products BLoC - business logic for products feature

import 'package:bloc/bloc.dart';

import '../../domain/entities/product.dart';
import '../../domain/usecases/product_usecases.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {

  ProductsBloc({
    required GetProductsUseCase getProductsUseCase,
    required GetProductUseCase getProductUseCase,
    required CreateProductUseCase createProductUseCase,
    required UpdateProductUseCase updateProductUseCase,
    required DeleteProductUseCase deleteProductUseCase,
    required SearchProductsUseCase searchProductsUseCase,
    required GetProductsByCategoryUseCase getProductsByCategoryUseCase,
  })  : _getProductsUseCase = getProductsUseCase,
        _getProductUseCase = getProductUseCase,
        _createProductUseCase = createProductUseCase,
        _updateProductUseCase = updateProductUseCase,
        _deleteProductUseCase = deleteProductUseCase,
        _searchProductsUseCase = searchProductsUseCase,
        _getProductsByCategoryUseCase = getProductsByCategoryUseCase,
        super(ProductsInitial()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<LoadProductEvent>(_onLoadProduct);
    on<CreateProductEvent>(_onCreateProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
    on<SearchProductsEvent>(_onSearchProducts);
    on<LoadProductsByCategoryEvent>(_onLoadProductsByCategory);
    on<RefreshProductsEvent>(_onRefreshProducts);
  }
  final GetProductsUseCase _getProductsUseCase;
  final GetProductUseCase _getProductUseCase;
  final CreateProductUseCase _createProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  final SearchProductsUseCase _searchProductsUseCase;
  final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoading());

    final result = await _getProductsUseCase();

    result.fold(
      (failure) {
        print('ProductsBloc: LoadProducts failed: $failure');
        emit(ProductsError(failure: failure));
      },
      (products) {
        print('ProductsBloc: LoadProducts succeeded with ${products.length} products');
        emit(ProductsLoaded(products: products));
      },
    );
  }

  Future<void> _onLoadProduct(
    LoadProductEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductLoading());

    final result = await _getProductUseCase(event.productId);

    result.fold(
      (failure) => emit(ProductError(failure: failure)),
      (product) => emit(ProductLoaded(product)),
    );
  }

  Future<void> _onCreateProduct(
    CreateProductEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductActionLoading(event.product.id));

    final result = await _createProductUseCase(event.product);

    result.fold(
      (failure) => emit(ProductActionError(failure, event.product.id)),
      (product) => emit(ProductActionSuccess(product, 'Product created successfully')),
    );
  }

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductActionLoading(event.product.id));

    final result = await _updateProductUseCase(event.product);

    result.fold(
      (failure) => emit(ProductActionError(failure, event.product.id)),
      (product) => emit(ProductActionSuccess(product, 'Product updated successfully')),
    );
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductActionLoading(event.productId));

    final result = await _deleteProductUseCase(event.productId);

    result.fold(
      (failure) => emit(ProductActionError(failure, event.productId)),
      (_) => emit(ProductActionSuccess(
        Product(
          id: event.productId,
          title: '',
          price: 0,
          category: '',
          description: '',
        ),
        'Product deleted successfully',
      )),
    );
  }

  Future<void> _onSearchProducts(
    SearchProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    if (state is ProductsLoading) return;

    final currentProducts = state is ProductsLoaded
        ? (state as ProductsLoaded).products
        : <Product>[];

    emit(ProductsLoading(isFirstLoad: currentProducts.isEmpty));

    final result = await _searchProductsUseCase(event.query);

    result.fold(
      (failure) {
        if (currentProducts.isNotEmpty) {
          emit(ProductsLoaded(products: currentProducts));
        } else {
          emit(ProductsError(failure: failure));
        }
      },
      (products) => emit(ProductsLoaded(products: products)),
    );
  }

  Future<void> _onLoadProductsByCategory(
    LoadProductsByCategoryEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoading());

    final result = await _getProductsByCategoryUseCase(event.category);

    result.fold(
      (failure) => emit(ProductsError(failure: failure)),
      (products) => emit(ProductsLoaded(products: products)),
    );
  }

  Future<void> _onRefreshProducts(
    RefreshProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    // Don't show loading if we already have data
    final hasData = state is ProductsLoaded;
    emit(ProductsLoading(isFirstLoad: !hasData));

    final result = await _getProductsUseCase();

    result.fold(
      (failure) {
        if (hasData) {
          // Keep showing cached data
          final cachedProducts = (state as ProductsLoaded?)?.products ?? [];
          emit(ProductsError(failure: failure, cachedProducts: cachedProducts));
        } else {
          emit(ProductsError(failure: failure));
        }
      },
      (products) => emit(ProductsLoaded(products: products)),
    );
  }
}