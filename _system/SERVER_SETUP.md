# LISN Server Setup Documentation
**Server:** 46.224.27.249 (Hetzner VPS)
**Setup-Datum:** 2026-01-07
**Version:** 1.0

═══════════════════════════════════════════════════════════════════
## SERVER-ÜBERSICHT
═══════════════════════════════════════════════════════════════════

**Provider:** Hetzner
**IP:** 46.224.27.249
**OS:** Ubuntu 24.04.3 LTS (Noble Numbat)
**Kernel:** 6.8.0-71-generic
**Arch:** x86_64

**Ressourcen:**
- CPU: [automatisch von Hetzner]
- RAM: 3.7GB
- Speicher: 38GB (35GB frei)

═══════════════════════════════════════════════════════════════════
## INSTALLIERTE SOFTWARE
═══════════════════════════════════════════════════════════════════

### Development Tools

**Node.js & Package Manager:**
- Node.js: v20.19.6 (LTS)
- npm: 10.8.2
- pnpm: 10.27.0

**Version Control:**
- git: 2.43.0

### Web Server & Tools

**Webserver:**
- Nginx: 1.24.0 (Ubuntu)

**SSL/TLS:**
- certbot: 2.9.0 (Let's Encrypt)

**Deployment:**
- rsync: 3.2.7

═══════════════════════════════════════════════════════════════════
## ORDNER-STRUKTUR
═══════════════════════════════════════════════════════════════════

```
/var/www/
├── staging/                    # Development-Umgebung
│   ├── _system/               # System-Dokumentation
│   │   ├── MASTER_PROMPT.md
│   │   ├── BRAND_VOICE.md
│   │   ├── COMPONENT_LIBRARY.md
│   │   ├── WORKFLOW.md
│   │   ├── BREVO_INTEGRATION.md
│   │   ├── START_TEMPLATE.txt
│   │   ├── README.md
│   │   ├── SERVER_SETUP.md
│   │   ├── scripts/
│   │   │   ├── new-project.sh
│   │   │   ├── cleanup-project.sh
│   │   │   ├── archive-project.sh
│   │   │   └── restore-backup.sh
│   │   └── templates/
│   │
│   ├── _template/             # Master-Template (TODO)
│   │   ├── src/
│   │   ├── public/
│   │   └── package.json
│   │
│   ├── _archive/              # Archivierte Projekte
│   │   └── 2024/
│   │
│   └── [kunde-slug]/          # Aktive Entwicklungsprojekte
│
├── kunden/                    # Production (Live-Sites)
│   └── [kunde-slug]/
│       └── index.html
│
└── backups/                   # Automatische Backups
    └── [kunde]-YYYY-MM-DD-HHMMSS.tar.gz
```

**Berechtigungen:**
- `/var/www/staging/`: www-data:www-data, 755
- `/var/www/kunden/`: www-data:www-data, 755
- `/var/www/backups/`: root:root, 700

═══════════════════════════════════════════════════════════════════
## NGINX-KONFIGURATION
═══════════════════════════════════════════════════════════════════

**Config-Pfade:**
- Haupt-Config: `/etc/nginx/nginx.conf`
- Sites verfügbar: `/etc/nginx/sites-available/`
- Sites aktiviert: `/etc/nginx/sites-enabled/`
- Template: `/etc/nginx/sites-available/TEMPLATE-kunde`

**Standard-Features pro Site:**
- Gzip Compression
- Security Headers
- Static Asset Caching (1 Jahr)
- SSL/TLS via Let's Encrypt
- HTTP → HTTPS Redirect

**Neue Site hinzufügen:**
```bash
# 1. Config aus Template erstellen
cp /etc/nginx/sites-available/TEMPLATE-kunde /etc/nginx/sites-available/[kunde].at

# 2. Platzhalter ersetzen
nano /etc/nginx/sites-available/[kunde].at
# [KUNDE] → kunde-slug
# [DOMAIN] → kunde.at

# 3. Site aktivieren
ln -s /etc/nginx/sites-available/[kunde].at /etc/nginx/sites-enabled/

# 4. Config testen
nginx -t

# 5. Reload
systemctl reload nginx

# 6. SSL einrichten
certbot --nginx -d [kunde].at -d www.[kunde].at
```

═══════════════════════════════════════════════════════════════════
## WICHTIGE COMMANDS
═══════════════════════════════════════════════════════════════════

### Server-Management

```bash
# System-Status
systemctl status nginx
df -h                    # Speicherplatz
free -h                  # RAM
top                      # Prozesse
htop                     # Interaktiv (falls installiert)

# System-Updates
apt update
apt upgrade -y
apt autoremove -y

# Logs
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log
journalctl -u nginx -f
```

### pnpm-Management

```bash
# pnpm updaten
npm install -g pnpm@latest

# Store-Pfad anzeigen
pnpm store path

# Store aufräumen
pnpm store prune

# Global installierte Packages
pnpm list -g
```

### Nginx-Management

```bash
# Status
systemctl status nginx

# Starten/Stoppen
systemctl start nginx
systemctl stop nginx
systemctl restart nginx
systemctl reload nginx    # Ohne Downtime

# Config testen
nginx -t

# Version anzeigen
nginx -v
```

### SSL/Certbot

```bash
# Zertifikate auflisten
certbot certificates

# Zertifikat erneuern (Dry-Run)
certbot renew --dry-run

# Zertifikat erneuern (Live)
certbot renew

# Zertifikat force-erneuern
certbot renew --force-renewal

# Neues Zertifikat
certbot --nginx -d example.com -d www.example.com
```

### Backup-Management

```bash
# Backups auflisten
ls -lh /var/www/backups/

# Altes Backup löschen
rm /var/www/backups/[kunde]-2024-01-01-*.tar.gz

# Manuelles Backup erstellen
tar -czf /var/www/backups/[kunde]-$(date +%Y-%m-%d).tar.gz -C /var/www/staging [kunde]
tar -czf /var/www/backups/[kunde]-$(date +%Y-%m-%d).tar.gz -C /var/www/kunden [kunde]

# Backup wiederherstellen
tar -xzf /var/www/backups/[backup].tar.gz -C /var/www/staging/
```

═══════════════════════════════════════════════════════════════════
## HELPER-SCRIPTS
═══════════════════════════════════════════════════════════════════

Alle Scripts in: `/var/www/staging/_system/scripts/`

### new-project.sh
**Zweck:** Neues Kundenprojekt automatisch anlegen
```bash
/var/www/staging/_system/scripts/new-project.sh mueller-sanitaer
```

**Was passiert:**
- Ordner-Check (existiert bereits?)
- Astro-Projekt initialisieren
- Dependencies installieren (Tailwind, Alpine.js, Klaro)
- Ordnerstruktur anlegen
- Berechtigungen setzen

### cleanup-project.sh
**Zweck:** node_modules, dist, .astro löschen (Speicherplatz freigeben)
```bash
/var/www/staging/_system/scripts/cleanup-project.sh mueller-sanitaer
```

### archive-project.sh
**Zweck:** Projekt archivieren (aus staging entfernen)
```bash
/var/www/staging/_system/scripts/archive-project.sh mueller-sanitaer
```

**Was passiert:**
- Backup erstellen
- Projekt nach `_archive/YYYY/` verschieben
- Production bleibt unverändert

### restore-backup.sh
**Zweck:** Backup wiederherstellen
```bash
/var/www/staging/_system/scripts/restore-backup.sh /var/www/backups/mueller-sanitaer-2024-01-07-123456.tar.gz
```

═══════════════════════════════════════════════════════════════════
## SICHERHEIT
═══════════════════════════════════════════════════════════════════

### SSH-Zugang

**Aktuell:** Password-Authentication aktiv
**Empfehlung:** SSH-Key Authentication

```bash
# Lokal: SSH-Key generieren
ssh-keygen -t ed25519 -C "your@email.com"

# Public Key auf Server kopieren
ssh-copy-id root@46.224.27.249

# Auf Server: Password-Login deaktivieren
nano /etc/ssh/sshd_config
# PasswordAuthentication no
systemctl restart sshd
```

### Firewall (ufw)

**Status prüfen:**
```bash
ufw status
```

**Empfohlene Konfiguration:**
```bash
# Firewall konfigurieren
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp     # SSH
ufw allow 80/tcp     # HTTP
ufw allow 443/tcp    # HTTPS

# Aktivieren
ufw enable

# Status
ufw status verbose
```

### Automatische Updates

**Unattended Upgrades:**
```bash
# Installieren
apt install unattended-upgrades

# Konfigurieren
dpkg-reconfigure -plow unattended-upgrades

# Status prüfen
systemctl status unattended-upgrades
```

### Fail2Ban (optional)

**Installation:**
```bash
apt install fail2ban

# Config
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
nano /etc/fail2ban/jail.local

# Aktivieren
systemctl enable fail2ban
systemctl start fail2ban

# Status
fail2ban-client status
```

═══════════════════════════════════════════════════════════════════
## MONITORING & WARTUNG
═══════════════════════════════════════════════════════════════════

### Regelmäßige Aufgaben

**Täglich:**
- [ ] Logs prüfen (Fehler?)
- [ ] Websites erreichbar?

**Wöchentlich:**
- [ ] Backups prüfen (`ls /var/www/backups/`)
- [ ] Speicherplatz prüfen (`df -h`)

**Monatlich:**
- [ ] System-Updates (`apt update && apt upgrade`)
- [ ] SSL-Zertifikate prüfen (`certbot certificates`)
- [ ] pnpm updaten (`npm install -g pnpm@latest`)

**Quartal:**
- [ ] Alte Backups löschen (> 90 Tage)
- [ ] Archivierte Projekte aufräumen
- [ ] Sicherheits-Audit

### Monitoring-Tools (optional)

**Empfohlene Tools:**
- **UptimeRobot** - Website-Monitoring (kostenlos)
- **Netdata** - Server-Monitoring
- **Glances** - Terminal-basiert

═══════════════════════════════════════════════════════════════════
## TROUBLESHOOTING
═══════════════════════════════════════════════════════════════════

### Problem: Website nicht erreichbar

```bash
# 1. Nginx läuft?
systemctl status nginx

# 2. Config korrekt?
nginx -t

# 3. Logs prüfen
tail -f /var/log/nginx/error.log

# 4. Permissions?
ls -la /var/www/kunden/[kunde]/
chown -R www-data:www-data /var/www/kunden/[kunde]/
```

### Problem: SSL-Zertifikat abgelaufen

```bash
# 1. Certbot-Status
certbot certificates

# 2. Erneuern
certbot renew

# 3. Falls Fehler:
certbot renew --force-renewal

# 4. Nginx reload
systemctl reload nginx
```

### Problem: Speicherplatz voll

```bash
# 1. Speicher prüfen
df -h

# 2. Große Dateien finden
du -sh /var/www/* | sort -h
du -sh /var/www/staging/* | sort -h

# 3. node_modules löschen
find /var/www/staging -name "node_modules" -type d -exec rm -rf {} +

# 4. Alte Backups löschen
find /var/www/backups -name "*.tar.gz" -mtime +90 -delete

# 5. Apt-Cache leeren
apt clean
apt autoremove -y
```

### Problem: pnpm nicht gefunden

```bash
# 1. Neu installieren
npm install -g pnpm

# 2. PATH prüfen
echo $PATH
which pnpm

# 3. Shell neu laden
source ~/.bashrc
```

### Problem: Nginx startet nicht

```bash
# 1. Config testen
nginx -t

# 2. Port belegt?
netstat -tulpn | grep :80
netstat -tulpn | grep :443

# 3. Logs
tail -50 /var/log/nginx/error.log

# 4. Process killen (falls nötig)
killall nginx
systemctl start nginx
```

═══════════════════════════════════════════════════════════════════
## BACKUP-STRATEGIE
═══════════════════════════════════════════════════════════════════

### Automatische Backups (TODO)

**Cronjob einrichten:**
```bash
# Crontab editieren
crontab -e

# Tägliches Backup um 2:00 Uhr
0 2 * * * /var/www/staging/_system/scripts/backup-all-projects.sh

# Wöchentliche Bereinigung (Backups > 90 Tage löschen)
0 3 * * 0 find /var/www/backups -name "*.tar.gz" -mtime +90 -delete
```

### Manuelle Backups

**Projekt:**
```bash
tar -czf /var/www/backups/[kunde]-$(date +%Y-%m-%d).tar.gz -C /var/www/staging [kunde]
```

**Gesamter Server:**
```bash
# Lokal downloaden
rsync -avz --progress root@46.224.27.249:/var/www/ ./local-backup/
```

═══════════════════════════════════════════════════════════════════
## KONTAKT & NOTFALL
═══════════════════════════════════════════════════════════════════

**LISN GmbH**
Julien
E-Mail: [wird ergänzt]

**Server-Provider:**
Hetzner
Support: https://docs.hetzner.com

**Notfall-Kontakte:**
- Server offline: Hetzner-Support
- DNS-Probleme: Domain-Registrar
- SSL-Probleme: Let's Encrypt Status (https://letsencrypt.status.io)

═══════════════════════════════════════════════════════════════════
## CHANGELOG
═══════════════════════════════════════════════════════════════════

**2026-01-07 - Initial Setup**
- Server aufgesetzt (Ubuntu 24.04.3 LTS)
- Node.js v20.19.6 + pnpm 10.27.0 installiert
- Nginx 1.24.0 konfiguriert
- certbot 2.9.0 für SSL eingerichtet
- Ordnerstruktur erstellt
- Dokumentation geschrieben
- Helper-Scripts erstellt

**Nächste Schritte:**
- Master-Template Astro-Projekt erstellen
- Erstes Kundenprojekt testen
- Backup-Automation einrichten
- Monitoring-Tools installieren

═══════════════════════════════════════════════════════════════════


═══════════════════════════════════════════════════════════════════
## PM2 (PROCESS MANAGER) - UPDATE 2026-01-07
═══════════════════════════════════════════════════════════════════

PM2 wird für Astro SSR-Projekte benötigt, die API-Endpoints haben
(z.B. Kontaktformular mit Brevo-Integration).

### Installation

```bash
npm install -g pm2
```

### PM2-Basics

```bash
# Status aller Apps
pm2 status

# App starten (aus ecosystem.config.cjs)
pm2 start ecosystem.config.cjs

# App neu starten
pm2 restart app-name

# App stoppen
pm2 stop app-name

# App entfernen
pm2 delete app-name

# Logs anzeigen
pm2 logs app-name
pm2 logs app-name --lines 50

# Live-Monitoring
pm2 monit
```

### PM2 beim Systemstart

```bash
# Startup-Script generieren
pm2 startup

# Aktuellen Zustand speichern
pm2 save

# Nach Neustart: automatisch alle Apps starten
```

### Ecosystem-Config Template

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

### Multi-Projekt Port-Vergabe

Wenn mehrere SSR-Projekte laufen, verschiedene Ports verwenden:

| Projekt           | Port |
|-------------------|------|
| forstinger-haus-bad | 4321 |
| projekt-2         | 4322 |
| projekt-3         | 4323 |
| ...               | ...  |

### PM2 Troubleshooting

```bash
# Fehler prüfen
pm2 logs app-name --err

# App komplett neu starten
pm2 delete app-name
pm2 start ecosystem.config.cjs

# PM2 selbst neu starten
pm2 kill
pm2 resurrect
```


═══════════════════════════════════════════════════════════════════
## CUSTOMER PREVIEW SYSTEM (UPDATE 2026-01-07)
═══════════════════════════════════════════════════════════════════

### Übersicht

Zentrale Preview-URL für alle Kundenprojekte:
`customers.lisn-agentur.com/[projekt-slug]`

### DNS-Eintrag

```
customers.lisn-agentur.com → A-Record → 46.224.27.249
```

### Nginx-Konfiguration

**Datei:** `/etc/nginx/sites-available/customers.lisn-agentur.com`

```nginx
# LISN Customer Preview System
server {
    listen 80;
    server_name customers.lisn-agentur.com;

    # Root → Redirect zu LISN Website
    location = / {
        return 301 https://lisn-agentur.com;
    }

    # ═══════════════════════════════════════════════════════════
    # PROJEKT: forstinger-haus-bad (Port 4321)
    # ═══════════════════════════════════════════════════════════
    location /forstinger-haus-bad {
        proxy_pass http://127.0.0.1:4321;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
    }

    location /forstinger-haus-bad/_astro/ {
        alias /var/www/staging/forstinger-haus-bad/dist/client/_astro/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    location /forstinger-haus-bad/fonts/ {
        alias /var/www/staging/forstinger-haus-bad/dist/client/fonts/;
        expires 1y;
    }

    location /forstinger-haus-bad/images/ {
        alias /var/www/staging/forstinger-haus-bad/dist/client/images/;
        expires 1y;
    }

    # ═══════════════════════════════════════════════════════════
    # TEMPLATE: Neues Projekt hinzufügen (kopieren & anpassen)
    # ═══════════════════════════════════════════════════════════
    # location /neues-projekt {
    #     proxy_pass http://127.0.0.1:4322;
    #     proxy_http_version 1.1;
    #     proxy_set_header Host $host;
    #     proxy_set_header X-Real-IP $remote_addr;
    #     proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    #     proxy_set_header X-Forwarded-Proto $scheme;
    # }
    #
    # location /neues-projekt/_astro/ {
    #     alias /var/www/staging/neues-projekt/dist/client/_astro/;
    #     expires 1y;
    # }
    #
    # location /neues-projekt/fonts/ {
    #     alias /var/www/staging/neues-projekt/dist/client/fonts/;
    #     expires 1y;
    # }
    #
    # location /neues-projekt/images/ {
    #     alias /var/www/staging/neues-projekt/dist/client/images/;
    #     expires 1y;
    # }

    # Catch-all → Redirect zu LISN
    location / {
        return 301 https://lisn-agentur.com;
    }
}
```

### Neues Projekt hinzufügen

1. **Astro mit Base-Path konfigurieren:**
   ```javascript
   // astro.config.mjs
   export default defineConfig({
     base: '/neues-projekt',
     // ...
   });
   ```

2. **PM2 auf neuem Port starten:**
   ```javascript
   // ecosystem.config.cjs
   env: {
     PORT: 4322  // Nächster freier Port
   }
   ```

3. **Location-Block in Nginx kopieren und anpassen**

4. **Nginx neu laden:**
   ```bash
   nginx -t && systemctl reload nginx
   ```

### Port-Vergabe

| Projekt             | Port |
|---------------------|------|
| forstinger-haus-bad | 4321 |
| [nächstes-projekt]  | 4322 |
| [weiteres-projekt]  | 4323 |
| ...                 | ...  |

### SSL für Preview (optional)

```bash
certbot --nginx -d customers.lisn-agentur.com
```

### Troubleshooting

**Problem:** 502 Bad Gateway
```bash
# PM2 läuft?
pm2 status

# Logs prüfen
pm2 logs projekt-name
```

**Problem:** 404 auf Unterseiten
```bash
# Base-Path in astro.config.mjs gesetzt?
# Nginx-Location korrekt?
```

**Problem:** Assets laden nicht (CSS/JS fehlt)
```bash
# Alias-Pfade in Nginx prüfen
# dist/client/ Ordner existiert?
ls /var/www/staging/projekt/dist/client/
```


═══════════════════════════════════════════════════════════════════
## NGINX: TRAILING SLASH REDIRECT (UPDATE 2026-01-07)
═══════════════════════════════════════════════════════════════════

### Problem

Astro mit `base: '/projekt/'` erwartet URLs mit Trailing Slash.
Ohne Redirect: `/projekt` → 404

### Lösung

```nginx
# EXAKTER Match ohne Trailing Slash → Redirect
location = /projekt-slug {
    return 301 $scheme://$host/projekt-slug/;
}

# Alle Requests MIT Trailing Slash → Proxy
location /projekt-slug/ {
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
```

### Ergebnis

- `/projekt-slug` → 301 → `/projekt-slug/`
- `/projekt-slug/` → 200 (Proxy zu Node.js)
- `/projekt-slug/formular` → 200 (Proxy zu Node.js)

### Aktuelle customers.lisn-agentur.com Config

```nginx
server {
    server_name customers.lisn-agentur.com;

    # Root → LISN Website
    location = / {
        return 301 https://lisn-agentur.com;
    }

    # Redirect ohne Slash
    location = /forstinger-haus-bad {
        return 301 $scheme://$host/forstinger-haus-bad/;
    }

    # Proxy mit Slash
    location /forstinger-haus-bad/ {
        proxy_pass http://127.0.0.1:4321;
        # ... headers
    }

    # Static Assets
    location /forstinger-haus-bad/_astro/ { ... }
    location /forstinger-haus-bad/fonts/ { ... }
    location /forstinger-haus-bad/images/ { ... }

    # Catch-all → LISN
    location / {
        return 301 https://lisn-agentur.com;
    }

    # SSL (certbot managed)
    listen 443 ssl;
    ssl_certificate ...;
}
```

