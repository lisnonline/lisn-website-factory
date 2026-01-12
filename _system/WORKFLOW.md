# LISN Workflow Guide
**Version:** 1.0
**Für:** Interne Nutzung durch LISN-Team
**Letzte Änderung:** 2026-01-07

═══════════════════════════════════════════════════════════════════
## PROJEKT-WORKFLOW (SCHRITT FÜR SCHRITT)
═══════════════════════════════════════════════════════════════════

### PHASE 1: KUNDE AKQUIRIERT

**1.1 Kickoff-Meeting**
- Erfasse Kundenwünsche
- Zeige Referenz-Websites
- Erkläre Prozess und Timeline
- Unterschreibe Vertrag

**1.2 Inputs sammeln**
- Stitch-Export (falls vorhanden)
- Logo (SVG + PNG)
- Firmeninformationen
- Bilder/Videos (optional)
- Farbschema (falls vorhanden)

**1.3 Kickoff-Dokument erstellen**
Erstelle ein Dokument mit:
- Firmenname + Kontaktdaten
- Branche + Leistungen
- Gewünschte Seiten
- Besonderheiten
- Brevo-Konfiguration (API-Key, List-ID)

### PHASE 2: PROJEKT SETUP

**2.1 Kundenname-Slug erstellen**
```bash
# Aus Firmenname Slug ableiten
Müller Sanitär GmbH → mueller-sanitaer
```

**2.2 Ordner-Check**
```bash
ssh root@46.224.27.249
ls /var/www/staging/ | grep mueller-sanitaer
ls /var/www/kunden/ | grep mueller-sanitaer

# Falls existiert: STOPPEN!
```

**2.3 Projekt-Ordner erstellen**
```bash
cd /var/www/staging
mkdir mueller-sanitaer
cd mueller-sanitaer
mkdir inputs
```

**2.4 Inputs hochladen**
```bash
# Lokal:
scp kickoff.pdf root@46.224.27.249:/var/www/staging/mueller-sanitaer/inputs/
scp logo.svg root@46.224.27.249:/var/www/staging/mueller-sanitaer/inputs/
```

### PHASE 3: ASTRO-PROJEKT ERSTELLEN

**3.1 Astro initialisieren**
```bash
cd /var/www/staging/mueller-sanitaer
pnpm create astro@latest . --template minimal --typescript strict
```

**3.2 Dependencies installieren**
```bash
pnpm astro add tailwind
pnpm add -D alpinejs
pnpm add @klaro/core
```

**3.3 Ordnerstruktur anlegen**
```bash
mkdir -p src/components/{global,sections,forms,legal}
mkdir -p src/layouts
mkdir -p public/fonts
mkdir -p public/images
```

**3.4 Config-Files erstellen**
- `config.json` - Firmenspezifische Daten
- `content.json` - CMS-ähnliche Inhalte
- `.env.example` - Environment-Template
- `deploy.sh` - Deploy-Script

### PHASE 4: DEVELOPMENT

═══════════════════════════════════════════════════════════════════
## ⚠️  PHASE 3.5: STITCH-DATEIEN ANALYSIEREN (KRITISCH!)
═══════════════════════════════════════════════════════════════════

**DIESE PHASE DARF NIEMALS ÜBERSPRUNGEN WERDEN!**

### 3.5.1 Prüfen ob Stitch-Export vorhanden

```bash
ls inputs/*.html
```

### 3.5.2 WENN HTML-Dateien vorhanden → ALLE LESEN!

```bash
# JEDE einzelne HTML-Datei durchlesen!
cat inputs/index.html
cat inputs/beratung.html      # Formular!
cat inputs/kontakt.html       # Falls vorhanden
cat inputs/leistungen.html    # Falls vorhanden
# ... ALLE Dateien!
```

### 3.5.3 Design-Elemente dokumentieren

Für JEDE Seite notieren:
- Anzahl Sections
- Komponenten (Cards, Lists, Grids, etc.)
- Formular-Struktur (Schritte, Felder, Design)
- Farben und Abstände
- Icons und deren Namen
- Besondere Features (Progress-Bar, Sidebar, etc.)

### 3.5.4 Entscheidung treffen

| Situation | Entscheidung |
|-----------|--------------|
| Stitch-HTML vorhanden | → Design 1:1 übernehmen! |
| Keine HTML vorhanden | → Standard-Template nutzen |
| Teils vorhanden | → Vorhandenes übernehmen, Rest Standard |

### ⚠️  KRITISCHE REGEL

**Wenn beratung.html / formular.html existiert:**
- Anzahl Schritte EXAKT übernehmen
- Progress-Bar Design EXAKT übernehmen
- Choice-Cards EXAKT übernehmen
- Sidebar-Layout EXAKT übernehmen
- Icons EXAKT übernehmen

**NIEMALS:**
- Eigenes vereinfachtes Design erstellen
- Schritte reduzieren oder ändern
- Layout "verbessern" oder "optimieren"

Das Stitch-Design wurde vom Kunden abgenommen!


**4.1 Layouts erstellen**
1. `src/layouts/Layout.astro`
2. `src/layouts/FormLayout.astro`

**4.2 Global Components**
1. Header mit Navigation
2. Footer mit Kontaktdaten
3. Mobile Menu

**4.3 Seiten erstellen (in Reihenfolge)**
1. **index.astro** (Startseite)
   - Hero
   - Leistungen (FeatureGrid)
   - Über uns (TextImageSection)
   - Stats
   - Testimonials (optional)
   - CTA

2. **formular.astro**
   - MultiStepForm (3 Schritte)

3. **danke.astro**
   - Bestätigung nach Formular

4. **impressum.astro**
   - Legal-Daten aus config.json

5. **datenschutz.astro**
   - DSGVO-konforme Datenschutzerklärung

6. **agb.astro**
   - Allgemeine Geschäftsbedingungen

**4.4 Formular-API einrichten**
```bash
# src/pages/api/submit-form.js
# Siehe BREVO_INTEGRATION.md
```

**4.5 Fonts lokal einbinden**
```bash
# KEINE Google Fonts CDN!
# Fonts downloaden → /public/fonts/
# In CSS einbinden via @font-face
```

**4.6 Cookie Banner einrichten**
```bash
# src/components/legal/CookieBanner.astro
# Klaro! konfigurieren
```

### PHASE 5: CONTENT-ERSTELLUNG

**5.1 config.json befüllen**
```json
{
  "company": { ... },
  "contact": { ... },
  "legal": { ... }
}
```

**5.2 Texte schreiben (Brand Voice beachten!)**
- Siehe BRAND_VOICE.md
- Direkt, ehrlich, auf Augenhöhe
- Konkrete Zahlen statt Superlative

**5.3 Bilder optimieren**
```bash
# Konvertieren zu WebP
# Max. 1920px Breite
# Komprimieren (TinyPNG)
```

### PHASE 6: TESTING

**6.1 Lokal testen**
```bash
pnpm dev
# Browser: http://localhost:4321
```

**6.2 Checklist durchgehen**
- [ ] Alle Links funktionieren
- [ ] Formular sendet (Test-Submit)
- [ ] Mobile Responsive (320px - 1920px)
- [ ] Cookie Banner funktioniert
- [ ] Fonts lokal geladen
- [ ] Lighthouse Score > 90

**6.3 Build erstellen**
```bash
pnpm build
pnpm preview
# Browser: http://localhost:4322
```

### PHASE 7: DEPLOYMENT

**7.1 Deploy-Script ausführen**
```bash
chmod +x deploy.sh
./deploy.sh
```

**7.2 Nginx-Config erstellen**
```bash
cp /etc/nginx/sites-available/TEMPLATE-kunde /etc/nginx/sites-available/mueller-sanitaer.at
nano /etc/nginx/sites-available/mueller-sanitaer.at
# [KUNDE] durch mueller-sanitaer ersetzen

ln -s /etc/nginx/sites-available/mueller-sanitaer.at /etc/nginx/sites-enabled/
nginx -t
systemctl reload nginx
```

**7.3 SSL-Zertifikat einrichten**
```bash
certbot --nginx -d mueller-sanitaer.at -d www.mueller-sanitaer.at
```

**7.4 DNS-Einträge prüfen**
```bash
# A-Record: mueller-sanitaer.at → 46.224.27.249
# A-Record: www.mueller-sanitaer.at → 46.224.27.249
```

### PHASE 8: GO-LIVE

**8.1 Finale Prüfung**
- [ ] Website erreichbar (https://mueller-sanitaer.at)
- [ ] SSL funktioniert (grünes Schloss)
- [ ] Formular sendet (Live-Test)
- [ ] Brevo-Integration funktioniert
- [ ] Cookie Banner funktioniert

**8.2 Kunde informieren**
- URL mitteilen
- Zugangsdaten für CMS (falls vorhanden)
- Anleitung für Content-Updates

**8.3 Monitoring einrichten**
- Uptime-Check (z.B. UptimeRobot)
- Google Search Console
- Google Analytics (falls Kunde zustimmt)

### PHASE 9: WARTUNG

**9.1 Regelmäßige Updates**
```bash
# Monatlich:
cd /var/www/staging/mueller-sanitaer
pnpm update
pnpm build
./deploy.sh
```

**9.2 Backups prüfen**
```bash
# Wöchentlich:
ls -lh /var/www/backups/ | grep mueller-sanitaer
```

**9.3 SSL-Zertifikat erneuern**
```bash
# Automatisch via certbot-cron
# Manuell:
certbot renew
```

═══════════════════════════════════════════════════════════════════
## TROUBLESHOOTING
═══════════════════════════════════════════════════════════════════

### Problem: Build schlägt fehl
```bash
rm -rf node_modules .astro
pnpm install
pnpm build
```

### Problem: Deploy schlägt fehl
```bash
# Berechtigungen prüfen:
ls -la /var/www/kunden/
chown -R www-data:www-data /var/www/kunden/mueller-sanitaer
```

### Problem: Nginx startet nicht
```bash
nginx -t  # Config testen
systemctl status nginx
tail -f /var/log/nginx/error.log
```

### Problem: SSL-Zertifikat läuft ab
```bash
certbot renew --dry-run
certbot renew --force-renewal
```

═══════════════════════════════════════════════════════════════════

═══════════════════════════════════════════════════════════════════
## PHASE 7B: SSR DEPLOYMENT (MIT FORMULAR/API)
═══════════════════════════════════════════════════════════════════

**WICHTIG:** Wenn die Website ein Kontaktformular mit Server-seitiger
API (z.B. Brevo E-Mail-Versand) hat, muss SSR (Server-Side Rendering)
verwendet werden statt statischem Export!

### 7B.1 Astro für SSR konfigurieren

**astro.config.mjs:**
```javascript
import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';
import node from '@astrojs/node';

export default defineConfig({
  output: 'server',  // WICHTIG: 'server' nicht 'hybrid'!
  adapter: node({ mode: 'standalone' }),
  vite: {
    plugins: [tailwindcss()]
  }
});
```

**Dependencies installieren:**
```bash
pnpm add @astrojs/node
```

### 7B.2 API-Endpoint erstellen

**src/pages/api/submit-form.ts:**
```typescript
import type { APIRoute } from 'astro';

export const prerender = false;  // KRITISCH!

export const POST: APIRoute = async ({ request }) => {
  const formData = await request.json();
  // ... Brevo API call
  return new Response(JSON.stringify({ success: true }), {
    status: 200,
    headers: { 'Content-Type': 'application/json' }
  });
};
```

### 7B.3 PM2 Ecosystem-Config erstellen

**ecosystem.config.cjs:**
```javascript
module.exports = {
  apps: [{
    name: 'projekt-name',
    script: './dist/server/entry.mjs',
    cwd: '/var/www/staging/projekt-name',
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

### 7B.4 Build und PM2 starten

```bash
# Build erstellen
cd /var/www/staging/projekt-name
pnpm build

# PM2 starten/neustarten
pm2 start ecosystem.config.cjs
# oder bei Updates:
pm2 restart projekt-name

# PM2 beim Boot starten
pm2 save
pm2 startup
```

### 7B.5 Nginx Reverse Proxy konfigurieren

**WICHTIG:** Bei SSR zeigt Nginx auf den Node.js-Server (Port 4321),
NICHT auf das /dist Verzeichnis!

**/etc/nginx/sites-available/projekt-name.at:**
```nginx
server {
    listen 80;
    server_name projekt-name.at www.projekt-name.at;

    # Redirect zu HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name projekt-name.at www.projekt-name.at;

    # SSL (wird von certbot ausgefüllt)
    ssl_certificate /etc/letsencrypt/live/projekt-name.at/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/projekt-name.at/privkey.pem;

    # Statische Assets direkt servieren
    location /fonts/ {
        alias /var/www/staging/projekt-name/dist/client/fonts/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    location /images/ {
        alias /var/www/staging/projekt-name/dist/client/images/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    location /_astro/ {
        alias /var/www/staging/projekt-name/dist/client/_astro/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Alles andere an Node.js SSR Server
    location / {
        proxy_pass http://127.0.0.1:4321;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_cache_bypass $http_upgrade;
    }
}
```

### 7B.6 Nginx aktivieren und testen

```bash
# Symlink erstellen
ln -s /etc/nginx/sites-available/projekt-name.at /etc/nginx/sites-enabled/

# Konfiguration testen
nginx -t

# Nginx neu laden
systemctl reload nginx
```

### 7B.7 SSL-Zertifikat erstellen

```bash
# Vor SSL: nur HTTP aktiv lassen!
certbot --nginx -d projekt-name.at -d www.projekt-name.at
```

### 7B.8 Deployment-Checkliste SSR

- [ ] `output: 'server'` in astro.config.mjs
- [ ] @astrojs/node Adapter installiert
- [ ] `prerender = false` in API-Endpoints
- [ ] .env Datei mit BREVO_API_KEY vorhanden
- [ ] Brevo IP-Autorisierung (siehe BREVO_INTEGRATION.md)
- [ ] ecosystem.config.cjs vorhanden
- [ ] PM2 läuft (`pm2 status`)
- [ ] Nginx Reverse Proxy konfiguriert
- [ ] SSL-Zertifikat aktiv
- [ ] Formular-Test erfolgreich

═══════════════════════════════════════════════════════════════════
## ALPINE.JS IN ASTRO (KRITISCH!)
═══════════════════════════════════════════════════════════════════

### Problem

Alpine.js Funktionen werden von Astro gebündelt und sind nicht
global verfügbar. Das bedeutet x-data="formHandler()" findet die
Funktion nicht.

### Lösung

Verwende `is:inline` für Alpine.js Scripts:

```astro
<script is:inline>
function formHandler() {
  return {
    step: 1,
    formData: { ... },
    nextStep() { this.step++; },
    async submitForm() { ... }
  };
}
</script>

<div x-data="formHandler()">
  <!-- Formular -->
</div>
```

**WICHTIG:** `is:inline` verhindert das Bundling durch Astro!


═══════════════════════════════════════════════════════════════════
## PHASE 7C: CUSTOMER PREVIEW DEPLOYMENT (UPDATE 2026-01-07)
═══════════════════════════════════════════════════════════════════

**Für Kunden-Previews VOR dem Live-Gang:**

### 7C.1 Base-Path in Astro setzen

```javascript
// astro.config.mjs
export default defineConfig({
  base: '/projekt-slug',  // z.B. '/forstinger-haus-bad'
  output: 'server',
  adapter: node({ mode: 'standalone' }),
  // ...
});
```

### 7C.2 Build und PM2

```bash
cd /var/www/staging/projekt-slug
pnpm build
pm2 start ecosystem.config.cjs
# oder: pm2 restart projekt-slug
```

### 7C.3 Nginx Location hinzufügen

In `/etc/nginx/sites-available/customers.lisn-agentur.com`:

```nginx
# Neues Projekt hinzufügen
location /projekt-slug {
    proxy_pass http://127.0.0.1:43XX;  # Neuer Port!
    proxy_http_version 1.1;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}

location /projekt-slug/_astro/ {
    alias /var/www/staging/projekt-slug/dist/client/_astro/;
    expires 1y;
}

location /projekt-slug/fonts/ {
    alias /var/www/staging/projekt-slug/dist/client/fonts/;
    expires 1y;
}

location /projekt-slug/images/ {
    alias /var/www/staging/projekt-slug/dist/client/images/;
    expires 1y;
}
```

### 7C.4 Nginx aktivieren

```bash
nginx -t
systemctl reload nginx
```

### 7C.5 Preview-URL

```
https://customers.lisn-agentur.com/projekt-slug
```

═══════════════════════════════════════════════════════════════════
## PHASE 8: LIVE-GANG (UPDATE 2026-01-07)
═══════════════════════════════════════════════════════════════════

### 8.1 Base-Path entfernen

```javascript
// astro.config.mjs
export default defineConfig({
  // base: '/projekt-slug',  // ENTFERNT!
  output: 'server',
  adapter: node({ mode: 'standalone' }),
  // ...
});
```

### 8.2 Neu builden

```bash
cd /var/www/staging/projekt-slug
pnpm build
pm2 restart projekt-slug
```

### 8.3 Eigene Domain-Config erstellen

```bash
cp /etc/nginx/sites-available/TEMPLATE-kunde /etc/nginx/sites-available/projekt.at
nano /etc/nginx/sites-available/projekt.at
# Domain und Pfade anpassen

ln -s /etc/nginx/sites-available/projekt.at /etc/nginx/sites-enabled/
nginx -t
systemctl reload nginx
```

### 8.4 SSL einrichten

```bash
certbot --nginx -d projekt.at -d www.projekt.at
```

### 8.5 DNS prüfen

```
projekt.at        → A-Record → 46.224.27.249
www.projekt.at    → A-Record → 46.224.27.249
```

### 8.6 Preview-Location entfernen (optional)

Aus `/etc/nginx/sites-available/customers.lisn-agentur.com`:
- Location-Blocks für das Projekt entfernen
- `nginx -t && systemctl reload nginx`

### 8.7 Go-Live Checkliste

- [ ] Base-Path aus astro.config.mjs entfernt
- [ ] Neu gebaut (`pnpm build`)
- [ ] PM2 neugestartet
- [ ] Eigene Nginx-Config erstellt
- [ ] SSL-Zertifikat aktiv
- [ ] DNS-Einträge korrekt
- [ ] Website unter eigener Domain erreichbar
- [ ] Formular funktioniert (Test-Submit)
- [ ] Alle internen Links funktionieren (keine /projekt-slug/ Pfade mehr)


═══════════════════════════════════════════════════════════════════
## ⚠️ KRITISCH: BASE_URL BEI PREVIEW (UPDATE 2026-01-07)
═══════════════════════════════════════════════════════════════════

**Siehe auch:** BASE_URL_GUIDE.md für vollständige Dokumentation!

### Kurzfassung

Bei Preview unter `customers.lisn-agentur.com/projekt-slug`:

1. **astro.config.mjs:**
   ```javascript
   base: '/projekt-slug/',  // MIT Trailing Slash!
   trailingSlash: 'ignore',
   ```

2. **ALLE Komponenten:**
   ```astro
   ---
   const base = import.meta.env.BASE_URL;
   ---
   <img src={base + 'images/logo.webp'} />
   <a href={base + 'formular'}>Link</a>
   ```

3. **Nginx:**
   ```nginx
   # Redirect ohne Slash zu mit Slash
   location = /projekt-slug {
       return 301 $scheme://$host/projekt-slug/;
   }
   
   location /projekt-slug/ {
       proxy_pass http://127.0.0.1:4321;
   }
   ```

### Betroffene Dateien

JEDE Datei mit `src="/` oder `href="/` muss angepasst werden:
- Header.astro, Footer.astro
- Hero.astro, Gallery.astro, Testimonials.astro
- CTA.astro, Process.astro
- formular.astro, danke.astro
- Alle weiteren Seiten/Komponenten

### Beim Live-Gang

1. `base` aus astro.config.mjs ENTFERNEN
2. `pnpm build && pm2 restart`
3. Alle Pfade funktionieren automatisch (BASE_URL wird zu `/`)



═══════════════════════════════════════════════════════════════════
## PHASE 5B: BILDOPTIMIERUNG (UPDATE 2026-01-07)
═══════════════════════════════════════════════════════════════════

### Warum Bildoptimierung kritisch ist

Lighthouse-Probleme ohne Optimierung:
- **LCP > 8 Sekunden** (sollte < 2.5s sein)
- **Seitengröße > 5 MB** (sollte < 1-2 MB sein)
- **CLS > 0.25** (sollte < 0.1 sein)

### 5B.1 Tools installieren (einmalig auf Server)

```bash
apt-get install -y webp imagemagick
```

### 5B.2 Bilder zu WebP konvertieren

```bash
cd /var/www/staging/projekt-name/public/images

# Backup erstellen
mkdir -p backup && cp *.jpg *.png backup/ 2>/dev/null

# Hero-Bild (max 1200px, Qualität 85%)
convert hero.jpg -resize '1200x1200>' -quality 85 hero.webp

# Gallery-Bilder (max 800px)
convert gallery-1.jpg -resize '800x800>' -quality 85 gallery-1.webp
convert gallery-2.jpg -resize '800x800>' -quality 85 gallery-2.webp

# Avatar/Thumbnails (max 150px)
convert avatar.jpg -resize '150x150>' -quality 85 avatar.webp

# Alte Dateien entfernen
rm -f *.jpg *.png

# Größen prüfen
ls -lh *.webp
```

### 5B.3 Bildgrößen nach Verwendung

| Bildtyp | Max Breite | Qualität | Erwartete Größe |
|---------|------------|----------|-----------------|
| Hero    | 1200px     | 85%      | 30-80 KB        |
| Gallery | 800px      | 85%      | 15-40 KB        |
| Avatar  | 150px      | 85%      | 3-8 KB          |
| Logo    | Original   | 90%      | 10-30 KB        |

### 5B.4 Komponenten aktualisieren

Alle .jpg/.png Referenzen zu .webp ändern:

```bash
# Alle Dateien finden die .jpg referenzieren
grep -r '\.jpg' src/components/ --include='*.astro'

# Automatisch ersetzen
sed -i 's/\.jpg/.webp/g' src/components/sections/*.astro
```

### 5B.5 CLS vermeiden mit width/height

```astro
<!-- IMMER width und height angeben! -->
<img 
  src={base + 'images/hero.webp'} 
  alt="Beschreibung"
  width="1200"
  height="800"
  class="w-full h-auto object-cover"
  loading="eager"         <!-- Hero: eager (above fold) -->
  fetchpriority="high"    <!-- Hero: high priority -->
/>

<img 
  src={base + 'images/gallery.webp'} 
  alt="Beschreibung"
  width="800"
  height="600"
  class="w-full h-auto object-cover"
  loading="lazy"          <!-- Below fold: lazy -->
  decoding="async"        <!-- Async decoding -->
/>
```

### 5B.6 Lighthouse-Ziele

| Metrik | Ziel | Beschreibung |
|--------|------|--------------|
| LCP    | < 2.5s | Largest Contentful Paint |
| CLS    | < 0.1 | Cumulative Layout Shift |
| FCP    | < 1.8s | First Contentful Paint |
| TBT    | < 200ms | Total Blocking Time |

### 5B.7 Ergebnis-Beispiel (Forstinger-Projekt)

**Vorher:**
- gallery-1.jpg: 352 KB
- gallery-2.jpg: 289 KB
- hero-bad.jpg: 317 KB
- **Total: ~1.7 MB**

**Nachher:**
- gallery-1.webp: 14 KB
- gallery-2.webp: 7 KB
- hero-bad.webp: 9 KB
- **Total: ~65 KB**

**Reduktion: 96%**


---

## PHASE 5C: FONT-OPTIMIERUNG (Performance + DSGVO)

### 5C.1 WICHTIG: Niemals Google Fonts CDN verwenden!

**Google Fonts ist NICHT DSGVO-konform!** Beim Laden von fonts.googleapis.com wird die IP-Adresse des Users an Google übertragen.

### 5C.2 Fonts lokal hosten

**Schritt 1: Fonts herunterladen**
Quelle: https://gwfh.mranftl.com/fonts (google-webfonts-helper)

1. Font suchen (z.B. "Noto Sans")
2. Gewünschte Styles wählen (400, 500, 700)
3. **WOFF2 Format** wählen (wichtig für Performance!)
4. Download & entpacken

**Schritt 2: Fonts hochladen**
```bash
mkdir -p /var/www/staging/projekt-name/public/fonts
scp *.woff2 root@server:/var/www/staging/projekt-name/public/fonts/
```

### 5C.3 Font-Größen (WOFF2 vs TTF)

| Format | Größe pro Font | Total (5 Fonts) |
|--------|----------------|-----------------|
| TTF    | ~800 KB        | ~4 MB ❌        |
| WOFF2  | ~65 KB         | ~335 KB ✅      |

**NIEMALS TTF preloaden!** Das blockiert das gesamte Rendering.

### 5C.4 CSS Font-Face Deklaration

```css
/* In global.css */

/* Noto Sans - lokal gehostet (DSGVO-konform) */
@font-face {
  font-family: 'Noto Sans';
  src: url('/fonts/NotoSans-Regular.woff2') format('woff2');
  font-weight: 400;
  font-style: normal;
  font-display: swap;
}

@font-face {
  font-family: 'Noto Sans';
  src: url('/fonts/NotoSans-Medium.woff2') format('woff2');
  font-weight: 500;
  font-style: normal;
  font-display: swap;
}

@font-face {
  font-family: 'Noto Sans';
  src: url('/fonts/NotoSans-Bold.woff2') format('woff2');
  font-weight: 700;
  font-style: normal;
  font-display: swap;
}

/* Noto Serif für Headlines */
@font-face {
  font-family: 'Noto Serif';
  src: url('/fonts/NotoSerif-Regular.woff2') format('woff2');
  font-weight: 400;
  font-style: normal;
  font-display: swap;
}

@font-face {
  font-family: 'Noto Serif';
  src: url('/fonts/NotoSerif-Bold.woff2') format('woff2');
  font-weight: 700;
  font-style: normal;
  font-display: swap;
}
```

### 5C.5 Font Metric Overrides (CLS verhindern!)

**Problem:** Wenn Web-Fonts laden, ändert sich die Textgröße → Layout Shift (CLS)

**Lösung:** Fallback-Fonts mit angepassten Metriken, die den Web-Fonts entsprechen:

```css
/* VOR den @font-face Deklarationen hinzufügen */

/* Fallback für Noto Sans */
@font-face {
  font-family: 'Noto Sans Fallback';
  src: local('Arial'), local('Helvetica Neue'), local('Helvetica');
  size-adjust: 100.5%;
  ascent-override: 100%;
  descent-override: 27%;
  line-gap-override: 0%;
}

/* Fallback für Noto Serif */
@font-face {
  font-family: 'Noto Serif Fallback';
  src: local('Georgia'), local('Times New Roman');
  size-adjust: 105%;
  ascent-override: 97%;
  descent-override: 27%;
  line-gap-override: 0%;
}

/* Dann im body/headlines: */
body {
  font-family: 'Noto Sans', 'Noto Sans Fallback', system-ui, sans-serif;
}

h1, h2, h3, h4, h5, h6 {
  font-family: 'Noto Serif', 'Noto Serif Fallback', Georgia, serif;
}
```

**Ergebnis:** CLS von 0.43 → 0.0 ✅

### 5C.6 Layout.astro - KEIN Font Preload!

```astro
<!-- ❌ NICHT MACHEN - blockiert Rendering! -->
<link rel="preload" href="/fonts/font.woff2" as="font" type="font/woff2" crossorigin />

<!-- ✅ STATTDESSEN - Hero-Bild preloaden für LCP -->
<link rel="preload" href={base + "images/hero.webp"} as="image" type="image/webp" />
```

---

## PHASE 5D: HTTP/2 AKTIVIEREN

### 5D.1 Nginx Konfiguration

```nginx
# In /etc/nginx/sites-available/projekt.conf

server {
    listen 443 ssl http2;  # <-- http2 hinzufügen!
    listen [::]:443 ssl http2;
    
    # ... rest der config
}
```

### 5D.2 Anwenden

```bash
# Syntax prüfen
nginx -t

# Neu laden
systemctl reload nginx
```

### 5D.3 Prüfen

```bash
# HTTP/2 Test
curl -I --http2 https://domain.at 2>&1 | grep HTTP
# Sollte ausgeben: HTTP/2 200
```

---

## PHASE 5E: PERFORMANCE-CHECKLISTE

### Vor jedem Go-Live prüfen:

**Bilder:**
- [ ] Alle Bilder in WebP konvertiert
- [ ] Hero-Bild max 1200px, < 50KB
- [ ] Gallery-Bilder max 800px, < 20KB
- [ ] width/height Attribute gesetzt
- [ ] Hero: loading="eager", fetchpriority="high"
- [ ] Below-fold: loading="lazy", decoding="async"

**Fonts:**
- [ ] WOFF2 Format (nicht TTF!)
- [ ] Lokal gehostet (DSGVO!)
- [ ] font-display: swap gesetzt
- [ ] Font Metric Overrides für CLS
- [ ] KEIN font preloading

**Server:**
- [ ] HTTP/2 aktiviert
- [ ] Gzip/Brotli aktiviert
- [ ] Cache-Header gesetzt

**Layout.astro:**
- [ ] Hero-Bild preload
- [ ] Keine externen Font-URLs

### Lighthouse-Ziele:

| Metrik      | Ziel    | Kritisch |
|-------------|---------|----------|
| Performance | > 85    | > 50     |
| LCP         | < 2.5s  | < 4.0s   |
| CLS         | < 0.1   | < 0.25   |
| FCP         | < 1.8s  | < 3.0s   |
| TBT         | < 200ms | < 600ms  |

### Lighthouse lokal ausführen:

```bash
# Installation (einmalig)
npm install -g lighthouse

# Ausführen
lighthouse https://domain.at --output html --output-path ./report.html

# Nur Performance
lighthouse https://domain.at --only-categories=performance
```

### Forstinger-Projekt Endergebnis:

| Metrik      | Vorher  | Nachher | Verbesserung |
|-------------|---------|---------|--------------|
| Performance | 27%     | 88%     | +61%         |
| LCP         | 21.0s   | 1.6s    | -92%         |
| CLS         | 0.43    | 0.0     | -100%        |
| FCP         | 2.8s    | 1.3s    | -54%         |
| Seitengröße | 8.7 MB  | 0.4 MB  | -95%         |

