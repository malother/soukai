import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:soukai/models/listing.dart';
import 'package:soukai/models/product.dart';
import 'package:soukai/screens/capture_screen.dart';
import 'package:soukai/screens/home_screen.dart';
import 'package:soukai/screens/listing_screen.dart';
import 'package:soukai/screens/share_screen.dart';
import 'package:soukai/state/catalog.dart';

/// 1x1 transparent PNG, so Image.file has a real file to decode.
const _onePixelPngBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8Xw8AAwMCAO+ip1sAAAAASUVORK5CYII=';

/// Fake picker: always "picks" the temp photo, whatever the source.
class FakeImagePickerPlatform extends ImagePickerPlatform {
  FakeImagePickerPlatform(this.file);

  final XFile file;

  @override
  Future<XFile?> getImageFromSource({
    required ImageSource source,
    ImagePickerOptions options = const ImagePickerOptions(),
  }) async =>
      file;
}

void main() {
  late Directory tempDir;
  late XFile photo;
  late ImagePickerPlatform originalPlatform;
  late Catalog catalog;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('soukai_test_');
    final file = File('${tempDir.path}/photo.png')
      ..writeAsBytesSync(base64Decode(_onePixelPngBase64));
    photo = XFile(file.path);
    originalPlatform = ImagePickerPlatform.instance;
    ImagePickerPlatform.instance = FakeImagePickerPlatform(photo);
    catalog = Catalog();
  });

  tearDown(() async {
    ImagePickerPlatform.instance = originalPlatform;
    await tempDir.delete(recursive: true);
  });

  /// Same route table as lib/main.dart, sharing one [Catalog].
  Widget testApp() => MaterialApp(
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
                builder: (_) =>
                    ListingScreen(catalog: catalog, product: product),
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

  testWidgets('capture -> mock listing -> edit -> share (camera flow)',
      (tester) async {
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    // Home is empty; start a new product.
    expect(find.textContaining('لا توجد منتجات بعد'), findsOneWidget);
    await tester.tap(find.text('صوّر منتج'));
    await tester.pumpAndSettle();

    // Camera pick shows the photo in the form.
    await tester.tap(find.text('الكاميرا'));
    await tester.pumpAndSettle();
    expect(find.byType(Image), findsOneWidget);

    // Fill the form: name + comparable range 3000-5000 DZD.
    final fields = find.byType(TextField);
    await tester.enterText(fields.first, 'حذاء رياضي');
    await tester.enterText(fields.at(1), '3000');
    await tester.enterText(fields.at(2), '5000');

    // Generate (mock provider, 600ms delay) -> listing screen. The photo
    // preview pushes the button below the fold in the test viewport.
    await tester.ensureVisible(find.text('ولّد الإعلان'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ولّد الإعلان'));
    await tester.pumpAndSettle();
    expect(find.text('حفظ ومشاركة'), findsOneWidget);
    // Generated Arabic title in the editable field (full title is
    // '✨ حذاء رياضي — كالجديد ✨'); suggested price for range 3000-5000
    // at like-new (x0.85): mid 4000 x 0.85 = 3400 DZD.
    expect(find.textContaining('حذاء رياضي'), findsWidgets);
    expect(find.textContaining('السعر المقترح: 3400 DZD'), findsOneWidget);
    // The product landed in the catalog with its listing.
    expect(catalog.products, hasLength(1));
    expect(catalog.listingFor(catalog.products.first.id), isNotNull);

    // Save & share -> share screen (button is below the fold).
    await tester.ensureVisible(find.text('حفظ ومشاركة'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('حفظ ومشاركة'));
    await tester.pumpAndSettle();
    expect(find.text('مشاركة على واتساب'), findsOneWidget);
  });

  testWidgets('generate with an empty name stays on the capture screen',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: CaptureScreen(catalog: catalog)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('ولّد الإعلان'));
    await tester.pump();
    expect(find.text('اكتب اسم المنتج أولاً'), findsOneWidget);
    // Still on the capture screen: no listing, nothing saved.
    expect(find.text('حفظ ومشاركة'), findsNothing);
    expect(catalog.products, isEmpty);
  });

  testWidgets('inverted price range is rejected', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: CaptureScreen(catalog: catalog)),
    );
    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    await tester.enterText(fields.first, 'حذاء رياضي');
    await tester.enterText(fields.at(1), '5000');
    await tester.enterText(fields.at(2), '3000');
    await tester.tap(find.text('ولّد الإعلان'));
    await tester.pump();
    expect(
      find.text('أدنى سعر يجب أن يكون أقل من أعلى سعر'),
      findsOneWidget,
    );
    expect(catalog.products, isEmpty);
  });
}
