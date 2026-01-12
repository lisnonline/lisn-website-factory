# PM2 & Nginx Setup für Astro SSR

> **Dieser Guide beschreibt das Setup für Node.js basierte Astro-Projekte (SSR) hinter Nginx.**

---

## 1. PM2 (Process Manager)

PM2 wird für Astro SSR-Projekte benötigt, die API-Endpoints haben (z.B. Kontaktformular mit Brevo-Integration).

### Installation

```bash
npm install -g pm2
```

### Ecosystem Config

Jedes Projekt braucht eine `ecosystem.config.cjs` im Root:

```javascript
module.exports = {
  apps: [{
    name: 'projekt-slug',
    script: './dist/server/entry.mjs',
    cwd: '/var/www/staging/projekt-slug',
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

### Port-Vergabe

Jedes Projekt benötigt einen eigenen Port:

| Projekt | Port |
|---------|------|
| forstinger-haus-bad | 4321 |
| [projekt-2] | 4322 |
| [projekt-3] | 4323 |

### PM2 Commands

```bash
# Starten
pm2 start ecosystem.config.cjs

# Status
pm2 status

# Neustart (nach Updates)
pm2 restart [name]

# Logs
pm2 logs [name]
```

### Autostart einrichten

```bash
pm2 startup
pm2 save
```

---

## 2. Customer Preview System

Zentrale URL: `customers.lisn-agentur.com/[projekt-slug]`

### Nginx Konfiguration

Datei: `/etc/nginx/sites-available/customers.lisn-agentur.com`

Pro Projekt muss ein neuer Block hinzugefügt werden:

```nginx
# PROJECT: projekt-slug (Port 4321)
location /projekt-slug {
    proxy_pass http://127.0.0.1:4321;
    proxy_http_version 1.1;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
}

# Static Assets (für Performance & Caching)
location /projekt-slug/_astro/ {
    alias /var/www/staging/projekt-slug/dist/client/_astro/;
    expires 1y;
    add_header Cache-Control "public, immutable";
}

location /projekt-slug/fonts/ {
    alias /var/www/staging/projekt-slug/dist/client/fonts/;
    expires 1y;
}

location /projekt-slug/images/ {
    alias /var/www/staging/projekt-slug/dist/client/images/;
    expires 1y;
}
```

### Neuen Preview anlegen

1. **Astro Config:** `base: '/projekt-slug/'` setzen
2. **PM2:** Auf neuem Port starten
3. **Nginx:** Location-Block hinzufügen
4. **Reload:** `nginx -t && systemctl reload nginx`

---

## 3. Troubleshooting

**Fehler 502 Bad Gateway:**
- Läuft PM2 Prozess? (`pm2 status`)
- Stimmt der Port in Nginx und PM2 überein?

**Assets laden nicht (404):**
- Stimmt der Alias-Pfad in Nginx?
- Wurde `pnpm build` ausgeführt? (Existiert `dist/client`?)

**404 auf Unterseiten:**
- Ist `base` in Astro Config gesetzt?
