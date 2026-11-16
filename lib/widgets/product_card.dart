import 'dart:io';

import 'package:flutter/material.dart';

import '../models/listing.dart';
import '../models/product.dart';

/// A catalog row: photo (if any), name, category, suggested price.
class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.product,
    required this.listing,
    required this.onTap,
    super.key,
  });

  final Product product;
  final Listing? listing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Local copy so the analyzer can promote the nullable field.
    final listing = this.listing;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            SizedBox(
              width: 84,
              height: 84,
              child: product.photoPath != null
                  ? Image.file(
                      File(product.photoPath!),
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.image, size: 40),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${product.category.labelAr} • ${product.condition.labelAr}',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    if (listing != null && listing.suggestedPrice > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${listing.suggestedPrice.toStringAsFixed(0)} ${listing.currency}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F766E),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const Icon(Icons.chevron_right),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
