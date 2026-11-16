import '../models/listing.dart';
import '../models/product.dart';
import 'listing_generator.dart';
import 'price_engine.dart';

/// Offline mock provider: builds a listing from templates.
/// No network, no API keys — the app is fully demoable without a backend.
class MockListingProvider implements ListingProvider {
  @override
  Future<Listing> generate(Product product) async {
    // Simulate a short generation delay so the UI loading state is visible.
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final suggestion =
        product.comparableMin != null && product.comparableMax != null
            ? suggestPrice(
                condition: product.condition,
                comparableMin: product.comparableMin!,
                comparableMax: product.comparableMax!,
              )
            : const PriceSuggestion(suggested: 0, min: 0, max: 0);

    final conditionAr = product.condition.labelAr;
    final categoryAr = product.category.labelAr;
    final categoryFr = product.category.labelFr;

    return Listing(
      productId: product.id,
      titleAr: '✨ ${product.name} — $conditionAr ✨',
      titleFr: '${product.name} — ${product.condition.labelFr}',
      descriptionAr:
          '$categoryAr $conditionAr للبيع. حالة ممتازة، جاهز للاستلام. '
          'للحجز أو الاستفسار راسلنا على واتساب.',
      descriptionFr:
          '$categoryFr en ${product.condition.labelFr.toLowerCase()} à vendre. '
          'Excellent état, prêt à être récupéré. '
          'Pour commander, contactez-nous sur WhatsApp.',
      hashtags: _hashtagsFor(product),
      suggestedPrice: suggestion.suggested,
    );
  }

  List<String> _hashtagsFor(Product product) {
    const base = <String>['#تسوق_الجزائر', '#بيع_وشراء', '#soukai'];
    final categoryTag = switch (product.category) {
      ProductCategory.clothing => '#ملابس',
      ProductCategory.electronics => '#إلكترونيات',
      ProductCategory.beauty => '#تجميل',
      ProductCategory.home => '#منزل',
      ProductCategory.food => '#أغذية',
      ProductCategory.other => '#عروض',
    };
    return <String>[categoryTag, ...base];
  }
}
