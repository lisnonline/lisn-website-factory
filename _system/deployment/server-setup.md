# LISN Server Setup Documentation

**Server:** 46.224.27.249 (Hetzner VPS)
**Setup-Datum:** 2026-01-07
**Version:** 1.0

---

## 1. Server-Übersicht

**Provider:** Hetzner
**IP:** 46.224.27.249
**OS:** Ubuntu 24.04.3 LTS (Noble Numbat)
**Kernel:** 6.8.0-71-generic
**Arch:** x86_64

**Ressourcen:**
- RAM: 3.7GB
- Speicher: 38GB (35GB frei)

---

## 2. Installierte Software

### Development Tools
- **Node.js:** v24.13.0 (LTS)
- **pnpm:** 10.27.0
- **git:** 2.43.0

### Web Server & Tools
- **Nginx:** 1.24.0
- **Certbot:** 2.9.0 (Let's Encrypt)
- **Rsync:** 3.2.7

---

## 3. Ordner-Struktur

```
/var/www/
├── staging/                    # Development-Umgebung
│   ├── _system/               # Docs & Scripts
│   ├── _archive/              # Archivierte Projekte
│   └── [kunde-slug]/          # Aktive Projekte (Port 4321+)
│
├── kunden/                    # Production (Live-Sites)
│   └── [kunde-slug]/          # Statische oder SSR Builds
│
└── backups/                   # Automatische Backups
```

**Berechtigungen:**
- Web-Root: `www-data:www-data`, 755
- Backups: `root:root`, 700

---

## 4. Sicherheit

### SSH-Zugang
**Empfehlung:** SSH-Key Authentication nutzen.
```bash
nano /etc/ssh/sshd_config
# PasswordAuthentication no
systemctl restart sshd
```

### Firewall (UFW)
```bash
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp     # SSH
ufw allow 80/tcp     # HTTP
ufw allow 443/tcp    # HTTPS
ufw enable
```

### Automatische Updates
`unattended-upgrades` ist installiert und aktiv für Sicherheits-Updates.

---

## 5. Monitoring & Wartung

### Tägliche Checks
- [ ] Logs prüfen: `tail -f /var/log/nginx/error.log`
- [ ] Websites erreichbar?

### Monatliche Wartung
```bash
apt update && apt upgrade -y
npm install -g pnpm@latest
certbot renew
```

### Backup-Strategie
- **Automatisch:** Cronjob um 2:00 Uhr (TODO)
- **Manuell:** `./scripts/archive-project.sh` nutzen
- **Speicherort:** `/var/www/backups/`
- **Retention:** Backups > 90 Tage löschen

---

## 6. Wichtige Commands

### Nginx
```bash
systemctl status nginx
nginx -t                 # Config testen
systemctl reload nginx   # Reload ohne Downtime
```

### SSL (Certbot)
```bash
certbot certificates
certbot renew
certbot --nginx -d domain.com
```

### Speicherplatz
```bash
df -h                    # Disk Usage
du -sh /var/www/*        # Ordnergrößen
```

---

## 7. App-Deployment (PM2)

Für Node.js Deployment und PM2 Konfiguration siehe:
👉 **[deployment/pm2-nginx.md](./pm2-nginx.md)**

---

## 8. Kontakt & Notfall

**Server-Provider:** Hetzner (Support: docs.hetzner.com)
**Status:** https://status.hetzner.com/
**SSL Status:** https://letsencrypt.status.io
