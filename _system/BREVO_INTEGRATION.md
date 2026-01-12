# Brevo Integration Guide
**Version:** 1.0
**Letzte Änderung:** 2026-01-07

═══════════════════════════════════════════════════════════════════
## ÜBERSICHT
═══════════════════════════════════════════════════════════════════

Brevo (ehemals Sendinblue) wird für folgende Funktionen genutzt:
1. ✉️ **Transactional Emails** - Bestätigung an Kunden
2. 📧 **Benachrichtigungen** - Info an Firma über neue Anfrage
3. 📋 **CRM** - Kontakt wird zur Liste hinzugefügt

═══════════════════════════════════════════════════════════════════
## SETUP (PRO KUNDE)
═══════════════════════════════════════════════════════════════════

### 1. Brevo-Account prüfen

**Zugang:**
- URL: https://app.brevo.com
- Login: [LISN-Zugangsdaten]

**Pro Kunde:**
- Neue Liste erstellen
- API-Key generieren (oder bestehenden verwenden)
- Template für Bestätigungs-E-Mail erstellen (optional)

### 2. Brevo-Liste erstellen

**Schritte:**
1. In Brevo einloggen
2. Contacts → Lists → Create a list
3. Name: "[Firmenname] - Website Anfragen"
4. List-ID notieren (z.B. 123)

### 3. API-Key generieren

**Schritte:**
1. Account → SMTP & API → API Keys
2. Create a new API key
3. Name: "[Firmenname] Website"
4. Key kopieren und sicher speichern

**Wichtig:** API-Key NIEMALS in Git committen!

### 4. .env-Datei erstellen

```env
# Brevo API
BREVO_API_KEY=xkeysib-1234567890abcdef...

# Site Config
SITE_URL=https://mueller-sanitaer.at
COMPANY_NAME=Müller Sanitär GmbH
```

### 5. config.json befüllen

```json
{
  "brevo": {
    "notification_email": "office@mueller-sanitaer.at",
    "list_id": 123,
    "template_id": 1
  }
}
```

═══════════════════════════════════════════════════════════════════
## API-ENDPOINT ERSTELLEN
═══════════════════════════════════════════════════════════════════

### Datei: src/pages/api/submit-form.js

```javascript
import type { APIRoute } from 'astro';

export const POST: APIRoute = async ({ request }) => {
  // Form-Daten parsen
  const formData = await request.json();

  const BREVO_API_KEY = import.meta.env.BREVO_API_KEY;
  const COMPANY_NAME = import.meta.env.COMPANY_NAME || 'Firma';
  const SITE_URL = import.meta.env.SITE_URL;

  // 1. BESTÄTIGUNGS-E-MAIL AN KUNDEN
  const customerEmailResponse = await fetch('https://api.brevo.com/v3/smtp/email', {
    method: 'POST',
    headers: {
      'api-key': BREVO_API_KEY,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      sender: {
        email: `noreply@${new URL(SITE_URL).hostname}`,
        name: COMPANY_NAME
      },
      to: [
        { email: formData.email, name: `${formData.firstname} ${formData.lastname}` }
      ],
      subject: `Ihre Anfrage bei ${COMPANY_NAME}`,
      htmlContent: `
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="utf-8">
        </head>
        <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
          <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
            <h2 style="color: #1e40af;">Vielen Dank für Ihre Anfrage!</h2>

            <p>Hallo ${formData.firstname},</p>

            <p>wir haben Ihre Anfrage erhalten und melden uns innerhalb von 24 Stunden bei Ihnen.</p>

            <h3>Ihre Angaben:</h3>
            <ul>
              <li><strong>Art der Anfrage:</strong> ${formData.type}</li>
              <li><strong>Beschreibung:</strong> ${formData.description}</li>
              ${formData.budget ? `<li><strong>Budget:</strong> ${formData.budget}</li>` : ''}
              <li><strong>Zeitrahmen:</strong> ${formData.timeline}</li>
            </ul>

            <p>Mit freundlichen Grüßen<br>
            Ihr ${COMPANY_NAME} Team</p>

            <hr style="border: none; border-top: 1px solid #ddd; margin: 30px 0;">

            <p style="font-size: 12px; color: #666;">
              ${COMPANY_NAME}<br>
              ${formData.companyAddress || ''}
            </p>
          </div>
        </body>
        </html>
      `
    })
  });

  if (!customerEmailResponse.ok) {
    console.error('Failed to send customer email:', await customerEmailResponse.text());
    return new Response(JSON.stringify({ error: 'Failed to send confirmation email' }), {
      status: 500
    });
  }

  // 2. BENACHRICHTIGUNG AN FIRMA
  const notificationEmailResponse = await fetch('https://api.brevo.com/v3/smtp/email', {
    method: 'POST',
    headers: {
      'api-key': BREVO_API_KEY,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      sender: {
        email: `website@${new URL(SITE_URL).hostname}`,
        name: 'Website Formular'
      },
      to: [
        { email: formData.notificationEmail }
      ],
      subject: `Neue Anfrage über Website von ${formData.firstname} ${formData.lastname}`,
      htmlContent: `
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="utf-8">
        </head>
        <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
          <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
            <h2 style="color: #1e40af;">Neue Anfrage über Website</h2>

            <h3>Kontaktdaten:</h3>
            <ul>
              <li><strong>Name:</strong> ${formData.firstname} ${formData.lastname}</li>
              <li><strong>E-Mail:</strong> <a href="mailto:${formData.email}">${formData.email}</a></li>
              <li><strong>Telefon:</strong> <a href="tel:${formData.phone}">${formData.phone}</a></li>
              <li><strong>PLZ:</strong> ${formData.zip}</li>
              ${formData.company ? `<li><strong>Firma:</strong> ${formData.company}</li>` : ''}
            </ul>

            <h3>Projektdetails:</h3>
            <ul>
              <li><strong>Art:</strong> ${formData.type}</li>
              <li><strong>Beschreibung:</strong><br>${formData.description}</li>
              ${formData.budget ? `<li><strong>Budget:</strong> ${formData.budget}</li>` : ''}
              <li><strong>Zeitrahmen:</strong> ${formData.timeline}</li>
            </ul>

            <p><strong>⏰ Eingegangen am:</strong> ${new Date().toLocaleString('de-AT')}</p>

            <hr style="border: none; border-top: 1px solid #ddd; margin: 30px 0;">

            <p style="font-size: 12px; color: #666;">
              Diese E-Mail wurde automatisch über das Website-Formular generiert.
            </p>
          </div>
        </body>
        </html>
      `
    })
  });

  if (!notificationEmailResponse.ok) {
    console.error('Failed to send notification email:', await notificationEmailResponse.text());
  }

  // 3. KONTAKT ZU BREVO-LISTE HINZUFÜGEN
  const addContactResponse = await fetch('https://api.brevo.com/v3/contacts', {
    method: 'POST',
    headers: {
      'api-key': BREVO_API_KEY,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      email: formData.email,
      attributes: {
        FIRSTNAME: formData.firstname,
        LASTNAME: formData.lastname,
        SMS: formData.phone,
        PLZ: formData.zip,
        FIRMA: formData.company || '',
        ANFRAGE_TYP: formData.type,
        ANFRAGE_DATUM: new Date().toISOString()
      },
      listIds: [parseInt(formData.listId)],
      updateEnabled: true
    })
  });

  if (!addContactResponse.ok) {
    console.error('Failed to add contact:', await addContactResponse.text());
  }

  // Erfolg
  return new Response(JSON.stringify({ success: true }), {
    status: 200,
    headers: {
      'Content-Type': 'application/json'
    }
  });
};
```

═══════════════════════════════════════════════════════════════════
## FRONTEND-INTEGRATION
═══════════════════════════════════════════════════════════════════

### In MultiStepForm.astro

```astro
<script>
  // Alpine.js Data
  document.addEventListener('alpine:init', () => {
    Alpine.data('multiStepForm', () => ({
      step: 1,
      loading: false,
      error: null,

      async submitForm(event) {
        event.preventDefault();
        this.loading = true;
        this.error = null;

        const formData = new FormData(event.target);
        const data = Object.fromEntries(formData.entries());

        // Config hinzufügen
        const config = JSON.parse(document.getElementById('formConfig').textContent);
        data.notificationEmail = config.brevo.notification_email;
        data.listId = config.brevo.list_id;
        data.companyAddress = `${config.contact.address.street}, ${config.contact.address.zip} ${config.contact.address.city}`;

        try {
          const response = await fetch('/api/submit-form', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
          });

          if (!response.ok) {
            throw new Error('Fehler beim Senden');
          }

          // Redirect zu Danke-Seite
          window.location.href = '/danke';
        } catch (err) {
          this.error = 'Es ist ein Fehler aufgetreten. Bitte versuchen Sie es erneut.';
          console.error('Form submission error:', err);
        } finally {
          this.loading = false;
        }
      }
    }));
  });
</script>

<!-- Config als JSON im DOM -->
<script id="formConfig" type="application/json">
  {{{JSON.stringify(config)}}}
</script>
```

═══════════════════════════════════════════════════════════════════
## TESTING
═══════════════════════════════════════════════════════════════════

### 1. Lokales Testing (Dev)

**Problem:** API-Key in .env

```bash
# .env erstellen (NICHT in Git!)
echo "BREVO_API_KEY=xkeysib-..." > .env

# Server starten
pnpm dev
```

**Test-Submit:**
1. Formular ausfüllen
2. Absenden
3. Prüfen:
   - [ ] E-Mail an Test-Adresse erhalten?
   - [ ] Benachrichtigung an Firma erhalten?
   - [ ] Kontakt in Brevo-Liste vorhanden?

### 2. Production Testing

**Nach Deploy:**
1. Live-Formular aufrufen
2. Test-Anfrage senden (mit echter E-Mail)
3. Prüfen:
   - [ ] Bestätigungs-E-Mail erhalten?
   - [ ] Firma hat Benachrichtigung erhalten?
   - [ ] Kontakt in Brevo sichtbar?

═══════════════════════════════════════════════════════════════════
## TROUBLESHOOTING
═══════════════════════════════════════════════════════════════════

### Problem: E-Mail kommt nicht an

**Mögliche Ursachen:**
1. API-Key falsch oder abgelaufen
2. Sender-Domain nicht verifiziert
3. E-Mail landet im Spam

**Lösung:**
```bash
# 1. API-Key prüfen
echo $BREVO_API_KEY

# 2. Brevo-Logs prüfen
# → Brevo Dashboard → Transactional → Logs

# 3. Spam-Ordner prüfen
```

### Problem: Kontakt wird nicht zur Liste hinzugefügt

**Mögliche Ursachen:**
1. List-ID falsch
2. E-Mail bereits in Liste (update failed)
3. Attribute nicht korrekt

**Lösung:**
```javascript
// Response loggen:
const addContactResponse = await fetch(...);
console.log('Brevo response:', await addContactResponse.text());
```

### Problem: API-Limit erreicht

**Brevo Free-Plan Limits:**
- 300 E-Mails pro Tag
- 9.000 E-Mails pro Monat

**Lösung:**
- Plan upgraden
- Rate-Limiting einbauen

═══════════════════════════════════════════════════════════════════
## SICHERHEIT
═══════════════════════════════════════════════════════════════════

### API-Key schützen

✅ **Richtig:**
```env
# .env (NICHT in Git!)
BREVO_API_KEY=xkeysib-...
```

❌ **Falsch:**
```javascript
// NIEMALS hardcoded!
const API_KEY = 'xkeysib-1234567890...';
```

### .gitignore

```gitignore
.env
.env.local
.env.production
```

### Rate-Limiting

```javascript
// Optional: Rate-Limiting einbauen
const rateLimiter = new Map();

export const POST: APIRoute = async ({ request, clientAddress }) => {
  const ip = clientAddress;
  const now = Date.now();
  const limit = rateLimiter.get(ip);

  if (limit && now - limit < 60000) {
    return new Response(JSON.stringify({ error: 'Too many requests' }), {
      status: 429
    });
  }

  rateLimiter.set(ip, now);

  // ... Rest des Codes
};
```

═══════════════════════════════════════════════════════════════════
## BREVO CUSTOM ATTRIBUTES
═══════════════════════════════════════════════════════════════════

### Standard-Attribute (LISN)

Folgende Attributes sollten in Brevo angelegt werden:

1. **FIRSTNAME** (Text) - Vorname
2. **LASTNAME** (Text) - Nachname
3. **SMS** (Text) - Telefonnummer
4. **PLZ** (Text) - Postleitzahl
5. **FIRMA** (Text) - Firmenname (optional)
6. **ANFRAGE_TYP** (Text) - Art der Anfrage
7. **ANFRAGE_DATUM** (Date) - Datum der Anfrage

### Attribute anlegen

**Schritte:**
1. Contacts → Settings → Contact attributes
2. Create an attribute
3. Name + Type auswählen
4. Speichern

═══════════════════════════════════════════════════════════════════
## RESSOURCEN
═══════════════════════════════════════════════════════════════════

**Brevo Docs:**
- API-Docs: https://developers.brevo.com
- Transactional Emails: https://developers.brevo.com/docs/send-a-transactional-email
- Contacts: https://developers.brevo.com/docs/contacts

**LISN-Guides:**
- MASTER_PROMPT.md
- COMPONENT_LIBRARY.md

═══════════════════════════════════════════════════════════════════

═══════════════════════════════════════════════════════════════════
## SERVER-IP AUTORISIERUNG (KRITISCH! - UPDATE 2026-01-07)
═══════════════════════════════════════════════════════════════════

### Problem

Brevo blockiert API-Anfragen von nicht autorisierten IP-Adressen:
```json
{
  "message": "We have detected you are using an unrecognised IP address...",
  "code": "unauthorized"
}
```

### Lösung

**VOR dem ersten Test:**
1. https://app.brevo.com/security/authorised_ips öffnen
2. Server-IPs hinzufügen:
   - IPv4: `46.224.27.249`
   - IPv6: `2a01:4f8:1c1f:8fc6::1`
3. Speichern

### Server-IPs ermitteln

```bash
# IPv4
curl -4 ifconfig.me

# IPv6
curl -6 ifconfig.me
```

### Checkliste vor Go-Live

- [ ] Server IPv4 bei Brevo autorisiert
- [ ] Server IPv6 bei Brevo autorisiert (falls vorhanden)
- [ ] Test-E-Mail erfolgreich gesendet
- [ ] Benachrichtigungs-E-Mail kommt an
- [ ] Bestätigungs-E-Mail kommt an

═══════════════════════════════════════════════════════════════════
## API-ENDPOINT TEMPLATE (UPDATE 2026-01-07)
═══════════════════════════════════════════════════════════════════

### Datei: src/pages/api/submit-form.ts

```typescript
import type { APIRoute } from 'astro';

export const prerender = false;  // WICHTIG: Muss false sein für SSR!

export const POST: APIRoute = async ({ request }) => {
  try {
    const formData = await request.json();
    
    const BREVO_API_KEY = import.meta.env.BREVO_API_KEY;
    const NOTIFICATION_EMAIL = import.meta.env.NOTIFICATION_EMAIL;
    
    if (!BREVO_API_KEY) {
      return new Response(JSON.stringify({ error: 'API key missing' }), {
        status: 500,
        headers: { 'Content-Type': 'application/json' }
      });
    }
    
    // E-Mail senden via Brevo API
    const response = await fetch('https://api.brevo.com/v3/smtp/email', {
      method: 'POST',
      headers: {
        'api-key': BREVO_API_KEY,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        sender: { email: 'noreply@domain.at', name: 'Website' },
        to: [{ email: NOTIFICATION_EMAIL }],
        subject: 'Neue Anfrage',
        htmlContent: '<html>...</html>'
      })
    });
    
    if (!response.ok) {
      const error = await response.text();
      console.error('Brevo error:', error);
      return new Response(JSON.stringify({ error: 'Email failed' }), {
        status: 500
      });
    }
    
    return new Response(JSON.stringify({ success: true }), {
      status: 200
    });
    
  } catch (error) {
    console.error('Submit error:', error);
    return new Response(JSON.stringify({ error: 'Server error' }), {
      status: 500
    });
  }
};
```

### .env Datei

```env
BREVO_API_KEY=xkeysib-xxxxx...
NOTIFICATION_EMAIL=office@kunde.at
```

