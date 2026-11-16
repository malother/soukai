# SoukAI — Snap a photo, get a ready-to-sell listing

SoukAI is a Flutter mobile app for North African micro-merchants who
sell through Instagram DMs and WhatsApp. Snap a product photo and get a
complete, localized sales listing — Arabic/French copy, hashtags, and a
price suggestion — ready to share in one tap.

**Kiroween 2026 hackathon entry** (Devpost, deadline 4 Dec 2026).
Built with Kiro: spec-driven development, steering files, and agent
hooks — see `.kiro/` for the specs, and the Kiro write-up in the
Devpost submission.

## Features (MVP)
- Photo capture (camera or gallery) + product form (name, category,
  condition, comparable prices)
- Listing generation: Arabic title/description, French title/description,
  hashtags, suggested price (mock provider offline; Gemini later)
- Price engine as pure functions (property-testable)
- Listing preview + edit before sharing
- Share to WhatsApp (wa.me deep link), system share sheet, copy text
- Local product catalog, newest first

## Run it
```bash
flutter pub get
flutter run
```

Run the tests:
```bash
flutter test
```

## Project structure
```
lib/
  main.dart            — MaterialApp, routing
  models/              — Product, Listing
  state/catalog.dart   — in-memory catalog (ChangeNotifier)
  services/
    listing_generator.dart      — ListingProvider interface
    mock_listing_provider.dart  — offline template provider
    gemini_listing_provider.dart — stub (TODO, no keys in code)
    price_engine.dart           — pure price functions
  screens/             — home, capture, listing, share
  widgets/             — product_card
test/
  price_engine_test.dart
workers/               — Cloudflare Worker stub (POST /generate, GET /health)
.kiro/                 — Kiro specs, steering, hooks (MANDATORY, committed)
```

## Free-tier services used
- Flutter — free
- Cloudflare Workers — free tier (backend stub, mock mode)
- Gemini API — free tier (planned, days 7-9; key in Worker secret)
- Supabase — free tier (planned, only if the demo needs storage)

No paid service is required to build, run, or demo this app.

## License
MIT — see [LICENSE](LICENSE).
