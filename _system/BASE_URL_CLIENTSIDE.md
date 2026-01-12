# BASE_URL in Client-Side JavaScript

> **Kritische Ergaenzung zur BASE_URL_GUIDE.md**
> Diese Probleme treten NUR bei Client-Side JavaScript auf!

═══════════════════════════════════════════════════════════════════
## DAS PROBLEM
═══════════════════════════════════════════════════════════════════

In Astro-Komponenten funktioniert `import.meta.env.BASE_URL` perfekt.
Aber in **Client-Side JavaScript** (Alpine.js, inline scripts) ist
`import.meta.env` NICHT verfuegbar!

**Betroffene Stellen:**
- `fetch()` Aufrufe zu API-Endpunkten
- `window.location.href` Redirects
- Dynamisch generierte Links

═══════════════════════════════════════════════════════════════════
## LOESUNG: DYNAMISCHE PFAD-ERKENNUNG
═══════════════════════════════════════════════════════════════════

### API Fetch Calls

```javascript
// FALSCH - funktioniert nicht mit Base-URL
const response = await fetch('/api/submit-form', { ... });

// RICHTIG - prueft ob Base-Pfad vorhanden
const response = await fetch(
  window.location.pathname.includes('/projekt-slug')
    ? '/projekt-slug/api/submit-form'
    : '/api/submit-form',
  { ... }
);
```

### Redirects nach Form Submit

```javascript
// FALSCH
window.location.href = '/danke';

// RICHTIG
window.location.href = window.location.pathname.includes('/projekt-slug')
  ? '/projekt-slug/danke'
  : '/danke';
```

═══════════════════════════════════════════════════════════════════
## ALTERNATIVE: BASE_URL ALS DATA-ATTRIBUT
═══════════════════════════════════════════════════════════════════

Wenn viele Client-Side URLs benoetigt werden, Base-URL als
data-Attribut uebergeben:

### In der Astro-Komponente:

```astro
---
const base = import.meta.env.BASE_URL;
---

<div x-data="formHandler()" data-base-url={base}>
  <!-- Form content -->
</div>

<script is:inline>
function formHandler() {
  return {
    baseUrl: '',

    init() {
      // Base URL aus data-Attribut lesen
      this.baseUrl = this.$el.dataset.baseUrl || '/';
    },

    async submitForm() {
      const response = await fetch(this.baseUrl + 'api/submit-form', { ... });
      // ...
      window.location.href = this.baseUrl + 'danke';
    }
  };
}
</script>
```

═══════════════════════════════════════════════════════════════════
## CHECKLISTE: CLIENT-SIDE JAVASCRIPT
═══════════════════════════════════════════════════════════════════

Bei jedem Formular/Script pruefen:

- [ ] `fetch('/api/...')` - Braucht Base-Pfad?
- [ ] `window.location.href = '...'` - Braucht Base-Pfad?
- [ ] `window.location.replace('...')` - Braucht Base-Pfad?
- [ ] Dynamische `<a href>` Generierung - Braucht Base-Pfad?

═══════════════════════════════════════════════════════════════════
## BEIM LIVE-GANG
═══════════════════════════════════════════════════════════════════

Die dynamische Loesung funktioniert auch nach dem Live-Gang:
- `window.location.pathname.includes('/projekt-slug')` ist `false`
- Daher wird der einfache Pfad `/api/submit-form` verwendet
- **Kein Code-Aenderung noetig!**

═══════════════════════════════════════════════════════════════════
## FEHLERSUCHE
═══════════════════════════════════════════════════════════════════

### Symptom: API-Fehler "404 Not Found" oder generischer Fehler

**Pruefe in Browser DevTools > Network:**
1. Welche URL wird aufgerufen?
2. Fehlt der Base-Pfad?

**Beispiel:**
```
Aufgerufene URL: /api/submit-form
Erwartet: /projekt-slug/api/submit-form
```

### Symptom: Redirect landet auf falscher Seite

**Pruefe:**
- `window.location.href` Ziel im Code
- Browser-URL nach Redirect

---

*Erstellt: Januar 2026*
*Anlass: Forstinger-Projekt Formular-Fix*
