import 'package:flutter_test/flutter_test.dart';
import 'package:soukai/models/product.dart';
import 'package:soukai/services/price_engine.dart';

void main() {
  group('conditionFactor', () {
    test('factors are ordered: brandNew > likeNew > good > fair', () {
      expect(conditionFactor(ProductCondition.brandNew),
          greaterThan(conditionFactor(ProductCondition.likeNew)));
      expect(conditionFactor(ProductCondition.likeNew),
          greaterThan(conditionFactor(ProductCondition.good)));
      expect(conditionFactor(ProductCondition.good),
          greaterThan(conditionFactor(ProductCondition.fair)));
    });

    test('all factors are in (0, 1]', () {
      for (final condition in ProductCondition.values) {
        final factor = conditionFactor(condition);
        expect(factor, greaterThan(0));
        expect(factor, lessThanOrEqualTo(1));
      }
    });
  });

  group('roundToNicePrice', () {
    test('zero and negative stay zero', () {
      expect(roundToNicePrice(0), 0);
      expect(roundToNicePrice(-50), 0);
    });

    test('below 1000 rounds to nearest 50', () {
      expect(roundToNicePrice(130), 150);
      expect(roundToNicePrice(120), 100);
    });

    test('at 1000 and above rounds to nearest 100', () {
      expect(roundToNicePrice(1450), 1500);
      expect(roundToNicePrice(1420), 1400);
    });
  });

  group('suggestPrice', () {
    test('suggested is always inside [min, max]', () {
      for (final condition in ProductCondition.values) {
        final result = suggestPrice(
          condition: condition,
          comparableMin: 1000,
          comparableMax: 2000,
        );
        expect(result.min, lessThanOrEqualTo(result.max));
        expect(result.suggested, greaterThanOrEqualTo(result.min));
        expect(result.suggested, lessThanOrEqualTo(result.max));
        expect(result.suggested, greaterThanOrEqualTo(0));
      }
    });

    test('better condition never suggests a lower price', () {
      final brandNew = suggestPrice(
        condition: ProductCondition.brandNew,
        comparableMin: 1000,
        comparableMax: 2000,
      );
      final fair = suggestPrice(
        condition: ProductCondition.fair,
        comparableMin: 1000,
        comparableMax: 2000,
      );
      expect(brandNew.suggested, greaterThanOrEqualTo(fair.suggested));
    });

    test('zero range returns zero prices', () {
      final result = suggestPrice(
        condition: ProductCondition.good,
        comparableMin: 0,
        comparableMax: 0,
      );
      expect(result.suggested, 0);
      expect(result.min, 0);
      expect(result.max, 0);
    });
  });

  group('isPriceWithinRange', () {
    test('boundaries are inclusive', () {
      expect(isPriceWithinRange(100, 100, 200), isTrue);
      expect(isPriceWithinRange(200, 100, 200), isTrue);
      expect(isPriceWithinRange(99, 100, 200), isFalse);
      expect(isPriceWithinRange(201, 100, 200), isFalse);
    });
  });
}
