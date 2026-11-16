import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/product.dart';
import '../services/listing_generator.dart';
import '../services/mock_listing_provider.dart';
import '../state/catalog.dart';

/// Capture: pick a photo (camera or gallery), describe the product,
/// generate the listing.
class CaptureScreen extends StatefulWidget {
  const CaptureScreen({required this.catalog, super.key});

  final Catalog catalog;

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  final _picker = ImagePicker();
  final _nameController = TextEditingController();
  final _minController = TextEditingController();
  final _maxController = TextEditingController();

  String? _photoPath;
  ProductCategory _category = ProductCategory.clothing;
  ProductCondition _condition = ProductCondition.likeNew;
  bool _generating = false;

  @override
  void dispose() {
    _nameController.dispose();
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1280,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => _photoPath = picked.path);
    }
  }

  Future<void> _generate() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اكتب اسم المنتج أولاً')),
      );
      return;
    }
    setState(() => _generating = true);
    final product = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      category: _category,
      condition: _condition,
      photoPath: _photoPath,
      comparableMin: double.tryParse(_minController.text.trim()),
      comparableMax: double.tryParse(_maxController.text.trim()),
    );
    // TODO (PLAN.md days 7-9): swap in GeminiListingProvider via the worker.
    final generator = ListingGenerator(MockListingProvider());
    final listing = await generator.generateListing(product);
    widget.catalog.addProduct(product);
    widget.catalog.saveListing(listing);
    if (!mounted) return;
    setState(() => _generating = false);
    Navigator.pushNamed(context, '/listing', arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('منتج جديد')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_photoPath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(_photoPath!),
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('الكاميرا'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('المعرض'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'اسم المنتج',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<ProductCategory>(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: 'الفئة',
                border: OutlineInputBorder(),
              ),
              items: ProductCategory.values
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text('${c.labelAr} — ${c.labelFr}'),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _category = value);
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<ProductCondition>(
              initialValue: _condition,
              decoration: const InputDecoration(
                labelText: 'الحالة',
                border: OutlineInputBorder(),
              ),
              items: ProductCondition.values
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text('${c.labelAr} — ${c.labelFr}'),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _condition = value);
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'أدنى سعر مشابه (دج)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _maxController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'أعلى سعر مشابه (دج)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _generating ? null : _generate,
              icon: _generating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(_generating ? 'جارٍ توليد الإعلان...' : 'ولّد الإعلان'),
            ),
          ],
        ),
      ),
    );
  }
}
