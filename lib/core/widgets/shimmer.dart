// Shimmer loading widgets for skeleton screens

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Base shimmer widget with configurable shape
class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
    this.baseColor,
    this.highlightColor,
    this.direction = ShimmerDirection.ltr,
  });

  final double width;
  final double height;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;
  final ShimmerDirection direction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: baseColor ?? (isDark ? Colors.grey[800]! : Colors.grey[300]!),
      highlightColor: highlightColor ?? (isDark ? Colors.grey[700]! : Colors.grey[100]!),
      direction: direction,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[300],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Shimmer for product card in grid
class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          const ShimmerWidget(
            width: double.infinity,
            height: double.infinity,
            borderRadius: 8,
          ),
          const SizedBox(height: 8),
          // Title placeholder
          const ShimmerWidget(
            width: double.infinity,
            height: 16,
            borderRadius: 4,
          ),
          const SizedBox(height: 4),
          // Price placeholder
          const ShimmerWidget(
            width: 80,
            height: 16,
            borderRadius: 4,
          ),
        ],
      ),
    );
  }
}

/// Shimmer for product detail screen
class ProductDetailShimmer extends StatelessWidget {
  const ProductDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          const ShimmerWidget(
            width: double.infinity,
            height: 220,
            borderRadius: 12,
          ),
          const SizedBox(height: 20),
          // Title placeholder
          const ShimmerWidget(
            width: double.infinity,
            height: 28,
            borderRadius: 4,
          ),
          const SizedBox(height: 4),
          // Price placeholder
          const ShimmerWidget(
            width: 120,
            height: 24,
            borderRadius: 4,
          ),
          const SizedBox(height: 12),
          // Description placeholder
          const ShimmerWidget(
            width: double.infinity,
            height: 16,
            borderRadius: 4,
          ),
          const SizedBox(height: 8),
          const ShimmerWidget(
            width: double.infinity,
            height: 16,
            borderRadius: 4,
          ),
          const SizedBox(height: 24),
          // Quantity row placeholder
          Row(
            children: [
              const ShimmerWidget(width: 40, height: 16, borderRadius: 4),
              const SizedBox(width: 16),
              const ShimmerWidget(width: 40, height: 40, borderRadius: 10),
              const SizedBox(width: 8),
              const ShimmerWidget(width: 44, height: 40, borderRadius: 10),
              const SizedBox(width: 8),
              const ShimmerWidget(width: 40, height: 40, borderRadius: 10),
            ],
          ),
          const SizedBox(height: 24),
          // Add to cart button placeholder
          const ShimmerWidget(
            width: double.infinity,
            height: 54,
            borderRadius: 10,
          ),
        ],
      ),
    );
  }
}

/// Shimmer for cart screen
class CartShimmer extends StatelessWidget {
  const CartShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) => const CartItemShimmer(),
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
                  const ShimmerWidget(width: 60, height: 16, borderRadius: 4),
                  const ShimmerWidget(width: 100, height: 24, borderRadius: 4),
                ],
              ),
              const SizedBox(height: 12),
              const ShimmerWidget(
                width: double.infinity,
                height: 50,
                borderRadius: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Shimmer for cart item
class CartItemShimmer extends StatelessWidget {
  const CartItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: const ShimmerWidget(width: 48, height: 48, borderRadius: 8),
      title: const ShimmerWidget(width: 150, height: 16, borderRadius: 4),
      subtitle: const ShimmerWidget(width: 60, height: 14, borderRadius: 4),
      trailing: const ShimmerWidget(width: 24, height: 24, borderRadius: 4),
    );
  }
}

/// Shimmer for home screen grid
class HomeGridShimmer extends StatelessWidget {
  const HomeGridShimmer({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final crossAxisCount = screenWidth > 900
        ? 4
        : (screenWidth > 600 ? 3 : 2);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: itemCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) => const ProductCardShimmer(),
      ),
    );
  }
}

/// Shimmer for list items
class ListItemShimmer extends StatelessWidget {
  const ListItemShimmer({
    super.key,
    this.leadingWidth = 48,
    this.leadingHeight = 48,
    this.titleWidth = 150,
    this.subtitleWidth = 100,
    this.trailingWidth = 24,
    this.trailingHeight = 24,
  });

  final double leadingWidth;
  final double leadingHeight;
  final double titleWidth;
  final double subtitleWidth;
  final double trailingWidth;
  final double trailingHeight;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: ShimmerWidget(
        width: leadingWidth,
        height: leadingHeight,
        borderRadius: 8,
      ),
      title: ShimmerWidget(
        width: titleWidth,
        height: 16,
        borderRadius: 4,
      ),
      subtitle: ShimmerWidget(
        width: subtitleWidth,
        height: 14,
        borderRadius: 4,
      ),
      trailing: ShimmerWidget(
        width: trailingWidth,
        height: trailingHeight,
        borderRadius: 4,
      ),
    );
  }
}