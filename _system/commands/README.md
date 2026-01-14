# Claude Code Slash Commands

Diese Commands können in Claude Code verwendet werden, um LISN-Projekte zu verwalten.

## Installation

Die `.md` Dateien aus diesem Ordner in den globalen Claude Commands Ordner kopieren:

**Windows:**
```bash
copy *.md C:\Users\[USERNAME]\.claude\commands\
```

**Mac/Linux:**
```bash
cp *.md ~/.claude/commands/
```

**Danach Claude Code neu starten.**

## Verfügbare Commands

| Command | Beschreibung |
|---------|--------------|
| `/lisn-update` | Änderungen an bestehendem Projekt (Bilder, Text, etc.) |
| `/lisn-newproject` | Neues Projekt von Grund auf erstellen |

## Verwendung

### /lisn-update

```
/lisn-update Forstinger Haus und Bad - Bild in Sektion "3D-Planung" ändern zu "D:\Pfad\bild.jpg"
```

```
/lisn-update Mueller GmbH - Telefonnummer im Footer ändern auf 0664 1234567
```

```
/lisn-update Projekt XY - Cookie Banner Text anpassen
```

### /lisn-newproject

```
/lisn-newproject Müller Installationen - Slug: mueller-installationen, Seiten: Home, Kontakt, Impressum, Datenschutz. Mit Kontaktformular.
```

## Was die Commands tun

1. **SSH-Verbindung** zum Hetzner Server herstellen
2. **Dokumentation lesen** (relevante Guides je nach Aufgabe)
3. **Änderungen durchführen** nach den LISN-Richtlinien
4. **Build & Deploy** ausführen
5. **Testen** der Änderungen

## Anpassung

Die Commands können bearbeitet werden, um den Workflow anzupassen. Nach Änderungen:
1. Datei im Repo aktualisieren
2. In `~/.claude/commands/` kopieren
3. Claude Code neu starten
