# Astro Base URL Guide

> **Wichtig für Customer Previews unter Subpfaden** (z.B. `/projekt-slug/`)

Dieser Guide erklärt, wie man Astro-Projekte korrekt konfiguriert, damit sie sowohl unter einem Subpfad (Preview) als auch unter der Root-Domain (Live) laufen.

---

## 1. Das Problem

Wenn ein Astro-Projekt unter `customers.lisn-agentur.com/forstinger-haus-bad` läuft, müssen ALLE internen Pfade den Base-Pfad enthalten.

**Ohne Konfiguration:**
- Bilder zeigen 404: `/images/logo.webp` statt `/projekt/images/logo.webp`
- Links sind falsch: `/formular` statt `/projekt/formular`
- CSS/JS Files werden nicht geladen

---

## 2. Astro Konfiguration (Server-Side)

In `astro.config.mjs`:

```javascript
import { defineConfig } from 'astro/config';

export default defineConfig({
  // WICHTIG: Trailing Slash am Ende!
  base: '/projekt-slug/',
  
  // Trailing Slash ignorieren (beide URLs funktionieren)
  trailingSlash: 'ignore',
  
  // ... restliche Config
});
```

### Verwendung in Astro Components (.astro)

```astro
---
const base = import.meta.env.BASE_URL;
// Enthält '/projekt-slug/' (Preview) oder '/' (Live)
---

<!-- Bilder -->
<img src={base + 'images/logo.webp'} alt="Logo" />

<!-- Links -->
<a href={base + 'formular'}>Kontakt</a>
```

---

## 3. Client-Side JavaScript (Alpine.js)

In Client-Code (Browser) ist `import.meta.env.BASE_URL` **NICHT** verfügbar.

### Lösung A: Dynamische Erkennung (Empfohlen)

Funktioniert automatisch für beide Umgebungen:

```javascript
// API Fetch
const baseUrl = window.location.pathname.includes('/projekt-slug')
  ? '/projekt-slug'
  : '';

await fetch(baseUrl + '/api/submit-form', { ... });

// Redirect
window.location.href = baseUrl + '/danke';
```

### Lösung B: Data Attribute

```astro
<!-- Astro Component -->
<div x-data="formHandler()" data-base-url={import.meta.env.BASE_URL}>
```

```javascript
// Alpine Component
init() {
  this.baseUrl = this.$el.dataset.baseUrl;
}
```

---

## 4. Nginx Konfiguration

Damit der Subpfad funktioniert, muss Nginx korrekt konfiguriert sein:

```nginx
# 1. Exact Match Redirect (ohne Slash -> mit Slash)
location = /projekt-slug {
    return 301 $scheme://$host/projekt-slug/;
}

# 2. Proxy Pass
location /projekt-slug/ {
    proxy_pass http://127.0.0.1:4321;
    # ... Proxy Header ...
}
```

---

## 5. Live-Gang (Checkliste)

Wenn das Projekt auf die echte Domain (z.B. `kunde.at`) geht:

1. [ ] `astro.config.mjs`: `base` entfernen oder auskommentieren
2. [ ] Projekt neu bauen: `pnpm build`
3. [ ] PM2 neu starten: `pm2 restart [app-name]`
4. [ ] Nginx Config für Root-Domain erstellen (ohne Subpfad-Location)

Da `import.meta.env.BASE_URL` dann automatisch `/` ist, muss am Code nichts geändert werden!
