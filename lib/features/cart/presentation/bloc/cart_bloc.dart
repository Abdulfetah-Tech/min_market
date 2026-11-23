// Cart BLoC

import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/usecases/cart_usecases.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase _getCartUseCase;
  final AddToCartUseCase _addToCartUseCase;
  final UpdateCartQuantityUseCase _updateQuantityUseCase;
  final RemoveFromCartUseCase _removeFromCartUseCase;
  final ClearCartUseCase _clearCartUseCase;

  CartBloc({
    required GetCartUseCase getCartUseCase,
    required AddToCartUseCase addToCartUseCase,
    required UpdateCartQuantityUseCase updateQuantityUseCase,
    required RemoveFromCartUseCase removeFromCartUseCase,
    required ClearCartUseCase clearCartUseCase,
  })  : _getCartUseCase = getCartUseCase,
        _addToCartUseCase = addToCartUseCase,
        _updateQuantityUseCase = updateQuantityUseCase,
        _removeFromCartUseCase = removeFromCartUseCase,
        _clearCartUseCase = clearCartUseCase,
        super(CartInitial()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<ClearCartEvent>(_onClearCart);
  }

  Future<void> _onLoadCart(
    LoadCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());

    final result = await _getCartUseCase();

    result.fold(
      (failure) => emit(CartError(failure: failure)),
      (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final currentCart = state is CartLoaded ? (state as CartLoaded).cart : null;
    emit(CartActionLoading(event.item.product.id));

    final result = await _addToCartUseCase(event.item);

    result.fold(
      (failure) {
        if (currentCart != null) {
          emit(CartLoaded(currentCart));
        } else {
          emit(CartError(failure: failure));
        }
      },
      (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    final currentCart = state is CartLoaded ? (state as CartLoaded).cart : null;
    emit(CartActionLoading(event.productId));

    final result = await _updateQuantityUseCase(event.productId, event.quantity);

    result.fold(
      (failure) {
        if (currentCart != null) {
          emit(CartLoaded(currentCart));
        } else {
          emit(CartError(failure: failure));
        }
      },
      (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final currentCart = state is CartLoaded ? (state as CartLoaded).cart : null;
    emit(CartActionLoading(event.productId));

    final result = await _removeFromCartUseCase(event.productId);

    result.fold(
      (failure) {
        if (currentCart != null) {
          emit(CartLoaded(currentCart));
        } else {
          emit(CartError(failure: failure));
        }
      },
      (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());

    final result = await _clearCartUseCase();

    result.fold(
      (failure) => emit(CartError(failure: failure)),
      (cart) => emit(CartLoaded(cart)),
    );
  }
}