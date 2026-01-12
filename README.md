# LISN Website Factory

Dokumentation, Prompts und Templates fuer die LISN Website-Produktion.

## Struktur

```
lisn-website-factory/
├── _system/              # Dokumentation & Scripts
│   ├── MASTER_PROMPT.md  # Haupt-Prompt fuer Claude
│   ├── COMPONENT_LIBRARY.md
│   ├── WORKFLOW.md
│   ├── SERVER_SETUP.md
│   ├── BREVO_INTEGRATION.md
│   ├── KLARO_COOKIE_BANNER.md
│   ├── BRAND_VOICE.md
│   ├── scripts/          # Shell-Scripts fuer Projektverwaltung
│   └── templates/        # Code-Templates (Klaro, etc.)
└── _template/            # Basis-Template fuer neue Projekte
```

## Hauptdokumentationen

| Datei | Beschreibung |
|-------|--------------|
| `MASTER_PROMPT.md` | Kompletter Prompt fuer Claude - Tech Stack, Komponenten, Workflows |
| `COMPONENT_LIBRARY.md` | Alle verfuegbaren UI-Komponenten |
| `WORKFLOW.md` | Schritt-fuer-Schritt Projekt-Workflow |
| `SERVER_SETUP.md` | Server-Konfiguration und Deployment |
| `BREVO_INTEGRATION.md` | E-Mail/CRM Integration mit Brevo |
| `KLARO_COOKIE_BANNER.md` | DSGVO-konformer Cookie-Banner |
| `BRAND_VOICE.md` | LISN Markenstimme und Tonalitaet |

## Scripts

```bash
# Neues Projekt anlegen
./scripts/new-project.sh [kunde-slug]

# Projekt archivieren
./scripts/archive-project.sh [kunde-slug]

# Projekt-Ordner bereinigen
./scripts/cleanup-project.sh [kunde-slug]

# Backup wiederherstellen
./scripts/restore-backup.sh [kunde-slug] [backup-file]
```

## Server

- **Host:** 46.224.27.249
- **Pfad:** `/var/www/staging/_system/`
- **Auto-Deploy:** Push zu `main` deployt automatisch

## Deployment

Push zu `main` Branch triggert automatisch:
1. rsync Dateien zum Server
2. Berechtigungen setzen

---

**LISN GmbH** - Digital Marketing Agentur
