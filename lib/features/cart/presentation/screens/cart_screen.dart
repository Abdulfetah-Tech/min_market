// Cart screen

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:min_market/core/core.dart';
import 'package:min_market/features/cart/domain/entities/cart.dart';
import 'package:min_market/features/products/domain/entities/product.dart';
import 'package:min_market/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:min_market/features/cart/presentation/bloc/cart_event.dart';
import 'package:min_market/features/cart/presentation/bloc/cart_state.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      context.read<CartBloc>().add(RemoveFromCartEvent(productId));
    } else {
      context.read<CartBloc>().add(UpdateQuantityEvent(productId, quantity));
    }
  }

  void _removeItem(String productId) {
    context.read<CartBloc>().add(RemoveFromCartEvent(productId));
  }

  Future<void> _checkout() async {
    final state = context.read<CartBloc>().state;
    if (state is! CartLoaded) return;

    final total = CurrencyFormatter.format(state.total);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Order'),
        content: Text('Place order for $total?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          AppButton(
            onPressed: () => Navigator.pop(context, true),
            variant: AppButtonVariant.primary,
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    // Show success and clear cart
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thank you!'),
        content: Text('Your order of $total was placed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    context.read<CartBloc>().add(const ClearCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your cart',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const CartShimmer();
          }

          if (state is CartError) {
            final cachedCart = state.cachedCart;
            if (cachedCart != null) {
              return _buildCartContent(context, cachedCart);
            }
            return ErrorState(
              message: state.failure.message,
              onRetry: () => context.read<CartBloc>().add(const LoadCartEvent()),
            );
          }

          if (state is CartLoaded) {
            return _buildCartContent(context, state.cart);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, Cart cart) {
    return cart.isEmpty
        ? EmptyState(
            title: 'Your cart is empty',
            message: 'Add some products to get started.',
            actionLabel: 'Continue Shopping',
            onAction: () => context.go('/'),
            icon: Icons.shopping_cart_outlined,
          )
        : Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: cart.items.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    final categoryTheme = Theme.of(context).extension<CategoryTheme>()!;
                    final color = categoryTheme.colorFor(item.product.category);
                    final icon = categoryTheme.iconFor(item.product.category);

                    return CartItemTile(
                      item: item,
                      color: color,
                      icon: icon,
                      onQuantityChanged: (quantity) =>
                          _updateQuantity(item.product.id, quantity),
                      onRemove: () => _removeItem(item.product.id),
                    );
                  },
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(cart.total),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: AppButton(
                        onPressed: _checkout,
                        variant: AppButtonVariant.outline,
                        child: const Text(
                          'Checkout',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    required this.color,
    required this.icon,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  final CartItem item;
  final Color color;
  final IconData icon;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        item.product.title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: [
          Text('Qty '),
          _QuantitySelector(
            quantity: item.quantity,
            onChanged: onQuantityChanged,
          ),
          const SizedBox(width: 8),
          Text(
            CurrencyFormatter.format(item.total),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
      trailing: IconButton(
        onPressed: onRemove,
        icon: const Icon(Icons.delete_outline, color: Colors.grey),
        tooltip: 'Remove from cart',
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({
    required this.quantity,
    required this.onChanged,
  });

  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _QuantityButton(
          onPressed: () => onChanged(quantity - 1),
          icon: Icons.remove,
          enabled: quantity > 1,
        ),
        SizedBox(
          width: 40,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        _QuantityButton(
          onPressed: () => onChanged(quantity + 1),
          icon: Icons.add,
        ),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.onPressed,
    required this.icon,
    this.enabled = true,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onPressed : null,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: enabled ? Colors.grey.shade300 : Colors.grey.shade200,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? null : Colors.grey.shade400,
        ),
      ),
    );
  }
}