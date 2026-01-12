#!/bin/bash
# LISN Website Factory - Neues Projekt anlegen
# Usage: ./new-project.sh [kunde-slug]
# Update: 2026-01-12 - Security improvements

set -e

if [ -z "$1" ]; then
  echo "Fehler: Kunden-Slug fehlt"
  echo "Usage: ./new-project.sh mueller-sanitaer"
  exit 1
fi

KUNDE="$1"
STAGING="/var/www/staging/${KUNDE}"
KUNDEN="/var/www/kunden/${KUNDE}"

echo "LISN - Neues Projekt anlegen"
echo "============================="
echo "Kunde: ${KUNDE}"
echo ""

# Check ob bereits existiert
if [ -d "$STAGING" ]; then
  echo "Fehler: Projekt existiert bereits in /var/www/staging/${KUNDE}"
  exit 1
fi

if [ -d "$KUNDEN" ]; then
  echo "Warnung: Projekt existiert bereits in /var/www/kunden/${KUNDE}"
  read -p "Fortfahren? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

# Ordner erstellen
echo "[1/7] Erstelle Ordner..."
mkdir -p "$STAGING"
cd "$STAGING"

# Astro initialisieren
echo "[2/7] Initialisiere Astro-Projekt..."
pnpm create astro@latest . --template minimal --typescript strict --yes

# Dependencies
echo "[3/7] Installiere Dependencies..."
pnpm astro add tailwind --yes
pnpm add -D alpinejs
pnpm add @klaro/core

# Ordnerstruktur
echo "[4/7] Erstelle Ordnerstruktur..."
mkdir -p src/components/{global,sections,forms,legal}
mkdir -p src/layouts
mkdir -p public/{fonts,images}
mkdir -p inputs

# .env.example erstellen
echo "[5/7] Erstelle .env.example..."
cat > .env.example << 'ENVEOF'
# Brevo API (E-Mail)
BREVO_API_KEY=your_api_key_here

# Meta Pixel (optional)
META_PIXEL_ID=
META_ACCESS_TOKEN=

# Site Config
SITE_URL=https://firmenname.at
ENVEOF

# .gitignore erstellen
echo "[6/7] Erstelle .gitignore..."
cat > .gitignore << 'GITEOF'
# Dependencies
node_modules/

# Build
dist/
.astro/

# Environment (NIEMALS committen!)
.env
.env.local
.env.production

# OS
.DS_Store
Thumbs.db

# Editor
.idea/
.vscode/
*.swp

# Logs
*.log
npm-debug.log*
GITEOF

# Berechtigungen
echo "[7/7] Setze Berechtigungen..."
chown -R www-data:www-data "$STAGING"
chmod -R 755 "$STAGING"

echo ""
echo "============================="
echo "Projekt erfolgreich angelegt!"
echo "Pfad: ${STAGING}"
echo ""
echo "Naechste Schritte:"
echo "1. Inputs hochladen: scp inputs/* root@46.224.27.249:${STAGING}/inputs/"
echo "2. .env erstellen: cp .env.example .env && chmod 600 .env"
echo "3. Development starten: cd ${STAGING} && pnpm dev"
echo "4. Documentation lesen: cat /var/www/staging/_system/MASTER_PROMPT.md"
echo ""
echo "WICHTIG: .env IMMER mit chmod 600 erstellen!"
echo "============================="
