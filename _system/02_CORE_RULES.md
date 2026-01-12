# LISN Core Rules

> **Diese Datei enthält die unveränderlichen Kern-Regeln für die LISN Website Factory.**
> Für Details siehe die verlinkten Guides.

---

## 1. Tech Stack (Non-Negotiable)

| Technologie | Details |
|-------------|---------|
| **Framework** | Astro 4.x (Static Site Generator) |
| **Styling** | Tailwind CSS 3.x |
| **Logic** | Alpine.js (für Interaktivität) |
| **Package Manager** | **pnpm** (NIEMALS npm oder yarn) |
| **Backend** | Brevo API (via Astro API Endpoints) |
| **Legal** | Klaro! (Cookie Banner) |

---

## 2. Ordner-Struktur

```
/var/www/staging/[kunde]/
├── src/
│   ├── components/
│   │   ├── global/      # Header, Footer
│   │   ├── sections/    # Hero, Features, TextImage
│   │   ├── forms/       # MultiStepForm
│   │   └── legal/       # CookieBanner
│   ├── layouts/
│   └── pages/           # index, formular, impressum
├── public/              # fonts, images
├── inputs/              # Kunden-Assets (Logo, Text)
└── .env                 # API Keys (chmod 600!)
```

---

## 3. Workflow & Naming

### Slug-Regeln
- Kleinbuchstaben, a-z, 0-9, Bindestrich
- Umlaute ersetzen (ä→ae)
- **Beispiel:** `Müller GmbH` → `mueller-gmbh`

### Neuer Projekt-Start
1. `ssh root@46.224.27.249`
2. `./_system/scripts/new-project.sh [slug]`
3. Assets nach `/inputs` laden
4. `.env` erstellen

👉 **Details:** [01_QUICK_START.md](./01_QUICK_START.md)

---

## 4. Komponenten & Styling

- **Tailwind-First:** Keine eigenen CSS-Klassen außer für komplexe Animationen.
- **Components:** Nutze die vorgefertigten Komponenten.
- **Responsive:** Mobile-First Ansatz.

👉 **Guide:** [guides/astro-components.md](./guides/astro-components.md)

---

## 5. Kritische Entwicklungs-Regeln

### ⚠️ Base URL (Preview vs. Live)
Projekte laufen im Staging unter `/slug/`.
- Nutze `import.meta.env.BASE_URL` in Astro.
- Nutze dynamische Pfad-Erkennung in JS.

👉 **Guide:** [guides/base-url.md](./guides/base-url.md)

### ⚠️ DSGVO & Legal
- **Fonts:** IMMER lokal laden `/public/fonts/`. NIEMALS Google CDN.
- **Cookies:** Klaro Banner ist Pflicht.
- **YouTube:** Nur mit 2-Click-Lösung.

👉 **Guide:** [guides/klaro-consent.md](./guides/klaro-consent.md)

### ⚠️ Alpine.js
- Nutze `<script is:inline>` für Alpine-Logik, damit sie global verfügbar bleibt.

👉 **Guide:** [guides/alpine-tips.md](./guides/alpine-tips.md)

---

## 6. Deployment

- Builds via `pnpm build`
- Server via PM2 (SSR)
- Nginx als Reverse Proxy

👉 **Details:** [deployment/server-setup.md](./deployment/server-setup.md)
