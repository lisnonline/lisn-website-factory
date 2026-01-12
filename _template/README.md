# LISN Astro Template

Basis-Template fuer neue Kundenprojekte.

## Verwendung

Das neue Projekt wird mit `new-project.sh` erstellt, welches:
1. Astro mit `pnpm create astro@latest` initialisiert
2. Tailwind CSS und Alpine.js installiert
3. Die Ordnerstruktur anlegt

Dieses Template-Verzeichnis dient als Platzhalter fuer zukuenftige vorgefertigte Komponenten.

## Ordnerstruktur (nach Initialisierung)

```
projekt/
├── src/
│   ├── components/
│   │   ├── global/      # Header, Footer, Navigation
│   │   ├── sections/    # Hero, Features, etc.
│   │   ├── forms/       # Kontaktformulare
│   │   └── legal/       # Impressum, Datenschutz
│   └── layouts/
├── public/
│   ├── fonts/
│   └── images/
└── inputs/              # Kunden-Input-Dateien
```
