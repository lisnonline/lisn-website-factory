#\!/bin/bash
# LISN - Backup wiederherstellen
# Usage: ./restore-backup.sh [backup-file]

set -e

if [ -z "$1" ]; then
  echo "❌ Fehler: Backup-Datei fehlt"
  echo ""
  echo "Verfügbare Backups:"
  ls -lh /var/www/backups/*.tar.gz 2>/dev/null || echo "Keine Backups gefunden"
  echo ""
  echo "Usage: ./restore-backup.sh /var/www/backups/mueller-sanitaer-2024-01-07-123456.tar.gz"
  exit 1
fi

BACKUP="$1"

if [ \! -f "$BACKUP" ]; then
  echo "❌ Fehler: Backup nicht gefunden: ${BACKUP}"
  exit 1
fi

# Kunde aus Filename extrahieren
FILENAME=$(basename "$BACKUP" .tar.gz)
KUNDE=$(echo "$FILENAME" | sed 's/-[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}-[0-9]\{6\}$//')
STAGING="/var/www/staging/${KUNDE}"

echo "♻️  LISN - Backup wiederherstellen"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Backup: ${BACKUP}"
echo "Kunde: ${KUNDE}"
echo "Ziel: ${STAGING}"
echo ""

# Check ob bereits existiert
if [ -d "$STAGING" ]; then
  echo "⚠️  Warnung: Projekt existiert bereits in ${STAGING}"
  read -p "Überschreiben? (y/n) " -n 1 -r
  echo
  if [[ \! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
  rm -rf "$STAGING"
fi

# Wiederherstellen
echo "📦 Stelle Backup wieder her..."
tar -xzf "$BACKUP" -C /var/www/staging/

# Berechtigungen
echo "🔒 Setze Berechtigungen..."
chown -R www-data:www-data "$STAGING"
chmod -R 755 "$STAGING"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Backup wiederhergestellt\!"
echo "📁 Pfad: ${STAGING}"
echo ""
echo "Nächste Schritte:"
echo "1. Dependencies installieren: cd ${STAGING} && pnpm install"
echo "2. Build testen: pnpm build"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
