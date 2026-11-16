import 'package:flutter/foundation.dart';

import '../models/listing.dart';
import '../models/product.dart';

/// In-memory catalog: products and their generated listings.
///
/// Kept deliberately simple for the MVP. Offline persistence
/// (shared_preferences) is a Day 12-13 task in PLAN.md.
class Catalog extends ChangeNotifier {
  final List<Product> _products = [];
  final Map<String, Listing> _listings = {};

  List<Product> get products => List.unmodifiable(_products);

  Listing? listingFor(String productId) => _listings[productId];

  void addProduct(Product product) {
    _products.insert(0, product);
    notifyListeners();
  }

  void saveListing(Listing listing) {
    _listings[listing.productId] = listing;
    notifyListeners();
  }
}
