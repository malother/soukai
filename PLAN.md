# SoukAI — 18-day plan (17 Nov → 4 Dec 2026)

Submission deadline: **Fri 4 Dec 2026, 23:00 Africa/Algiers.**
One buffer day is built in (Day 17); Day 18 is submit-only.

## Day 1 — Mon 17 Nov: Setup + specs
- Create public GitHub repo `soukai`, push this scaffold, verify `.kiro/`
  is visible on github.com (not gitignored)
- Register on Devpost (Kiroween 2026), pick category: Costume Contest
  (primary) / Best Startup (secondary)
- Request the one-time 4,000 free Kiro credits (request deadline:
  1 Dec 12:00 PT — do it Day 1, don't wait)
- Install Kiro CLI (`curl -fsSL https://cli.kiro.dev/install | bash`),
  sign in with GitHub, run `kiro-cli doctor`

## Day 2 — Tue 18 Nov: Flutter runs
- `flutter pub get`, `flutter analyze`, fix all issues
- Verify the app launches on emulator/phone; fix routing

## Day 3 — Wed 19 Nov: Home + catalog
- Home screen wired to the catalog; empty state; product cards
- Add a few seed products by hand for demo purposes

## Day 4 — Thu 20 Nov: Capture (camera)
- Camera + gallery pick working; photo shown in the form

## Day 5 — Fri 21 Nov: Capture (form) + listing screen
- Product form complete; listing screen preview + edit working

## Day 6 — Sat 22 Nov: Mock generation end-to-end
- Capture → mock listing → edit → share flow working offline
- Price engine wired to the form's comparable prices

## Day 7 — Sun 23 Nov: Worker live
- `wrangler dev`: /health + /generate (mock) responding locally

## Day 8 — Mon 24 Nov: Gemini in the worker
- Gemini API key as a Worker secret (`wrangler secret put
  GEMINI_API_KEY`); worker calls Gemini, returns a real listing
- Keep mock as fallback when the key is absent

## Day 9 — Tue 25 Nov: App ↔ worker
- App calls the deployed worker when online, mock when offline
- One flag swaps providers; verify both paths on the phone

## Day 10 — Wed 26 Nov: Property tests (price engine)
- Random ranges/conditions; assert invariants: suggested in [min, max],
  condition ordering, rounding, non-negative prices
- `flutter test` green

## Day 11 — Thu 27 Nov: Share + catalog polish
- WhatsApp deep link, system share sheet, copy text — all verified
  on the phone

## Day 12 — Fri 28 Nov: Offline persistence
- Catalog saved with shared_preferences; survives app restart

## Day 13 — Sat 29 Nov: UI polish
- Arabic-first labels, RTL where Arabic copy appears, loading/error
  states, consistent spacing; test on a real phone

## Day 14 — Sun 30 Nov: Demo script + dry run
- Write the <3 min script: problem (15s) → snap photo (30s) →
  listing appears (30s) → edit + price (20s) → share to WhatsApp
  (20s) → how Kiro built it: specs/hooks (30s)
- Dry-run the recording twice

## Day 15 — Mon 1 Dec: Record the demo video
- Record on the phone, <3 minutes, full flow end-to-end
- Upload to YouTube (public, no copyrighted music)

## Day 16 — Tue 2 Dec: Write-up + README
- Kiro usage write-up: specs, steering, hooks, what Kiro did
- README final pass; screenshots in the repo

## Day 17 — Wed 3 Dec: Devpost submission (buffer day)
- Submit: public repo + MIT license + live app/worker URL + YouTube
  video + description + Kiro write-up
- Verify every link from a clean browser

## Day 18 — Thu 4 Dec: Submit-only day
- Final link check; fix anything broken; submit before 23:00 Algiers
- Do NOT start new features today
