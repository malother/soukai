# SoukAI — Design

## What it is
A Flutter mobile app for North African micro-merchants who sell through
Instagram DMs and WhatsApp. Snap a product photo → get a complete,
localized sales listing (Arabic/French copy, hashtags, price suggestion)
→ share it to WhatsApp/Instagram in one tap.

## Architecture
```
Flutter app (Dart, Material 3)
  lib/main.dart            — MaterialApp, routing (onGenerateRoute)
  lib/models/              — Product, Listing (plain data classes)
  lib/state/catalog.dart   — in-memory catalog (ChangeNotifier)
  lib/services/
    listing_generator.dart — ListingProvider interface + ListingGenerator
    mock_listing_provider.dart   — offline template provider (MVP)
    gemini_listing_provider.dart — stub, TODO days 7-9 (no keys in code)
    price_engine.dart      — pure functions (property-test targets)
  lib/screens/             — home, capture, listing, share
  lib/widgets/             — product_card
  test/price_engine_test.dart

Cloudflare Worker (TypeScript, free tier)
  workers/src/index.ts     — GET /health, POST /generate (mock mode now)
  workers/wrangler.toml    — MOCK_MODE=true
```

## Data flow
1. Merchant picks a photo + fills the product form (capture screen).
2. `ListingGenerator` calls the configured `ListingProvider`
   (mock now, Gemini later — screens never see the difference).
3. The price engine computes a suggestion from the comparable range
   and the condition factor (pure functions, no I/O).
4. The listing is saved in the `Catalog`; the merchant edits it on the
   listing screen, then shares it from the share screen (wa.me deep link
   or the system share sheet).

## Key decisions
- **Provider interface, not a hard-coded mock.** Swapping mock → Gemini
  is a one-line change in `capture_screen.dart`; screens depend only on
  `ListingGenerator`. This is the spec-driven seam judges inspect.
- **Price engine as pure functions.** Deterministic, no I/O — the exact
  shape property-based testing needs (R4, R11).
- **Offline-first.** The mock provider means the whole demo works with
  no network; the worker is an optional upgrade, not a dependency.
- **Arabic-first.** Arabic copy is primary, French secondary, both
  editable. Currency is DZD by default.
- **Free tiers only.** Flutter (free), Cloudflare Workers free tier,
  Supabase free tier (later, for storage), Gemini API free tier
  (later, for vision/copy). No paid service is required to run or demo.

## Kiro usage (for the submission write-up)
- Spec-driven development: this spec (requirements/design/tasks) was
  written first in `.kiro/specs/soukai/`; code follows the spec.
- Steering files: `.kiro/steering/product.md` (vision, audience, tone)
  and `tech.md` (stack, free-tier rule).
- Agent hook: `.kiro/hooks/dart-analyze-on-save.json` runs
  `dart analyze` on every Dart file save.
- NOTE: validate the hook JSON against the current Kiro hook schema
  before demo day — the schema is the one moving part of this design.
