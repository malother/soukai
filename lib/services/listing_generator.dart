import '../models/listing.dart';
import '../models/product.dart';

/// Contract for anything that can turn a [Product] into a sales [Listing].
///
/// The app ships with [MockListingProvider]; the real Gemini provider
/// ([GeminiListingProvider]) is a separate file wired in later (PLAN.md
/// days 7-9). Screens only ever talk to [ListingGenerator], never to a
/// concrete provider, so swapping providers is a one-line change.
abstract class ListingProvider {
  Future<Listing> generate(Product product);
}

/// Orchestrates listing generation: delegates to the configured provider.
class ListingGenerator {
  ListingGenerator(this._provider);

  final ListingProvider _provider;

  Future<Listing> generateListing(Product product) =>
      _provider.generate(product);
}
