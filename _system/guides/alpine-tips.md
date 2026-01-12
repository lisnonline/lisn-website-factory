# Astro Forms mit Alpine.js - Best Practices

> Haeufige Probleme und Loesungen fuer Formulare mit Alpine.js

═══════════════════════════════════════════════════════════════════
## CHECKBOX MIT LABEL - DAS RICHTIGE PATTERN
═══════════════════════════════════════════════════════════════════

### Problem: Checkbox reagiert nicht auf Text-Klick

**FALSCH - @click auf Label kollidiert mit x-model:**
```html
<label @click="formData.check = !formData.check">
  <input type="checkbox" x-model="formData.check" @click.stop />
  <span>Ich stimme zu</span>
</label>
```

Warum falsch:
- `@click` auf Label toggled manuell
- `x-model` auf Checkbox toggled auch
- Ergebnis: Doppeltes Toggle = keine Aenderung

**RICHTIG - Natives HTML Label-Verhalten nutzen:**
```html
<label class="flex items-start gap-3 cursor-pointer">
  <input
    type="checkbox"
    x-model="formData.check"
    class="mt-1 w-5 h-5"
  />
  <span>Ich stimme zu</span>
</label>
```

Warum richtig:
- Kein @click auf Label
- Natives HTML: Klick auf Label = Klick auf Input
- x-model reagiert auf den nativen Klick

═══════════════════════════════════════════════════════════════════
## LINK INNERHALB EINES CHECKBOX-LABELS
═══════════════════════════════════════════════════════════════════

### Problem: Klick auf Link toggled auch die Checkbox

**LOESUNG: @click.stop auf dem Link**

```html
<label class="flex items-start gap-3 cursor-pointer">
  <input
    type="checkbox"
    x-model="formData.datenschutz"
    required
    class="mt-1 w-5 h-5"
  />
  <span class="text-sm select-none">
    Ich stimme den
    <a href="/datenschutz"
       class="text-primary hover:underline"
       @click.stop>
      Datenschutzbestimmungen
    </a>
    zu.
  </span>
</label>
```

**Erklaerung:**
- `@click.stop` auf Link verhindert Event-Bubbling
- Klick auf Link navigiert zur Seite
- Checkbox wird NICHT getoggled
- Klick auf anderen Text toggled Checkbox normal

═══════════════════════════════════════════════════════════════════
## MULTI-STEP FORM PATTERN
═══════════════════════════════════════════════════════════════════

```javascript
function formHandler() {
  return {
    step: 1,
    loading: false,
    error: null,
    formData: {
      // Step 1
      projektart: '',
      // Step 2
      zeitrahmen: '',
      // Step 3
      termin: '',
      // Step 4
      name: '',
      email: '',
      telefon: '',
      datenschutz: false
    },

    // Auto-Weiter nach Auswahl (UX-Verbesserung)
    selectOption(field, value) {
      this.formData[field] = value;
      setTimeout(() => this.nextStep(), 300);
    },

    nextStep() {
      if (this.step < 4) {
        this.step++;
        window.scrollTo({ top: 0, behavior: 'smooth' });
      }
    },

    prevStep() {
      if (this.step > 1) {
        this.step--;
        window.scrollTo({ top: 0, behavior: 'smooth' });
      }
    },

    isStepValid(stepNum) {
      switch(stepNum) {
        case 1: return !!this.formData.projektart;
        case 2: return !!this.formData.zeitrahmen;
        case 3: return !!this.formData.termin;
        case 4: return this.formData.name &&
                       this.formData.email &&
                       this.formData.telefon &&
                       this.formData.datenschutz;
      }
    },

    async submitForm() {
      if (!this.isStepValid(4)) return;

      this.loading = true;
      this.error = null;

      try {
        // WICHTIG: Base-URL beachten!
        const baseUrl = window.location.pathname.includes('/projekt-slug')
          ? '/projekt-slug'
          : '';

        const response = await fetch(baseUrl + '/api/submit-form', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(this.formData)
        });

        if (!response.ok) throw new Error('Fehler beim Senden');

        // WICHTIG: Redirect mit Base-URL!
        window.location.href = baseUrl + '/danke';

      } catch (err) {
        this.error = 'Es ist ein Fehler aufgetreten.';
        this.loading = false;
      }
    }
  };
}
```

═══════════════════════════════════════════════════════════════════
## STEP INDICATOR COMPONENT
═══════════════════════════════════════════════════════════════════

```html
<!-- Progress Bar -->
<div class="flex items-center justify-center mb-12">
  <template x-for="i in 4" :key="i">
    <div class="flex items-center">
      <!-- Step Circle -->
      <div class="flex flex-col items-center">
        <div
          class="w-12 h-12 rounded-full flex items-center justify-center font-bold"
          :class="i <= step
            ? 'bg-primary text-white'
            : 'bg-gray-200 text-gray-500'"
          x-text="i"
        ></div>
      </div>
      <!-- Connector Line (nicht nach letztem Step) -->
      <div
        x-show="i < 4"
        class="w-16 h-1 mx-2"
        :class="i < step ? 'bg-primary' : 'bg-gray-200'"
      ></div>
    </div>
  </template>
</div>
```

═══════════════════════════════════════════════════════════════════
## CHOICE CARDS (Klickbare Optionen)
═══════════════════════════════════════════════════════════════════

```html
<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
  <div
    class="border-2 rounded-xl p-6 cursor-pointer transition-all"
    :class="formData.option === 'a'
      ? 'border-primary bg-primary/5'
      : 'border-gray-200 hover:border-primary/30'"
    @click="selectOption('option', 'a')"
  >
    <div class="flex items-center gap-4">
      <div class="w-12 h-12 bg-primary/10 rounded-lg flex items-center justify-center">
        <span class="material-symbols-outlined text-primary">icon_name</span>
      </div>
      <div>
        <h3 class="font-bold">Option A</h3>
        <p class="text-sm text-gray-500">Beschreibung</p>
      </div>
    </div>
  </div>

  <!-- Weitere Options... -->
</div>
```

═══════════════════════════════════════════════════════════════════
## FORM VALIDATION STYLING
═══════════════════════════════════════════════════════════════════

```html
<!-- Input mit Icon -->
<div class="relative">
  <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-gray-400">
    person
  </span>
  <input
    type="text"
    x-model="formData.name"
    required
    class="w-full pl-12 pr-4 py-3 border-2 border-gray-200 rounded-lg
           focus:border-primary focus:outline-none transition-colors"
    placeholder="Max Mustermann"
  />
</div>

<!-- Error Message -->
<div
  x-show="error"
  x-cloak
  class="mt-6 p-4 bg-red-50 border border-red-200 rounded-lg text-red-700"
>
  <div class="flex items-center gap-2">
    <span class="material-symbols-outlined">error</span>
    <span x-text="error"></span>
  </div>
</div>
```

═══════════════════════════════════════════════════════════════════
## BUTTON STATES
═══════════════════════════════════════════════════════════════════

```html
<button
  type="submit"
  class="bg-accent text-white px-8 py-3 rounded-lg font-bold"
  :disabled="loading || !isStepValid(step)"
  :class="loading || !isStepValid(step)
    ? 'opacity-50 cursor-not-allowed'
    : 'hover:bg-accent-hover'"
>
  <span x-show="!loading">Absenden</span>
  <span x-show="loading">Wird gesendet...</span>
</button>
```

═══════════════════════════════════════════════════════════════════
## DEBUGGING TIPPS
═══════════════════════════════════════════════════════════════════

### Alpine.js State inspizieren

```html
<!-- Temporaer hinzufuegen zum Debuggen -->
<pre x-text="JSON.stringify(formData, null, 2)" class="text-xs"></pre>
```

### Event-Flow pruefen

```html
<!-- Zeigt welche Events feuern -->
<input
  @click="console.log('input click')"
  @change="console.log('input change')"
/>
<label @click="console.log('label click')">...</label>
```

### Netzwerk-Requests pruefen

Browser DevTools > Network Tab:
1. Welche URL wird aufgerufen?
2. Welcher Status-Code kommt zurueck?
3. Was ist im Response Body?

---

*Erstellt: Januar 2026*
*Basierend auf: Forstinger-Projekt Formular*
