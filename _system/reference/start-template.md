# START TEMPLATE - LISN Website Factory
# Diesen Text als Prompt an Claude senden, um ein neues Projekt zu starten

═══════════════════════════════════════════════════════════════════
NEUES LISN-KUNDENPROJEKT STARTEN
═══════════════════════════════════════════════════════════════════

Server: 46.224.27.249 (Hetzner VPS)
User: root

WICHTIG: Lies zuerst die Core-Dokumentation (in dieser Reihenfolge):
```bash
# 1. Übersicht aller Dokumentationen
ssh root@46.224.27.249 "cat /var/www/staging/_system/00_INDEX.md"

# 2. Kurzanleitung für neues Projekt
ssh root@46.224.27.249 "cat /var/www/staging/_system/01_QUICK_START.md"

# 3. Unveränderliche Kern-Regeln (Tech Stack, Naming, etc.)
ssh root@46.224.27.249 "cat /var/www/staging/_system/02_CORE_RULES.md"
```

═══════════════════════════════════════════════════════════════════
SCHRITT 1: KUNDE-INFORMATIONEN
═══════════════════════════════════════════════════════════════════

**Firmenname:** [HIER EINFÜGEN]
**Branche:** [Elektro / Sanitär / Heizung / Bau / etc.]
**Standort:** [Stadt, Bundesland]

**Kontakt:**
- E-Mail: [office@firma.at]
- Telefon: [+43 ...]
- Adresse: [Straße, PLZ Stadt]

**Legal:**
- UID: [ATU...]
- FB-Nummer: [FN ...]
- Gericht: [Landesgericht ...]

═══════════════════════════════════════════════════════════════════
SCHRITT 2: INPUTS
═══════════════════════════════════════════════════════════════════

Folgende Files sind verfügbar:
- [ ] Kickoff-Dokument (PDF/MD)
- [ ] Logo (SVG/PNG)
- [ ] Stitch-Export (HTML/CSS) oder Screenshots
- [ ] Bilder (optional)
- [ ] Farbschema (optional)

Inputs hochgeladen nach: `/var/www/staging/[kunde-slug]/inputs/`

═══════════════════════════════════════════════════════════════════
SCHRITT 3: BREVO-KONFIGURATION
═══════════════════════════════════════════════════════════════════

- Brevo API-Key: [xkeysib-...]
- Brevo List-ID: [123]
- Benachrichtigungs-E-Mail: [office@firma.at]

═══════════════════════════════════════════════════════════════════
SCHRITT 4: GEWÜNSCHTE SEITEN
═══════════════════════════════════════════════════════════════════

**Pflicht:**
- [x] Startseite
- [x] Formular (Multi-Step)
- [x] Danke-Seite
- [x] Impressum
- [x] Datenschutz
- [x] AGB

**Optional:**
- [ ] Leistungen
- [ ] Über uns
- [ ] Referenzen
- [ ] Team
- [ ] Kontakt

═══════════════════════════════════════════════════════════════════
SCHRITT 5: BESONDERHEITEN
═══════════════════════════════════════════════════════════════════

[Hier spezielle Wünsche/Anforderungen eintragen]

Beispiele:
- Spezielle Farbschema
- Bestimmte Sections auf Startseite
- Integration von externen Tools
- Mehrsprachigkeit
- etc.

═══════════════════════════════════════════════════════════════════
AUFGABE FÜR CLAUDE
═══════════════════════════════════════════════════════════════════

Erstelle basierend auf den obigen Informationen ein komplettes Astro-Projekt auf dem Server:

1. **Setup**
   - Kundenname-Slug ableiten
   - Ordner-Check (existiert bereits?)
   - Projekt-Ordner anlegen
   - Astro initialisieren

2. **Development**
   - Layouts erstellen
   - Components erstellen (siehe guides/astro-components.md)
   - Seiten erstellen
   - Formular-API einrichten (siehe guides/brevo-forms.md)

3. **Content**
   - config.json mit Firmeninfos befüllen
   - Texte schreiben (Brand Voice beachten!)
   - Bilder optimieren

4. **Testing**
   - Build testen
   - Lighthouse-Check
   - Formular-Test

5. **Deployment**
   - Deploy-Script erstellen
   - Nginx-Config erstellen
   - SSL-Zertifikat einrichten

6. **Ausgabe**
   - README.md
   - DEPLOYMENT.md
   - MISSING_INFO.md (falls Infos fehlen)
   - .env.example

═══════════════════════════════════════════════════════════════════
WICHTIG - BRAND VOICE
═══════════════════════════════════════════════════════════════════

Alle Texte müssen folgende Kriterien erfüllen:
- Direkt und ehrlich (keine Marketing-Floskeln)
- Auf Augenhöhe (Unternehmer für Unternehmer)
- Konkrete Zahlen statt Superlative
- Österreichisches Deutsch
- Sie-Form

Details siehe: /var/www/staging/_system/reference/brand-voice.md

═══════════════════════════════════════════════════════════════════
WEITERE GUIDES (bei Bedarf)
═══════════════════════════════════════════════════════════════════

- Components: /var/www/staging/_system/guides/astro-components.md
- Formulare: /var/www/staging/_system/guides/brevo-forms.md
- Cookie Banner: /var/www/staging/_system/guides/klaro-consent.md
- Alpine.js: /var/www/staging/_system/guides/alpine-tips.md
- Workflow: /var/www/staging/_system/reference/workflow-checklist.md

═══════════════════════════════════════════════════════════════════
