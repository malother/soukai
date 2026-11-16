import '../models/listing.dart';
import '../models/product.dart';
import 'listing_generator.dart';

/// Real AI provider (Gemini vision + text) — NOT wired up yet.
///
/// TODO (PLAN.md days 7-9): implement [generate] by calling the Gemini API
/// (or the Cloudflare Worker in workers/, which will hold the key server-side).
///
/// SECURITY: the API key must come from a build-time `--dart-define`
/// (GEMINI_API_KEY) or from the backend worker. Never hard-code a key in
/// this file and never commit one to the repo.
class GeminiListingProvider implements ListingProvider {
  GeminiListingProvider({required this.apiKey});

  final String apiKey;

  @override
  Future<Listing> generate(Product product) {
    throw UnimplementedError(
      'Gemini provider is a stub. See PLAN.md days 7-9. '
      'Do not ship with a hard-coded API key.',
    );
  }
}
