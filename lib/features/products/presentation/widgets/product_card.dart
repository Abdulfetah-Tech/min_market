// Product card widget

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:min_market/core/core.dart';
import 'package:min_market/features/products/domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final categoryTheme = Theme.of(context).extension<CategoryTheme>()!;
    final color = categoryTheme.colorFor(product.category);
    final icon = categoryTheme.iconFor(product.category);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: product.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: product.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: Icon(icon, color: color, size: 34),
                          ),
                          errorWidget: (context, url, error) => Center(
                            child: Icon(icon, color: color, size: 34),
                          ),
                        ),
                      )
                    : Center(
                        child: Icon(icon, color: color, size: 34),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15),
            ),
            Text(
              CurrencyFormatter.formatPrice(product.price),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}