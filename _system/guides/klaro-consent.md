# Klaro Cookie Banner - Complete Implementation Guide

> **One-Shot Implementation Guide** fuer DSGVO-konforme Cookie Banner mit Google Consent Mode v2

## Quick Start Checklist

- [ ] Klaro CSS von CDN laden
- [ ] Custom Theme CSS danach laden
- [ ] klaro-config.js mit Consent Mode v2
- [ ] klaro-no-css.js (NICHT klaro.js!)
- [ ] GTM Script nach Klaro Config
- [ ] Datenschutzseite mit Cookie-Info

---

## 1. Dateistruktur

```
public/
  css/
    klaro-theme.css      # Custom Styling
  js/
    klaro-config.js      # Klaro Config + Scroll Lock
```

---

## 2. Layout.astro Integration

```astro
<!-- Im <head> - REIHENFOLGE WICHTIG! -->

<!-- 1. Klaro Default CSS (von CDN) -->
<link rel="stylesheet" href="https://cdn.kiprotect.com/klaro/v0.7/klaro.min.css" />

<!-- 2. Klaro Custom Theme (ueberschreibt Default) -->
<link rel="stylesheet" href={base + "css/klaro-theme.css"} />

<!-- 3. Klaro Config (MUSS vor Klaro Library!) -->
<script src={base + "js/klaro-config.js"}></script>

<!-- 4. Klaro Library (klaro-no-css.js!) -->
<script
  defer
  data-config="klaroConfig"
  src="https://cdn.kiprotect.com/klaro/v0.7/klaro-no-css.js"
></script>

<!-- 5. Google Tag Manager -->
<script>
  window.dataLayer = window.dataLayer || [];
  (function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
  new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
  j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
  'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
  })(window,document,'script','dataLayer','GTM-XXXXXXX');
</script>
```

**WICHTIG:**
- `klaro-no-css.js` verwenden, NICHT `klaro.js` (sonst doppeltes CSS!)
- Config Script MUSS vor Library laden
- Custom CSS MUSS nach CDN CSS laden

---

## 3. klaro-config.js (Vollstaendig)

```javascript
// Klaro Cookie Consent Configuration
// EU-DSGVO konform mit Google Consent Mode v2

// Body Scroll Lock fuer Modal (iOS Safari kompatibel)
(function() {
    var scrollPosition = 0;
    var isLocked = false;

    function lockScroll() {
        if (isLocked) return;
        isLocked = true;
        scrollPosition = window.pageYOffset || document.documentElement.scrollTop;

        // HTML und Body sperren (wichtig fuer iOS!)
        document.documentElement.style.overflow = 'hidden';
        document.documentElement.style.height = '100%';
        document.body.style.overflow = 'hidden';
        document.body.style.height = '100%';
        document.body.style.position = 'fixed';
        document.body.style.top = '-' + scrollPosition + 'px';
        document.body.style.left = '0';
        document.body.style.right = '0';
        document.body.style.width = '100%';
    }

    function unlockScroll() {
        if (!isLocked) return;
        isLocked = false;

        document.documentElement.style.overflow = '';
        document.documentElement.style.height = '';
        document.body.style.overflow = '';
        document.body.style.height = '';
        document.body.style.position = '';
        document.body.style.top = '';
        document.body.style.left = '';
        document.body.style.right = '';
        document.body.style.width = '';

        window.scrollTo(0, scrollPosition);
    }

    var observer = new MutationObserver(function(mutations) {
        var modal = document.querySelector('.klaro .cookie-modal');
        if (modal) {
            lockScroll();
        } else {
            unlockScroll();
        }
    });

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            observer.observe(document.body, { childList: true, subtree: true });
        });
    } else {
        observer.observe(document.body, { childList: true, subtree: true });
    }
})();

var klaroConfig = {
    // Speicherung
    storageMethod: 'cookie',
    storageName: 'klaro-consent',
    cookieExpiresAfterDays: 365,

    // DSGVO-Konformitaet
    default: false,              // Alle Services standardmaessig AUS (Opt-in!)
    mustConsent: false,          // User kann Banner schliessen
    acceptAll: true,             // "Alle akzeptieren" anzeigen
    hideDeclineAll: false,       // "Alle ablehnen" MUSS sichtbar sein!
    hideLearnMore: false,        // Details-Link anzeigen
    noticeAsModal: false,        // Banner unten, nicht als Modal
    disablePoweredBy: true,      // "Powered by Klaro" ausblenden
    groupByPurpose: false,       // Services einzeln anzeigen
    htmlTexts: true,             // HTML in Texten erlauben

    // Styling
    styling: {
        theme: ['light', 'bottom', 'left']
    },

    // Deutsche Uebersetzungen
    translations: {
        zz: {
            privacyPolicyUrl: '/datenschutz'
        },
        de: {
            privacyPolicyUrl: '/datenschutz',
            privacyPolicy: {
                name: 'Datenschutzerklaerung',
                text: 'Weitere Informationen finden Sie in unserer {privacyPolicy}.'
            },
            consentModal: {
                title: 'Datenschutz-Einstellungen',
                description: 'Hier koennen Sie einsehen und anpassen, welche Dienste wir nutzen duerfen.'
            },
            consentNotice: {
                title: 'Cookie-Einstellungen',
                description: 'Wir verwenden Cookies und aehnliche Technologien, um Ihnen ein optimales Website-Erlebnis zu bieten.',
                learnMore: 'Einstellungen'
            },
            ok: 'Alle akzeptieren',
            decline: 'Alle ablehnen',
            save: 'Auswahl speichern',
            acceptAll: 'Alle akzeptieren',
            acceptSelected: 'Auswahl speichern'
        }
    },

    // Services
    services: [
        {
            name: 'google-tag-manager',
            title: 'Google Tag Manager',
            purposes: ['essential'],
            required: true,
            description: 'Verwaltet das Laden von Tags basierend auf Ihrer Einwilligung.',
            onInit: function() {
                window.dataLayer = window.dataLayer || [];
                window.gtag = function() { dataLayer.push(arguments); };

                // Consent Mode v2 - Default: Alles verweigern
                gtag('consent', 'default', {
                    'ad_storage': 'denied',
                    'ad_user_data': 'denied',
                    'ad_personalization': 'denied',
                    'analytics_storage': 'denied',
                    'functionality_storage': 'denied',
                    'personalization_storage': 'denied',
                    'security_storage': 'granted'
                });

                gtag('set', 'ads_data_redaction', true);
                gtag('set', 'url_passthrough', true);
            }
        },
        {
            name: 'google-analytics',
            title: 'Google Analytics',
            purposes: ['analytics'],
            required: false,
            default: false,
            description: 'Sammelt anonymisierte Statistiken.',
            cookies: [/^_ga/, /^_gid/, /^_gat/],
            onAccept: function() {
                gtag('consent', 'update', { 'analytics_storage': 'granted' });
                dataLayer.push({'event': 'klaro-google-analytics-accepted'});
            },
            onDecline: function() {
                gtag('consent', 'update', { 'analytics_storage': 'denied' });
            }
        },
        {
            name: 'google-ads',
            title: 'Google Ads',
            purposes: ['marketing'],
            required: false,
            default: false,
            description: 'Ermoeglicht Werbemessung und personalisierte Anzeigen.',
            cookies: [/^_gcl/, /^_gac/, 'IDE', 'DSID', 'NID'],
            onAccept: function() {
                gtag('consent', 'update', {
                    'ad_storage': 'granted',
                    'ad_user_data': 'granted',
                    'ad_personalization': 'granted'
                });
                dataLayer.push({'event': 'klaro-google-ads-accepted'});
            },
            onDecline: function() {
                gtag('consent', 'update', {
                    'ad_storage': 'denied',
                    'ad_user_data': 'denied',
                    'ad_personalization': 'denied'
                });
            }
        }
    ]
};
```

---

## 4. klaro-theme.css - Button Layout (KRITISCH!)

### Das wichtigste Learning: CSS Grid mit expliziten Positionen!

Flexbox mit `order` funktioniert NICHT zuverlaessig bei Klaro. CSS Grid mit expliziten `grid-column` und `grid-row` ist die einzige zuverlaessige Loesung.

```css
/* Banner Buttons Container - CSS Grid */
.klaro .cookie-notice .cn-buttons {
    display: grid !important;
    grid-template-columns: 1fr 1fr !important;
    grid-template-rows: auto auto !important;
    gap: 10px !important;
}

/* Einstellungen Link - ERSTE ZEILE, volle Breite */
.klaro .cookie-notice .cn-buttons .cm-btn-info,
.klaro .cookie-notice .cn-buttons .cm-link,
.klaro .cookie-notice .cn-buttons a.cm-link {
    grid-column: 1 / -1 !important;
    grid-row: 1 !important;
    background: transparent !important;
    border: none !important;
    color: #6b7280 !important;
    font-size: 13px !important;
    font-weight: 400 !important;
    text-decoration: underline !important;
    padding: 0 0 4px 0 !important;
    text-align: left !important;
}

/* Alle akzeptieren - ZWEITE ZEILE, links */
.klaro .cookie-notice .cn-buttons .cm-btn-success {
    grid-column: 1 !important;
    grid-row: 2 !important;
    background: #1e3a5f !important;
    color: #ffffff !important;
    border: 2px solid #1e3a5f !important;
}

/* Alle ablehnen - ZWEITE ZEILE, rechts */
.klaro .cookie-notice .cn-buttons .cm-btn-danger {
    grid-column: 2 !important;
    grid-row: 2 !important;
    background: #ffffff !important;
    color: #1e3a5f !important;
    border: 2px solid #1e3a5f !important;
}
```

### Gewuenschtes Layout:

```
+----------------------------------------+
| Einstellungen (Link, volle Breite)     |  <- grid-row: 1, grid-column: 1 / -1
+----------------------------------------+
| [Alle akzeptieren] | [Alle ablehnen]   |  <- grid-row: 2
+----------------------------------------+
```

### Button-Klassen Referenz:

| Klasse | Bedeutung | Styling |
|--------|-----------|---------|
| `.cm-btn-success` | "Alle akzeptieren" | Primary, gefuellt |
| `.cm-btn-danger` | "Alle ablehnen" | Secondary, outlined |
| `.cm-btn-info` / `.cm-link` | "Einstellungen" | Link-Style |

---

## 5. Modal zentrieren

```css
.klaro .cookie-modal .cm-modal {
    position: absolute !important;
    top: 50% !important;
    left: 50% !important;
    transform: translate(-50%, -50%) !important;
    /* ... */
}
```

---

## 6. Body Scroll Lock (iOS Safari)

WICHTIG: Sowohl `html` als auch `body` Element sperren!

```javascript
function lockScroll() {
    scrollPosition = window.pageYOffset;

    // HTML UND Body!
    document.documentElement.style.overflow = 'hidden';
    document.documentElement.style.height = '100%';
    document.body.style.overflow = 'hidden';
    document.body.style.height = '100%';
    document.body.style.position = 'fixed';
    document.body.style.top = '-' + scrollPosition + 'px';
    document.body.style.width = '100%';
}
```

Zusaetzlich im CSS:
```css
.klaro .cookie-modal .cm-bg {
    touch-action: none !important;
}
```

---

## 7. Haeufige Probleme & Loesungen

### Problem: Buttons falsch angeordnet
**Ursache:** Flexbox mit `order` funktioniert nicht zuverlaessig
**Loesung:** CSS Grid mit expliziten `grid-column` und `grid-row` Werten

### Problem: Modal-Hintergrund scrollt auf Mobile
**Ursache:** Nur body gesperrt, nicht html
**Loesung:** Beide Elemente sperren + `touch-action: none` auf Backdrop

### Problem: CSS wird nicht ueberschrieben
**Ursache:** Klaro CSS wird doppelt geladen oder hat hoehere Spezifitaet
**Loesung:**
1. `klaro-no-css.js` statt `klaro.js` verwenden
2. CDN CSS zuerst, dann Custom CSS
3. Alle Selektoren mit `!important`

### Problem: Toggle-Farben aendern sich nicht
**Loesung:** Spezifische Selektoren:
```css
.klaro .cm-list-input:checked + .cm-list-label .slider {
    background-color: #1e3a5f !important;
}
```

---

## 8. Farbanpassung Quick Reference

Fuer neues Projekt diese Werte anpassen:

| Element | Wert |
|---------|------|
| Primary Color | `#1e3a5f` |
| Primary Hover | `#2a4a73` |
| Text Main | `#374151` |
| Text Muted | `#4b5563` |
| Border | `#e5e7eb` |
| Background | `#ffffff` |

---

## 9. Testing Checklist

- [ ] Banner erscheint beim ersten Besuch
- [ ] Layout: Einstellungen oben, Buttons unten nebeneinander
- [ ] "Alle akzeptieren" setzt alle Consents
- [ ] "Alle ablehnen" verweigert optionale Consents
- [ ] Modal ist vertikal zentriert
- [ ] Hintergrund scrollt NICHT wenn Modal offen (Mobile!)
- [ ] Toggle-Switches funktionieren und haben richtige Farbe
- [ ] Cookie wird gespeichert
- [ ] `klaro.show()` oeffnet Einstellungen
- [ ] DataLayer Events werden gefeuert

---

## 10. Vollstaendige klaro-theme.css Vorlage

Siehe: `/var/www/staging/forstinger-haus-bad/public/css/klaro-theme.css`

Diese Datei als Vorlage fuer neue Projekte verwenden und nur Farben anpassen.

---

*Erstellt: Januar 2026*
*Basierend auf: Klaro v0.7, Google Consent Mode v2*
*Getestet auf: Desktop Chrome/Firefox/Safari, Mobile iOS Safari/Chrome*


---

## 11. Meta Pixel Integration (UPDATE 2026-01-12)

### Warum Meta Pixel in Klaro?

Meta Pixel (Facebook Pixel) ist ein Marketing-Tracker und braucht Consent.
DSGVO erfordert Opt-in vor dem Laden des Pixels.

### Meta Pixel Service hinzufuegen

```javascript
// In klaro-config.js - nach google-ads Service

// Meta Pixel ID global setzen (vor klaroConfig)
window.META_PIXEL_ID = '123456789012345';
window.metaPixelConsent = false;
window.metaPixelLoaded = false;

// Im services Array:
{
    name: 'meta-pixel',
    title: 'Meta Pixel (Facebook)',
    purposes: ['marketing'],
    required: false,
    default: false,
    description: 'Ermoeglicht die Messung von Werbeerfolg auf Facebook und Instagram.',
    cookies: ['_fbp', '_fbc', 'fr'],

    onInit: function() {
        // NUR Flags setzen, NICHT fbq initialisieren!
        window.metaPixelConsent = false;
        window.metaPixelLoaded = false;
    },

    onAccept: function() {
        window.metaPixelConsent = true;

        if (window.metaPixelLoaded) {
            if (typeof fbq === 'function') {
                fbq('consent', 'grant');
                fbq('track', 'PageView');
            }
            return;
        }

        // Standard Meta Pixel Code MIT Error Handling
        !function(f,b,e,v,n,t,s)
        {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
        n.callMethod.apply(n,arguments):n.queue.push(arguments)};
        if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
        n.queue=[];t=b.createElement(e);t.async=!0;
        t.src=v;
        t.onerror=function(){
            console.log('[Meta Pixel] Script blocked - Ad-Blocker active');
            window.metaPixelLoaded = false;
        };
        t.onload=function(){
            window.metaPixelLoaded = true;
            window.dispatchEvent(new CustomEvent('metaPixelReady'));
        };
        s=b.getElementsByTagName(e)[0];
        s.parentNode.insertBefore(t,s)}(window, document,'script',
        'https://connect.facebook.net/en_US/fbevents.js');

        fbq('init', window.META_PIXEL_ID);
        fbq('consent', 'grant');
        fbq('track', 'PageView');
    },

    onDecline: function() {
        window.metaPixelConsent = false;
        if (typeof fbq === 'function') {
            fbq('consent', 'revoke');
        }
    }
}
```

### KRITISCH: fbq NICHT vorab initialisieren!

**FALSCH:**
```javascript
onInit: function() {
    window.fbq = function() { ... };  // NEIN!
}
```

**RICHTIG:**
```javascript
onInit: function() {
    window.metaPixelConsent = false;  // Nur Flags!
    window.metaPixelLoaded = false;
}
```

Das Vorab-Initialisieren von fbq fuehrt zu:
- "Multiple pixels with conflicting versions"
- "pixel has not been activated for this event"

### Event Tracking auf anderen Seiten

```html
<script is:inline>
(function() {
    function fireEvent() {
        if (typeof fbq !== 'undefined' && window.metaPixelConsent) {
            fbq('track', 'ViewContent', { content_name: 'Formular' });
        }
    }

    if (window.metaPixelLoaded && window.metaPixelConsent) {
        fireEvent();
    } else {
        window.addEventListener('metaPixelReady', fireEvent);
    }
})();
</script>
```

### Vollstaendiges Template

Siehe: `/var/www/staging/_system/templates/klaro-config-template.js`

---

*Update: Januar 2026 - Meta Pixel + Conversions API Integration*
