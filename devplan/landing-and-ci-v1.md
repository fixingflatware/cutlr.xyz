# CUTLR — Landing page + GitHub Pages CI (v1)

**Scope:** stand up `cutlr.xyz` following the house pattern of the sibling sites
(static site in `public/`, CI publishes `public/` to Pages, `dev.sh` for local),
but on **GitHub Pages** instead of GitLab. Then build a single self-contained
`public/index.html` landing page from `landing.md`.

**Repo (already exists, empty):** `git@github.com:cutlr/cutlr-xyz.git`
**Env verified:** `gh` authenticated as `Ymx1ZQ`, SSH to GitHub OK.

## Assumptions (pending confirmation — AskUserQuestion went unanswered)

- **Aesthetic:** *Cold Steel* — steel greys + cyan-steel accent, cutlery metaphor,
  technical-mono / Linear-Vercel vibe. Native dark/light, hacker-but-modern.
- **Domain:** apex `cutlr.xyz` as GitHub Pages custom domain (CNAME + DNS A records).
- **Fonts:** system stacks (`system-ui` grotesk + `ui-monospace`) → zero external
  runtime deps, instant load, on-brand with "no bloat". (Geist/JetBrains Mono via
  Google Fonts is an optional upgrade if you want the exact dev-tool look.)

If any assumption is wrong, say so and I'll adjust before executing.

---

## M0 — Repo scaffolding (house pattern)

- [ ] `public/` directory (site root, deployed as-is).
- [ ] `.gitignore` — editor/OS junk, `.claude/`, `node_modules/` (mirrors cerase.ai).
- [ ] `dev.sh` — serve `public/` on :8080 via `python3 -m http.server` (mirrors siblings).
- [ ] `README.md` — one-liner: what it is, `./dev.sh` to preview, push-to-deploy note.

## M1 — GitHub Pages CI (GitHub Actions)

Modern equivalent of the siblings' `.gitlab-ci.yml pages` job.

- [ ] `.github/workflows/deploy.yml` — on push to `main`:
      `actions/configure-pages` → `actions/upload-pages-artifact` (path: `public/`)
      → `actions/deploy-pages`. Perms `pages: write`, `id-token: write`;
      `concurrency: pages` (cancel-in-progress false).
- [ ] `public/CNAME` = `cutlr.xyz` (apex custom domain).
- [ ] **Manual, one-time (yours or via `gh api`):** repo Settings → Pages →
      Source = "GitHub Actions". I'll try to set it with `gh api` during execution;
      if it needs the UI I'll hand you the exact click-path.
- [ ] **DNS to hand over** (apex): 4 A records → `185.199.108.153`, `185.199.109.153`,
      `185.199.110.153`, `185.199.111.153` (+ optional AAAA). Plus a `www` CNAME → `cutlr.github.io` if you want www→apex.

## M2 — Landing page `public/index.html` (self-contained)

Built from `landing.md`. Single file, inlined CSS + tiny JS. Structure:

- [ ] **No-FOUC theme script** — blocking inline `<script>` first in `<head>`:
      localStorage → `prefers-color-scheme` → default; sets `data-theme` on `<html>`
      before first paint. CSS custom props keyed to `[data-theme]`.
- [ ] **Sticky header** — `CUTLR` wordmark, anchor nav, **theme toggle** (sun/moon,
      `aria-label`), and **GitHub org link → https://github.com/cutlr**.
- [ ] **Hero** — "🍴 CUTLR / We're cutlers. We fix bent flatware.", tagline
      **"Keep it straight."**, fake terminal line `$ npx cutlr add notes tasks track`
      with blinking cursor. CTAs: *Explore the suite* · *MIT code on GitHub*.
- [ ] **Manifesto** — the "tools have become twisted" anti-bloat pitch; MIT + native
      **MCP** callout ("bring your own AI"); "one account, every tool".
- [ ] **The Suite** — 6 cards, each a **clickable link to its subdomain**:
      notes · tasks · track · polls · rsvp · bookmarks `.cutlr.xyz`. Mono `[01]…[06]` labels.
- [ ] **Pricing & Access** — Self-hosted always free · Essentials free · Power User
      **$2.99/mo** whole suite. **Anti-lock-in block (your new angle):** *no mega annual
      discounts, no lock-in — fair monthly price, cancel/detach whenever you want.*
      Rendered as a mono "ledger" table with dotted leaders.
- [ ] **Footer** — "Keep it straight." + links: **GitHub org (github.com/cutlr)**,
      X (building in public), and the full **subdomain list** (all 6, clickable).
      Plus a **Guidance credit** (cerase.ai-style): "Built & maintained with ♥ by
      **Guidance Srl**" → https://www.guidance.studio, with company legal details
      (P.IVA, Sede, REA, Capitale sociale).
- [ ] **Style** — Cold Steel palette (both modes), 1px borders, faint grid bg (~6%),
      mono micro-labels, `>` prompt bullets, `<kbd>` hints, blinking cursor;
      respects `prefers-reduced-motion`. Responsive, no horizontal scroll.

## M3 — Verify & deploy

- [ ] `./dev.sh` → visually verify both themes, toggle persistence, all links/anchors,
      mobile width, no console errors.
- [ ] `git init` (branch `main`), commit, `git remote add origin
      git@github.com:cutlr/cutlr-xyz.git`, push.
- [ ] Confirm the Actions run goes green; report the live URL + the exact DNS records
      and any one-time Pages setting you still need to flip.

---

---

## Status — 2026-07-03

- **DONE** M0 scaffolding, M1 CI, M2 landing page, M3 deploy, **v1.1 marketer pass**.
- **LIVE on https://www.cutlr.xyz** (canonical, HTTPS enforced); naked `cutlr.xyz` 301→www.
- **Aesthetic:** Cold Steel · system font stacks (zero external deps).
- **Domain — RESOLVED:** DNS on Route 53 (apex A ×4 + `www` CNAME). The blocker was
  a typo in GitHub's custom-domain field (`cutrl.xyz`), not the DNS; fixed to
  `cutlr.xyz`, cert provisioned (`approved`), HTTPS enforced.

---

## Revision v1.1 — de-nerd the hero (2026-07-03)

**Feedback:** the hero reads *too* technical. The fake terminal
`$ npx cutlr add notes tasks track` signals "install CLI software on your
machine" and pushes away non-technical users. First impression must say
"ready-to-use web apps — open a link and go", with the hacker styling kept only
as *flavor*, not as the message.

- [ ] **Replace the hero terminal** with a friendlier visual (per chosen direction).
- [ ] **Rewrite the lede** to lead with the hosted/no-install promise: name the
      everyday apps, "open a link, sign in once, it just works — nothing to install".
      Demote MIT / MCP / self-hosted to a secondary "for the technical" line.
- [ ] **CTAs:** primary "Open the suite →" (welcoming); "Source on GitHub" demoted.
- [ ] Keep headline + "we're cutlers" chip; keep Cold Steel look but dial the
      terminal motif down to a light accent.
- [ ] Everything below the hero stays; this revision is hero-only.

**Final decisions (all confirmed):**
- Hero visual = **browser-window mock** (address bar `notes.cutlr.xyz` + mini note) → "it's a website, open and use".
- Language stays **English**.
- Rename tool **bookmarks → `pins`** (📌 `pins.cutlr.xyz`, "Pin a link, tag it, find it again") everywhere (suite card + footer).
- **No hard-coded tool count** anywhere ("Six straight tools" → generic) so adding/removing tools needs no copy edit.
- **No open-source / MIT / MCP in the hero** — audience is mainstream Evernote/Calendly refugees. Those signals live in manifesto/footer only. De-jargon the suite cards (drop "native MCP" wording).
- Hero CTAs: primary "Explore the suite →", secondary "Honest pricing →" (GitHub demoted to header/footer).

## Revision v1.2 — header conversion + www canonical (2026-07-03)

**Feedback:** the single-app browser mock (only `notes`) is wrong for the hero →
removed. GitHub out of the header entirely. Header must carry the real actions:
**Log in** + **Start for free**. The hero may list every tool, but **by what it
does, not by product name**. Canonical domain → **www.cutlr.xyz**, apex 301 → www.

- [x] Header: remove GitHub (text link + icon). Add "Log in" + "Start for free" (primary btn).
- [x] Hero: drop the browser mock. CTAs → "Start for free" (primary) + "Explore the suite".
- [x] Hero suite strip by **function, not name**: 📝 Write notes · 📋 Track to-dos ·
      ⏱ Log time · 📅 Find a time · 🎟 Host events · 📌 Save links.
- [x] Auth links → placeholders `https://www.cutlr.xyz/{login,signup}` — **repoint when auth exists.**
- [x] Domain: `public/CNAME` + Pages cname → `www.cutlr.xyz`; apex A records already set →
      GitHub 301s apex→www. `og:url` + canonical → www.

## Revision v1.3 — toggle relocation + full marketing pass (2026-07-03)

- [x] **Theme toggle → footer** (foot-bottom). Header stays clean for conversion
      (brand · nav · Log in · Start for free). Page already auto-respects the OS
      theme, so the manual toggle is just an override → belongs out of the way. `T` shortcut kept.
- [x] **Comparison "bloat tax"** section (between Suite & Pricing): the usual
      separate-app stack (~$44/mo, by function not brand) vs CUTLR **$2.99/mo**, with CTA.
- [x] **Trust line** under pricing: data is yours · export anytime · no contracts · cancel in one click.
- [x] **FAQ** (native `<details>`, no JS): install? · import/export · cancel-anytime ·
      data if you leave · why so cheap.
- [x] **Closing CTA** band + **honest** building-in-public line (real GitHub link, no fake numbers/testimonials).

## Revision v1.4 — rsvp → future Events product; Fixing Flatware umbrella (2026-07-03)

Strategy: umbrella brand **Fixing Flatware** (flat*ware* = cutlery, matches CUTLR).
CUTLR becomes product #1; a dedicated Events product (Meetup/Eventbrite) will own RSVP.

- [x] **Remove `rsvp` from CUTLR** (overlaps the future Events product). Keep `polls`
      (scheduling ≠ events). Suite now 5 tools; renumber pins → [05]. Remove hero
      "🎟️ Host events" chip, footer `rsvp.cutlr.xyz` link, and the events line in the
      bloat-tax table (total ≈ $44 → ≈ $36/mo).
- [x] **Footer reference** to the umbrella: "CUTLR is the first tool of Fixing Flatware".
      Link deferred until `fixingflatware.(com/xyz)` is bought + live.
- [ ] **Umbrella site** `fixingflatware` — separate deliverable (own devplan).
- [ ] **GitHub org rename** `cutlr` → `fixingflatware`: **UI-only** (no API); user does it,
      then update git remote + the `www` DNS CNAME target → `fixingflatware.github.io`.

## Revision v1.5 — add `cal` (Calendly-equivalent) as the 6th tool (2026-07-10)

**Context:** CUTLR gains a Calendly-shaped module — the host **publishes availability**,
an invitee **books a slot** — distinct from `polls` (Doodle-shaped: a group *votes* for a
common time). Name **decided: `cal`**, drawn from the category's shared root (Calendly /
Cal.com / SavvyCal). This revision is **site-only**; the app's own devplan/scoping (roadmap
wave, external-calendar sync) is handled separately by the user.

Tool identity on the site: **🗓️ `cal` · `cal.cutlr.xyz`** (emoji 🗓️ to contrast `polls`' 📅).

**Decisions (user 2026-07-10):** label = **`Take bookings`** (host-voice, matches sibling
chips); placement = **after `polls`** (scheduling tools grouped, `pins`→`[06]`); bonus
`events`/`bookings` fixes = **yes**.

- [x] **Hero suite strip** (function, not name): inserted `🗓️ Take bookings` after
      `📅 Find a time` → Write notes · Track to-dos · Log time · Find a time · **Take bookings** · Save links.
- [x] **The Suite grid**: `cal` card added **after `polls`**, `pins` renumbered `[06]`. Grid is a clean 2×3.
      Copy (parallel to `polls`, **no external-sync promise** — sync is still an open app-side question):
      *"Post your open hours, share the link, let people book a slot — no back-and-forth. Or let your AI take the bookings."*
- [x] **Footer Tools column**: `cal.cutlr.xyz` added after `polls.cutlr.xyz`.
- [x] **Bonus fixes**: hero lede prose — dropped stale **`events`**, added **`bookings`**;
      added `bookings` to `<meta name="description">`. Bloat-tax `~€12/mo` "scheduling tool"
      row left as-is (already stands in for Calendly).
- [x] **Verify & ship**: `./dev.sh`, both themes, no horizontal scroll, all 6 links resolve;
      commit + push (Pages auto-deploys). — *shipped in `b074530`; box closed 2026-08-06 after
      verifying the `cal` card is live and `main` is level with `origin/main`. The work landed
      2026-07-11 and the tick sat open for 26 days.*

## Revision v1.6 — the AI costs nothing extra, and say what each plan gets (2026-08-06) ✅

**Why:** the manifesto chip promises "Native MCP — bring your own AI" and the suite copy says
"let your AI take the bookings", but the page never says what that AI costs. The FAQ carries six
business-model questions and none about AI. Mirrors fixingflatware v1.3 (`dd312dd`), which states
the argument; here it lands as a product fact — umbrella argues, cutlr prices.

**Levels, from the locked plan (`software/cutlr/ARCHITECTURE.md` §Billing, §API & MCP):**
Free = full API/MCP at 20 req/min per token · Power User = unmetered (fair use) · self-hosted =
your server. Principle: "gate throughput, never access". No credits, no metering as a billing
dimension ("protection, not pricing").

- [x] FAQ: new entry "Do I pay extra for the AI?" before "Why is it so cheap?", carrying the
      three levels and "we don't resell you tokens — you pay your model provider at their price"
- [x] Pricing, "One fair monthly price" card: + "MCP on every plan — no AI tier, no credits"
- [x] Pricing ledger, Essentials row: "The basics of every tool" contradicts the locked plan
      ("plans never differ on item counts"; free is the full suite, gated on throughput only)
      → "The whole suite on our cloud, AI access included."
- [x] Render check at 1280px and 390px (preview copy with every `<details>` forced open, so the
      new FAQ answer was actually inspected, not assumed). Ledger leader dots still resolve;
      "One fair monthly price" goes from 3 to 4 lines and the three `.lockin` cards equalise.
- [x] Commit + push

**Limitation found on the render check:** `.ledger .desc` is `display: none` under 720px, so the
Essentials correction is desktop-only — on mobile that row reads "Essentials / hosted by us /
free" with no scope statement. Not a regression (pre-existing CSS) and the new FAQ answer covers
it ("the free plan gets all of it"), but the pricing block itself stays silent there. Deferred:
if the free plan's scope is worth stating on mobile, the ledger needs a stacked layout, which is
a redesign of the block, not a copy edit.

**Not doing:** a 4th `.lockin` card (grid is `repeat(3,1fr)`, leaves an orphan); an "AI add-on"
row in THE MATH (invented figure, and it moves the ≈€36 anchor); req/min numbers in the ledger
or hero — the v1 decision above (l.121) keeps that language out of the mainstream-facing blocks,
so the precise figures live in the FAQ.

### Out of scope (v1)
Actual per-tool apps (notes/tasks/…), auth/SSO ("one account"), analytics, favicon
artwork beyond a simple inline SVG. Flag if you want any pulled in.
