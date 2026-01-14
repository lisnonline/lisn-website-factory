# LISN Neues Projekt erstellen

Du erstellst ein neues LISN Website Factory Projekt von Grund auf.

## Schritt 1: Dokumentation lesen

Verbinde dich per SSH auf den Hetzner Server und lies die Dokumentationen:

```bash
ssh hetzner
```

**Pflicht-Dokumentation:**
- `/var/www/staging/_system/00_INDEX.md` - Übersicht
- `/var/www/staging/_system/01_QUICK_START.md` - Setup-Anleitung
- `/var/www/staging/_system/02_CORE_RULES.md` - Tech Stack & Regeln
- `/var/www/staging/_system/reference/workflow-checklist.md` - Kompletter Workflow

**Je nach Projektanforderung zusätzlich:**

| Feature | Dokumentation |
|---------|---------------|
| Komponenten | `guides/astro-components.md` |
| Kontaktformular | `guides/brevo-forms.md` |
| Cookie Banner | `guides/klaro-consent.md` |
| Interaktivität | `guides/alpine-tips.md` |
| Preview-URL | `guides/base-url.md` |
| SSR Deployment | `deployment/pm2-nginx.md` |
| Texte schreiben | `reference/brand-voice.md` |

## Schritt 2: Projekt-Slug erstellen

**Regeln:**
- Kleinbuchstaben, a-z, 0-9, Bindestrich
- Umlaute ersetzen (ä→ae, ö→oe, ü→ue, ß→ss)
- Beispiel: "Müller & Söhne GmbH" → `mueller-soehne`

## Schritt 3: Projekt anlegen

```bash
cd /var/www/staging

# Prüfen ob Slug frei ist
ls | grep [slug]

# Projekt erstellen (Script verwenden)
/var/www/staging/_system/scripts/new-project.sh [slug]

# Oder manuell:
mkdir [slug] && cd [slug]
pnpm create astro@latest . --template minimal --typescript strict
pnpm astro add tailwind
pnpm add alpinejs @klaro/core
```

## Schritt 4: Konfiguration

**.env erstellen:**
```bash
cp .env.example .env
chmod 600 .env
nano .env
```

**astro.config.mjs für Preview:**
```javascript
base: '/[slug]/'
```

**ecosystem.config.cjs:**
- Eindeutigen PORT wählen (4321, 4322, ...)
- Name setzen

## Schritt 5: Inputs verarbeiten

Falls der User Dateien bereitstellt:
- Kickoff-Dokument analysieren
- Logo in `/public/images/` speichern
- Bilder zu WebP konvertieren (85% Qualität)
- Texte nach `reference/brand-voice.md` aufbereiten

## Schritt 6: Entwicklung

**Struktur:**
```
src/
├── components/
│   ├── global/      # Header.astro, Footer.astro
│   ├── sections/    # Hero.astro, Features.astro, etc.
│   ├── forms/       # ContactForm.astro
│   └── legal/       # CookieBanner.astro
├── layouts/
│   └── Layout.astro
└── pages/
    ├── index.astro
    ├── impressum.astro
    ├── datenschutz.astro
    └── formular.astro (optional)
```

**Wichtige Regeln:**
- pnpm verwenden (NIEMALS npm)
- Fonts lokal laden (NIEMALS Google CDN)
- `base +` vor allen Asset-Pfaden
- Alpine.js Scripts mit `is:inline`
- Bilder immer WebP, mit width/height

## Schritt 7: Preview deployen

```bash
pnpm build
pm2 start ecosystem.config.cjs
pm2 save
```

**Preview-URL:** `https://customers.lisn-agentur.com/[slug]/`

## Schritt 8: Testen

- [ ] Alle Seiten laden
- [ ] Mobile Ansicht
- [ ] Formular funktioniert (falls vorhanden)
- [ ] Cookie Banner erscheint
- [ ] Impressum/Datenschutz vollständig
- [ ] Lighthouse Score > 90

---

## Deine Aufgabe

$ARGUMENTS
