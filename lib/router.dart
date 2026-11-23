// Router configuration using go_router

import 'package:go_router/go_router.dart';

import 'features/products/domain/entities/product.dart';
import 'features/products/presentation/screens/home_screen.dart';
import 'features/products/presentation/screens/product_detail_screen.dart';
import 'features/products/presentation/screens/product_form_screen.dart';
import 'features/cart/presentation/screens/cart_screen.dart';

final GoRouter routes = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
    GoRoute(
      path: '/product/new',
      builder: (context, state) => const ProductFormScreen(),
    ),
    GoRoute(
      path: '/product/:id/edit',
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductFormScreen(product: product);
      },
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final String id = state.pathParameters['id']!;
        return ProductDetailScreen(productId: id);
      },
    ),
  ],
);