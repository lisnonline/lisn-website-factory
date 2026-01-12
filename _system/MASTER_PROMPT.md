# LISN Website Factory - Master Prompt
**Version:** 1.0
**Server:** 46.224.27.249
**Letzte Änderung:** 2026-01-12

═══════════════════════════════════════════════════════════════════
## ÜBER LISN
═══════════════════════════════════════════════════════════════════

**Firma:** LISN GmbH
**Branche:** Digital-Marketing-Agentur
**Standort:** Vorarlberg, Österreich
**Spezialisierung:** Kundenakquise für Handwerksbetriebe (10-100 Mitarbeiter)
**Positionierung:** "Unternehmer für Unternehmer" - authentisch, auf Augenhöhe
**Gründer:** Julien (Elektromeister mit Marketing-Ausbildung)

**Zielgruppe:**
- Handwerksbetriebe in Österreich
- 10-100 Mitarbeiter
- Branchen: Elektro, Sanitär, Heizung, Bau, etc.
- Fokus auf Neukundengewinnung

═══════════════════════════════════════════════════════════════════
## TECH STACK
═══════════════════════════════════════════════════════════════════

**Framework:** Astro 4.x (Static Site Generator)
**Styling:** Tailwind CSS 3.x
**Interaktivität:** Alpine.js (für Formulare, Mobile Menu)
**Package Manager:** pnpm (NICHT npm!)
**Deployment:** Hetzner VPS (dieser Server)
**Formular-Backend:** Brevo API (Transactional Email + CRM)
**Cookie Banner:** Klaro! (Open Source, DSGVO-konform)

**Wichtige Versionen:**
- Node.js: v20.19.6
- pnpm: 10.27.0
- Nginx: 1.24.0

═══════════════════════════════════════════════════════════════════
## ORDNER-STRUKTUR
═══════════════════════════════════════════════════════════════════

**Development:** `/var/www/staging/[kundenname]/`
**Production:** `/var/www/kunden/[kundenname]/`
**Backups:** `/var/www/backups/`
**System-Docs:** `/var/www/staging/_system/`
**Template:** `/var/www/staging/_template/`
**Archive:** `/var/www/staging/_archive/`

═══════════════════════════════════════════════════════════════════
## PROJEKT-WORKFLOW
═══════════════════════════════════════════════════════════════════

### 1. SETUP

```bash
cd /var/www/staging
mkdir [kundenname-slug]
cd [kundenname-slug]
mkdir inputs
```

### 2. INPUTS

Erwarte folgende Dateien in `./inputs/`:
- ✅ Kickoff-Dokument (PDF/MD) mit Firmeninfos
- ✅ Stitch HTML/CSS Export ODER Screenshots
- ✅ Logo (SVG/PNG)
- 🔹 Optional: Bilder, Videos, Farbschema

### 3. KUNDENNAME-SLUG

**Regeln für Slug-Erstellung:**
- Kleinbuchstaben
- Umlaute: ä→ae, ö→oe, ü→ue, ß→ss
- Leerzeichen → Bindestrich
- Nur: a-z, 0-9, Bindestrich
- Rechtsform weglassen (GmbH, KG, etc.)

**Beispiele:**
```
"Müller Sanitär GmbH" → mueller-sanitaer
"Huber & Söhne Elektro KG" → huber-soehne-elektro
"Forstinger Haus & Bad" → forstinger-haus-bad
```

### 4. ORDNER-CHECK (WICHTIG!)

**IMMER vor Start prüfen:**
```bash
# Prüfe ob bereits existiert
ls /var/www/staging/ | grep [kundenname]
ls /var/www/kunden/ | grep [kundenname]

# Falls JA: STOPPE und frage User!
```

### 5. ASTRO-PROJEKT ERSTELLEN

```bash
cd /var/www/staging/[kundenname-slug]
pnpm create astro@latest . --template minimal --typescript strict
pnpm astro add tailwind
pnpm add -D alpinejs
pnpm add @klaro/core
```

### 6. PROJEKT-ORDNER-STRUKTUR

```
/var/www/staging/[kunde]/
├── src/
│   ├── components/
│   │   ├── global/
│   │   │   ├── Header.astro
│   │   │   ├── Footer.astro
│   │   │   └── MobileMenu.astro
│   │   ├── sections/
│   │   │   ├── Hero.astro
│   │   │   ├── TextImageSection.astro
│   │   │   ├── FeatureGrid.astro
│   │   │   ├── Testimonials.astro
│   │   │   ├── Stats.astro
│   │   │   ├── CTA.astro
│   │   │   └── FAQ.astro
│   │   ├── forms/
│   │   │   ├── MultiStepForm.astro
│   │   │   ├── FormStep1.astro
│   │   │   ├── FormStep2.astro
│   │   │   └── FormStep3.astro
│   │   └── legal/
│   │       ├── CookieBanner.astro
│   │       └── LegalNav.astro
│   ├── layouts/
│   │   ├── Layout.astro
│   │   └── FormLayout.astro
│   ├── pages/
│   │   ├── index.astro
│   │   ├── formular.astro
│   │   ├── impressum.astro
│   │   ├── datenschutz.astro
│   │   ├── agb.astro
│   │   └── danke.astro
│   └── styles/
│       └── global.css
├── public/
│   ├── fonts/
│   ├── images/
│   │   └── logo.svg
│   └── robots.txt
├── inputs/                # User-Uploads (Kickoff, Logo, etc.)
├── config.json            # Firmenspezifische Konfiguration
├── content.json           # CMS-ähnliche Content-Daten
├── .env.example
├── deploy.sh
├── README.md
└── package.json
```

═══════════════════════════════════════════════════════════════════
## STANDARD-SEITEN
═══════════════════════════════════════════════════════════════════

### PFLICHT-SEITEN (immer):
1. ✅ **Startseite** (`index.astro`)
2. ✅ **Formular** (`formular.astro`) - Multi-Step
3. ✅ **Danke-Seite** (`danke.astro`) - nach Formular-Submit
4. ✅ **Impressum** (`impressum.astro`)
5. ✅ **Datenschutz** (`datenschutz.astro`)
6. ✅ **AGB** (`agb.astro`)

### OPTIONAL (wenn im Kickoff erwähnt):
- 🔹 Leistungen
- 🔹 Über uns
- 🔹 Kontakt
- 🔹 Referenzen

═══════════════════════════════════════════════════════════════════
## CONFIG.JSON STRUKTUR
═══════════════════════════════════════════════════════════════════

```json
{
  "company": {
    "name": "Müller Sanitär GmbH",
    "fullLegalName": "Müller Sanitär GmbH",
    "slug": "mueller-sanitaer",
    "owner": "Max Müller",
    "foundedYear": "1995",
    "industry": "Sanitär, Heizung, Klima"
  },
  "contact": {
    "email": "office@mueller-sanitaer.at",
    "phone": "+43 5572 12345",
    "fax": "+43 5572 12345-99",
    "address": {
      "street": "Musterstraße 123",
      "zip": "6850",
      "city": "Dornbirn",
      "country": "Österreich"
    },
    "website": "https://mueller-sanitaer.at"
  },
  "legal": {
    "uid": "ATU12345678",
    "fb": "FN 123456a",
    "court": "Landesgericht Feldkirch",
    "authority": "Wirtschaftskammer Vorarlberg",
    "chamber": "Landesinnung Vorarlberg"
  },
  "brevo": {
    "notification_email": "office@mueller-sanitaer.at",
    "list_id": 123,
    "template_id": 1
  },
  "theme": {
    "primary": "#3B82F6",
    "secondary": "#1E40AF",
    "accent": "#F59E0B"
  },
  "social": {
    "facebook": "",
    "instagram": "",
    "linkedin": ""
  }
}
```

═══════════════════════════════════════════════════════════════════
## CONTENT-ERSTELLUNG (BRAND VOICE)
═══════════════════════════════════════════════════════════════════

### TONALITÄT - DOs

✅ **Direkt und ehrlich**
- Sage was ist, ohne Umschweife
- Keine Marketing-Floskeln

✅ **Fachkompetent aber verständlich**
- Verwende Fachbegriffe nur wenn nötig
- Erkläre komplexe Dinge einfach

✅ **Auf Augenhöhe (Kollege zu Kollege)**
- "Unternehmer für Unternehmer"
- Respektvoll aber nicht unterwürfig

✅ **Konkrete Zahlen und Beispiele**
- "150+ Projekte in Vorarlberg"
- "Durchschnittlich 12 Anfragen pro Monat"

✅ **Österreichisches Deutsch**
- "Angebot" statt "Offerte"
- "Auftrag" statt "Order"
- Lokale Begriffe verwenden

✅ **Sie-Form**
- Professionell und respektvoll
- In Vorarlberg Standard

### TONALITÄT - DON'Ts

❌ **Marketing-Buzzwords**
- "innovativ", "ganzheitlich", "nachhaltig" (ohne Beleg)
- "führend", "einzigartig"

❌ **Superlative ohne Beleg**
- "beste Lösung am Markt"
- "höchste Qualität"

❌ **Passive Formulierungen**
- "Es wird gemacht" → "Wir machen"
- "Kann erreicht werden" → "Erreichen Sie"

❌ **Corporate-Sprech**
- "Synergien nutzen"
- "Paradigmenwechsel"

❌ **Allgemeine Floskeln**
- "Ihr Partner für..."
- "Wir sind für Sie da"

### BEISPIEL-TEXTE

**❌ Schlecht:**
"Ihr innovativer Partner für ganzheitliche Elektrolösungen mit nachhaltigem Mehrwert"

**✅ Gut:**
"Elektriker in Vorarlberg - für Neubauten und Renovierungen"

**❌ Schlecht:**
"Wir bieten Ihnen maßgeschneiderte Lösungen für Ihre individuellen Bedürfnisse"

**✅ Gut:**
"Wir planen und installieren Ihre Elektrik - vom Einfamilienhaus bis zur Gewerbeimmobilie"

═══════════════════════════════════════════════════════════════════
## FORMULAR (MULTI-STEP)
═══════════════════════════════════════════════════════════════════

### Standard 3-Schritte:

**Schritt 1: Art der Anfrage**
- Radio Buttons
- Optionen abhängig von Branche:
  - Sanitär: Neubau, Renovierung, Wartung, Notfall, Sonstiges
  - Elektro: Neubau, Renovierung, Smart Home, Photovoltaik, Notfall
  - Heizung: Neubau, Heizungstausch, Wartung, Notfall

**Schritt 2: Projektdetails**
- Beschreibung (Textarea, required, min 20 Zeichen)
- Budget-Rahmen (Select, optional)
  - "< 5.000 €"
  - "5.000 - 15.000 €"
  - "15.000 - 30.000 €"
  - "> 30.000 €"
  - "Weiß ich noch nicht"
- Zeitrahmen (Select, required)
  - "Notfall (sofort)"
  - "Innerhalb 1 Monat"
  - "Innerhalb 3 Monate"
  - "Innerhalb 6 Monate"
  - "Noch offen"

**Schritt 3: Kontaktdaten**
- Vorname (Text, required)
- Nachname (Text, required)
- Telefon (Tel, required, Format: +43...)
- E-Mail (Email, required)
- PLZ (Text, required, 4 Ziffern, österreichische PLZ)
- Firma (Text, optional)
- Datenschutz-Checkbox (required)

### Formular-Features:
- ✅ Progress-Indicator (Schritt X von 3)
- ✅ Vor/Zurück Navigation
- ✅ Inline-Validierung
- ✅ Success-Page (`/danke`)
- ✅ Alpine.js für Frontend-Logik
- ✅ API-Endpoint: `/api/submit-form.js`
- ✅ Loading-State beim Submit
- ✅ Error-Handling

### Brevo-Integration:

```javascript
// src/pages/api/submit-form.js
import type { APIRoute } from 'astro';

export const POST: APIRoute = async ({ request }) => {
  const formData = await request.json();

  // 1. E-Mail an Kunden senden (Brevo Transactional)
  await fetch('https://api.brevo.com/v3/smtp/email', {
    method: 'POST',
    headers: {
      'api-key': import.meta.env.BREVO_API_KEY,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      sender: { email: 'noreply@kunde.at', name: 'Firmenname' },
      to: [{ email: formData.email }],
      subject: 'Ihre Anfrage bei Firmenname',
      htmlContent: '...'
    })
  });

  // 2. Benachrichtigung an Firma
  await fetch('https://api.brevo.com/v3/smtp/email', {
    method: 'POST',
    headers: {
      'api-key': import.meta.env.BREVO_API_KEY,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      sender: { email: 'noreply@kunde.at', name: 'Website' },
      to: [{ email: 'office@kunde.at' }],
      subject: 'Neue Anfrage über Website',
      htmlContent: '...'
    })
  });

  // 3. Kontakt zu Brevo-Liste hinzufügen
  await fetch('https://api.brevo.com/v3/contacts', {
    method: 'POST',
    headers: {
      'api-key': import.meta.env.BREVO_API_KEY,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      email: formData.email,
      listIds: [123],
      attributes: {
        FIRSTNAME: formData.firstname,
        LASTNAME: formData.lastname,
        SMS: formData.phone
      }
    })
  });

  return new Response(JSON.stringify({ success: true }), {
    status: 200
  });
};
```

═══════════════════════════════════════════════════════════════════
## DSGVO & LEGAL
═══════════════════════════════════════════════════════════════════

### Cookie Banner (Klaro!)

```javascript
// src/components/legal/CookieBanner.astro
import '@klaro/core/dist/klaro.css';

const config = {
  lang: 'de',
  translations: {
    de: {
      consentNotice: {
        description: 'Wir verwenden Cookies für Analyse und Marketing.'
      }
    }
  },
  services: [
    {
      name: 'google-analytics',
      title: 'Google Analytics',
      purposes: ['analytics'],
      required: false
    },
    {
      name: 'google-ads',
      title: 'Google Ads',
      purposes: ['marketing'],
      required: false
    }
  ]
};
```

### Lokale Fonts (WICHTIG!)

❌ **NICHT:**
```html
<link href="https://fonts.googleapis.com/css2?family=Inter" rel="stylesheet">
```

✅ **RICHTIG:**
```css
/* src/styles/global.css */
@font-face {
  font-family: 'Inter';
  src: url('/fonts/Inter-Regular.woff2') format('woff2');
  font-weight: 400;
  font-display: swap;
}
```

**Fonts downloaden:**
```bash
# Von Google Fonts → Download → public/fonts/
# Nur WOFF2 Format verwenden
```

### 2-Click-Lösung für Videos

```astro
<!-- Vimeo/YouTube Embeds -->
<div class="video-consent" data-service="youtube">
  <div class="consent-overlay">
    <p>Dieses Video wird von YouTube gehostet. Durch Klick willigen Sie ein.</p>
    <button onclick="loadVideo(this)">Video laden</button>
    <a href="/datenschutz">Datenschutz</a>
  </div>
</div>

<script>
function loadVideo(btn) {
  const container = btn.closest('.video-consent');
  const videoId = container.dataset.videoid;
  container.innerHTML = `<iframe src="https://www.youtube.com/embed/${videoId}"></iframe>`;
}
</script>
```

═══════════════════════════════════════════════════════════════════
## DEPLOYMENT
═══════════════════════════════════════════════════════════════════

### Build & Deploy Script

**Erstelle `deploy.sh` im Projekt:**

```bash
#!/bin/bash
set -e

KUNDE="[kundenname]"
STAGING="/var/www/staging/${KUNDE}"
PRODUCTION="/var/www/kunden/${KUNDE}"
BACKUP="/var/www/backups/${KUNDE}-$(date +%Y-%m-%d-%H%M%S).tar.gz"

echo "🚀 LISN Deploy - ${KUNDE}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Backup (falls Production existiert)
if [ -d "$PRODUCTION" ]; then
  echo "📦 Erstelle Backup..."
  tar -czf "$BACKUP" -C "$PRODUCTION" .
  echo "✅ Backup: $BACKUP"
fi

# Build
echo "🔨 Baue Projekt..."
cd "$STAGING"
pnpm build

# Deploy
echo "🚀 Deploye nach Production..."
mkdir -p "$PRODUCTION"
rsync -av --delete dist/ "$PRODUCTION/"

# Permissions
echo "🔒 Setze Berechtigungen..."
chown -R www-data:www-data "$PRODUCTION"
chmod -R 755 "$PRODUCTION"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Deploy erfolgreich!"
echo "🌐 Live: https://${KUNDE}.at"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
```

**Ausführbar machen:**
```bash
chmod +x deploy.sh
```

**Deployment durchführen:**
```bash
./deploy.sh
```

═══════════════════════════════════════════════════════════════════
## QUALITÄTSSICHERUNG
═══════════════════════════════════════════════════════════════════

### Pre-Deployment Checklist:

**Funktionalität:**
- [ ] Alle Links funktionieren (keine 404)
- [ ] Formular sendet korrekt (Test-Submit)
- [ ] Danke-Seite wird angezeigt
- [ ] Brevo-Integration funktioniert

**Design:**
- [ ] Mobile Responsive (320px - 1920px)
- [ ] Touch-Targets mindestens 44x44px
- [ ] Schriften lesbar (min. 16px)
- [ ] Kontrast ausreichend (WCAG AA)

**Performance:**
- [ ] Lighthouse Score > 90 (alle Kategorien)
- [ ] Bilder optimiert (WebP, lazy loading)
- [ ] Fonts lokal geladen
- [ ] CSS/JS minimiert

**DSGVO:**
- [ ] Cookie Banner funktioniert
- [ ] Fonts lokal (keine Google Fonts CDN)
- [ ] Impressum vollständig
- [ ] Datenschutz vollständig
- [ ] AGB vorhanden

**SEO:**
- [ ] Meta-Tags auf allen Seiten
- [ ] Title eindeutig (< 60 Zeichen)
- [ ] Description eindeutig (< 160 Zeichen)
- [ ] robots.txt vorhanden
- [ ] Sitemap.xml generiert

═══════════════════════════════════════════════════════════════════
## AUSGABE-DATEIEN
═══════════════════════════════════════════════════════════════════

Nach Build IMMER erstellen:

**1. README.md**
```markdown
# [Firmenname] - Website

## Setup
1. Dependencies: `pnpm install`
2. Dev-Server: `pnpm dev`
3. Build: `pnpm build`
4. Deploy: `./deploy.sh`

## Kontakt
[Firmenname]
[E-Mail]
[Telefon]
```

**2. DEPLOYMENT.md**
```markdown
# Deployment-Anleitung

## Voraussetzungen
- SSH-Zugang zum Server
- Berechtigungen für /var/www/kunden/

## Schritte
1. Build lokal testen: `pnpm build && pnpm preview`
2. Deploy-Script ausführen: `./deploy.sh`
3. Website prüfen: https://[kunde].at

## Rollback
Falls Probleme auftreten:
1. Backup finden: `ls /var/www/backups/[kunde]-*`
2. Wiederherstellen: `tar -xzf [backup] -C /var/www/kunden/[kunde]/`
```

**3. MISSING_INFO.md**
```markdown
# Fehlende Informationen

Bitte nachliefern:

## Formular
- [ ] Brevo API-Key
- [ ] Brevo List-ID
- [ ] Ziel-E-Mail für Benachrichtigungen

## Legal
- [ ] UID-Nummer
- [ ] Firmenbuchnummer
- [ ] Zuständige Kammer

## Optional
- [ ] Social Media Links
- [ ] Team-Fotos
- [ ] Referenz-Projekte
```

**4. .env.example**
```env
# Brevo API
BREVO_API_KEY=your_api_key_here

# Site Config
SITE_URL=https://firmenname.at
```

═══════════════════════════════════════════════════════════════════
## TROUBLESHOOTING
═══════════════════════════════════════════════════════════════════

### Problem: pnpm nicht gefunden
```bash
npm install -g pnpm
```

### Problem: Build schlägt fehl
```bash
# Cache löschen
rm -rf node_modules .astro
pnpm install
pnpm build
```

### Problem: Formular sendet nicht
1. `.env` vorhanden?
2. Brevo API-Key korrekt?
3. Network-Tab in Browser-DevTools prüfen

### Problem: Fonts werden nicht geladen
1. Fonts in `/public/fonts/`?
2. Pfad in CSS korrekt?
3. MIME-Type in Nginx korrekt?

═══════════════════════════════════════════════════════════════════
## KONTAKT & SUPPORT
═══════════════════════════════════════════════════════════════════

**LISN GmbH**
Julien
E-Mail: [wird noch ergänzt]
Telefon: [wird noch ergänzt]

**Server-Admin:**
Hetzner VPS - 46.224.27.249
Ubuntu 24.04.3 LTS

═══════════════════════════════════════════════════════════════════

═══════════════════════════════════════════════════════════════════
## ALPINE.JS - KRITISCHE REGELN (NEU 2026-01-12)
═══════════════════════════════════════════════════════════════════

### WICHTIG: Script-Tags in Astro

Astro bündelt `<script>` Tags standardmäßig. Das bedeutet:
- Scripts werden verarbeitet und in separate JS-Dateien ausgelagert
- Globale Funktionen sind NICHT mehr verfügbar für Alpine.js!

**❌ FALSCH (funktioniert NICHT):**
```astro
<div x-data="formHandler()">
  <!-- Alpine template -->
</div>

<script>
function formHandler() {
  return { step: 1, ... };
}
</script>
```

**✅ RICHTIG (mit is:inline):**
```astro
<div x-data="formHandler()">
  <!-- Alpine template -->
</div>

<script is:inline>
function formHandler() {
  return { step: 1, ... };
}
</script>
```

### Warum is:inline?

Mit `is:inline` wird das Script:
1. NICHT von Astro verarbeitet
2. Direkt im HTML ausgegeben
3. Vor Alpine.js init verfügbar
4. Global zugänglich (window.formHandler)

### Wann is:inline verwenden?

✅ **IMMER bei:**
- Alpine.js Komponenten-Funktionen (`x-data="funktionsName()"`)
- Globale Funktionen die im HTML referenziert werden
- Inline Event-Handler

❌ **NICHT bei:**
- Imports aus npm-Paketen
- TypeScript-Code
- Code der gebündelt werden soll

═══════════════════════════════════════════════════════════════════
## STITCH-EXPORT KONVERTIERUNG (NEU 2026-01-12)
═══════════════════════════════════════════════════════════════════

### Was ist Stitch?

Stitch by Google ist ein Design-Tool das HTML/CSS exportiert.
Die Exporte verwenden:
- Google Fonts CDN (muss durch lokale Fonts ersetzt werden)
- Tailwind CSS CDN (muss durch eigenes Tailwind ersetzt werden)
- Vanilla JavaScript (muss zu Alpine.js konvertiert werden)

### Konvertierungs-Checkliste

**1. Farben extrahieren:**
```javascript
// Im Stitch-Export finden:
tailwind.config = {
  theme: {
    extend: {
      colors: {
        "primary": "#3750be",  // ← EXAKT übernehmen!
        "accent-gold": "#C5A065",
      }
    }
  }
}
```

**2. In Tailwind 4.x CSS umsetzen:**
```css
@theme {
  --color-primary: #3750be;
  --color-accent: #C5A065;
  /* ... */
}
```

**3. Fonts lokal laden (DSGVO!):**
```css
/* Stitch lädt von Google CDN - NICHT ERLAUBT */
/* Stattdessen: */
@font-face {
  font-family: 'Noto Sans';
  src: url('/fonts/NotoSans.ttf') format('truetype');
  font-weight: 100 900;  /* Variable Font Range */
  font-display: swap;
}
```

**4. Material Symbols laden:**
```bash
# Download von GitHub
curl -L -o public/fonts/MaterialSymbolsOutlined.woff2   "https://github.com/AdalbertoAKU/materialiconsfix/raw/main/MaterialSymbolsOutlined.woff2"
```

```css
/* In global.css */
@font-face {
  font-family: 'Material Symbols Outlined';
  src: url('/fonts/MaterialSymbolsOutlined.woff2') format('woff2');
  font-weight: 100 700;
  font-display: swap;
}

.material-symbols-outlined {
  font-family: 'Material Symbols Outlined';
  font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
  /* weitere Styles... */
}

.material-symbols-outlined.filled {
  font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24;
}
```

**5. Formular konvertieren (Vanilla JS → Alpine.js):**

Stitch-Export (Vanilla JS):
```html
<div class="choice-card" onclick="selectChoice('neubau')">
```

Astro + Alpine.js:
```html
<div x-data="formHandler()">
  <label :class="formData.type === 'neubau' ? 'selected' : ''">
    <input type="radio" x-model="formData.type" value="neubau" class="sr-only" />
  </label>
</div>

<script is:inline>
function formHandler() {
  return {
    formData: { type: '' },
    // ...
  };
}
</script>
```

### Häufige Fehler bei Konvertierung

| Problem | Ursache | Lösung |
|---------|---------|--------|
| Icons fehlen | Material Symbols Font nicht geladen | Font in public/fonts/ + CSS-Regel |
| Formular funktioniert nicht | Alpine.js-Funktion nicht global | `<script is:inline>` verwenden |
| Falsche Farben | Farbe nicht exakt übernommen | Hex-Werte direkt aus Stitch kopieren |
| Fonts falsch | Google Fonts CDN statt lokal | TTF/WOFF2 herunterladen + @font-face |
| Tailwind Klassen fehlen | Tailwind 3 vs 4 Syntax | `@theme` statt `theme.extend` |

═══════════════════════════════════════════════════════════════════
## TAILWIND CSS 4.x MIGRATION (NEU 2026-01-12)
═══════════════════════════════════════════════════════════════════

### Wichtige Änderungen von v3 zu v4

**Import:**
```css
/* v3 */
@tailwind base;
@tailwind components;
@tailwind utilities;

/* v4 */
@import "tailwindcss";
```

**Theme-Konfiguration:**
```css
/* v3 (tailwind.config.js) */
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: '#3750be',
      }
    }
  }
}

/* v4 (global.css) */
@theme {
  --color-primary: #3750be;
}
```

**CSS Variable Referenz:**
```css
/* v3 */
.element { color: theme('colors.primary'); }

/* v4 */
.element { color: var(--color-primary); }
```

### Utility-Klassen Referenz

| v3 Klasse | v4 Klasse | Anmerkung |
|-----------|-----------|-----------|
| `bg-primary` | `bg-primary` | Gleich, wenn --color-primary definiert |
| `text-accent-gold` | `text-accent` | Nur wenn --color-accent definiert |


═══════════════════════════════════════════════════════════════════
## MATERIAL SYMBOLS FONT - KORREKTER DOWNLOAD (UPDATE 2026-01-12)
═══════════════════════════════════════════════════════════════════

### WICHTIG: GitHub Raw-Links funktionieren NICHT!

❌ **FALSCH (liefert HTML statt Font):**
```bash
# Diese URLs liefern HTML-Redirects, NICHT die Font-Datei!
curl -L -o font.woff2 'https://github.com/user/repo/raw/main/font.woff2'
```

✅ **RICHTIG (direkt von Google Fonts CDN):**
```bash
# Vollständige Material Symbols Outlined (3.4MB, alle Icons)
curl -L -o public/fonts/MaterialSymbolsOutlined.woff2   'https://fonts.gstatic.com/s/materialsymbolsoutlined/v252/kJEhBvYX7BgnkSrUwT8OhrdQw4oELdPIeeII9v6oFsI.woff2'
```

### Verifizierung

Nach Download IMMER prüfen:
```bash
# Korrekte WOFF2-Datei beginnt mit wOF2
xxd fontfile.woff2 | head -1
# Erwartete Ausgabe: 00000000: 774f 4632 ...  wOF2.....

# Wenn HTML erscheint (<!DOCTYPE), ist der Download FEHLGESCHLAGEN!
```

### Alternative: Subset für kleinere Dateigröße

Wenn nur bestimmte Icons benötigt werden:
1. https://fonts.google.com/icons öffnen
2. Icons auswählen
3. Download → WOFF2 herunterladen
4. In `public/fonts/` kopieren


═══════════════════════════════════════════════════════════════════
## KRITISCHE REGEL: STITCH-DESIGN ÜBERNEHMEN (UPDATE 2026-01-12)
═══════════════════════════════════════════════════════════════════

### WICHTIGSTE REGEL BEI STITCH-KONVERTIERUNG

**Wenn Stitch-HTML-Dateien im Input-Ordner liegen:**
→ Das EXAKTE Design muss übernommen werden!
→ NIEMALS ein neues/vereinfachtes Design erstellen!
→ Pixel-genau konvertieren, nur Tech-Stack ändern (HTML → Astro)

### Workflow bei Stitch-Export

1. **ZUERST alle HTML-Dateien lesen:**
   ```bash
   ls inputs/*.html
   cat inputs/index.html
   cat inputs/beratung.html  # Falls Formular existiert!
   cat inputs/*.html
   ```

2. **Design-Elemente identifizieren:**
   - Anzahl Schritte im Formular
   - Progress-Bar Design
   - Choice-Card Layout
   - Icons und deren Position
   - Farben, Abstände, Typografie
   - Trust-Badges
   - Sidebar-Layouts

3. **1:1 konvertieren:**
   - HTML-Struktur beibehalten
   - CSS-Klassen übernehmen
   - JavaScript → Alpine.js konvertieren
   - Bilder/Icons übernehmen

### ❌ FALSCH (was ich gemacht habe):

```
Input: beratung.html mit 4-Schritt-Formular, Progress-Circles, 
       Choice-Cards mit Icons, Sidebar im letzten Schritt

Output: Neues 3-Schritt-Formular mit einfacher Progress-Bar,
        Radio-Buttons ohne Icons, kein Sidebar
        
→ KOMPLETT FALSCH! Design wurde ignoriert!
```

### ✅ RICHTIG:

```
Input: beratung.html mit 4-Schritt-Formular, Progress-Circles,
       Choice-Cards mit Icons, Sidebar im letzten Schritt

Output: Exakt gleiches 4-Schritt-Formular mit Progress-Circles,
        Choice-Cards mit Icons, Sidebar im letzten Schritt
        Nur: Vanilla JS → Alpine.js, Google Fonts → Lokal
        
→ KORREKT! Design wurde 1:1 übernommen!
```

### Checkliste vor Konvertierung

- [ ] Alle HTML-Dateien im Input-Ordner gelesen?
- [ ] Formular-Struktur verstanden (Anzahl Schritte)?
- [ ] UI-Komponenten identifiziert (Cards, Progress, etc.)?
- [ ] Design-Entscheidung: Übernehmen oder neu?
  - Stitch-Dateien vorhanden → ÜBERNEHMEN
  - Keine Dateien → Freie Hand (Standard-Template)

### Warum ist das wichtig?

1. **Kunde hat Design bereits abgenommen** - Stitch-Export wurde vom Kunden gesehen
2. **Konsistenz** - Alle Seiten müssen zusammenpassen
3. **Zeitersparnis** - Design existiert bereits, nur konvertieren
4. **Qualität** - Stitch-Designs sind durchdacht und getestet


═══════════════════════════════════════════════════════════════════
## ASTRO SSR DEPLOYMENT (UPDATE 2026-01-12)
═══════════════════════════════════════════════════════════════════

### Wann SSR verwenden?

**SSR erforderlich für:**
- API-Endpoints (z.B. Formular-Submission)
- Server-side Datenverarbeitung
- Brevo/E-Mail Integration

**Static reicht für:**
- Reine Informationsseiten ohne Backend

### Astro Config für SSR

```javascript
// astro.config.mjs
import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';
import node from '@astrojs/node';

export default defineConfig({
  output: 'server',  // NICHT 'hybrid' - wurde in neueren Versionen entfernt!
  adapter: node({
    mode: 'standalone'
  }),
  vite: {
    plugins: [tailwindcss()]
  }
});
```

### Dependencies installieren

```bash
pnpm add @astrojs/node
```

### PM2 Ecosystem Config

```javascript
// ecosystem.config.cjs
module.exports = {
  apps: [{
    name: 'projektname',
    script: './dist/server/entry.mjs',
    cwd: '/var/www/staging/projektname',
    env: {
      NODE_ENV: 'production',
      HOST: '127.0.0.1',
      PORT: 4321
    },
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '500M'
  }]
};
```

### PM2 Befehle

```bash
# Starten
pm2 start ecosystem.config.cjs

# Status prüfen
pm2 status

# Logs anzeigen
pm2 logs projektname

# Neustarten nach Code-Änderungen
pm2 restart projektname

# Autostart einrichten
pm2 startup systemd -u root --hp /root
pm2 save
```

### Nginx Reverse Proxy

```nginx
server {
    listen 80;
    server_name example.com;
    
    location / {
        proxy_pass http://127.0.0.1:4321;
        proxy_http_version 1.1;
        proxy_set_header Upgrade ;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host ;
        proxy_set_header X-Real-IP ;
        proxy_set_header X-Forwarded-For ;
        proxy_set_header X-Forwarded-Proto ;
        proxy_cache_bypass ;
    }
}
```

### .env Datei

```bash
# .env MUSS ins dist/ Verzeichnis kopiert werden!
cp .env dist/

# Oder beim Build-Script automatisch:
pnpm build && cp .env dist/
```

### Deployment-Ablauf (SSR)

1. `pnpm build`
2. `cp .env dist/`
3. `pm2 restart projektname`



═══════════════════════════════════════════════════════════════════
## CUSTOMER PREVIEW SYSTEM (UPDATE 2026-01-12)
═══════════════════════════════════════════════════════════════════

### Übersicht

Für Kunden-Previews verwenden wir eine zentrale Subdomain:
`customers.lisn-agentur.com/[projekt-slug]`

**Verhalten:**
- `customers.lisn-agentur.com` → Redirect zu `lisn-agentur.com`
- `customers.lisn-agentur.com/forstinger-haus-bad` → Preview der Seite

### Astro Base-Path Konfiguration

Für Preview muss ein `base` Pfad gesetzt werden:

```javascript
// astro.config.mjs (PREVIEW)
export default defineConfig({
  base: '/forstinger-haus-bad',  // Preview-Pfad
  output: 'server',
  adapter: node({ mode: 'standalone' }),
  // ...
});
```

### Beim Live-Gang

1. `base` aus astro.config.mjs ENTFERNEN
2. Neu builden: `pnpm build`
3. PM2 neu starten: `pm2 restart [app]`
4. Eigene Domain-Config in Nginx erstellen

### Nginx für Preview (customers.lisn-agentur.com)

```nginx
server {
    listen 80;
    server_name customers.lisn-agentur.com;

    # Root → Redirect zu LISN
    location = / {
        return 301 https://lisn-agentur.com;
    }

    # Projekt-Preview
    location /forstinger-haus-bad {
        proxy_pass http://127.0.0.1:4321;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Catch-all → Redirect zu LISN
    location / {
        return 301 https://lisn-agentur.com;
    }
}
```

### Neues Projekt hinzufügen

1. Projekt erstellen mit `base: '/projekt-slug'` in astro.config.mjs
2. PM2 auf neuem Port starten (4322, 4323, ...)
3. Location-Block in `/etc/nginx/sites-available/customers.lisn-agentur.com` hinzufügen
4. `nginx -t && systemctl reload nginx`

═══════════════════════════════════════════════════════════════════
## LOGO IM HEADER/FOOTER (UPDATE 2026-01-12)
═══════════════════════════════════════════════════════════════════

### Logo einbinden

Logos gehören nach `/public/images/logo.webp` (oder .svg, .png)

**Header.astro:**
```astro
<a href="/" class="flex items-center">
  <img
    src="/images/logo.webp"
    alt="Firmenname"
    class="h-12 sm:h-14 w-auto"
  />
</a>
```

**Footer.astro:**
```astro
<a href="/" class="inline-block mb-4">
  <img
    src="/images/logo.webp"
    alt="Firmenname"
    class="h-10 w-auto"
  />
</a>
```

### Logo-Größen

| Position | Mobile | Desktop |
|----------|--------|---------|
| Header   | h-12 (48px) | h-14 (56px) |
| Footer   | h-10 (40px) | h-10 (40px) |

═══════════════════════════════════════════════════════════════════
## FORMULAR UX-PATTERNS (UPDATE 2026-01-12)
═══════════════════════════════════════════════════════════════════

### Auto-Advance nach Auswahl

Bei Single-Choice Steps (nur eine Option möglich) automatisch
weiter zum nächsten Schritt nach kurzer Verzögerung:

```javascript
function formHandler() {
  return {
    step: 1,
    formData: { projektart: '', zeitrahmen: '', termin: '' },

    // Auto-Weiter nach Auswahl
    selectProjektart(value) {
      this.formData.projektart = value;
      setTimeout(() => this.nextStep(), 300);  // 300ms Verzögerung
    },

    selectZeitrahmen(value) {
      this.formData.zeitrahmen = value;
      setTimeout(() => this.nextStep(), 300);
    },

    selectTermin(value) {
      this.formData.termin = value;
      setTimeout(() => this.nextStep(), 300);
    },

    nextStep() {
      if (this.step < 4) {
        this.step++;
        this.updateProgressBar();
        window.scrollTo({ top: 0, behavior: 'smooth' });
      }
    },
    // ...
  };
}
```

**HTML:**
```html
<div @click="selectProjektart('neubau')" ...>
  Neubau
</div>
```

### Mobile Navigation Layout

Auf Mobile sollten Buttons gestapelt werden mit "Weiter" oben:

```html
<div class="flex flex-col sm:flex-row justify-between items-stretch sm:items-center gap-4">
  <!-- Zurück: unten auf Mobile, links auf Desktop -->
  <button class="order-2 sm:order-1 py-3 sm:py-0" @click="prevStep()">
    <span class="material-symbols-outlined">arrow_back</span>
    Zurück
  </button>

  <!-- Weiter: oben auf Mobile, rechts auf Desktop -->
  <button class="order-1 sm:order-2 bg-accent text-white px-8 py-3 rounded-lg">
    Weiter zu Schritt X
    <span class="material-symbols-outlined">arrow_forward</span>
  </button>
</div>
```

### Datenschutz-Checkbox mit klickbarem Label

Der gesamte Text soll die Checkbox aktivieren:

```html
<label class="flex items-start gap-3 cursor-pointer"
       @click="formData.datenschutz = !formData.datenschutz">
  <input
    type="checkbox"
    x-model="formData.datenschutz"
    class="mt-1 w-5 h-5 cursor-pointer"
    @click.stop
  />
  <span class="text-sm select-none">
    Ich stimme den
    <a href="/datenschutz" class="text-primary hover:underline" @click.stop>
      Datenschutzbestimmungen
    </a> zu.
  </span>
</label>
```

**Wichtig:** `@click.stop` auf dem Link verhindert, dass ein Klick
auf "Datenschutzbestimmungen" die Checkbox toggled.

### Progress Bar mit gleichmäßigen Abständen

```html
<div class="flex items-center justify-center">
  <!-- Step 1 -->
  <div class="flex flex-col items-center">
    <div class="progress-circle ...">1</div>
    <span class="progress-label ...">Projekt</span>
  </div>

  <!-- Line 1-2 (feste Breite!) -->
  <div class="w-16 sm:w-24 h-1 bg-gray-200 mx-2 sm:mx-4 mb-6"></div>

  <!-- Step 2 -->
  <div class="flex flex-col items-center">
    <div class="progress-circle ...">2</div>
    <span class="progress-label ...">Zeitrahmen</span>
  </div>

  <!-- usw. -->
</div>
```

**NICHT:** flex-1 auf den Containern verwenden (führt zu ungleichen Abständen)


═══════════════════════════════════════════════════════════════════
## ⚠️ BASE_URL - KRITISCH BEI PREVIEW (UPDATE 2026-01-12)
═══════════════════════════════════════════════════════════════════

**WICHTIG:** Neue separate Dokumentation erstellt!

Siehe: **BASE_URL_GUIDE.md** für vollständige Anleitung.

### Kurzfassung

Bei Preview unter `customers.lisn-agentur.com/projekt-slug`:

1. `base: '/projekt-slug/'` in astro.config.mjs (MIT Trailing Slash!)
2. `const base = import.meta.env.BASE_URL;` in JEDER Komponente
3. `src={base + 'images/...'}` und `href={base + '...'}` für alle Pfade
4. Nginx Redirect: `/projekt-slug` → `/projekt-slug/`

### Dateien die angepasst werden müssen

- Header.astro, Footer.astro (Logo, Nav-Links, CTA)
- Hero.astro (Bild, CTA)
- Gallery.astro (alle Bilder)
- Testimonials.astro (Avatar)
- CTA.astro, Process.astro (Buttons)
- danke.astro (Zurück-Link)
- formular.astro (Datenschutz-Link)



═══════════════════════════════════════════════════════════════════
## LIGHTBOX/GALERIE MIT ALPINE.JS (UPDATE 2026-01-12)
═══════════════════════════════════════════════════════════════════

### Problem: define:vars funktioniert NICHT mit is:inline

❌ **FALSCH (Daten sind nicht verfügbar im Script):**
```astro
<script is:inline define:vars={{ stories, base }}>
  function myComponent() {
    // stories und base sind hier UNDEFINED!
    const story = stories.find(s => s.id === id);
  }
</script>
```

✅ **RICHTIG (Daten als JSON in versteckte Script-Tags):**
```astro
---
const data = [{ id: "foo", images: [...] }];
const base = import.meta.env.BASE_URL;
---

<!-- Daten als JSON einbetten -->
<script type="application/json" id="gallery-data" set:html={JSON.stringify(data)}></script>
<script type="text/plain" id="base-url" set:html={base}></script>

<script is:inline>
  function myComponent() {
    // Daten aus DOM lesen
    const data = JSON.parse(document.getElementById('gallery-data').textContent);
    const baseUrl = document.getElementById('base-url').textContent;
    
    return {
      data: data,
      baseUrl: baseUrl,
      // ... rest of component
    };
  }
</script>
```

### Vollständiges Lightbox-Pattern

**1. Datenstruktur im Frontmatter:**
```javascript
const stories = [
  {
    id: "kunde-1",
    images: [
      { src: "bild1.webp", label: "Vorher" },
      { src: "bild2.webp", label: "Nachher" }
    ]
  }
];
```

**2. Klickbare Bilder mit Alpine.js:**
```html
<section x-data="storyGallery()">
  {stories.map((story) => (
    <div>
      {story.images.map((img, idx) => (
        <button @click={`openGallery('${story.id}', ${idx})`} class="group">
          <img src={base + 'images/' + img.src} />
          <!-- Zoom-Icon bei Hover -->
          <div class="opacity-0 group-hover:opacity-100">
            <span class="material-symbols-outlined">zoom_in</span>
          </div>
        </button>
      ))}
    </div>
  ))}

  <!-- Lightbox Modal -->
  <div x-show="isOpen" x-cloak class="fixed inset-0 z-[100]"
       @keydown.escape.window="close()"
       @keydown.arrow-left.window="prev()"
       @keydown.arrow-right.window="next()">
    
    <!-- Backdrop -->
    <div class="absolute inset-0 bg-black/90" @click="close()"></div>
    
    <!-- Bild -->
    <img :src="currentImage?.src" class="max-h-[80vh] object-contain" />
    
    <!-- Navigation -->
    <button @click="prev()">←</button>
    <button @click="next()">→</button>
    
    <!-- Thumbnails -->
    <template x-for="(img, idx) in images">
      <button @click="currentIndex = idx" :class="idx === currentIndex ? 'active' : ''">
        <img :src="img.src" />
      </button>
    </template>
  </div>
</section>
```

**3. Alpine.js Component:**
```javascript
function storyGallery() {
  const storiesData = JSON.parse(document.getElementById('gallery-data').textContent);
  const baseUrl = document.getElementById('base-url').textContent;

  return {
    isOpen: false,
    images: [],
    currentIndex: 0,
    storiesData: storiesData,
    baseUrl: baseUrl,

    get currentImage() {
      return this.images[this.currentIndex] || null;
    },

    openGallery(storyId, imageIndex) {
      const story = this.storiesData.find(s => s.id === storyId);
      if (story) {
        this.images = story.images.map(img => ({
          src: this.baseUrl + 'images/' + img.src,
          label: img.label
        }));
        this.currentIndex = imageIndex;
        this.isOpen = true;
        document.body.style.overflow = 'hidden';
      }
    },

    close() {
      this.isOpen = false;
      document.body.style.overflow = '';
    },

    prev() {
      this.currentIndex = (this.currentIndex - 1 + this.images.length) % this.images.length;
    },

    next() {
      this.currentIndex = (this.currentIndex + 1) % this.images.length;
    }
  };
}
```

### Features dieser Implementierung

- ✅ Klickbare Bilder mit Zoom-Icon bei Hover
- ✅ Fullscreen Modal mit Backdrop
- ✅ Keyboard-Navigation (←/→/Esc)
- ✅ Thumbnail-Leiste zur schnellen Navigation
- ✅ Bild-Counter (z.B. "2 / 4")
- ✅ Labels pro Bild (Vorher/Nachher)
- ✅ Body-Scroll wird bei geöffneter Lightbox deaktiviert
- ✅ Funktioniert mit BASE_URL für Preview-Umgebungen

### Wichtige CSS-Klassen

```css
[x-cloak] { display: none !important; }
```



═══════════════════════════════════════════════════════════════════
## ALPINE.JS - KLASSEN MIT BINDESTRICH (UPDATE 2026-01-12)
═══════════════════════════════════════════════════════════════════

### Problem: Syntax-Fehler bei Tailwind-Klassen

Tailwind-Klassen wie `rotate-180`, `translate-x-full`, `bg-black/50` enthalten
Bindestriche oder Schrägstriche. Diese MÜSSEN in Alpine.js x-bind:class in 
Anführungszeichen gesetzt werden!

**❌ FALSCH:**
```html
<span x-bind:class="{ rotate-180: isOpen }">Icon</span>
<!-- Fehler: Unexpected token '-' -->
```

**✅ RICHTIG:**
```html
<span x-bind:class="{ 'rotate-180': isOpen }">Icon</span>
```

### Weitere Beispiele

```html
<!-- Alle Klassen mit Sonderzeichen brauchen Quotes -->
<div x-bind:class="{ 
  'translate-x-full': isOpen,
  'bg-black/50': showOverlay,
  '-mt-4': hasNegativeMargin,
  'hover:bg-primary': isHoverable
}">
```

### In Astro mit dynamischen Werten

```astro
{items.map((item, index) => (
  <button x-bind:class={"{ 'rotate-180': activeIndex === " + index + " }"}>
    <span class="material-symbols-outlined">expand_more</span>
  </button>
))}
```


═══════════════════════════════════════════════════════════════════
## META PIXEL + CONVERSIONS API MIT KLARO (UPDATE 2026-01-12)
═══════════════════════════════════════════════════════════════════

### Übersicht

Meta Pixel DSGVO-konform mit Klaro Cookie Banner + Server-seitige 
Conversions API (CAPI) für bessere Attribution.

### 1. Klaro Service für Meta Pixel

**WICHTIG:** NICHT fbq vorab initialisieren! Der Standard Meta Pixel Code 
erstellt seine eigene fbq-Funktion. Eine Vorab-Initialisierung führt zu:
- "Multiple pixels with conflicting versions"
- Events werden nicht gesendet

```javascript
// klaro-config.js - Meta Pixel Service
{
    name: 'meta-pixel',
    title: 'Meta Pixel (Facebook)',
    purposes: ['marketing'],
    required: false,
    default: false,
    description: 'Ermöglicht die Messung von Werbeerfolg auf Facebook und Instagram.',
    cookies: ['_fbp', '_fbc', 'fr'],

    onInit: function() {
        // NUR Flags setzen, NICHT fbq initialisieren!
        window.metaPixelConsent = false;
        window.metaPixelLoaded = false;
    },

    onAccept: function() {
        window.metaPixelConsent = true;

        if (window.metaPixelLoaded) {
            // Pixel bereits geladen
            if (typeof fbq === 'function') {
                fbq('consent', 'grant');
                fbq('track', 'PageView');
            }
            return;
        }

        // Standard Meta Pixel Code (EXAKT wie von Meta)
        !function(f,b,e,v,n,t,s)
        {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
        n.callMethod.apply(n,arguments):n.queue.push(arguments)};
        if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
        n.queue=[];t=b.createElement(e);t.async=!0;
        t.src=v;s=b.getElementsByTagName(e)[0];
        s.parentNode.insertBefore(t,s)}(window, document,'script',
        'https://connect.facebook.net/en_US/fbevents.js');

        fbq('init', window.META_PIXEL_ID);
        fbq('consent', 'grant');
        fbq('track', 'PageView');

        window.metaPixelLoaded = true;
        window.dispatchEvent(new CustomEvent('metaPixelReady'));
    },

    onDecline: function() {
        window.metaPixelConsent = false;
        if (typeof fbq === 'function') {
            fbq('consent', 'revoke');
        }
        // Cookies löschen
        document.cookie = '_fbp=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
        document.cookie = '_fbc=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
    }
}
```

### 2. KEIN noscript Meta Pixel!

**❌ NICHT DSGVO-konform:**
```html
<!-- NICHT verwenden - feuert ohne Consent! -->
<noscript>
  <img src="https://www.facebook.com/tr?id=PIXEL_ID&ev=PageView&noscript=1" />
</noscript>
```

Das noscript-Tag feuert IMMER, auch ohne Cookie-Consent. Daher weglassen.

### 3. Events auf Unterseiten (ViewContent, Lead)

```html
<!-- z.B. auf /formular für ViewContent -->
<script is:inline>
(function() {
  function fireViewContent() {
    if (typeof fbq !== 'undefined' && window.metaPixelConsent) {
      fbq('track', 'ViewContent', {
        content_name: 'Beratungsformular',
        content_category: 'Lead Generation'
      });
    }
  }

  // Wenn Pixel bereits geladen
  if (typeof fbq !== 'undefined' && window.metaPixelLoaded && window.metaPixelConsent) {
    fireViewContent();
  } else {
    // Warte auf metaPixelReady Event
    window.addEventListener('metaPixelReady', fireViewContent);
  }
})();
</script>
```

### 4. Conversions API (Server-Side) für Lead Event

Für bessere Attribution: Lead-Event sowohl Browser-seitig als auch Server-seitig senden.
Wichtig: Gleiche event_id für Deduplizierung!

**Browser-Seite (Formular Submit):**
```javascript
// Event-ID generieren
var eventId = 'evt_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);

// An API senden
fetch('/api/submit-form', {
  method: 'POST',
  body: JSON.stringify({
    ...formData,
    event_id: eventId,
    fbp: getCookie('_fbp'),
    fbc: getCookie('_fbc'),
    client_user_agent: navigator.userAgent
  })
});

// In sessionStorage für Browser-Event auf /danke
sessionStorage.setItem('lead_event_id', eventId);

// Redirect
window.location.href = '/danke';
```

**Server-Seite (API Endpoint):**
```typescript
// submit-form.ts
import { createHash } from 'crypto';

function sha256Hash(value: string): string {
  return createHash('sha256').update(value.toLowerCase().trim()).digest('hex');
}

// Nach E-Mail senden: Conversions API Call
const eventData = {
  data: [{
    event_name: 'Lead',
    event_time: Math.floor(Date.now() / 1000),
    event_id: formData.event_id,  // Gleiche ID wie Browser!
    event_source_url: formData.event_source_url,
    action_source: 'website',
    user_data: {
      em: [sha256Hash(formData.email)],
      ph: [sha256Hash(normalizePhone(formData.telefon))],
      fn: [sha256Hash(firstName)],
      ln: [sha256Hash(lastName)],
      country: [sha256Hash('at')],
      fbp: formData.fbp,
      fbc: formData.fbc,
      client_ip_address: clientAddress,
      client_user_agent: formData.client_user_agent
    },
    custom_data: {
      content_name: 'Beratungsanfrage'
    }
  }]
};

await fetch(
  `https://graph.facebook.com/v18.0/${PIXEL_ID}/events?access_token=${ACCESS_TOKEN}`,
  { method: 'POST', body: JSON.stringify(eventData) }
);
```

**Browser-Seite (/danke):**
```javascript
// Lead Event mit gleicher event_id wie Server
var eventId = sessionStorage.getItem('lead_event_id');
sessionStorage.removeItem('lead_event_id');

if (eventId && typeof fbq !== 'undefined' && window.metaPixelConsent) {
  fbq('track', 'Lead', {
    content_name: 'Beratungsanfrage'
  }, {
    eventID: eventId  // Für Deduplizierung
  });
}
```

### 5. Environment Variables

```env
META_PIXEL_ID=920933450513626
META_ACCESS_TOKEN=EAAd2XARzOv8BO...
```

### Event-Übersicht

| Event | Seite | Typ | Trigger |
|-------|-------|-----|---------|
| PageView | Alle | Browser | Bei Consent (Klaro) |
| ViewContent | /formular | Browser | Seitenaufruf |
| Lead | /danke | Browser + Server | Form Submit |

### Debugging

- Browser Console: `[Meta Pixel] Initialized with consent`
- Meta Pixel Helper Extension (Chrome)
- Meta Events Manager > Test Events
- Server Logs: `pm2 logs [app-name]`



═══════════════════════════════════════════════════════════════════
## ALPINE.JS - KLASSEN MIT BINDESTRICH (UPDATE 2026-01-12)
═══════════════════════════════════════════════════════════════════

### Problem: Syntax Error bei Klassen mit Bindestrich

Alpine.js interpretiert Bindestriche in Klassennamen als JavaScript-Minus!

**FALSCH (JavaScript Error):**
```html
<span x-bind:class="{ rotate-180: isOpen }">
<!-- Error: Unexpected token '-' -->
```

**RICHTIG (String-Key verwenden):**
```html
<span x-bind:class="{ 'rotate-180': isOpen }">
```

### Regel

IMMER Anfuehrungszeichen um Klassennamen mit:
- Bindestrichen: `'text-red-500'`
- Punkten: `'bg-primary.dark'`
- Sonderzeichen: `'hover:scale-105'`

### Beispiele

```html
<!-- Einfache Klasse ohne Sonderzeichen - OK ohne Quotes -->
<div x-bind:class="{ active: isActive }">

<!-- Klasse mit Bindestrich - MUSS Quotes haben -->
<div x-bind:class="{ 'is-active': isActive }">

<!-- Mehrere Klassen -->
<div x-bind:class="{
  'bg-primary': isPrimary,
  'text-white': isPrimary,
  'rotate-180': isOpen
}">

<!-- In Astro mit dynamischem Index -->
<span x-bind:class={"{ 'rotate-180': activeIndex === " + index + " }"}>
```


═══════════════════════════════════════════════════════════════════
## META PIXEL + CONVERSIONS API MIT KLARO (NEU 2026-01-12)
═══════════════════════════════════════════════════════════════════

### Uebersicht

Meta Pixel besteht aus zwei Teilen:
1. **Browser Pixel** - JavaScript auf der Website (fbevents.js)
2. **Conversions API (CAPI)** - Server-to-Server Kommunikation

Beide muessen mit derselben `event_id` dedupliziert werden!

### Voraussetzungen

1. Meta Business Manager Account
2. Pixel ID (z.B. `920933450513626`)
3. Conversions API Access Token (Einstellungen -> Conversions API -> Token generieren)

### Klaro Service Konfiguration

**WICHTIG: fbq NIEMALS vorab initialisieren!**

```javascript
// klaro-config.js
window.META_PIXEL_ID = '920933450513626';
window.metaPixelConsent = false;
window.metaPixelLoaded = false;

var klaroConfig = {
    // ... andere Config ...
    services: [
        // ... andere Services ...
        {
            name: 'meta-pixel',
            title: 'Meta Pixel (Facebook)',
            purposes: ['marketing'],
            required: false,
            default: false,
            description: 'Ermoeglicht die Messung von Werbeerfolg auf Facebook und Instagram.',
            cookies: ['_fbp', '_fbc', 'fr'],

            onInit: function() {
                // NUR Flags setzen, NICHT fbq initialisieren!
                window.metaPixelConsent = false;
                window.metaPixelLoaded = false;
            },

            onAccept: function() {
                window.metaPixelConsent = true;

                if (window.metaPixelLoaded) {
                    if (typeof fbq === 'function') {
                        fbq('consent', 'grant');
                        fbq('track', 'PageView');
                    }
                    return;
                }

                // Standard Meta Pixel Code MIT Error Handling
                !function(f,b,e,v,n,t,s)
                {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
                n.callMethod.apply(n,arguments):n.queue.push(arguments)};
                if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
                n.queue=[];t=b.createElement(e);t.async=!0;
                t.src=v;
                t.onerror=function(){
                    console.log('[Meta Pixel] Script blocked - Ad-Blocker active');
                    window.metaPixelLoaded = false;
                };
                t.onload=function(){
                    window.metaPixelLoaded = true;
                    window.dispatchEvent(new CustomEvent('metaPixelReady'));
                };
                s=b.getElementsByTagName(e)[0];
                s.parentNode.insertBefore(t,s)}(window, document,'script',
                'https://connect.facebook.net/en_US/fbevents.js');

                fbq('init', window.META_PIXEL_ID);
                fbq('consent', 'grant');
                fbq('track', 'PageView');
            },

            onDecline: function() {
                window.metaPixelConsent = false;
                if (typeof fbq === 'function') {
                    fbq('consent', 'revoke');
                }
            }
        }
    ]
};
```

### Haeufige Fehler und Loesungen

| Fehler | Ursache | Loesung |
|--------|---------|---------|
| "Multiple pixels with conflicting versions" | fbq wurde vorab initialisiert | NUR Standard-Code in onAccept |
| "pixel has not been activated" | Initialisierung vor Consent | Pixel-Code NUR in onAccept laden |
| "An unknown error occurred" | Ad-Blocker aktiv | Normal - User hat Blocker |

### Event Tracking auf Seiten

**ViewContent (z.B. Formular-Seite):**
```html
<script is:inline>
(function() {
    function fireViewContent() {
        if (typeof fbq !== 'undefined' && window.metaPixelConsent) {
            fbq('track', 'ViewContent', {
                content_name: 'Beratungsformular',
                content_category: 'Lead Generation'
            });
        }
    }

    if (window.metaPixelLoaded && window.metaPixelConsent) {
        fireViewContent();
    } else {
        window.addEventListener('metaPixelReady', fireViewContent);
    }
})();
</script>
```

**Lead Event (Danke-Seite) mit Deduplizierung:**
```html
<script is:inline>
(function() {
    var hasFired = false;

    function fireLeadEvent() {
        if (hasFired) return;

        var eventId = sessionStorage.getItem('lead_event_id');
        if (!eventId) return; // Direktzugriff ohne Formular

        if (typeof fbq === 'function' && window.metaPixelConsent) {
            hasFired = true;
            sessionStorage.removeItem('lead_event_id');

            fbq('track', 'Lead', {
                content_name: 'Beratungsanfrage'
            }, {
                eventID: eventId  // WICHTIG fuer Deduplizierung!
            });
        }
    }

    window.addEventListener('metaPixelReady', fireLeadEvent);

    if (window.metaPixelLoaded && window.metaPixelConsent) {
        fireLeadEvent();
    }

    // Polling Fallback fuer Race Conditions
    var attempts = 0;
    var poll = setInterval(function() {
        if (hasFired || ++attempts >= 20) {
            clearInterval(poll);
            return;
        }
        if (window.metaPixelLoaded && window.metaPixelConsent) {
            fireLeadEvent();
        }
    }, 500);
})();
</script>
```

### Conversions API (Server-Side)

**Environment Variables (.env):**
```
META_PIXEL_ID=920933450513626
META_ACCESS_TOKEN=EAAd2XARz...langerToken...
```

**API Endpoint (submit-form.ts):**
```typescript
import { createHash } from 'crypto';

// SHA256 Hash fuer User-Daten (Meta Requirement)
function sha256Hash(value: string): string {
    return createHash('sha256')
        .update(value.toLowerCase().trim())
        .digest('hex');
}

// Telefonnummer normalisieren (nur Ziffern)
function normalizePhone(phone: string): string {
    return phone.replace(/[^0-9]/g, '');
}

export const POST: APIRoute = async ({ request, clientAddress }) => {
    const formData = await request.json();

    // 1. Formular verarbeiten (Brevo etc.)
    // ...

    // 2. Conversions API Call
    const META_PIXEL_ID = import.meta.env.META_PIXEL_ID;
    const META_ACCESS_TOKEN = import.meta.env.META_ACCESS_TOKEN;

    if (META_PIXEL_ID && META_ACCESS_TOKEN) {
        const eventData = {
            data: [{
                event_name: 'Lead',
                event_time: Math.floor(Date.now() / 1000),
                event_id: formData.event_id,  // GLEICHE ID wie Browser!
                action_source: 'website',
                event_source_url: request.headers.get('referer'),
                user_data: {
                    em: [sha256Hash(formData.email)],
                    ph: formData.telefon ? [sha256Hash(normalizePhone(formData.telefon))] : undefined,
                    fn: formData.vorname ? [sha256Hash(formData.vorname)] : undefined,
                    ln: formData.nachname ? [sha256Hash(formData.nachname)] : undefined,
                    client_ip_address: clientAddress,
                    client_user_agent: request.headers.get('user-agent'),
                    fbp: formData.fbp,  // _fbp Cookie vom Browser
                    fbc: formData.fbc   // _fbc Cookie vom Browser
                },
                custom_data: {
                    content_name: 'Beratungsanfrage',
                    content_category: formData.anfrageTyp
                }
            }]
        };

        await fetch(
            `https://graph.facebook.com/v18.0/${META_PIXEL_ID}/events?access_token=${META_ACCESS_TOKEN}`,
            {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(eventData)
            }
        );
    }

    return new Response(JSON.stringify({ success: true }));
};
```

### Formular: Event-ID und Cookies senden

```javascript
// Im Formular-Handler (Alpine.js)
async submitForm() {
    // Event-ID generieren
    var eventId = 'evt_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);

    // Fuer Danke-Seite speichern
    sessionStorage.setItem('lead_event_id', eventId);

    // _fbp und _fbc Cookies auslesen
    function getCookie(name) {
        var match = document.cookie.match(new RegExp('(^| )' + name + '=([^;]+)'));
        return match ? match[2] : null;
    }

    // An API senden
    await fetch('/api/submit-form', {
        method: 'POST',
        body: JSON.stringify({
            ...this.formData,
            event_id: eventId,
            fbp: getCookie('_fbp'),
            fbc: getCookie('_fbc'),
            client_user_agent: navigator.userAgent
        })
    });

    window.location.href = '/danke';
}
```

### Deduplizierung verstehen

```
+------------------+          +------------------+
|  Browser Pixel   |          |  Conversions     |
|  (fbevents.js)   |          |  API (Server)    |
+--------+---------+          +--------+---------+
         |                             |
         | event_id: "evt_123"         | event_id: "evt_123"
         |                             |
         +-------------+---------------+
                       |
                       v
               +---------------+
               |  Meta Server  |
               |  dedupliziert |
               |  = 1 Event    |
               +---------------+
```

OHNE gleiche event_id -> Meta zaehlt 2 Events (falsche Daten!)
MIT gleicher event_id -> Meta dedupliziert zu 1 Event (korrekt!)

### KEIN noscript Fallback!

**NICHT DSGVO-konform:**
```html
<noscript><img src="https://www.facebook.com/tr?id=123&ev=PageView" /></noscript>
```

Das noscript Bild feuert OHNE Consent und ist in der EU illegal!


═══════════════════════════════════════════════════════════════════
## RACE CONDITIONS BEI CUSTOM EVENTS (NEU 2026-01-12)
═══════════════════════════════════════════════════════════════════

### Problem

Bei Single Page Navigation oder schnellen Seitenwechseln kann ein
Custom Event (z.B. `metaPixelReady`) gefeuert werden BEVOR der
Event-Listener auf der Zielseite registriert ist.

### Loesung: Polling Fallback

```javascript
(function() {
    var hasFired = false;

    function doSomething() {
        if (hasFired) return;
        hasFired = true;
        // ... eigentliche Logik ...
    }

    // 1. Event Listener registrieren
    window.addEventListener('metaPixelReady', doSomething);

    // 2. Sofort pruefen falls bereits ready
    if (window.metaPixelLoaded && window.metaPixelConsent) {
        doSomething();
    }

    // 3. Polling Fallback
    var attempts = 0;
    var maxAttempts = 20;  // 10 Sekunden max
    var poll = setInterval(function() {
        attempts++;
        if (hasFired || attempts >= maxAttempts) {
            clearInterval(poll);
            return;
        }
        if (window.metaPixelLoaded && window.metaPixelConsent) {
            doSomething();
            clearInterval(poll);
        }
    }, 500);
})();
```

### Wann verwenden?

- Events die von externen Scripts gefeuert werden (Analytics, Pixel)
- Events bei Seitenwechseln (SPA Navigation)
- Events die zeitkritisch sind (Conversion Tracking)


═══════════════════════════════════════════════════════════════════
## PRELOAD HINTS - BEST PRACTICES (NEU 2026-01-12)
═══════════════════════════════════════════════════════════════════

### Problem

```html
<!-- In Layout.astro (ALLE Seiten) -->
<link rel="preload" href="/images/hero-bad.webp" as="image" />
```

Warnung in Console:
"The resource was preloaded but not used within a few seconds"

### Regel

**Preload NUR fuer Ressourcen die auf DIESER Seite verwendet werden!**

### Loesung: Conditional Preload

**Option 1: Slot in Layout:**
```astro
<!-- Layout.astro -->
<head>
    <slot name="preload" />
</head>

<!-- index.astro -->
<Layout>
    <link slot="preload" rel="preload" href="/images/hero.webp" as="image" />
</Layout>
```

**Option 2: Prop in Layout:**
```astro
<!-- Layout.astro -->
---
const { preloadImage } = Astro.props;
---
<head>
    {preloadImage && <link rel="preload" href={preloadImage} as="image" />}
</head>

<!-- index.astro -->
<Layout preloadImage="/images/hero.webp">
```

**Option 3: Einfach weglassen**

Moderne Browser sind gut im Priorisieren. Ein `<img>` im Hero-Bereich
wird automatisch frueh geladen. Preload ist oft unnoetig.


═══════════════════════════════════════════════════════════════════
## AD-BLOCKER DETECTION UND HANDLING (NEU 2026-01-12)
═══════════════════════════════════════════════════════════════════

### Warum wichtig?

~30% der User haben Ad-Blocker. Tracking-Scripts (Meta Pixel, GA)
werden blockiert. Die Website muss trotzdem funktionieren!

### Error Handling fuer blockierte Scripts

```javascript
// Im Script-Loader
t.onerror = function() {
    console.log('[Meta Pixel] Script blocked - Ad-Blocker or Privacy Feature active');
    window.metaPixelLoaded = false;
    // KEINE Error-Meldung an User - ist deren Entscheidung!
};

t.onload = function() {
    window.metaPixelLoaded = true;
    window.dispatchEvent(new CustomEvent('metaPixelReady'));
    console.log('[Meta Pixel] Script loaded successfully');
};
```

### Regeln

1. **Graceful Degradation** - Website funktioniert ohne Tracking
2. **Keine Blocker-Walls** - User nicht zwingen, Blocker zu deaktivieren
3. **Server-Side Fallback** - Conversions API funktioniert trotz Blocker
4. **Saubere Console** - Klare Meldungen, keine kryptischen Errors

### Testing

Zum Testen ohne Blocker:
- Inkognito-Modus ohne Extensions
- Anderer Browser
- Oder: Blocker temporaer deaktivieren



═══════════════════════════════════════════════════════════════════
## SICHERHEIT - WICHTIGE REGELN (UPDATE 2026-01-12)
═══════════════════════════════════════════════════════════════════

### .env Dateien - KRITISCH!

**.env Dateien enthalten sensible Daten (API-Keys, Passwoerter).**

**Permissions IMMER auf 600 setzen:**
```bash
chmod 600 .env
```

**Nach jedem Build pruefen:**
```bash
ls -la .env
# Erwartet: -rw------- (nur Owner kann lesen)
```

**NIEMALS:**
- .env auf GitHub pushen (in .gitignore!)
- .env mit falschen Permissions (644 = jeder kann lesen)
- API-Keys in Code hardcoden

**.env.example Template:**
```env
# Brevo API (E-Mail)
BREVO_API_KEY=your_api_key_here

# Meta Pixel (optional)
META_PIXEL_ID=
META_ACCESS_TOKEN=

# Site Config
SITE_URL=https://firmenname.at
```

### Nginx Security Headers

Alle Sites MUESSEN Security Headers haben. Snippet inkludieren:

```nginx
include /etc/nginx/snippets/security-headers.conf;
```

**Enthaltene Headers:**
- X-Frame-Options: SAMEORIGIN (Clickjacking-Schutz)
- X-Content-Type-Options: nosniff (MIME-Sniffing verhindern)
- X-XSS-Protection: 1; mode=block (XSS-Filter)
- Referrer-Policy: strict-origin-when-cross-origin

### Backups

**Automatische Backups:** Taeglich 03:00 Uhr via Cron
**Speicherort:** /var/www/backups/
**Retention:** 7 Tage

**Manuelles Backup vor grossen Aenderungen:**
```bash
/usr/local/bin/lisn-backup.sh
```

### Server-Zugriff

**SSH:** Nur mit SSH-Key (Password-Auth deaktiviert)
**Deploy-User:** deploy (fuer GitHub Actions, eingeschraenkte Rechte)
**Root:** Nur fuer Administration

### Brevo IP-Whitelist ✅

Server-IP ist in Brevo autorisiert (Stand: 2026-01-12):
- IPv4: 46.224.27.249
- IPv6: 2a01:4f8:1c1f:8fc6::1

Einstellungen: https://app.brevo.com/security/authorised_ips

### Checkliste bei neuem Projekt

- [ ] .env mit chmod 600 erstellt
- [ ] .env in .gitignore
- [ ] Nginx Security Headers aktiv
- [ ] SSL-Zertifikat eingerichtet
- [ ] Backup nach Go-Live erstellt

