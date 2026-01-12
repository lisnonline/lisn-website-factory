#!/bin/bash
# LISN - Projekt aufräumen (node_modules, dist, .astro löschen)
# Usage: ./cleanup-project.sh [kunde-slug]

set -e

if [ -z "$1" ]; then
  echo "❌ Fehler: Kunden-Slug fehlt"
  echo "Usage: ./cleanup-project.sh mueller-sanitaer"
  exit 1
fi

KUNDE="$1"
STAGING="/var/www/staging/${KUNDE}"

if [ ! -d "$STAGING" ]; then
  echo "❌ Fehler: Projekt nicht gefunden: ${STAGING}"
  exit 1
fi

echo "🧹 LISN - Projekt aufräumen"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Kunde: ${KUNDE}"
echo ""

cd "$STAGING"

# node_modules löschen
if [ -d "node_modules" ]; then
  echo "🗑️  Lösche node_modules..."
  rm -rf node_modules
fi

# dist löschen
if [ -d "dist" ]; then
  echo "🗑️  Lösche dist..."
  rm -rf dist
fi

# .astro löschen
if [ -d ".astro" ]; then
  echo "🗑️  Lösche .astro cache..."
  rm -rf .astro
fi

echo ""
echo "✅ Projekt aufgeräumt!"
echo "💾 Freier Speicherplatz:"
df -h /var/www
