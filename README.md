# cutlr.xyz

Landing page for **CUTLR** — a growing suite of lightweight, MIT-licensed,
MCP-native alternatives to bloated SaaS tools. Keep it straight.

Static site. Everything lives in `public/` and is deployed as-is.

## Develop

```bash
./dev.sh          # serves public/ on http://localhost:8080
./dev.sh 8090     # pick another port
```

## Deploy

Push to `main` → GitHub Actions (`.github/workflows/deploy.yml`) publishes
`public/` to **GitHub Pages**, served on the custom domain **cutlr.xyz**
(`public/CNAME`).

One-time repo setting: **Settings → Pages → Source = "GitHub Actions"**.
