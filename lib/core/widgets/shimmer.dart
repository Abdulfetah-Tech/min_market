// Shimmer loading widgets for skeleton screens

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Base shimmer widget with configurable shape
class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    required this.width, required this.height, super.key,
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
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder - use Expanded to fill available height
          Expanded(
            child: ShimmerWidget(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          SizedBox(height: 8),
          // Title placeholder
          ShimmerWidget(
            width: double.infinity,
            height: 16,
            borderRadius: 4,
          ),
          SizedBox(height: 4),
          // Price placeholder
          ShimmerWidget(
            width: 80,
            height: 16,
            borderRadius: 4,
          ),
        ],
      ),
    );
}

/// Shimmer for product detail screen
class ProductDetailShimmer extends StatelessWidget {
  const ProductDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) => const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          ShimmerWidget(
            width: double.infinity,
            height: 220,
            borderRadius: 12,
          ),
          SizedBox(height: 20),
          // Title placeholder
          ShimmerWidget(
            width: double.infinity,
            height: 28,
            borderRadius: 4,
          ),
          SizedBox(height: 4),
          // Price placeholder
          ShimmerWidget(
            width: 120,
            height: 24,
            borderRadius: 4,
          ),
          SizedBox(height: 12),
          // Description placeholder
          ShimmerWidget(
            width: double.infinity,
            height: 16,
            borderRadius: 4,
          ),
          SizedBox(height: 8),
          ShimmerWidget(
            width: double.infinity,
            height: 16,
            borderRadius: 4,
          ),
          SizedBox(height: 24),
          // Quantity row placeholder
          Row(
            children: [
              ShimmerWidget(width: 40, height: 16, borderRadius: 4),
              SizedBox(width: 16),
              ShimmerWidget(width: 40, height: 40, borderRadius: 10),
              SizedBox(width: 8),
              ShimmerWidget(width: 44, height: 40, borderRadius: 10),
              SizedBox(width: 8),
              ShimmerWidget(width: 40, height: 40, borderRadius: 10),
            ],
          ),
          SizedBox(height: 24),
          // Add to cart button placeholder
          ShimmerWidget(
            width: double.infinity,
            height: 54,
            borderRadius: 10,
          ),
        ],
      ),
    );
}

/// Shimmer for cart screen
class CartShimmer extends StatelessWidget {
  const CartShimmer({super.key});

  @override
  Widget build(BuildContext context) => Column(
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
        const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerWidget(width: 60, height: 16, borderRadius: 4),
                  ShimmerWidget(width: 100, height: 24, borderRadius: 4),
                ],
              ),
              SizedBox(height: 12),
              ShimmerWidget(
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

/// Shimmer for cart item
class CartItemShimmer extends StatelessWidget {
  const CartItemShimmer({super.key});

  @override
  Widget build(BuildContext context) => const ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8),
      leading: ShimmerWidget(width: 48, height: 48),
      title: ShimmerWidget(width: 150, height: 16, borderRadius: 4),
      subtitle: ShimmerWidget(width: 60, height: 14, borderRadius: 4),
      trailing: ShimmerWidget(width: 24, height: 24, borderRadius: 4),
    );
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
              (context, index) => const ProductCardShimmer(),
              childCount: itemCount,
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
  Widget build(BuildContext context) => ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: ShimmerWidget(
        width: leadingWidth,
        height: leadingHeight,
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