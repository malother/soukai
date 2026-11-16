# SoukAI — Implementation tasks

> Work in order. Check a box only when the step runs (or is verified in
> the target environment). See PLAN.md for the day-by-day schedule.

## Phase 1 — Scaffold (Day 1)
- [x] Create project structure: Flutter app, worker stub, tests
- [x] Write Kiro spec: requirements.md, design.md, tasks.md
- [x] Write steering files: product.md, tech.md
- [x] Add example agent hook: dart-analyze-on-save
- [x] README, MIT license, .gitignore (must NOT ignore .kiro/)
- [ ] Create public GitHub repo `soukai`, push scaffold, verify `.kiro/`
      is visible on github.com
- [ ] Register on Devpost (Kiroween 2026), request 4,000 free Kiro credits
      (deadline to request: 1 Dec 12:00 PT)

## Phase 2 — Flutter UI + camera (Days 2-5)
- [ ] Run `flutter pub get` and `flutter analyze`, fix all issues
- [ ] Home screen: catalog list, empty state, navigation
- [ ] Capture screen: camera/gallery pick, product form (name, category,
      condition, comparable prices)
- [ ] Listing screen: preview + edit all fields (AR + FR)
- [ ] Share screen: system share sheet, WhatsApp deep link, copy text

## Phase 3 — Generation (Days 6-9)
- [ ] Wire mock provider end-to-end (capture → listing → share)
- [ ] Price engine + unit tests (`flutter test`)
- [ ] Gemini provider: implement via Cloudflare Worker (key in Worker
      secret, never in code); wire worker /generate to Gemini
- [ ] Swap mock → worker provider behind one flag; keep mock as fallback

## Phase 4 — Quality (Days 10-13)
- [ ] Property-based tests for the price engine (random ranges/conditions;
      invariants: suggested in [min, max], condition ordering, rounding)
- [ ] Offline persistence for the catalog (shared_preferences)
- [ ] Polish: Arabic-first UI, RTL where Arabic copy appears, loading
      and error states, empty states

## Phase 5 — Ship (Days 14-18)
- [ ] Record demo video (<3 min, phone screen, full flow end-to-end)
- [ ] Publish video on YouTube (public, no copyrighted music)
- [ ] Write Kiro usage write-up (specs, steering, hooks, what Kiro did)
- [ ] Deploy worker (wrangler deploy) and note the live URL
- [ ] Submit on Devpost before 4 Dec 2026, 23:00 Africa/Algiers:
      public repo + license + live URL + video + write-up
