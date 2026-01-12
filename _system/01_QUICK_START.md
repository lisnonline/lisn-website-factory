# Quick Start - Neues LISN Projekt

> **1-Seiten Kurzanleitung** - Für Details siehe jeweilige Dokumentation.

---

## 1. Vorbereitung

```bash
ssh root@46.224.27.249
cd /var/www/staging
```

**Prüfen ob Slug frei ist:**
```bash
ls | grep [kunde-slug]
```

---

## 2. Projekt erstellen

```bash
# Option A: Mit Script (empfohlen)
/var/www/staging/_system/scripts/new-project.sh [kunde-slug]

# Option B: Manuell
mkdir [kunde-slug] && cd [kunde-slug]
pnpm create astro@latest . --template minimal --typescript strict
pnpm astro add tailwind
pnpm add -D alpinejs
pnpm add @klaro/core
```

---

## 3. Inputs hochladen

```bash
# Lokal ausführen:
scp kickoff.pdf logo.svg root@46.224.27.249:/var/www/staging/[kunde-slug]/inputs/
```

**Benötigt:**
- ✅ Kickoff-Dokument (Firmeninfos)
- ✅ Logo (SVG/PNG)
- 🔹 Optional: Stitch-Export, Bilder

---

## 4. Entwicklung

```bash
cd /var/www/staging/[kunde-slug]

# .env erstellen
cp .env.example .env
chmod 600 .env  # WICHTIG: Sicherheit!
nano .env       # API-Keys eintragen

# Dev-Server starten
pnpm dev
```

---

## 5. Preview einrichten

1. **astro.config.mjs:** `base: '/[kunde-slug]/'`
2. **ecosystem.config.cjs:** PORT anpassen (4321, 4322, ...)
3. **Build & PM2:** `pnpm build && pm2 start ecosystem.config.cjs`
4. **Nginx:** Location-Block in customers.lisn-agentur.com hinzufügen

**Preview-URL:** `https://customers.lisn-agentur.com/[kunde-slug]/`

---

## 6. Live-Gang

1. `base` aus astro.config.mjs entfernen
2. `pnpm build && pm2 restart [name]`
3. Nginx-Config für eigene Domain erstellen
4. SSL: `certbot --nginx -d [domain].at -d www.[domain].at`

---

## 📚 Weitere Dokumentation

| Thema | Datei |
|-------|-------|
| Formular + Brevo | [guides/brevo-forms.md](./guides/brevo-forms.md) |
| Cookie Banner | [guides/klaro-consent.md](./guides/klaro-consent.md) |
| Alpine.js Tipps | [guides/alpine-tips.md](./guides/alpine-tips.md) |
| Server Details | [deployment/server-setup.md](./deployment/server-setup.md) |
| Alle Regeln | [02_CORE_RULES.md](./02_CORE_RULES.md) |

---

## ⚠️ Wichtigste Regeln

1. **pnpm verwenden** (nicht npm!)
2. **Fonts lokal** (keine Google Fonts CDN)
3. **.env mit chmod 600** (Sicherheit!)
4. **Alpine.js Scripts mit `is:inline`**
5. **Brevo IP-Whitelist nicht vergessen**

---

*Vollständige Dokumentation: [00_INDEX.md](./00_INDEX.md)*
