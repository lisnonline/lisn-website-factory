# LISN Website Factory - System Documentation
**Server:** 46.224.27.249 (Hetzner VPS)
**OS:** Ubuntu 24.04.3 LTS
**Version:** 1.0
**Setup-Datum:** 2026-01-07

═══════════════════════════════════════════════════════════════════
## ÜBERSICHT
═══════════════════════════════════════════════════════════════════

Dieses System ist eine vollautomatisierte Website-Factory für LISN-Kundenprojekte (Handwerksbetriebe in Österreich).

**Tech Stack:**
- Astro 4.x (Static Site Generator)
- Tailwind CSS 3.x
- Alpine.js
- pnpm
- Nginx
- Brevo API (Formulare)

═══════════════════════════════════════════════════════════════════
## SERVER-SPECS
═══════════════════════════════════════════════════════════════════

**Hardware:**
- Provider: Hetzner
- IP: 46.224.27.249
- Speicher: 38GB (35GB frei)
- RAM: 3.7GB

**Software:**
- OS: Ubuntu 24.04.3 LTS
- Node.js: v20.19.6
- npm: 10.8.2
- pnpm: 10.27.0
- Nginx: 1.24.0
- Git: 2.43.0
- rsync: 3.2.7
- certbot: 2.9.0

═══════════════════════════════════════════════════════════════════
## ORDNER-STRUKTUR
═══════════════════════════════════════════════════════════════════

```
/var/www/
├── staging/                    # Development-Ordner
│   ├── _system/               # Zentrale Dokumentation
│   │   ├── MASTER_PROMPT.md   # Haupt-Workflow
│   │   ├── BRAND_VOICE.md     # Tonalität-Guide
│   │   ├── COMPONENT_LIBRARY.md # Component-Docs
│   │   ├── WORKFLOW.md        # Schritt-für-Schritt
│   │   ├── BREVO_INTEGRATION.md # Formular-Setup
│   │   ├── START_TEMPLATE.txt # Projekt-Start Template
│   │   ├── README.md          # Diese Datei
│   │   ├── scripts/           # Helper-Scripts
│   │   └── templates/         # Config-Templates
│   │
│   ├── _template/             # Master-Template
│   │   ├── src/               # Astro-Components
│   │   ├── public/            # Static Assets
│   │   └── package.json
│   │
│   ├── _archive/              # Alte Projekte
│   │   └── 2024/
│   │
│   └── [kunde-slug]/          # Aktive Kundenprojekte
│       ├── src/
│       ├── public/
│       ├── inputs/            # Kunden-Uploads
│       ├── config.json
│       ├── deploy.sh
│       └── package.json
│
├── kunden/                    # Production - Live-Sites
│   └── [kunde-slug]/          # Gebuildte Sites
│       └── index.html
│
└── backups/                   # Automatische Backups
    └── [kunde]-YYYY-MM-DD-HHMMSS.tar.gz
```

═══════════════════════════════════════════════════════════════════
## DOKUMENTATION
═══════════════════════════════════════════════════════════════════

### MASTER_PROMPT.md
**Zweck:** Kompletter Workflow für neue Projekte
**Enthält:**
- Tech Stack Details
- Projekt-Workflow (1-9 Schritte)
- Standard-Seiten
- Config-Strukturen
- Deployment-Prozess
- Qualitätssicherung

**Verwendung:**
```bash
cat /var/www/staging/_system/MASTER_PROMPT.md
```

---

### BRAND_VOICE.md
**Zweck:** Tonalität-Guide für alle Texte
**Enthält:**
- Kern-Prinzipien (Unternehmer für Unternehmer)
- Tonalität-Regeln (DOs & DON'Ts)
- Branchen-spezifische Beispiele
- Content-Typen (Headlines, CTAs, etc.)
- Praxis-Beispiele

**Verwendung:**
Vor jedem neuen Projekt lesen!

---

### COMPONENT_LIBRARY.md
**Zweck:** Übersicht aller Standard-Components
**Enthält:**
- Global Components (Header, Footer)
- Section Components (Hero, Features, etc.)
- Form Components (Multi-Step)
- Legal Components (Cookie Banner)
- Code-Beispiele

**Verwendung:**
Als Referenz beim Entwickeln

---

### WORKFLOW.md
**Zweck:** Schritt-für-Schritt Anleitung
**Enthält:**
- 9 Phasen (von Akquise bis Wartung)
- Commands für jeden Schritt
- Checklisten
- Troubleshooting

**Verwendung:**
Als Checkliste für jedes neue Projekt

---

### BREVO_INTEGRATION.md
**Zweck:** Formular-Backend Setup
**Enthält:**
- Brevo-Account Setup
- API-Endpoint Code
- Frontend-Integration
- Testing-Anleitung
- Troubleshooting

**Verwendung:**
Bei jedem Formular-Setup

---

### START_TEMPLATE.txt
**Zweck:** Copy-Paste Template für neue Projekte
**Enthält:**
- Formular für Kunden-Infos
- Inputs-Checkliste
- Brevo-Config
- Aufgabe für Claude

**Verwendung:**
Als Prompt an Claude senden

═══════════════════════════════════════════════════════════════════
## WORKFLOWS
═══════════════════════════════════════════════════════════════════

### Neues Projekt starten

```bash
# 1. Auf Server einloggen
ssh root@46.224.27.249

# 2. Ordner erstellen
cd /var/www/staging
mkdir [kunde-slug]
cd [kunde-slug]

# 3. Astro initialisieren
pnpm create astro@latest . --template minimal --typescript strict
pnpm astro add tailwind
pnpm add -D alpinejs
pnpm add @klaro/core

# 4. Ordnerstruktur
mkdir -p src/components/{global,sections,forms,legal}
mkdir -p src/layouts
mkdir -p public/{fonts,images}
mkdir inputs

# 5. Development starten
pnpm dev
```

### Projekt deployen

```bash
# 1. Build testen
pnpm build
pnpm preview

# 2. Deploy-Script ausführen
chmod +x deploy.sh
./deploy.sh

# 3. Nginx-Config erstellen
cp /etc/nginx/sites-available/TEMPLATE-kunde /etc/nginx/sites-available/[kunde].at
nano /etc/nginx/sites-available/[kunde].at
ln -s /etc/nginx/sites-available/[kunde].at /etc/nginx/sites-enabled/
nginx -t
systemctl reload nginx

# 4. SSL einrichten
certbot --nginx -d [kunde].at -d www.[kunde].at
```

### Projekt archivieren

```bash
# 1. Backup erstellen
tar -czf /var/www/backups/[kunde]-$(date +%Y-%m-%d).tar.gz -C /var/www/staging [kunde-slug]

# 2. Nach Archive verschieben
mv /var/www/staging/[kunde-slug] /var/www/staging/_archive/2024/

# 3. Production behalten (oder auch entfernen)
# /var/www/kunden/[kunde-slug] bleibt bestehen
```

═══════════════════════════════════════════════════════════════════
## HELPER-SCRIPTS
═══════════════════════════════════════════════════════════════════

Siehe `/var/www/staging/_system/scripts/`:

1. **new-project.sh** - Neues Projekt automatisch anlegen
2. **cleanup-project.sh** - node_modules/dist löschen
3. **archive-project.sh** - Projekt archivieren
4. **restore-backup.sh** - Backup wiederherstellen

═══════════════════════════════════════════════════════════════════
## WICHTIGE COMMANDS
═══════════════════════════════════════════════════════════════════

### Server-Management

```bash
# Server-Status
systemctl status nginx
df -h                           # Speicherplatz
free -h                         # RAM
top                             # Prozesse

# Logs
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log

# Updates
apt update && apt upgrade -y
npm install -g pnpm@latest
```

### pnpm-Management

```bash
# Global installierte Packages
pnpm list -g

# pnpm Store Location
pnpm store path

# Store aufräumen
pnpm store prune
```

### Nginx-Management

```bash
# Config testen
nginx -t

# Reload (ohne Downtime)
systemctl reload nginx

# Restart
systemctl restart nginx

# Sites verfügbar/aktiviert
ls /etc/nginx/sites-available/
ls /etc/nginx/sites-enabled/
```

### SSL-Management

```bash
# Zertifikate auflisten
certbot certificates

# Zertifikat erneuern (Dry-Run)
certbot renew --dry-run

# Zertifikat erneuern (Force)
certbot renew --force-renewal
```

### Backup-Management

```bash
# Backups anzeigen
ls -lh /var/www/backups/

# Altes Backup löschen
rm /var/www/backups/[kunde]-2024-01-01-*.tar.gz

# Backup wiederherstellen
tar -xzf /var/www/backups/[backup].tar.gz -C /var/www/staging/
```

═══════════════════════════════════════════════════════════════════
## TROUBLESHOOTING
═══════════════════════════════════════════════════════════════════

### Problem: "pnpm not found"

```bash
npm install -g pnpm
# oder
corepack enable
corepack prepare pnpm@latest --activate
```

### Problem: "Permission denied" bei /var/www/

```bash
# Berechtigungen prüfen
ls -la /var/www/

# Berechtigungen setzen
chown -R www-data:www-data /var/www/staging
chown -R www-data:www-data /var/www/kunden
chmod -R 755 /var/www/staging
chmod -R 755 /var/www/kunden
```

### Problem: Nginx startet nicht

```bash
# Config testen
nginx -t

# Error-Log prüfen
tail -f /var/log/nginx/error.log

# Syntax-Fehler beheben
nano /etc/nginx/sites-available/[site]

# Restart
systemctl restart nginx
```

### Problem: SSL-Zertifikat läuft ab

```bash
# Auto-Renewal prüfen
systemctl status certbot.timer

# Manuell erneuern
certbot renew

# Falls Fehler:
certbot renew --force-renewal
```

### Problem: Speicherplatz voll

```bash
# Speicherplatz prüfen
df -h

# Große Dateien finden
du -sh /var/www/* | sort -h

# node_modules löschen
find /var/www/staging -name "node_modules" -type d -exec rm -rf {} +

# Alte Backups löschen
find /var/www/backups -name "*.tar.gz" -mtime +90 -delete
```

═══════════════════════════════════════════════════════════════════
## SICHERHEIT
═══════════════════════════════════════════════════════════════════

### SSH-Key Authentication (empfohlen)

```bash
# Lokal: SSH-Key generieren
ssh-keygen -t ed25519 -C "your@email.com"

# Public Key auf Server kopieren
ssh-copy-id root@46.224.27.249

# Password-Login deaktivieren
nano /etc/ssh/sshd_config
# PasswordAuthentication no
systemctl restart sshd
```

### Firewall (ufw)

```bash
# Status prüfen
ufw status

# Ports öffnen
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS

# Firewall aktivieren
ufw enable
```

### Updates

```bash
# Wöchentliche Updates
apt update && apt upgrade -y

# Unattended Upgrades einrichten
apt install unattended-upgrades
dpkg-reconfigure -plow unattended-upgrades
```

═══════════════════════════════════════════════════════════════════
## KONTAKT & SUPPORT
═══════════════════════════════════════════════════════════════════

**LISN GmbH**
Julien
E-Mail: [wird noch ergänzt]

**Server:**
Hetzner VPS
IP: 46.224.27.249
SSH: root@46.224.27.249

**Notfälle:**
- Server offline: Hetzner-Support kontaktieren
- Website down: Nginx-Logs prüfen
- Formular funktioniert nicht: Brevo-Status prüfen

═══════════════════════════════════════════════════════════════════
## CHANGELOG
═══════════════════════════════════════════════════════════════════

**2026-01-07 - Initial Setup (v1.0)**
- Server aufgesetzt (Ubuntu 24.04.3 LTS)
- Node.js v20.19.6 + pnpm 10.27.0 installiert
- Nginx 1.24.0 konfiguriert
- Ordnerstruktur angelegt
- Dokumentation erstellt (MASTER_PROMPT, BRAND_VOICE, etc.)
- Helper-Scripts erstellt
- Master-Template vorbereitet

═══════════════════════════════════════════════════════════════════
