import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:min_market/data/product_data_provider.dart';
import 'package:min_market/models/product.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductDataProvider provider;
  List<Product> _cachedProducts = [];

  List<Product> get cachedProducts => List.unmodifiable(_cachedProducts);

  ProductBloc(this.provider) : super(ProductInitial()) {
    on<ProductCreateEvent>((event, emit) async {
      emit(ProductLoading());

      try {
        await provider.addProduct(event.product);
        _cachedProducts = await provider.getProducts();

        emit(ProductLoaded(_cachedProducts));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<ProductUpdateEvent>((event, emit) async {
      emit(ProductLoading());

      try {
        final product = await provider.updateProduct(event.product);
        final index = _cachedProducts.indexWhere((p) => p.id == product.id);
        if (index != -1) {
          _cachedProducts[index] = product;
        }
        emit(SingleProductLoaded(product));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<DeleteProductEvent>((event, emit) async {
      emit(ProductLoading());

      try {
        await provider.deleteProduct(event.productId);
        _cachedProducts = await provider.getProducts();

        emit(ProductLoaded(_cachedProducts));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<GetProductsEvent>((event, emit) async {
      emit(ProductLoading());

      try {
        _cachedProducts = await provider.getProducts();
        emit(ProductLoaded(_cachedProducts));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<GetProductEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        final product = await provider.getProduct(event.productId);
        emit(SingleProductLoaded(product));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}
