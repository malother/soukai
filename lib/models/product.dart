/// A product a merchant wants to sell.
enum ProductCategory { clothing, electronics, beauty, home, food, other }

extension ProductCategoryLabel on ProductCategory {
  String get labelAr => switch (this) {
        ProductCategory.clothing => 'ملابس',
        ProductCategory.electronics => 'إلكترونيات',
        ProductCategory.beauty => 'تجميل',
        ProductCategory.home => 'منزل',
        ProductCategory.food => 'أغذية',
        ProductCategory.other => 'أخرى',
      };

  String get labelFr => switch (this) {
        ProductCategory.clothing => 'Vêtements',
        ProductCategory.electronics => 'Électronique',
        ProductCategory.beauty => 'Beauté',
        ProductCategory.home => 'Maison',
        ProductCategory.food => 'Alimentation',
        ProductCategory.other => 'Autre',
      };
}

enum ProductCondition { brandNew, likeNew, good, fair }

extension ProductConditionLabel on ProductCondition {
  String get labelAr => switch (this) {
        ProductCondition.brandNew => 'جديد',
        ProductCondition.likeNew => 'كالجديد',
        ProductCondition.good => 'جيد',
        ProductCondition.fair => 'مقبول',
      };

  String get labelFr => switch (this) {
        ProductCondition.brandNew => 'Neuf',
        ProductCondition.likeNew => 'Comme neuf',
        ProductCondition.good => 'Bon état',
        ProductCondition.fair => 'État correct',
      };
}

class Product {
  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.condition,
    this.photoPath,
    this.comparableMin,
    this.comparableMax,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String id;
  final String name;
  final ProductCategory category;
  final ProductCondition condition;

  /// Local path of the product photo (from camera or gallery), if any.
  final String? photoPath;

  /// Comparable market prices the merchant has seen (optional, in DZD).
  final double? comparableMin;
  final double? comparableMax;

  final DateTime createdAt;
}
