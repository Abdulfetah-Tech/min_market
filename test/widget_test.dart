import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:min_market/features/products/domain/entities/product.dart';
import 'package:min_market/features/products/domain/usecases/product_usecases.dart';
import 'package:min_market/features/products/presentation/bloc/products_bloc.dart';
import 'package:min_market/features/products/presentation/bloc/products_event.dart';
import 'package:min_market/features/products/presentation/bloc/products_state.dart';
import 'package:min_market/features/cart/domain/entities/cart.dart';
import 'package:min_market/features/cart/domain/usecases/cart_usecases.dart';
import 'package:min_market/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:min_market/features/cart/presentation/bloc/cart_event.dart';
import 'package:min_market/features/cart/presentation/bloc/cart_state.dart';
import 'package:min_market/core/config/environment.dart';

class MockProductsBloc extends MockBloc<ProductsEvent, ProductsState> {}

class MockCartBloc extends MockBloc<CartEvent, CartState> {}

// Mock use cases
class GetProductsUseCaseMock extends Mock implements GetProductsUseCase {}
class GetProductUseCaseMock extends Mock implements GetProductUseCase {}
class CreateProductUseCaseMock extends Mock implements CreateProductUseCase {}
class UpdateProductUseCaseMock extends Mock implements UpdateProductUseCase {}
class DeleteProductUseCaseMock extends Mock implements DeleteProductUseCase {}
class SearchProductsUseCaseMock extends Mock implements SearchProductsUseCase {}
class GetProductsByCategoryUseCaseMock extends Mock implements GetProductsByCategoryUseCase {}

class GetCartUseCaseMock extends Mock implements GetCartUseCase {}
class AddToCartUseCaseMock extends Mock implements AddToCartUseCase {}
class UpdateCartQuantityUseCaseMock extends Mock implements UpdateCartQuantityUseCase {}
class RemoveFromCartUseCaseMock extends Mock implements RemoveFromCartUseCase {}
class ClearCartUseCaseMock extends Mock implements ClearCartUseCase {}

void main() {
  setUpAll(() {
    // Initialize AppConfig for tests
    AppConfig.initialize();
  });

  group('Product entity', () {
    test('serialization and copyWith', () {
      const product = Product(
        id: 'test_1',
        title: 'Test Item',
        price: 29.99,
        category: 'smartphones',
        description: 'A test product',
      );

      expect(product.id, 'test_1');
      expect(product.title, 'Test Item');
      expect(product.price, 29.99);

      final updated = product.copyWith(price: 35.0, title: 'Updated Item');
      expect(updated.id, 'test_1');
      expect(updated.title, 'Updated Item');
      expect(updated.price, 35.0);
      expect(updated.category, 'smartphones');
    });
  });

  group('CartItem entity', () {
    test('total calculation', () {
      const product = Product(
        id: 'test_cart_p',
        title: 'Cart Item',
        price: 15.5,
        category: 'clothing',
        description: 'Desc',
      );

      const cartItem = CartItem(product: product, quantity: 2);
      expect(cartItem.total, 31.0);

      const cartItem2 = CartItem(product: product, quantity: 3);
      expect(cartItem2.total, 46.5);
    });
  });

  group('Cart entity', () {
    test('itemCount and total', () {
      const product = Product(
        id: 'test_cart_p',
        title: 'Cart Item',
        price: 15.5,
        category: 'clothing',
        description: 'Desc',
      );

      final cart = Cart(items: [
        const CartItem(product: product, quantity: 2),
        const CartItem(product: product, quantity: 1),
      ]);

      expect(cart.itemCount, 3);
      expect(cart.total, 46.5);
      expect(cart.isNotEmpty, true);
    });

    test('empty cart', () {
      final cart = Cart(items: []);
      expect(cart.itemCount, 0);
      expect(cart.total, 0.0);
      expect(cart.isEmpty, true);
    });
  });

  group('ProductsBloc', () {
    late ProductsBloc productsBloc;
    late GetProductsUseCaseMock getProductsUseCaseMock;

    const testProducts = [
      Product(
        id: '1',
        title: 'Test Product 1',
        price: 100.0,
        category: 'smartphones',
        description: 'Description 1',
      ),
      Product(
        id: '2',
        title: 'Test Product 2',
        price: 200.0,
        category: 'audio',
        description: 'Description 2',
      ),
    ];

    setUp(() {
      getProductsUseCaseMock = GetProductsUseCaseMock();
      productsBloc = ProductsBloc(
        getProductsUseCase: getProductsUseCaseMock,
        getProductUseCase: GetProductUseCaseMock(),
        createProductUseCase: CreateProductUseCaseMock(),
        updateProductUseCase: UpdateProductUseCaseMock(),
        deleteProductUseCase: DeleteProductUseCaseMock(),
        searchProductsUseCase: SearchProductsUseCaseMock(),
        getProductsByCategoryUseCase: GetProductsByCategoryUseCaseMock(),
      );

      when(() => getProductsUseCaseMock()).thenAnswer(
        (_) async => Right(testProducts),
      );
    });

    tearDown(() {
      productsBloc.close();
    });

    blocTest<ProductsBloc, ProductsState>(
      'emits [ProductsLoading, ProductsLoaded] when LoadProductsEvent is added',
      build: () => productsBloc,
      act: (bloc) => bloc.add(LoadProductsEvent()),
      expect: () => [
        isA<ProductsLoading>(),
        isA<ProductsLoaded>(),
      ],
    );
  });

  group('CartBloc', () {
    late CartBloc cartBloc;
    late GetCartUseCaseMock getCartUseCaseMock;

    final testCart = Cart(items: [
      CartItem(
        product: const Product(
          id: '1',
          title: 'Test Product 1',
          price: 100.0,
          category: 'smartphones',
          description: 'Description 1',
        ),
        quantity: 2,
      ),
    ]);

    setUp(() {
      getCartUseCaseMock = GetCartUseCaseMock();
      cartBloc = CartBloc(
        getCartUseCase: getCartUseCaseMock,
        addToCartUseCase: AddToCartUseCaseMock(),
        updateQuantityUseCase: UpdateCartQuantityUseCaseMock(),
        removeFromCartUseCase: RemoveFromCartUseCaseMock(),
        clearCartUseCase: ClearCartUseCaseMock(),
      );

      when(() => getCartUseCaseMock()).thenAnswer(
        (_) async => Right(testCart),
      );
    });

    tearDown(() {
      cartBloc.close();
    });

    blocTest<CartBloc, CartState>(
      'emits [CartLoading, CartLoaded] when LoadCartEvent is added',
      build: () => cartBloc,
      act: (bloc) => bloc.add(LoadCartEvent()),
      expect: () => [
        isA<CartLoading>(),
        isA<CartLoaded>(),
      ],
    );
  });
}