#\!/bin/bash
# LISN - Projekt archivieren
# Usage: ./archive-project.sh [kunde-slug]

set -e

if [ -z "$1" ]; then
  echo "❌ Fehler: Kunden-Slug fehlt"
  echo "Usage: ./archive-project.sh mueller-sanitaer"
  exit 1
fi

KUNDE="$1"
STAGING="/var/www/staging/${KUNDE}"
ARCHIVE="/var/www/staging/_archive/$(date +%Y)"
BACKUP="/var/www/backups/${KUNDE}-$(date +%Y-%m-%d-%H%M%S).tar.gz"

if [ \! -d "$STAGING" ]; then
  echo "❌ Fehler: Projekt nicht gefunden: ${STAGING}"
  exit 1
fi

echo "📦 LISN - Projekt archivieren"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Kunde: ${KUNDE}"
echo ""

# Backup erstellen
echo "💾 Erstelle Backup..."
tar -czf "$BACKUP" -C /var/www/staging "$KUNDE"
echo "✅ Backup: ${BACKUP}"

# In Archive verschieben
echo "📁 Verschiebe in Archiv..."
mkdir -p "$ARCHIVE"
mv "$STAGING" "$ARCHIVE/"
echo "✅ Archiviert: ${ARCHIVE}/${KUNDE}"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Projekt archiviert\!"
echo "📦 Backup: ${BACKUP}"
echo "📁 Archiv: ${ARCHIVE}/${KUNDE}"
echo ""
echo "Production bleibt unverändert in:"
echo "/var/www/kunden/${KUNDE}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
