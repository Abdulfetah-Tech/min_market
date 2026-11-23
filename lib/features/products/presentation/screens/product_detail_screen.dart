// Product detail screen

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:min_market/core/core.dart';
import 'package:min_market/features/products/domain/entities/product.dart';
import 'package:min_market/features/cart/domain/entities/cart.dart';
import 'package:min_market/features/products/presentation/bloc/products_bloc.dart';
import 'package:min_market/features/products/presentation/bloc/products_event.dart';
import 'package:min_market/features/products/presentation/bloc/products_state.dart';
import 'package:min_market/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:min_market/features/cart/presentation/bloc/cart_event.dart';
import 'package:min_market/features/products/presentation/screens/product_form_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    context.read<ProductsBloc>().add(LoadProductEvent(widget.productId));
  }

  Future<void> _editProduct(Product product) async {
    await context.push('/product/${widget.productId}/edit', extra: product);
    if (!mounted) return;
    context.read<ProductsBloc>().add(LoadProductEvent(widget.productId));
  }

  Future<void> _deleteProduct() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete product?'),
        content: const Text('This product will be removed from the market.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;
    if (!mounted) return;

    context.read<ProductsBloc>().add(DeleteProductEvent(widget.productId));

    // Wait for the action to complete
    await Future.delayed(const Duration(milliseconds: 300));
    if (context.mounted) {
      context.pop();
    }
  }

  void _addToCart(Product product) {
    context.read<CartBloc>().add(AddToCartEvent(
      CartItem(product: product, quantity: quantity),
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$quantity x ${product.title} added to cart'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        if (state is ProductLoading && state.isFirstLoad) {
          return const Scaffold(body: ProductDetailShimmer());
        }

        if (state is ProductError) {
          if (state.cachedProduct != null) {
            return _buildDetail(context, state.cachedProduct!);
          }
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: ErrorState(
              message: state.failure.message,
              onRetry: () => context.read<ProductsBloc>().add(LoadProductEvent(widget.productId)),
            ),
          );
        }

        if (state is ProductLoaded) {
          return _buildDetail(context, state.product);
        }

        if (state is ProductActionLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state is ProductActionSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              context.read<ProductsBloc>().add(LoadProductEvent(widget.productId));
            }
          });
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state is ProductActionError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.failure.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              context.read<ProductsBloc>().add(LoadProductEvent(widget.productId));
            }
          });
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget _buildDetail(BuildContext context, Product product) {
    final categoryTheme = Theme.of(context).extension<CategoryTheme>()!;
    final color = categoryTheme.colorFor(product.category);
    final icon = categoryTheme.iconFor(product.category);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          AppIconButton(
            onPressed: () => _editProduct(product),
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit product',
            semanticLabel: 'Edit product',
          ),
          AppIconButton(
            onPressed: _deleteProduct,
            icon: const Icon(Icons.delete_outline),
            variant: AppButtonVariant.destructive,
            tooltip: 'Delete product',
            semanticLabel: 'Delete product',
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product image
                    Hero(
                      tag: 'product-${product.id}',
                      child: Container(
                        height: 220,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: product.imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: product.imageUrl!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  placeholder: (context, url) => Center(
                                    child: Icon(icon, color: color, size: 80),
                                  ),
                                  errorWidget: (context, url, error) => Center(
                                    child: Icon(icon, color: color, size: 80),
                                  ),
                                ),
                              )
                            : Center(
                                child: Icon(icon, color: color, size: 80),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Title
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Price
                    Text(
                      CurrencyFormatter.format(product.price),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Description
                    Text(
                      product.description,
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    // Quantity selector
                    Row(
                      children: [
                        const Text('Qty', style: TextStyle(color: Colors.grey)),
                        const SizedBox(width: 16),
                        _QuantityButton(
                          onPressed: () {
                            if (quantity > 1) {
                              setState(() => quantity--);
                            }
                          },
                          icon: Icons.remove,
                        ),
                        SizedBox(
                          width: 44,
                          child: Text(
                            '$quantity',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _QuantityButton(
                          onPressed: () {
                            setState(() => quantity++);
                          },
                          icon: Icons.add,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Add to cart button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: AppButton(
                  onPressed: () => _addToCart(product),
                  variant: AppButtonVariant.primary,
                  size: AppButtonSize.large,
                  child: const Text(
                    'Add to cart',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.onPressed,
    required this.icon,
  });

  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.shade300),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }
}