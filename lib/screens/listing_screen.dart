import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/catalog.dart';

/// Listing preview + edit: the merchant reviews and fixes the generated
/// copy before sharing. Every field is editable.
class ListingScreen extends StatefulWidget {
  const ListingScreen({
    required this.catalog,
    required this.product,
    super.key,
  });

  final Catalog catalog;
  final Product product;

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  late final TextEditingController _titleAr;
  late final TextEditingController _descriptionAr;
  late final TextEditingController _titleFr;
  late final TextEditingController _descriptionFr;

  @override
  void initState() {
    super.initState();
    final listing = widget.catalog.listingFor(widget.product.id);
    _titleAr = TextEditingController(text: listing?.titleAr ?? '');
    _descriptionAr = TextEditingController(text: listing?.descriptionAr ?? '');
    _titleFr = TextEditingController(text: listing?.titleFr ?? '');
    _descriptionFr =
        TextEditingController(text: listing?.descriptionFr ?? '');
  }

  @override
  void dispose() {
    _titleAr.dispose();
    _descriptionAr.dispose();
    _titleFr.dispose();
    _descriptionFr.dispose();
    super.dispose();
  }

  void _saveAndShare() {
    final listing = widget.catalog.listingFor(widget.product.id);
    if (listing == null) return;
    listing.titleAr = _titleAr.text;
    listing.descriptionAr = _descriptionAr.text;
    listing.titleFr = _titleFr.text;
    listing.descriptionFr = _descriptionFr.text;
    widget.catalog.saveListing(listing);
    Navigator.pushNamed(context, '/share', arguments: listing);
  }

  Widget _field(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listing = widget.catalog.listingFor(widget.product.id);
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (listing != null && listing.suggestedPrice > 0)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '💰 السعر المقترح: ${listing.suggestedPrice.toStringAsFixed(0)} ${listing.currency}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            const Text(
              'العربية',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _field(_titleAr, 'العنوان'),
            _field(_descriptionAr, 'الوصف', maxLines: 4),
            const SizedBox(height: 8),
            const Text(
              'Français',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _field(_titleFr, 'Titre'),
            _field(_descriptionFr, 'Description', maxLines: 4),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _saveAndShare,
              icon: const Icon(Icons.share),
              label: const Text('حفظ ومشاركة'),
            ),
          ],
        ),
      ),
    );
  }
}
