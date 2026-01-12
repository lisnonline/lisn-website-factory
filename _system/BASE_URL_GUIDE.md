# ASTRO BASE URL - KRITISCHER GUIDE
**Version:** 1.0
**Erstellt:** 2026-01-07
**Anlass:** Forstinger-Projekt Bugfix

═══════════════════════════════════════════════════════════════════
## DAS PROBLEM
═══════════════════════════════════════════════════════════════════

Wenn ein Astro-Projekt unter einem Subpfad läuft (z.B. 
`customers.lisn-agentur.com/forstinger-haus-bad`), müssen ALLE 
internen Pfade den Base-Pfad enthalten.

**Ohne korrekte Konfiguration:**
- Bilder zeigen 404: `/images/logo.webp` statt `/projekt/images/logo.webp`
- Links gehen auf falsche URLs: `/formular` statt `/projekt/formular`
- CSS/JS laden nicht

═══════════════════════════════════════════════════════════════════
## LÖSUNG: SCHRITT FÜR SCHRITT
═══════════════════════════════════════════════════════════════════

### 1. astro.config.mjs

```javascript
// astro.config.mjs
import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';
import node from '@astrojs/node';

export default defineConfig({
  // WICHTIG: Trailing Slash am Ende!
  base: '/projekt-slug/',
  
  // Trailing Slash ignorieren (beide URLs funktionieren)
  trailingSlash: 'ignore',
  
  output: 'server',
  adapter: node({ mode: 'standalone' }),
  vite: {
    plugins: [tailwindcss()]
  }
});
```

### 2. Nginx: Redirect ohne Trailing Slash

```nginx
# Redirect /projekt-slug → /projekt-slug/
location = /projekt-slug {
    return 301 $scheme://$host/projekt-slug/;
}

# Eigentlicher Proxy mit Trailing Slash
location /projekt-slug/ {
    proxy_pass http://127.0.0.1:4321;
    # ... weitere proxy headers
}
```

### 3. In JEDER Komponente: BASE_URL verwenden

```astro
---
const base = import.meta.env.BASE_URL;
// BASE_URL enthält: '/projekt-slug/' (MIT trailing slash)
---

<!-- Bilder -->
<img src={base + 'images/logo.webp'} alt="Logo" />

<!-- Links -->
<a href={base + 'formular'}>Kontakt</a>
<a href={base + '#section'}>Zur Section</a>
<a href={base}>Startseite</a>

<!-- Navigation Array -->
const navItems = [
  { label: 'Vorteile', href: base + '#vorteile' },
  { label: 'Kontakt', href: base + 'formular' },
];
```

═══════════════════════════════════════════════════════════════════
## CHECKLISTE: ALLE DATEIEN DIE ANGEPASST WERDEN MÜSSEN
═══════════════════════════════════════════════════════════════════

### Komponenten mit Bildern:
- [ ] Header.astro → Logo
- [ ] Footer.astro → Logo
- [ ] Hero.astro → Hero-Bild
- [ ] Gallery.astro → Alle Galerie-Bilder
- [ ] Testimonials.astro → Avatar-Bilder
- [ ] Alle weiteren Komponenten mit `src="/images/..."`

### Komponenten mit Links:
- [ ] Header.astro → Navigation Links, CTA Button
- [ ] Footer.astro → Navigation Links, Legal Links
- [ ] Hero.astro → CTA Button
- [ ] CTA.astro → Buttons
- [ ] Process.astro → CTA Button
- [ ] danke.astro → "Zurück zur Startseite" Link
- [ ] formular.astro → Datenschutz-Link

### Layout:
- [ ] Layout.astro → favicon, CSS imports (werden automatisch gehandhabt)

═══════════════════════════════════════════════════════════════════
## TEMPLATE: KOMPONENTE MIT BASE_URL
═══════════════════════════════════════════════════════════════════

```astro
---
// IMMER am Anfang des Frontmatter
const base = import.meta.env.BASE_URL;

// Props, andere imports...
interface Props {
  headline: string;
}

const { headline } = Astro.props;
---

<section>
  <h1>{headline}</h1>
  
  <!-- Bild mit Base URL -->
  <img src={base + 'images/beispiel.jpg'} alt="Beispiel" />
  
  <!-- Link mit Base URL -->
  <a href={base + 'formular'}>Jetzt anfragen</a>
  
  <!-- Anker-Link mit Base URL -->
  <a href={base + '#kontakt'}>Zum Kontakt</a>
</section>
```

═══════════════════════════════════════════════════════════════════
## HÄUFIGE FEHLER
═══════════════════════════════════════════════════════════════════

### Fehler 1: Kein Trailing Slash in Config

❌ FALSCH:
```javascript
base: '/projekt-slug'  // Ohne Trailing Slash
```

Ergebnis: `base + 'images/logo.webp'` → `/projekt-slugimages/logo.webp`

✅ RICHTIG:
```javascript
base: '/projekt-slug/'  // MIT Trailing Slash
```

Ergebnis: `base + 'images/logo.webp'` → `/projekt-slug/images/logo.webp`

---

### Fehler 2: Hardcoded Pfade

❌ FALSCH:
```astro
<img src="/images/logo.webp" />
<a href="/formular">Link</a>
```

✅ RICHTIG:
```astro
<img src={base + 'images/logo.webp'} />
<a href={base + 'formular'}>Link</a>
```

---

### Fehler 3: Doppelter Slash

❌ FALSCH:
```astro
<a href={base + '/formular'}>  <!-- Ergibt: /projekt-slug//formular -->
```

✅ RICHTIG:
```astro
<a href={base + 'formular'}>   <!-- Ergibt: /projekt-slug/formular -->
```

---

### Fehler 4: Nginx ohne Redirect

❌ FALSCH:
```nginx
location /projekt-slug {
    proxy_pass ...
}
```

Ergebnis: `/projekt-slug` (ohne Slash) → 404

✅ RICHTIG:
```nginx
location = /projekt-slug {
    return 301 $scheme://$host/projekt-slug/;
}

location /projekt-slug/ {
    proxy_pass ...
}
```

═══════════════════════════════════════════════════════════════════
## LIVE-GANG: BASE_URL ENTFERNEN
═══════════════════════════════════════════════════════════════════

Beim Go-Live auf eigener Domain:

### 1. astro.config.mjs anpassen

```javascript
export default defineConfig({
  // base: '/projekt-slug/',  // ENTFERNEN oder auskommentieren
  output: 'server',
  // ...
});
```

### 2. Neu builden

```bash
pnpm build
pm2 restart projekt-name
```

### 3. Eigene Nginx-Config

Keine Location-Pfade nötig, da Root-Domain:
```nginx
server {
    server_name projekt.at www.projekt.at;
    
    location / {
        proxy_pass http://127.0.0.1:4321;
        # ...
    }
}
```

**WICHTIG:** Nach Entfernen des base-Pfads funktionieren alle 
internen Links automatisch korrekt, da `import.meta.env.BASE_URL` 
dann `/` zurückgibt.

═══════════════════════════════════════════════════════════════════
## DEBUGGING
═══════════════════════════════════════════════════════════════════

### Pfade im HTML prüfen

```bash
# Alle Pfade im gerenderten HTML anzeigen
curl -s https://url.com/projekt/ | grep -oE '(href|src)="[^"]+"' | head -30
```

### Erwartete Ausgabe (korrekt):
```
src="/projekt-slug/images/logo.webp"
href="/projekt-slug/formular"
href="/projekt-slug/#vorteile"
```

### Fehlerhafte Ausgabe:
```
src="/projekt-slugimages/logo.webp"    # Fehlender Slash
src="/images/logo.webp"                 # Kein Base-Pfad
href="/formular"                        # Kein Base-Pfad
```

### Image-Test

```bash
# Prüfen ob Bild erreichbar ist
curl -s -o /dev/null -w '%{http_code}' https://url.com/projekt-slug/images/logo.webp
# Erwartung: 200
```



═══════════════════════════════════════════════════════════════════
## BILDER MIT BASE_URL (UPDATE 2026-01-07)
═══════════════════════════════════════════════════════════════════

### Vollständiges Bild-Template

```astro
---
const base = import.meta.env.BASE_URL;
---

<!-- Hero-Bild (LCP-kritisch!) -->
<img 
  src={base + 'images/hero.webp'} 
  alt="Aussagekräftige Beschreibung"
  width="1200"
  height="800"
  class="w-full h-auto object-cover"
  loading="eager"
  fetchpriority="high"
/>

<!-- Gallery/Below Fold -->
<img 
  src={base + 'images/gallery.webp'} 
  alt="Aussagekräftige Beschreibung"
  width="800"
  height="600"
  class="w-full h-auto object-cover"
  loading="lazy"
  decoding="async"
/>
```

### Wichtige Performance-Attribute

| Attribut | Hero | Below Fold |
|----------|------|------------|
| `loading` | eager | lazy |
| `fetchpriority` | high | - |
| `decoding` | - | async |
| `width/height` | IMMER | IMMER |

### Warum width/height?

Ohne diese Attribute:
- Browser weiß nicht wie groß das Bild wird
- Layout verschiebt sich beim Laden (CLS)
- Lighthouse-Score leidet drastisch

Mit width/height:
- Browser reserviert Platz
- Kein Layout-Shift
- CLS bleibt unter 0.1


---

## HERO IMAGE PRELOAD FÜR LCP

### In Layout.astro

```astro
---
const base = import.meta.env.BASE_URL;
---

<head>
  <!-- Meta tags... -->
  
  <!-- Hero-Bild Preload für besseres LCP -->
  <link rel="preload" href={base + "images/hero.webp"} as="image" type="image/webp" />
  
  <!-- CSS... -->
</head>
```

### Wichtig:
- Nur das Hero-Bild preloaden (above the fold)
- **KEINE Fonts preloaden** (blockiert Rendering bei großen Dateien)
- WebP Format verwenden

