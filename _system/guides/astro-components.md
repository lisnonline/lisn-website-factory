# LISN Component Library
**Version:** 1.0
**Framework:** Astro 4.x + Tailwind CSS 3.x
**Letzte Änderung:** 2026-01-07

═══════════════════════════════════════════════════════════════════
## ÜBERSICHT
═══════════════════════════════════════════════════════════════════

Diese Library enthält alle Standard-Components für LISN-Kundenprojekte.
Alle Components sind:
- ✅ Mobile-responsive
- ✅ DSGVO-konform
- ✅ Accessibility-optimiert (WCAG AA)
- ✅ SEO-freundlich

═══════════════════════════════════════════════════════════════════
## STRUKTUR
═══════════════════════════════════════════════════════════════════

```
src/components/
├── global/          # Header, Footer, Navigation
├── sections/        # Content-Sections (Hero, Features, etc.)
├── forms/           # Multi-Step Formular
└── legal/           # Cookie Banner, Legal Navigation
```

═══════════════════════════════════════════════════════════════════
## GLOBAL COMPONENTS
═══════════════════════════════════════════════════════════════════

### Header.astro

**Zweck:** Haupt-Navigation mit Logo, Menü und CTA-Button
**Features:**
- Sticky Header (bleibt oben beim Scrollen)
- Mobile Menu (Hamburger Icon)
- Transparent auf Hero, dann solid

**Verwendung:**
```astro
---
import Header from '../components/global/Header.astro';
import config from '../config.json';
---

<Header
  logo={config.company.name}
  phone={config.contact.phone}
/>
```

**Standard-Struktur:**
- Logo (links)
- Navigation (mitte): Leistungen, Über uns, Kontakt
- CTA-Button (rechts): "Jetzt anfragen"
- Mobile: Hamburger-Menü

---

### Footer.astro

**Zweck:** Footer mit Kontaktdaten, Links und Legal
**Features:**
- 3-Spalten-Layout (Desktop)
- 1-Spalte (Mobile)
- Social Media Icons
- Legal Links

**Verwendung:**
```astro
---
import Footer from '../components/global/Footer.astro';
import config from '../config.json';
---

<Footer company={config} />
```

**Standard-Struktur:**
- Spalte 1: Firma + Adresse
- Spalte 2: Kontakt (Telefon, E-Mail)
- Spalte 3: Schnelllinks (Leistungen, Über uns)
- Unten: Legal Links (Impressum, Datenschutz, AGB)

---

### MobileMenu.astro

**Zweck:** Slide-In Menü für Mobile
**Features:**
- Alpine.js für Toggle
- Overlay-Background
- Smooth Animation

**Verwendung:**
```astro
<!-- Wird automatisch in Header.astro eingebunden -->
```

═══════════════════════════════════════════════════════════════════
## SECTION COMPONENTS
═══════════════════════════════════════════════════════════════════

### Hero.astro

**Zweck:** Haupt-Section oberhalb des Folds
**Varianten:**
1. Text-Only (mit Background-Image)
2. Text + Image (Split)
3. Text + Video

**Verwendung:**
```astro
---
import Hero from '../components/sections/Hero.astro';
---

<Hero
  headline="Elektriker in Dornbirn"
  subheadline="150+ Projekte in Vorarlberg seit 1995"
  ctaText="Jetzt anfragen"
  ctaLink="/formular"
  image="/images/hero.jpg"
/>
```

**Best Practices:**
- Headline: H1, max 60 Zeichen
- Subheadline: max 120 Zeichen
- CTA prominent platziert
- Image: WebP, lazy loading

---

### TextImageSection.astro

**Zweck:** Wiederverwendbare Section für Text + Bild
**Features:**
- Image links oder rechts
- Flexible Content-Area
- Responsive Grid

**Verwendung:**
```astro
<TextImageSection
  headline="Über uns"
  text="<p>Seit 1995 sind wir...</p>"
  image="/images/team.jpg"
  imagePosition="right"
/>
```

**Parameter:**
- `headline` (string, required)
- `text` (HTML string, required)
- `image` (string, required)
- `imagePosition` ("left" | "right", default: "left")

---

### FeatureGrid.astro

**Zweck:** Grid für Leistungen/Features
**Layout:** 2-Spalten (Desktop), 1-Spalte (Mobile)

**Verwendung:**
```astro
---
const features = [
  {
    icon: "⚡",
    title: "Elektroinstallationen",
    description: "Neubau & Renovierung"
  },
  {
    icon: "🏠",
    title: "Smart Home",
    description: "Moderne Gebäudetechnik"
  }
];
---

<FeatureGrid features={features} />
```

---

### Testimonials.astro

**Zweck:** Kunden-Testimonials / Bewertungen
**Layout:** Slider oder Grid

**Verwendung:**
```astro
---
const testimonials = [
  {
    text: "Schnell, sauber, verlässlich. Sehr empfehlenswert!",
    author: "Max Mustermann",
    company: "Musterfirma GmbH",
    rating: 5
  }
];
---

<Testimonials items={testimonials} />
```

---

### Stats.astro

**Zweck:** Zahlen/Statistiken prominent zeigen
**Layout:** 3-4 Spalten

**Verwendung:**
```astro
---
const stats = [
  { number: "150+", label: "Projekte" },
  { number: "30", label: "Jahre Erfahrung" },
  { number: "15", label: "Mitarbeiter" }
];
---

<Stats items={stats} />
```

---

### CTA.astro

**Zweck:** Call-to-Action Section
**Varianten:**
1. Einfach (Headline + Button)
2. Mit Form (Quick-Contact)
3. Mit Image

**Verwendung:**
```astro
<CTA
  headline="Jetzt unverbindlich anfragen"
  text="Wir melden uns innerhalb von 24 Stunden"
  buttonText="Zum Formular"
  buttonLink="/formular"
/>
```

---

### FAQ.astro

**Zweck:** Häufige Fragen (Accordion)
**Features:**
- Alpine.js für Accordion
- SEO-optimiert (Schema.org)

**Verwendung:**
```astro
---
const faqs = [
  {
    question: "Was kostet eine Elektroinstallation?",
    answer: "Das hängt von vielen Faktoren ab..."
  }
];
---

<FAQ items={faqs} />
```

═══════════════════════════════════════════════════════════════════
## FORM COMPONENTS
═══════════════════════════════════════════════════════════════════

### MultiStepForm.astro

**Zweck:** 3-Schritt Formular (Master-Component)
**Features:**
- Alpine.js State Management
- Progress Indicator
- Validation
- API-Integration (Brevo)

**Verwendung:**
```astro
---
import MultiStepForm from '../components/forms/MultiStepForm.astro';
import config from '../config.json';
---

<MultiStepForm config={config} />
```

**Flow:**
1. FormStep1 → Art der Anfrage
2. FormStep2 → Projektdetails
3. FormStep3 → Kontaktdaten

---

### FormStep1.astro

**Zweck:** Schritt 1 - Art der Anfrage
**Input:** Radio Buttons

**Optionen (branchenabhängig):**
- Elektro: Neubau, Renovierung, Smart Home, Photovoltaik, Notfall
- Sanitär: Neubau, Renovierung, Wartung, Notfall, Sonstiges

**Code:**
```astro
<div class="form-step" x-show="step === 1">
  <h3>Was können wir für Sie tun?</h3>

  <div class="radio-group">
    <label>
      <input type="radio" name="type" value="neubau" required>
      <span>Neubau</span>
    </label>
    <!-- ... weitere Optionen -->
  </div>

  <button @click="step = 2">Weiter</button>
</div>
```

---

### FormStep2.astro

**Zweck:** Schritt 2 - Projektdetails

**Felder:**
- Beschreibung (Textarea, required, min 20 Zeichen)
- Budget-Rahmen (Select, optional)
- Zeitrahmen (Select, required)

**Code:**
```astro
<div class="form-step" x-show="step === 2">
  <h3>Erzählen Sie uns mehr über Ihr Projekt</h3>

  <label>
    Beschreibung *
    <textarea name="description" minlength="20" required></textarea>
  </label>

  <label>
    Budget-Rahmen
    <select name="budget">
      <option value="">Weiß ich noch nicht</option>
      <option value="under5k">< 5.000 €</option>
      <option value="5k-15k">5.000 - 15.000 €</option>
      <option value="15k-30k">15.000 - 30.000 €</option>
      <option value="over30k">> 30.000 €</option>
    </select>
  </label>

  <label>
    Zeitrahmen *
    <select name="timeline" required>
      <option value="emergency">Notfall (sofort)</option>
      <option value="1month">Innerhalb 1 Monat</option>
      <option value="3months">Innerhalb 3 Monate</option>
      <option value="6months">Innerhalb 6 Monate</option>
      <option value="open">Noch offen</option>
    </select>
  </label>

  <button @click="step = 1">Zurück</button>
  <button @click="step = 3">Weiter</button>
</div>
```

---

### FormStep3.astro

**Zweck:** Schritt 3 - Kontaktdaten

**Felder:**
- Vorname * (Text)
- Nachname * (Text)
- Telefon * (Tel, Format: +43...)
- E-Mail * (Email)
- PLZ * (Text, 4 Ziffern)
- Firma (Text, optional)
- Datenschutz * (Checkbox)

**Code:**
```astro
<div class="form-step" x-show="step === 3">
  <h3>Wie können wir Sie erreichen?</h3>

  <div class="form-row">
    <label>
      Vorname *
      <input type="text" name="firstname" required>
    </label>
    <label>
      Nachname *
      <input type="text" name="lastname" required>
    </label>
  </div>

  <label>
    Telefon *
    <input type="tel" name="phone" pattern="\+43[0-9]{9,13}" required>
  </label>

  <label>
    E-Mail *
    <input type="email" name="email" required>
  </label>

  <label>
    PLZ *
    <input type="text" name="zip" pattern="[0-9]{4}" required>
  </label>

  <label>
    Firma (optional)
    <input type="text" name="company">
  </label>

  <label class="checkbox">
    <input type="checkbox" name="privacy" required>
    Ich akzeptiere die <a href="/datenschutz">Datenschutzerklärung</a> *
  </label>

  <button @click="step = 2">Zurück</button>
  <button type="submit" :disabled="loading">
    <span x-show="!loading">Anfrage senden</span>
    <span x-show="loading">Wird gesendet...</span>
  </button>
</div>
```

═══════════════════════════════════════════════════════════════════
## LEGAL COMPONENTS
═══════════════════════════════════════════════════════════════════

### CookieBanner.astro

**Zweck:** DSGVO-konformer Cookie-Banner
**Library:** Klaro! (Open Source)

**Features:**
- Opt-in für Google Analytics
- Opt-in für Google Ads
- LocalStorage für Consent
- Link zu Datenschutz

**Code:**
```astro
---
import '@klaro/core/dist/klaro.css';
---

<script>
  import klaro from '@klaro/core';

  const config = {
    lang: 'de',
    mustConsent: false,
    acceptAll: true,

    translations: {
      de: {
        consentNotice: {
          description: 'Wir verwenden Cookies für Analyse und Marketing. Sie können selbst entscheiden, welche Sie zulassen möchten.'
        }
      }
    },

    services: [
      {
        name: 'google-analytics',
        title: 'Google Analytics',
        purposes: ['analytics'],
        required: false,
        onAccept: () => {
          // GA initialisieren
        }
      },
      {
        name: 'google-ads',
        title: 'Google Ads',
        purposes: ['marketing'],
        required: false
      }
    ]
  };

  klaro.setup(config);
</script>
```

---

### LegalNav.astro

**Zweck:** Footer-Navigation für Legal-Seiten
**Links:** Impressum, Datenschutz, AGB

**Code:**
```astro
<nav class="legal-nav">
  <a href="/impressum">Impressum</a>
  <a href="/datenschutz">Datenschutz</a>
  <a href="/agb">AGB</a>
</nav>
```

═══════════════════════════════════════════════════════════════════
## LAYOUTS
═══════════════════════════════════════════════════════════════════

### Layout.astro

**Zweck:** Standard-Layout für alle Seiten
**Includes:** Header, Footer, Meta-Tags

**Verwendung:**
```astro
---
import Layout from '../layouts/Layout.astro';
---

<Layout
  title="Elektriker Dornbirn | Müller Elektro"
  description="Ihr Elektriker in Dornbirn. 150+ Projekte seit 1995."
>
  <!-- Page Content -->
</Layout>
```

**Features:**
- Meta-Tags (Title, Description)
- Open Graph Tags
- Favicon
- Google Fonts (lokal!)
- Tailwind CSS
- Alpine.js

---

### FormLayout.astro

**Zweck:** Spezielles Layout für Formular-Seite
**Features:**
- Kein Footer-Ablenkung
- Fokus auf Formular
- Progress-Bar oben

**Verwendung:**
```astro
---
import FormLayout from '../layouts/FormLayout.astro';
---

<FormLayout title="Anfrage senden">
  <MultiStepForm />
</FormLayout>
```

═══════════════════════════════════════════════════════════════════
## STYLING-KONVENTIONEN
═══════════════════════════════════════════════════════════════════

### FARBEN (Tailwind)

**Primärfarbe:**
```js
// config.json → theme.primary
// Tailwind: bg-primary, text-primary, border-primary
```

**Sekundärfarbe:**
```js
// config.json → theme.secondary
```

**Graustufen:**
- `gray-50` - Hintergründe
- `gray-200` - Borders
- `gray-600` - Text (secondary)
- `gray-900` - Text (primary)

### TYPOGRAFIE

**Schriftgrößen:**
- H1: `text-4xl md:text-5xl` (36px / 48px)
- H2: `text-3xl md:text-4xl` (30px / 36px)
- H3: `text-2xl md:text-3xl` (24px / 30px)
- Body: `text-base md:text-lg` (16px / 18px)
- Small: `text-sm` (14px)

**Line Heights:**
- Headlines: `leading-tight` (1.25)
- Body: `leading-relaxed` (1.625)

### SPACING

**Container:**
```html
<div class="container mx-auto px-4 md:px-8 max-w-7xl">
```

**Sections:**
```html
<section class="py-16 md:py-24">
```

**Components:**
- Margin zwischen Sections: `mb-16 md:mb-24`
- Padding in Components: `p-6 md:p-8`

### BUTTONS

**Primary:**
```html
<button class="bg-primary text-white px-6 py-3 rounded-lg hover:bg-primary-dark transition">
  Button Text
</button>
```

**Secondary:**
```html
<button class="bg-gray-200 text-gray-900 px-6 py-3 rounded-lg hover:bg-gray-300 transition">
  Button Text
</button>
```

═══════════════════════════════════════════════════════════════════
## BEST PRACTICES
═══════════════════════════════════════════════════════════════════

### PERFORMANCE

✅ **Images:**
- WebP Format
- Lazy Loading: `loading="lazy"`
- Responsive: `srcset` für verschiedene Größen
- Alt-Text immer angeben

✅ **CSS:**
- Tailwind Purge aktiviert
- Unused CSS entfernt
- Critical CSS inline

✅ **JavaScript:**
- Alpine.js nur wo nötig
- Defer/Async für externe Scripts

### ACCESSIBILITY

✅ **Semantisches HTML:**
```html
<header>, <nav>, <main>, <section>, <article>, <aside>, <footer>
```

✅ **Alt-Texte:**
```html
<img src="..." alt="Beschreibender Text">
```

✅ **ARIA-Labels:**
```html
<button aria-label="Menü öffnen">
```

✅ **Keyboard-Navigation:**
- Alle interaktiven Elemente via Tab erreichbar
- Focus-States stylen

✅ **Kontrast:**
- Text/Background mindestens 4.5:1 (WCAG AA)
- Tools: https://webaim.org/resources/contrastchecker/

### SEO

✅ **Meta-Tags:**
```html
<title>Keyword | Firmenname</title>
<meta name="description" content="...">
```

✅ **Headings:**
- Nur ein H1 pro Seite
- Logische Hierarchie (H1 → H2 → H3)

✅ **Structured Data:**
```json
{
  "@context": "https://schema.org",
  "@type": "LocalBusiness",
  "name": "Müller Elektro GmbH",
  "address": {...}
}
```

═══════════════════════════════════════════════════════════════════
## WEITERE RESSOURCEN
═══════════════════════════════════════════════════════════════════

**LISN-Guides:**
- MASTER_PROMPT.md - Kompletter Workflow
- BRAND_VOICE.md - Tonalität-Guide
- BREVO_INTEGRATION.md - Formular-Setup

**Externe Docs:**
- Astro: https://docs.astro.build
- Tailwind: https://tailwindcss.com/docs
- Alpine.js: https://alpinejs.dev
- Klaro: https://klaro.org

═══════════════════════════════════════════════════════════════════


═══════════════════════════════════════════════════════════════════
## HEADER MIT LOGO (UPDATE 2026-01-07)
═══════════════════════════════════════════════════════════════════

### Header.astro mit Logo-Bild

```astro
---
const navItems = [
  { label: 'Vorteile', href: '/#vorteile' },
  { label: 'Ablauf', href: '/#ablauf' },
  { label: 'Galerie', href: '/#galerie' },
];
---

<header class="sticky top-0 z-50 bg-white/95 backdrop-blur-sm border-b border-gray-200">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex justify-between items-center h-20">

      <!-- Logo (BILD statt Text) -->
      <a href="/" class="flex items-center">
        <img
          src="/images/logo.webp"
          alt="Firmenname"
          class="h-12 sm:h-14 w-auto"
        />
      </a>

      <!-- Desktop Nav -->
      <nav class="hidden md:flex gap-8 items-center">
        {navItems.map((item) => (
          <a href={item.href} class="text-text-main hover:text-primary font-medium">
            {item.label}
          </a>
        ))}
      </nav>

      <!-- CTA Button -->
      <a href="/formular" class="hidden md:block bg-accent text-white px-6 py-2.5 rounded-lg font-bold">
        Beratung anfordern
      </a>

      <!-- Mobile Menu Button -->
      <!-- ... -->
    </div>
  </div>
</header>
```

### Logo-Größen Empfehlung

| Position | Mobile    | Desktop   |
|----------|-----------|-----------|
| Header   | h-12 (48px) | h-14 (56px) |
| Footer   | h-10 (40px) | h-10 (40px) |

═══════════════════════════════════════════════════════════════════
## FOOTER MIT LOGO (UPDATE 2026-01-07)
═══════════════════════════════════════════════════════════════════

```astro
<footer class="bg-white border-t border-gray-200 pt-16 pb-8">
  <div class="max-w-7xl mx-auto px-4">
    <div class="grid grid-cols-1 md:grid-cols-4 gap-12 mb-12">

      <!-- Logo & Description -->
      <div>
        <a href="/" class="inline-block mb-4">
          <img
            src="/images/logo.webp"
            alt="Firmenname"
            class="h-10 w-auto"
          />
        </a>
        <p class="text-text-muted text-sm">
          Beschreibungstext...
        </p>
      </div>

      <!-- Weitere Spalten... -->
    </div>
  </div>
</footer>
```

═══════════════════════════════════════════════════════════════════
## MULTI-STEP FORM PATTERNS (UPDATE 2026-01-07)
═══════════════════════════════════════════════════════════════════

### Auto-Advance Pattern

Bei Single-Choice Steps automatisch weiter nach Auswahl:

```javascript
function formHandler() {
  return {
    step: 1,
    formData: {
      projektart: '',
      zeitrahmen: '',
      termin: '',
      name: '',
      email: '',
      telefon: '',
      datenschutz: false
    },

    // Auto-Weiter Funktionen
    selectProjektart(value) {
      this.formData.projektart = value;
      setTimeout(() => this.nextStep(), 300);
    },

    selectZeitrahmen(value) {
      this.formData.zeitrahmen = value;
      setTimeout(() => this.nextStep(), 300);
    },

    selectTermin(value) {
      this.formData.termin = value;
      setTimeout(() => this.nextStep(), 300);
    },

    nextStep() {
      if (this.step < 4) {
        this.step++;
        this.updateProgressBar();
        window.scrollTo({ top: 0, behavior: 'smooth' });
      }
    },

    prevStep() {
      if (this.step > 1) {
        this.step--;
        this.updateProgressBar();
        window.scrollTo({ top: 0, behavior: 'smooth' });
      }
    },

    // ...
  };
}
```

**Verwendung im HTML:**
```html
<div
  class="choice-card ..."
  @click="selectProjektart('neubau')"
  :class="formData.projektart === 'neubau' ? 'border-primary' : ''"
>
  Neubau
</div>
```

### Mobile-Optimierte Navigation

```html
<div class="flex flex-col sm:flex-row justify-between items-stretch sm:items-center gap-4">
  <!-- Zurück: unten auf Mobile -->
  <button
    type="button"
    class="order-2 sm:order-1 text-text-main flex items-center justify-center gap-2 py-3 sm:py-0"
    @click="prevStep()"
  >
    <span class="material-symbols-outlined">arrow_back</span>
    Zurück
  </button>

  <!-- Weiter: oben auf Mobile (wichtiger!) -->
  <button
    type="button"
    class="order-1 sm:order-2 bg-accent text-white px-8 py-3 rounded-lg font-bold flex items-center justify-center gap-2"
    @click="nextStep()"
  >
    Weiter zu Schritt X
    <span class="material-symbols-outlined">arrow_forward</span>
  </button>
</div>
```

**Wichtig:**
- `order-1/order-2` steuert die Reihenfolge auf Mobile
- Auf Mobile erscheint der wichtigere Button (Weiter) OBEN
- `items-stretch` macht Buttons auf Mobile gleich breit

### Progress Bar mit gleichmäßigen Abständen

**FALSCH (ungleiche Abstände):**
```html
<div class="flex-1 flex items-center">
  <div class="flex flex-col items-center flex-1">...</div>
  <div class="flex-1 h-1 bg-gray-200"></div>  <!-- Problem! -->
</div>
```

**RICHTIG (feste Breiten):**
```html
<div class="flex items-center justify-center">
  <!-- Step 1 -->
  <div class="flex flex-col items-center">
    <div class="progress-circle w-12 h-12 ...">1</div>
    <span class="progress-label ...">Projekt</span>
  </div>

  <!-- Linie (FESTE BREITE) -->
  <div class="w-16 sm:w-24 h-1 bg-gray-200 mx-2 sm:mx-4 mb-6"></div>

  <!-- Step 2 -->
  <div class="flex flex-col items-center">
    <div class="progress-circle w-12 h-12 ...">2</div>
    <span class="progress-label ...">Zeitrahmen</span>
  </div>

  <!-- usw. -->
</div>
```

### Datenschutz-Checkbox mit klickbarem Label

```html
<label
  class="flex items-start gap-3 cursor-pointer"
  @click="formData.datenschutz = !formData.datenschutz"
>
  <input
    type="checkbox"
    x-model="formData.datenschutz"
    required
    class="mt-1 w-5 h-5 cursor-pointer"
    @click.stop
  />
  <span class="text-sm text-text-muted select-none">
    Ich stimme den
    <a
      href="/datenschutz"
      class="text-primary hover:underline font-medium"
      @click.stop
    >Datenschutzbestimmungen</a>
    zu. Wir behandeln Ihre Daten vertraulich.
  </span>
</label>
```

**Wichtig:**
- `@click` auf dem Label toggled die Checkbox
- `@click.stop` auf dem Input verhindert doppeltes Toggle
- `@click.stop` auf dem Link verhindert Toggle bei Link-Klick
- `select-none` verhindert Text-Selektion beim Klicken

═══════════════════════════════════════════════════════════════════
## CHOICE CARDS (UPDATE 2026-01-07)
═══════════════════════════════════════════════════════════════════

### Standard Choice Card

```html
<div
  class="choice-card border-2 rounded-xl p-6 cursor-pointer transition-all
         hover:border-primary/30 hover:shadow-md hover:-translate-y-0.5"
  :class="formData.value === 'option' ? 'border-primary bg-primary/5' : 'border-gray-200'"
  @click="selectValue('option')"
>
  <div class="flex items-center gap-4">
    <!-- Icon -->
    <div class="w-12 h-12 bg-primary/10 rounded-lg flex items-center justify-center flex-shrink-0">
      <span class="material-symbols-outlined text-2xl text-primary">icon_name</span>
    </div>

    <!-- Text -->
    <div class="flex-1">
      <h3 class="font-bold text-text-main mb-1">Titel</h3>
      <p class="text-sm text-text-muted">Beschreibung</p>
    </div>
  </div>
</div>
```

### Große Choice Card (für 2-Spalten)

```html
<div
  class="choice-card border-2 rounded-xl p-8 cursor-pointer ..."
  @click="selectValue('option')"
>
  <div class="flex flex-col items-center text-center">
    <!-- Icon -->
    <div class="w-16 h-16 bg-primary/10 rounded-full flex items-center justify-center mb-4">
      <span class="material-symbols-outlined text-4xl text-primary">icon_name</span>
    </div>

    <!-- Text -->
    <h3 class="text-xl font-serif font-bold text-text-main mb-3">Titel</h3>
    <p class="text-text-muted text-sm">Beschreibung</p>
  </div>
</div>
```

### CSS für Choice Cards

```css
.choice-card {
  transition: all 0.2s ease;
}

.choice-card:hover {
  transform: translateY(-2px);
}
```


═══════════════════════════════════════════════════════════════════
## ⚠️ BASE_URL IN KOMPONENTEN (KRITISCH - UPDATE 2026-01-07)
═══════════════════════════════════════════════════════════════════

**Siehe auch:** BASE_URL_GUIDE.md für vollständige Dokumentation!

### Warum BASE_URL?

Bei Preview unter Subpfad (`/projekt-slug/`) müssen alle Pfade
den Base-Pfad enthalten. `import.meta.env.BASE_URL` liefert diesen.

### Template für JEDE Komponente

```astro
---
const base = import.meta.env.BASE_URL;
// Weitere imports/props...
---

<!-- Bilder -->
<img src={base + 'images/beispiel.jpg'} alt="..." />

<!-- Links -->
<a href={base + 'formular'}>Kontakt</a>
<a href={base + '#section'}>Zur Section</a>
<a href={base}>Startseite</a>
```

### Checkliste: Komponenten die BASE_URL brauchen

#### Global Components:
```astro
<!-- Header.astro -->
---
const base = import.meta.env.BASE_URL;
const navItems = [
  { label: 'Vorteile', href: base + '#vorteile' },
  { label: 'Kontakt', href: base + 'formular' },
];
---
<a href={base}><img src={base + 'images/logo.webp'} /></a>
<a href={base + 'formular'}>Beratung anfordern</a>

<!-- Footer.astro -->
---
const base = import.meta.env.BASE_URL;
---
<a href={base}><img src={base + 'images/logo.webp'} /></a>
<a href={base + 'impressum'}>Impressum</a>
<a href={base + 'datenschutz'}>Datenschutz</a>
```

#### Section Components:
```astro
<!-- Hero.astro -->
---
const base = import.meta.env.BASE_URL;
const { ctaLink = base + 'formular' } = Astro.props;
---
<img src={base + 'images/hero.jpg'} />
<a href={ctaLink}>Jetzt anfragen</a>

<!-- Gallery.astro -->
---
const base = import.meta.env.BASE_URL;
const projects = [
  { image: base + 'images/gallery-1.jpg', title: '...' },
  { image: base + 'images/gallery-2.jpg', title: '...' },
];
---

<!-- Testimonials.astro -->
---
const base = import.meta.env.BASE_URL;
---
<img src={base + 'images/avatar.jpg'} />

<!-- CTA.astro, Process.astro -->
---
const base = import.meta.env.BASE_URL;
---
<a href={base + 'formular'}>Button</a>
```

#### Pages:
```astro
<!-- danke.astro -->
---
const base = import.meta.env.BASE_URL;
---
<a href={base}>Zurück zur Startseite</a>

<!-- formular.astro (im Alpine.js Teil) -->
<a href={base + 'datenschutz'}>Datenschutz</a>
```

### ❌ FALSCH vs ✅ RICHTIG

| FALSCH | RICHTIG |
|--------|---------|
| `src="/images/logo.webp"` | `src={base + 'images/logo.webp'}` |
| `href="/formular"` | `href={base + 'formular'}` |
| `href="/#section"` | `href={base + '#section'}` |
| `href="/"` | `href={base}` |

### Nach Live-Gang

Wenn `base` aus astro.config.mjs entfernt wird:
- `import.meta.env.BASE_URL` → `/`
- Alle Pfade funktionieren automatisch korrekt
- KEIN Code-Änderungen in Komponenten nötig!



═══════════════════════════════════════════════════════════════════
## BILDOPTIMIERUNG FÜR PERFORMANCE (UPDATE 2026-01-07)
═══════════════════════════════════════════════════════════════════

### Pflicht-Attribute für alle Bilder

```astro
---
const base = import.meta.env.BASE_URL;
---

<!-- Hero-Bild (Above Fold) -->
<img 
  src={base + 'images/hero.webp'} 
  alt="Aussagekräftige Beschreibung"
  width="1200"
  height="800"
  class="w-full h-auto object-cover"
  loading="eager"
  fetchpriority="high"
/>

<!-- Bilder Below Fold -->
<img 
  src={base + 'images/gallery.webp'} 
  alt="Aussagekräftige Beschreibung"
  width="800"
  height="600"
  class="w-full h-auto object-cover"
  loading="lazy"
  decoding="async"
/>
```

### Attribut-Erklärungen

| Attribut | Wert | Wann verwenden |
|----------|------|----------------|
| `loading` | `eager` | Hero, erstes sichtbares Bild |
| `loading` | `lazy` | Alle Bilder below fold |
| `fetchpriority` | `high` | Nur Hero-Bild |
| `decoding` | `async` | Alle lazy-loaded Bilder |
| `width/height` | Pixelwerte | IMMER (verhindert CLS!) |

### CLS-Vermeidung

**Problem:** Bilder ohne width/height verursachen Layout-Shifts.

**Lösung:** IMMER Dimensionen angeben:
```html
<!-- Mit aspect-ratio Container -->
<div class="aspect-[4/3] overflow-hidden">
  <img 
    src="..." 
    width="800" 
    height="600"
    class="w-full h-full object-cover"
  />
</div>

<!-- Oder direkt mit width/height -->
<img 
  src="..." 
  width="800" 
  height="600"
  class="w-full h-auto"  <!-- h-auto für responsive -->
/>
```

### Bildformate

| Format | Verwendung | Kompression |
|--------|------------|-------------|
| WebP | Standard für alle Bilder | 85% Qualität |
| SVG | Logos, Icons | Vektoren |
| PNG | Nur wenn Transparenz nötig | Vermeiden |

### Konvertierung auf Server

```bash
# ImageMagick + WebP installieren
apt-get install -y webp imagemagick

# JPG/PNG zu WebP konvertieren
convert input.jpg -resize '1200x1200>' -quality 85 output.webp

# Batch-Konvertierung
for f in *.jpg; do
  convert "$f" -resize '800x800>' -quality 85 "${f%.jpg}.webp"
done
```

### Größen-Richtlinien

| Bildtyp | Max Breite | Max Dateigröße |
|---------|------------|----------------|
| Hero | 1200px | 80 KB |
| Gallery | 800px | 40 KB |
| Avatar | 150px | 10 KB |
| Logo | Original | 30 KB |
| Icons | SVG bevorzugt | 5 KB |


---

## PERFORMANCE BEST PRACTICES

### Bilder in Komponenten

```astro
---
// Basis-URL importieren
const base = import.meta.env.BASE_URL;
---

<!-- Hero-Bilder (Above the Fold) -->
<img 
  src={base + 'images/hero.webp'} 
  alt="Beschreibende Alt-Text"
  width="1200"
  height="800"
  class="w-full h-auto object-cover"
  loading="eager"
  fetchpriority="high"
/>

<!-- Alle anderen Bilder (Below the Fold) -->
<img 
  src={base + 'images/gallery.webp'} 
  alt="Beschreibende Alt-Text"
  width="800"
  height="600"
  class="w-full h-auto object-cover"
  loading="lazy"
  decoding="async"
/>
```

### Bildformate

| Verwendung | Format | Max Breite | Qualität |
|------------|--------|------------|----------|
| Hero       | WebP   | 1200px     | 85%      |
| Gallery    | WebP   | 800px      | 85%      |
| Avatar     | WebP   | 150px      | 85%      |
| Logo       | WebP   | Original   | 90%      |

### CLS-Vermeidung

**IMMER width und height Attribute angeben!**

```astro
<!-- ❌ FALSCH - verursacht CLS -->
<img src="bild.webp" alt="..." class="w-full" />

<!-- ✅ RICHTIG - kein CLS -->
<img src="bild.webp" alt="..." width="800" height="600" class="w-full h-auto" />
```

### Font-Verwendung in Tailwind

```astro
<!-- Body Text (Noto Sans) -->
<p class="font-sans text-text-main">...</p>

<!-- Headlines (Noto Serif) -->
<h2 class="font-serif text-3xl font-bold">...</h2>
```

### Tailwind Config für Fonts

```js
// tailwind.config.mjs
export default {
  theme: {
    extend: {
      fontFamily: {
        sans: ['Noto Sans', 'Noto Sans Fallback', 'system-ui', 'sans-serif'],
        serif: ['Noto Serif', 'Noto Serif Fallback', 'Georgia', 'serif'],
      },
    },
  },
}
```

