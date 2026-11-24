// Home screen - product listing with new architecture

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/core.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../domain/entities/product.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';
import '../bloc/products_state.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductsBloc>().add(const LoadProductsEvent());
  }

  Future<void> _openProductDetail(Product product) async {
    await context.push('/product/${product.id}');
    if (!mounted) return;
    context.read<ProductsBloc>().add(const RefreshProductsEvent());
  }

  Future<void> _openAddProduct() async {
    await context.push('/product/new');
    if (!mounted) return;
    context.read<ProductsBloc>().add(const RefreshProductsEvent());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          AppConfig.appName,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              final count = state is CartLoaded ? state.itemCount : 0;
              return AppIconButton(
                onPressed: () => context.push('/cart'),
                icon: Badge(
                  isLabelVisible: count > 0,
                  label: Text('$count'),
                  child: const Icon(Icons.shopping_cart),
                ),
                tooltip: 'Cart',
                semanticLabel: 'Shopping cart with $count items',
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading && state.isFirstLoad) {
            return const HomeGridShimmer();
          }

          if (state is ProductsError) {
            final cachedProducts = state.cachedProducts ?? [];
            if (cachedProducts.isNotEmpty) {
              return _buildProductGrid(context, cachedProducts, _openProductDetail);
            }
            return ErrorState(
              message: state.failure.message,
              onRetry: () => context.read<ProductsBloc>().add(const LoadProductsEvent()),
            );
          }

          if (state is ProductsLoaded) {
            if (state.products.isEmpty) {
              return EmptyState(
                title: 'No products yet',
                message: 'Tap + to add your first product.',
                actionLabel: 'Add Product',
                onAction: _openAddProduct,
                icon: Icons.add_shopping_cart_outlined,
              );
            }
            return _buildProductGrid(context, state.products, _openProductDetail);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddProduct,
        child: const Icon(Icons.add),
      ),
    );

  Widget _buildProductGrid(
    BuildContext context,
    List<Product> products,
    Function(Product) onTap,
  ) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final crossAxisCount = Breakpoints.crossAxisCount(screenWidth);

    // Calculate item height based on aspect ratio
    final itemWidth = (screenWidth - 16 * 2 - 10 * (crossAxisCount - 1)) / crossAxisCount;
    final itemHeight = itemWidth / 0.85;

    // Use CustomScrollView with SliverGrid to avoid infinite height constraints on Flutter web
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onTap: () => onTap(product),
                );
              },
              childCount: products.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: itemHeight,
            ),
          ),
        ),
      ],
    );
  }
}