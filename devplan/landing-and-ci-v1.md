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

### Out of scope (v1)
Actual per-tool apps (notes/tasks/…), auth/SSO ("one account"), analytics, favicon
artwork beyond a simple inline SVG. Flag if you want any pulled in.
