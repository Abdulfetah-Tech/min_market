import 'package:go_router/go_router.dart';
import 'package:min_market/models/product.dart';
import 'package:min_market/screens/cart_screen.dart';
import 'package:min_market/screens/home_screen.dart';
import 'package:min_market/screens/product_detail_screen.dart';
import 'package:min_market/screens/product_form_screen.dart';

final GoRouter routes = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomeScreen()),
    GoRoute(path: '/cart', builder: (context, state) => CartScreen()),
    GoRoute(
      path: '/product/new',
      builder: (context, state) => ProductFormScreen(),
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
