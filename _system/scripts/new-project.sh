#!/bin/bash
# LISN Website Factory - Neues Projekt anlegen
# Usage: ./new-project.sh [kunde-slug]

set -e

if [ -z "$1" ]; then
  echo "❌ Fehler: Kunden-Slug fehlt"
  echo "Usage: ./new-project.sh mueller-sanitaer"
  exit 1
fi

KUNDE="$1"
STAGING="/var/www/staging/${KUNDE}"
KUNDEN="/var/www/kunden/${KUNDE}"

echo "🚀 LISN - Neues Projekt anlegen"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Kunde: ${KUNDE}"
echo ""

# Check ob bereits existiert
if [ -d "$STAGING" ]; then
  echo "❌ Fehler: Projekt existiert bereits in /var/www/staging/${KUNDE}"
  exit 1
fi

if [ -d "$KUNDEN" ]; then
  echo "⚠️  Warnung: Projekt existiert bereits in /var/www/kunden/${KUNDE}"
  read -p "Fortfahren? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

# Ordner erstellen
echo "📁 Erstelle Ordner..."
mkdir -p "$STAGING"
cd "$STAGING"

# Astro initialisieren
echo "🎨 Initialisiere Astro-Projekt..."
pnpm create astro@latest . --template minimal --typescript strict --yes

# Dependencies
echo "📦 Installiere Dependencies..."
pnpm astro add tailwind --yes
pnpm add -D alpinejs
pnpm add @klaro/core

# Ordnerstruktur
echo "📂 Erstelle Ordnerstruktur..."
mkdir -p src/components/{global,sections,forms,legal}
mkdir -p src/layouts
mkdir -p public/{fonts,images}
mkdir -p inputs

# Berechtigungen
echo "🔒 Setze Berechtigungen..."
chown -R www-data:www-data "$STAGING"
chmod -R 755 "$STAGING"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Projekt erfolgreich angelegt!"
echo "📁 Pfad: ${STAGING}"
echo ""
echo "Nächste Schritte:"
echo "1. Inputs hochladen: scp inputs/* root@46.224.27.249:${STAGING}/inputs/"
echo "2. Development starten: cd ${STAGING} && pnpm dev"
echo "3. Documentation lesen: cat /var/www/staging/_system/MASTER_PROMPT.md"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
