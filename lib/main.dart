import 'package:flutter/material.dart';

import 'models/listing.dart';
import 'models/product.dart';
import 'screens/capture_screen.dart';
import 'screens/home_screen.dart';
import 'screens/listing_screen.dart';
import 'screens/share_screen.dart';
import 'state/catalog.dart';

void main() => runApp(const SoukAiApp());

/// Root widget. The [Catalog] is created once here and passed down to screens.
class SoukAiApp extends StatelessWidget {
  const SoukAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final catalog = Catalog();
    return MaterialApp(
      title: 'SoukAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F766E),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => HomeScreen(catalog: catalog),
            );
          case '/capture':
            return MaterialPageRoute(
              builder: (_) => CaptureScreen(catalog: catalog),
            );
          case '/listing':
            final product = settings.arguments as Product;
            return MaterialPageRoute(
              builder: (_) => ListingScreen(catalog: catalog, product: product),
            );
          case '/share':
            final listing = settings.arguments as Listing;
            return MaterialPageRoute(
              builder: (_) => ShareScreen(listing: listing),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => HomeScreen(catalog: catalog),
            );
        }
      },
    );
  }
}
