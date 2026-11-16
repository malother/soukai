# SoukAI — Tech steering

## Stack
- **Mobile:** Flutter (Dart), Material 3. Single codebase, Android-first
  (the audience is on Android). Packages: image_picker, share_plus,
  url_launcher. No other dependencies without a reason written down.
- **Backend:** Cloudflare Workers (TypeScript), free tier. One worker:
  `POST /generate`, `GET /health`. The worker is an optional upgrade —
  the app must demo fully offline via the mock provider.
- **AI (later):** Gemini API free tier for vision + copy generation.
  The key lives in a Worker secret or a `--dart-define`, never in code,
  never in git.
- **Storage (later):** Supabase free tier, only if the demo needs it.

## Rules
- **Free tiers only.** No paid service may be required to build, run,
  or demo this app.
- **Pure functions for pricing.** `price_engine.dart` has no I/O and no
  randomness — it must stay property-testable.
- **Provider interface.** Screens talk to `ListingGenerator`, never to
  a concrete provider. Mock → Gemini is a one-line swap.
- **No secrets in the repo.** No API keys, no tokens, no credentials
  in any file. The `.gitignore` must never exclude `.kiro/`.
- **Spec first.** New behavior starts in `.kiro/specs/soukai/` before
  code is written; the spec is the source of truth judges inspect.
