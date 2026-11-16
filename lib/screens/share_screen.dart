import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/listing.dart';

/// Share: send the listing to WhatsApp / Instagram / anywhere,
/// or copy the text.
class ShareScreen extends StatelessWidget {
  const ShareScreen({required this.listing, super.key});

  final Listing listing;

  Future<void> _shareAnywhere(BuildContext context) async {
    await Share.share(listing.shareText);
  }

  Future<void> _shareWhatsApp(BuildContext context) async {
    final uri = Uri.parse(
      'https://wa.me/?text=${Uri.encodeComponent(listing.shareText)}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      _showError(context, 'تعذّر فتح واتساب');
    }
  }

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: listing.shareText));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم نسخ نص الإعلان')),
      );
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مشاركة الإعلان')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SelectableText(
                      listing.shareText,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => _shareWhatsApp(context),
              icon: const Icon(Icons.chat),
              label: const Text('مشاركة على واتساب'),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => _shareAnywhere(context),
              icon: const Icon(Icons.share),
              label: const Text('مشاركة (إنستغرام / أخرى)'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _copy(context),
              icon: const Icon(Icons.copy),
              label: const Text('نسخ النص'),
            ),
          ],
        ),
      ),
    );
  }
}
