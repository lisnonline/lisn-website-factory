# Troubleshooting Guide

Zentrale Sammlung häufiger Probleme und Lösungen.

---

## 🛠️ Build & Deployment

### Build schlägt fehl
```bash
# Cache löschen und neu installieren
rm -rf node_modules .astro dist
pnpm install
pnpm build
```

### pnpm nicht gefunden
```bash
npm install -g pnpm
source ~/.bashrc
```

### Speicherplatz voll
```bash
# Node Modules von alten Projekten löschen
/var/www/staging/_system/scripts/cleanup-project.sh [kunde-slug]

# Alte Backups löschen
find /var/www/backups -name "*.tar.gz" -mtime +90 -delete
```

---

## 🌐 Server & Nginx

### Website nicht erreichbar (502 Bad Gateway)
1. **PM2 Status prüfen:** `pm2 status`
2. **Logs prüfen:** `pm2 logs [app-name]`
3. **Nginx Status:** `systemctl status nginx`

### 404 auf Unterseiten (Preview)
- Prüfen ob `base: '/slug/'` in `astro.config.mjs` gesetzt ist
- Prüfen ob Nginx Location Block korrekt ist

### SSL Zertifikat abgelaufen
```bash
certbot renew
# Falls Fehler:
certbot renew --force-renewal
systemctl reload nginx
```

---

## 📨 Formulare & API (Brevo)

### Formular sendet nicht
1. **Console prüfen:** Netzwerk-Tab > Response ansehen
2. **Logs am Server:** `pm2 logs [app-name]`
3. **Brevo API Key:** Sitmmt der Key in `.env`?
4. **IP Whitelist:** Ist die Server-IP (46.224.27.249) in Brevo freigegeben?

### API Fehler 404
- Läuft das Projekt unter einem Subpfad?
- Siehe [Base URL Guide](../guides/base-url.md) für Client-Side Fetch Fix.

### E-Mail-Text nicht lesbar (Light Mode)
- Weißer Text auf weißem Hintergrund im E-Mail-Client?
- **Ursache:** E-Mail-Clients entfernen CSS `background`, behalten aber `color: white`
- **Lösung:** Inline-Styles auf jedem Text-Element: `<h1 style="color: #ffffff;">`
- Siehe [Brevo Forms Guide - E-Mail Styling](../guides/brevo-forms.md#e-mail-styling-best-practices-update-2026-01-13)

---

## 💻 Frontend (Astro/Alpine)

### Alpine.js reagiert nicht
- Wurde `<script>` ohne `is:inline` verwendet? Astro bündelt Scripts, was globale Funktionen versteckt.
- **Lösung:** Immer `<script is:inline>` verwenden für Alpine-Logik.

### Fonts werden nicht geladen
- Pfad in `global.css` prüfen (muss relativ zu public sein)
- Prüfen ob Fonts in `/public/fonts/` liegen

### Bilder 404
- Fehlt der Base-Path im `src` Attribut?
- Nutzung: `<img src={base + 'images/logo.png'} />`

---

## 🍪 Klaro Cookie Banner

### Banner erscheint nicht
- Config geladen? (Console prüfen)
- CSS geladen?

### Google Analytics feuert nicht
- Wurde Consent gegeben?
- Prüfen ob `gtag` korrekt initialisiert ist
- Ad-Blocker aktiv?
