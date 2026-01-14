# LISN Projekt Update

Du führst Änderungen an einem bestehenden LISN Website Factory Projekt durch.

## Schritt 1: Dokumentation lesen

Verbinde dich per SSH auf den Hetzner Server und lies die relevanten Dokumentationen:

```bash
ssh hetzner
```

**Immer lesen:**
- `/var/www/staging/_system/00_INDEX.md` - Übersicht
- `/var/www/staging/_system/02_CORE_RULES.md` - Grundregeln
- `/var/www/staging/_system/guides/project-updates.md` - Update-Workflow

**Je nach Änderung zusätzlich lesen:**

| Änderung betrifft | Dokumentation lesen |
|-------------------|---------------------|
| Bilder | `guides/astro-components.md` (Abschnitt BILDOPTIMIERUNG) |
| Komponenten/Sektionen | `guides/astro-components.md` |
| Formular/Brevo | `guides/brevo-forms.md` |
| Cookie Banner/Klaro | `guides/klaro-consent.md` |
| Alpine.js/Interaktivität | `guides/alpine-tips.md` |
| URLs/Pfade | `guides/base-url.md` |
| Deployment/PM2/Nginx | `deployment/pm2-nginx.md` |
| Server-Konfiguration | `deployment/server-setup.md` |
| Texte/Tonalität | `reference/brand-voice.md` |
| Troubleshooting | `reference/troubleshooting.md` |

## Schritt 2: Projekt identifizieren

Projekte befinden sich unter:
- **Staging:** `/var/www/staging/[projekt-slug]/`
- **Production:** `/var/www/kunden/[projekt-slug]/`

## Schritt 3: Änderungen durchführen

Halte dich strikt an die gelesenen Guidelines:

**Bei Bildern:**
- IMMER zu WebP konvertieren (85% Qualität)
- Max-Größen einhalten (Hero: 1200px, Gallery: 800px)
- width/height Attribute setzen
- loading="lazy" für Below-Fold

**Bei Code-Änderungen:**
- `base +` vor Asset-Pfaden (für Staging)
- Österreichische Schreibweise bei Texten
- pnpm verwenden (nicht npm)

## Schritt 4: Build & Deploy

Nach jeder Änderung:
```bash
cd /var/www/staging/[projekt-slug]
pnpm build
pm2 restart [projekt-name]
```

## Schritt 5: Testen

- Seite im Browser prüfen
- Bei Bildern: Dateigröße und Darstellung checken
- Bei Formularen: Testabsendung machen

---

## Deine Aufgabe

$ARGUMENTS
