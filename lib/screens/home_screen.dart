import 'package:flutter/material.dart';

import '../state/catalog.dart';
import '../widgets/product_card.dart';

/// Home: the merchant's product catalog. Empty state in Arabic.
class HomeScreen extends StatelessWidget {
  const HomeScreen({required this.catalog, super.key});

  final Catalog catalog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SoukAI — سوق AI'),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: catalog,
        builder: (context, _) {
          final products = catalog.products;
          if (products.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'لا توجد منتجات بعد.\nصوّر أول منتج وسيحوّله SoukAI إلى إعلان جاهز للبيع.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17),
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                listing: catalog.listingFor(product.id),
                onTap: () => Navigator.pushNamed(
                  context,
                  '/listing',
                  arguments: product,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/capture'),
        icon: const Icon(Icons.camera_alt),
        label: const Text('صوّر منتج'),
      ),
    );
  }
}
