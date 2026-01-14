# LISN Website Factory - Dokumentation

> **Zentrale Übersicht aller Dokumentationen für die LISN Website-Produktion.**

---

## 🚀 Quick Start

Neues Projekt starten? → [01_QUICK_START.md](./01_QUICK_START.md)

Bestehendes Projekt ändern? → [guides/project-updates.md](./guides/project-updates.md)

---

## 📁 Dokumentations-Struktur

### Core (immer lesen)

| Datei | Beschreibung |
|-------|--------------|
| [01_QUICK_START.md](./01_QUICK_START.md) | 1-Seiten Kurzanleitung für neue Projekte |
| [02_CORE_RULES.md](./02_CORE_RULES.md) | Tech Stack, Naming, kritische Regeln |

---

### 📘 Guides (thematische Anleitungen)

| Datei | Beschreibung |
|-------|--------------|
| [guides/project-updates.md](./guides/project-updates.md) | **Bestehende Projekte ändern (Bilder, Text, Deploy)** |
| [guides/astro-components.md](./guides/astro-components.md) | Standard UI-Komponenten |
| [guides/brevo-forms.md](./guides/brevo-forms.md) | Formular-Backend mit Brevo API |
| [guides/klaro-consent.md](./guides/klaro-consent.md) | DSGVO Cookie Banner Setup |
| [guides/alpine-tips.md](./guides/alpine-tips.md) | Alpine.js Best Practices |
| [guides/base-url.md](./guides/base-url.md) | Preview-URLs mit Base Path |

---

### 🖥️ Deployment

| Datei | Beschreibung |
|-------|--------------|
| [deployment/server-setup.md](./deployment/server-setup.md) | Hetzner VPS Konfiguration |
| [deployment/pm2-nginx.md](./deployment/pm2-nginx.md) | PM2 + Nginx für SSR-Projekte |

---

### 📚 Referenz (Nachschlagen)

| Datei | Beschreibung |
|-------|--------------|
| [reference/brand-voice.md](./reference/brand-voice.md) | Tonalität-Guide für Texte |
| [reference/workflow-checklist.md](./reference/workflow-checklist.md) | Projekt-Workflow Schritt für Schritt |
| [reference/troubleshooting.md](./reference/troubleshooting.md) | Häufige Probleme & Lösungen |
| [reference/start-template.md](./reference/start-template.md) | Copy-Paste Prompt für neue Projekte |
| [reference/dashboard-plan.md](./reference/dashboard-plan.md) | Dashboard Implementierungsplan |

---

### 🛠️ Scripts

| Script | Befehl |
|--------|--------|
| Neues Projekt | `./scripts/new-project.sh [kunde-slug]` |
| Projekt archivieren | `./scripts/archive-project.sh [kunde-slug]` |
| Aufräumen (node_modules) | `./scripts/cleanup-project.sh [kunde-slug]` |
| Backup wiederherstellen | `./scripts/restore-backup.sh [backup-file]` |

---

### 🤖 Claude Code Commands

Slash Commands für Claude Code zur Projekt-Verwaltung.
Siehe [commands/README.md](./commands/README.md) für Installation.

| Command | Beschreibung |
|---------|--------------|
| `/lisn-update` | Änderungen an bestehendem Projekt |
| `/lisn-newproject` | Neues Projekt erstellen |

---

### 📦 Templates

| Datei | Beschreibung |
|-------|--------------|
| [templates/klaro-config-template.js](./templates/klaro-config-template.js) | Klaro Konfiguration mit Meta Pixel |
| [templates/klaro-theme-template.css](./templates/klaro-theme-template.css) | Klaro Custom Styling |

---

## 🔗 Server-Informationen

| Feld | Wert |
|------|------|
| **IP** | 46.224.27.249 |
| **SSH** | `ssh root@46.224.27.249` |
| **Staging** | `/var/www/staging/` |
| **Production** | `/var/www/kunden/` |
| **Preview** | `https://customers.lisn-agentur.com/[slug]/` |

---

*Stand: 2026-01-14*
