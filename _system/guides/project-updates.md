# Bestehende Projekte aktualisieren

> **Anleitung für Änderungen an bereits deployten LISN-Projekten.**
> Für neue Projekte siehe [01_QUICK_START.md](../01_QUICK_START.md)

---

## Vor jeder Änderung

```bash
# 1. SSH-Verbindung zum Server
ssh hetzner
# oder: ssh root@46.224.27.249

# 2. Zum Projekt navigieren
cd /var/www/staging/[projekt-slug]
# oder für Live-Projekte:
cd /var/www/kunden/[projekt-slug]
```

**Wichtig:** Lies immer zuerst die relevante Dokumentation:
- [02_CORE_RULES.md](../02_CORE_RULES.md) - Tech Stack & Naming
- [astro-components.md](./astro-components.md) - Komponenten & Bildoptimierung

---

## 1. Bilder austauschen

### 1.1 Bild hochladen (lokal → Server)

```bash
# Von lokalem Rechner ausführen:
scp "D:\Pfad\zum\bild.jpg" hetzner:/var/www/staging/[projekt-slug]/public/images/
```

### 1.2 Zu WebP konvertieren (Pflicht!)

```bash
# Auf dem Server:
cd /var/www/staging/[projekt-slug]/public/images

# Hero-Bild (max 1200px)
convert bild.jpg -resize '1200x1200>' -quality 85 bild.webp

# Gallery-Bild (max 800px)
convert bild.jpg -resize '800x800>' -quality 85 bild.webp

# Avatar/Logo (max 150px)
convert bild.jpg -resize '150x150>' -quality 85 bild.webp

# Original löschen
rm bild.jpg

# Ergebnis prüfen
ls -lh bild.webp
```

**Bildgrößen-Referenz:**

| Bildtyp | Max Breite | Qualität | Ziel-Größe |
|---------|------------|----------|------------|
| Hero    | 1200px     | 85%      | < 50 KB    |
| Gallery | 800px      | 85%      | < 20 KB    |
| Avatar  | 150px      | 85%      | < 5 KB     |
| Logo    | Original   | 90%      | < 10 KB    |

### 1.3 Komponente anpassen

```bash
# Datei finden, die das Bild verwendet
grep -r "alter-bildname" src/

# Datei bearbeiten
nano src/components/sections/[Komponente].astro
```

**Bildpfad ändern:**
```astro
<!-- ALT -->
src={base + 'images/alter-name.jpg'}

<!-- NEU -->
src={base + 'images/neuer-name.webp'}
```

**Bildattribute (Pflicht für Performance):**
```astro
<img
  src={base + 'images/bild.webp'}
  alt="Beschreibender Alt-Text"
  width="800"
  height="600"
  loading="lazy"
  decoding="async"
  class="w-full h-auto"
/>
```

---

## 2. Text-Inhalte ändern

### 2.1 Datei finden

```bash
# Nach Text suchen
grep -r "gesuchter text" src/

# Typische Orte:
# - src/pages/index.astro (Hauptseite)
# - src/components/sections/*.astro (Sektionen)
# - src/components/global/*.astro (Header/Footer)
```

### 2.2 Datei bearbeiten

```bash
nano src/components/sections/[Komponente].astro
```

**Tipp:** Bei Texten auf österreichische Schreibweise achten (siehe [brand-voice.md](../reference/brand-voice.md))

---

## 3. Neue Sektion hinzufügen

### 3.1 Komponente erstellen

```bash
nano src/components/sections/NeueSektion.astro
```

### 3.2 In Seite einbinden

```astro
---
// In src/pages/index.astro
import NeueSektion from '../components/sections/NeueSektion.astro';
---

<Layout>
  <!-- Bestehende Sektionen -->
  <NeueSektion />
</Layout>
```

---

## 4. Nach jeder Änderung: Build & Deploy

### 4.1 Projekt neu bauen

```bash
cd /var/www/staging/[projekt-slug]
pnpm build
```

**Bei Fehlern:** Build-Output lesen und Fehler beheben.

### 4.2 PM2 neu starten

```bash
pm2 restart [projekt-name]

# Oder mit ecosystem.config.cjs:
pm2 restart ecosystem.config.cjs
```

### 4.3 Status prüfen

```bash
pm2 status
```

### 4.4 Im Browser testen

- **Staging:** `https://customers.lisn-agentur.com/[projekt-slug]/`
- **Live:** `https://[domain].at/`

---

## 5. Checkliste für Änderungen

### Bilder
- [ ] Bild in WebP konvertiert (nicht JPG/PNG)
- [ ] Maximale Breite eingehalten (Hero: 1200px, Gallery: 800px)
- [ ] Qualität 85%
- [ ] Dateigröße unter Limit (Hero < 50KB, Gallery < 20KB)
- [ ] `width` und `height` Attribute gesetzt
- [ ] `loading="lazy"` für Below-Fold Bilder
- [ ] `alt`-Text vorhanden

### Code
- [ ] Keine Tippfehler in Pfaden
- [ ] `base +` vor allen Asset-Pfaden (für Staging)
- [ ] Komponente korrekt importiert

### Deployment
- [ ] `pnpm build` erfolgreich
- [ ] `pm2 restart` ausgeführt
- [ ] Seite im Browser getestet
- [ ] Auf Mobile getestet (falls relevant)

---

## 6. Häufige Änderungen

### Telefonnummer/E-Mail ändern

```bash
# Suchen
grep -r "alte@email.at" src/
grep -r "0123456789" src/

# Typische Orte: Header.astro, Footer.astro, Impressum
```

### Farben anpassen

```bash
# In tailwind.config.mjs oder CSS-Variablen
nano tailwind.config.mjs
```

### Formular-Felder ändern

Siehe [brevo-forms.md](./brevo-forms.md) für Details zur Brevo-Integration.

---

## 7. Troubleshooting

### Bild wird nicht angezeigt (404)

```bash
# Prüfen ob Datei existiert
ls -la public/images/

# Pfad in Komponente prüfen (base + vergessen?)
grep -r "bildname" src/
```

### Build schlägt fehl

```bash
# Fehler lesen und beheben
pnpm build 2>&1 | head -50

# Häufig: Syntaxfehler, fehlende Imports
```

### Änderungen nicht sichtbar

```bash
# PM2 wirklich neugestartet?
pm2 status

# Browser-Cache leeren (Ctrl+Shift+R)

# Nginx-Cache leeren (falls konfiguriert)
```

---

## 8. Rollback bei Problemen

Falls etwas schiefgeht:

```bash
# Git-Status prüfen
cd /var/www/staging/[projekt-slug]
git status
git log --oneline -5

# Letzte Änderung rückgängig machen
git checkout -- [datei]

# Oder komplett zurücksetzen
git reset --hard HEAD~1

# Neu bauen
pnpm build && pm2 restart [projekt-name]
```

---

## Quick Reference

| Aufgabe | Befehl |
|---------|--------|
| Bild hochladen | `scp local.jpg hetzner:/var/www/staging/projekt/public/images/` |
| Zu WebP konvertieren | `convert bild.jpg -resize '800x800>' -quality 85 bild.webp` |
| Text suchen | `grep -r "suchtext" src/` |
| Datei bearbeiten | `nano src/components/sections/Datei.astro` |
| Build | `pnpm build` |
| Restart | `pm2 restart [name]` |
| Status | `pm2 status` |

---

*Erstellt: 2026-01-14*
*Siehe auch: [workflow-checklist.md](../reference/workflow-checklist.md) für komplette Projekt-Workflows*
