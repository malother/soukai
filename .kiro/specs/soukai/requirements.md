# SoukAI — Requirements (Kiro spec-driven development)

> Kiroween 2026 entry. Spec written 16 Nov 2026. All materials in English
> (hackathon rule). Arabic-first product: the app UI and generated copy are
> Arabic-first, French second.

## R1 — Photo capture
The app MUST let the merchant capture a product photo with the camera or
pick one from the gallery (image_picker). The photo is stored locally with
the product.

## R2 — Product form
The merchant MUST enter: product name (required), category (clothing,
electronics, beauty, home, food, other), condition (brand new, like new,
good, fair), and optional comparable min/max prices in DZD.

## R3 — Listing generation (mock first)
The app MUST generate a complete sales listing from a product: Arabic
title, Arabic description, French title, French description, hashtags,
and a suggested price. The MVP ships with an offline mock provider; the
real Gemini provider replaces it without changing any screen code.

## R4 — Price suggestion
The price engine MUST be pure functions (no I/O): given a comparable
market range and a condition, it returns a suggested price plus a
min/max range. Suggested price MUST always sit inside [min, max]; a
better condition MUST never suggest a lower price than a worse one for
the same range.

## R5 — Listing preview and edit
The merchant MUST be able to review and edit every generated field
(Arabic + French) before sharing.

## R6 — Share to WhatsApp
The app MUST share the listing text to WhatsApp via a wa.me deep link
and to any other app via the system share sheet.

## R7 — Catalog
The app MUST keep a local catalog of products with their listings,
newest first, and open a product's listing when tapped.

## R8 — Offline-first
Core flows (capture, mock generation, catalog, share-text copy) MUST
work without network. AI generation degrades to the mock provider
offline.

## R9 — Arabic-first UI
The UI MUST be Arabic-first (Arabic labels primary, French secondary)
and readable right-to-left where Arabic copy appears.

## R10 — Backend stub
A Cloudflare Worker MUST expose POST /generate (validates input, returns
a listing) and GET /health. Mock mode by default; the Gemini key lives
in a Worker secret, never in code.

## R11 — Tests
The price engine MUST have unit tests covering: condition ordering,
suggested price inside [min, max], rounding, and inclusive range
boundaries. (Property-based tests extend these on Day 10-11, see tasks.md.)

## R12 — Submission artifacts
The repo MUST be public with an MIT license, a `.kiro/` directory at the
root (specs, steering, hooks — never gitignored), a live app URL, a
<3-minute YouTube demo video, and a write-up of how Kiro was used.
