/// A ready-to-sell listing generated for a [Product].
///
/// Arabic-first: the Arabic copy is the primary text, French is secondary.
/// The merchant can edit every field before sharing.
class Listing {
  Listing({
    required this.productId,
    required this.titleAr,
    required this.titleFr,
    required this.descriptionAr,
    required this.descriptionFr,
    required this.hashtags,
    required this.suggestedPrice,
    this.currency = 'DZD',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String productId;
  String titleAr;
  String titleFr;
  String descriptionAr;
  String descriptionFr;
  List<String> hashtags;
  double suggestedPrice;
  final String currency;
  final DateTime createdAt;

  String get _priceText =>
      suggestedPrice > 0 ? '${suggestedPrice.toStringAsFixed(0)} $currency' : '';

  /// Share text for WhatsApp / Instagram (Arabic first, then French).
  String get shareText {
    final buffer = StringBuffer()
      ..writeln('✨ $titleAr ✨')
      ..writeln(descriptionAr);
    if (_priceText.isNotEmpty) {
      buffer.writeln('💰 السعر: $_priceText');
    }
    buffer
      ..writeln()
      ..writeln(titleFr)
      ..writeln(descriptionFr);
    if (_priceText.isNotEmpty) {
      buffer.writeln('💰 Prix : $_priceText');
    }
    if (hashtags.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln(hashtags.join(' '));
    }
    return buffer.toString().trim();
  }
}
