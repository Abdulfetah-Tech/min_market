import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:min_market/data/market_store.dart';
import 'package:min_market/models/product.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartLoaded([])) {
    on<AddToCartEvent>((event, emit) {
      MarketStore.addToCart(event.product, event.quantity);

      emit(CartLoaded(List.from(MarketStore.cart)));
    });

    on<RemoveFromCart>((event, emit) {
      MarketStore.removeFromCart(event.productId);

      emit(CartLoaded(List.from(MarketStore.cart)));
    });

    on<ClearCart>((event, emit) {
      MarketStore.clearCart();

      emit(CartLoaded(List.from(MarketStore.cart)));
    });
  }
}
