// Klaro Cookie Consent Configuration
// EU-DSGVO konform mit Google Consent Mode v2 + Meta Pixel

// Body Scroll Lock für Modal (iOS Safari kompatibel)
(function() {
    var scrollPosition = 0;
    var isLocked = false;

    function lockScroll() {
        if (isLocked) return;
        isLocked = true;
        scrollPosition = window.pageYOffset || document.documentElement.scrollTop;

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

// Meta Pixel ID (global für Zugriff aus anderen Scripts)
window.META_PIXEL_ID = 'YOUR_PIXEL_ID_HERE';

// Consent-Status Flags
window.metaPixelConsent = false;
window.metaPixelLoaded = false;

var klaroConfig = {
    storageMethod: 'cookie',
    storageName: 'klaro-consent',
    cookieExpiresAfterDays: 365,

    default: false,
    mustConsent: false,
    acceptAll: true,
    hideDeclineAll: false,
    hideLearnMore: false,
    noticeAsModal: false,
    disablePoweredBy: true,
    groupByPurpose: false,
    htmlTexts: true,

    styling: {
        theme: ['light', 'bottom', 'left']
    },

    translations: {
        zz: {
            privacyPolicyUrl: '/datenschutz'
        },
        de: {
            privacyPolicyUrl: '/datenschutz',
            privacyPolicy: {
                name: 'Datenschutzerklärung',
                text: 'Weitere Informationen finden Sie in unserer {privacyPolicy}.'
            },
            consentModal: {
                title: 'Datenschutz-Einstellungen',
                description: 'Hier können Sie einsehen und anpassen, welche Dienste wir auf dieser Website nutzen dürfen. Weitere Informationen finden Sie in unserer Datenschutzerklärung.'
            },
            consentNotice: {
                title: 'Cookie-Einstellungen',
                description: 'Wir verwenden Cookies und ähnliche Technologien, um Ihnen ein optimales Website-Erlebnis zu bieten. Einige sind notwendig, andere helfen uns, die Website zu verbessern und Werbung anzuzeigen.',
                learnMore: 'Einstellungen',
                changeDescription: 'Es gab Änderungen seit Ihrem letzten Besuch. Bitte aktualisieren Sie Ihre Einstellungen.'
            },
            ok: 'Alle akzeptieren',
            decline: 'Alle ablehnen',
            save: 'Auswahl speichern',
            acceptAll: 'Alle akzeptieren',
            acceptSelected: 'Auswahl speichern',
            close: 'Schließen',
            poweredBy: '',
            purposes: {
                essential: {
                    title: 'Notwendig',
                    description: 'Diese Dienste sind für die Grundfunktionen der Website erforderlich.'
                },
                analytics: {
                    title: 'Statistik',
                    description: 'Diese Dienste helfen uns zu verstehen, wie Besucher mit der Website interagieren.'
                },
                marketing: {
                    title: 'Marketing',
                    description: 'Diese Dienste werden verwendet, um Werbung relevanter für Sie zu gestalten.'
                }
            }
        }
    },

    services: [
        {
            name: 'google-tag-manager',
            title: 'Google Tag Manager',
            purposes: ['essential'],
            required: true,
            description: 'Verwaltet das Laden von Analyse- und Marketing-Tags basierend auf Ihrer Einwilligung.',

            onInit: function() {
                window.dataLayer = window.dataLayer || [];
                window.gtag = function() { dataLayer.push(arguments); };

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
            },

            onAccept: function(opts) {
                if (opts && opts.consents) {
                    for (var k in opts.consents) {
                        if (opts.consents[k]) {
                            var eventName = 'klaro-' + k + '-accepted';
                            dataLayer.push({'event': eventName});
                        }
                    }
                }
            }
        },
        {
            name: 'google-analytics',
            title: 'Google Analytics',
            purposes: ['analytics'],
            required: false,
            default: false,
            description: 'Sammelt anonymisierte Statistiken über die Nutzung unserer Website.',
            cookies: [
                /^_ga/,
                /^_gid/,
                /^_gat/
            ],

            onAccept: function() {
                gtag('consent', 'update', {
                    'analytics_storage': 'granted'
                });
                dataLayer.push({'event': 'klaro-google-analytics-accepted'});
            },

            onDecline: function() {
                gtag('consent', 'update', {
                    'analytics_storage': 'denied'
                });
            }
        },
        {
            name: 'google-ads',
            title: 'Google Ads',
            purposes: ['marketing'],
            required: false,
            default: false,
            description: 'Ermöglicht die Messung von Werbeerfolg und personalisierte Werbeanzeigen.',
            cookies: [
                /^_gcl/,
                /^_gac/,
                'IDE',
                'DSID',
                'NID'
            ],

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
        },
        {
            name: 'meta-pixel',
            title: 'Meta Pixel (Facebook)',
            purposes: ['marketing'],
            required: false,
            default: false,
            description: 'Ermöglicht die Messung von Werbeerfolg auf Facebook und Instagram.',
            cookies: [
                '_fbp',
                '_fbc',
                'fr'
            ],

            onInit: function() {
                // Nur Consent-Flag setzen, NICHT fbq vorab initialisieren
                window.metaPixelConsent = false;
                window.metaPixelLoaded = false;
            },

            onAccept: function() {
                window.metaPixelConsent = true;

                // Prüfen ob Pixel-Script bereits geladen
                if (window.metaPixelLoaded) {
                    // Pixel bereits geladen - nur PageView senden
                    if (typeof fbq === 'function') {
                        fbq('consent', 'grant');
                        fbq('track', 'PageView');
                        console.log('[Meta Pixel] Consent granted, PageView sent');
                    }
                    return;
                }

                // Meta Pixel Code mit Error Handling
                !function(f,b,e,v,n,t,s)
                {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
                n.callMethod.apply(n,arguments):n.queue.push(arguments)};
                if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
                n.queue=[];t=b.createElement(e);t.async=!0;
                t.src=v;
                t.onerror=function(){
                    console.log('[Meta Pixel] Script blocked - Ad-Blocker or Privacy Feature active');
                    window.metaPixelLoaded = false;
                };
                t.onload=function(){
                    window.metaPixelLoaded = true;
                    window.dispatchEvent(new CustomEvent('metaPixelReady'));
                    console.log('[Meta Pixel] Script loaded successfully');
                };
                s=b.getElementsByTagName(e)[0];
                s.parentNode.insertBefore(t,s)}(window, document,'script',
                'https://connect.facebook.net/en_US/fbevents.js');

                // Pixel initialisieren (wird in Queue gespeichert bis Script lädt)
                fbq('init', window.META_PIXEL_ID);
                fbq('consent', 'grant');
                fbq('track', 'PageView');

                console.log('[Meta Pixel] Initialized with consent');
                dataLayer.push({'event': 'klaro-meta-pixel-accepted'});
            },

            onDecline: function() {
                window.metaPixelConsent = false;

                if (typeof fbq === 'function') {
                    fbq('consent', 'revoke');
                }

                // Cookies löschen
                document.cookie = '_fbp=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
                document.cookie = '_fbc=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
            }
        }
    ]
};
