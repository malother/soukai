import '../models/product.dart';

/// Result of a price suggestion: a single price plus the range it sits in.
class PriceSuggestion {
  const PriceSuggestion({
    required this.suggested,
    required this.min,
    required this.max,
  });

  final double suggested;
  final double min;
  final double max;
}

/// Multiplier applied to the comparable market range for a given condition.
double conditionFactor(ProductCondition condition) => switch (condition) {
      ProductCondition.brandNew => 1.0,
      ProductCondition.likeNew => 0.85,
      ProductCondition.good => 0.7,
      ProductCondition.fair => 0.5,
    };

/// Rounds a price to a shop-friendly number:
/// nearest 50 below 1,000, nearest 100 at 1,000 and above.
double roundToNicePrice(double price) {
  if (price <= 0) return 0;
  final step = price < 1000 ? 50.0 : 100.0;
  return (price / step).round() * step;
}

/// True when [price] sits inside [min]..[max] (inclusive).
bool isPriceWithinRange(double price, double min, double max) =>
    price >= min && price <= max;

/// Suggests a selling price from a comparable market range and the item's
/// condition.
///
/// Pure function: no I/O, fully deterministic. Written so property-based
/// tests can target it (see test/price_engine_test.dart):
/// - suggested is always inside [min, max]
/// - min <= max, all values >= 0
/// - a better condition never suggests a lower price than a worse one
///   for the same comparable range.
PriceSuggestion suggestPrice({
  required ProductCondition condition,
  required double comparableMin,
  required double comparableMax,
}) {
  assert(comparableMin >= 0, 'comparableMin must be >= 0');
  assert(comparableMax >= comparableMin, 'max must be >= min');
  final factor = conditionFactor(condition);
  final min = roundToNicePrice(comparableMin * factor);
  final max = roundToNicePrice(comparableMax * factor);
  final mid = roundToNicePrice(((comparableMin + comparableMax) / 2) * factor);
  return PriceSuggestion(
    suggested: mid.clamp(min, max).toDouble(),
    min: min,
    max: max,
  );
}
