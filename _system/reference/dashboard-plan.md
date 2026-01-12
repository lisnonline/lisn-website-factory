# LISN Dashboard - Implementierungsplan

**Version:** 1.0
**Erstellt:** 2026-01-12
**Autor:** Claude Code
**Status:** Bereit zur Implementierung

---

## ZUSAMMENFASSUNG (für Context Recovery)

Dieses Dokument beschreibt den Plan für ein **Dashboard zur Verwaltung von LISN Kundenprojekten** auf dem Hetzner Server (46.224.27.249). Das Dashboard ersetzt manuelle SSH-Arbeit und ermöglicht:

1. **Übersicht aller Projekte** mit Status (PM2, Preview-URL, Live-URL)
2. **Projekt-Details** mit Config, Env-Vars, Logs
3. **Neues Projekt erstellen** via Wizard → generiert Claude Code Prompt
4. **Quick Actions** wie Rebuild, PM2 Restart, Logs ansehen

**Tech Stack:** Astro SSR + Tailwind + Alpine.js (identisch zu Kundenprojekten)
**Deployment:** PM2 auf Port 4400, Nginx Reverse Proxy
**URL:** https://dashboard.lisn-agentur.com (oder /dashboard auf customers.)

---

## 1. TECHNISCHE MACHBARKEIT (Verifiziert)

### 1.1 PM2 Programmatic Access
```bash
# PM2 gibt detailliertes JSON aus
pm2 jlist
# Enthält: name, status, memory, cpu, uptime, restart_time, port, logs
```

### 1.2 Filesystem Access
```bash
# Projektverzeichnisse
/var/www/staging/
├── _system/          # Ignorieren
├── _template/        # Ignorieren
├── _archive/         # Ignorieren
└── [projekt-slug]/   # Echte Projekte
    ├── config.json   # Firmeninfos
    ├── .env          # Umgebungsvariablen (Keys maskiert anzeigen)
    ├── package.json  # Version, Scripts
    └── dist/         # Existiert = gebaut
```

### 1.3 Server-Ressourcen
```bash
# Verfügbar auf Server
Node.js: v20.19.6
PM2: 6.0.14
pnpm: 10.27.0
Freier RAM: ~2.5GB
Freier Disk: ~35GB
```

---

## 2. ARCHITEKTUR

### 2.1 High-Level Architektur

```
┌─────────────────────────────────────────────────────────────────────┐
│                         Hetzner Server                              │
│                        (46.224.27.249)                              │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                         Nginx                                │   │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐  │   │
│  │  │ dashboard.lisn  │  │ customers.lisn  │  │ kunde.at    │  │   │
│  │  │ :4400           │  │ :4321, :4322... │  │ :43xx       │  │   │
│  │  └────────┬────────┘  └────────┬────────┘  └──────┬──────┘  │   │
│  └───────────┼────────────────────┼──────────────────┼─────────┘   │
│              │                    │                  │              │
│  ┌───────────▼────────┐  ┌───────▼────────┐  ┌──────▼───────┐     │
│  │   LISN Dashboard   │  │   Forstinger   │  │   Kunde X    │     │
│  │   (Astro SSR)      │  │   (Astro SSR)  │  │  (Astro SSR) │     │
│  │   PM2: dashboard   │  │   PM2: fofa    │  │  PM2: kunde  │     │
│  └───────────┬────────┘  └────────────────┘  └──────────────┘     │
│              │                                                      │
│              ▼                                                      │
│  ┌────────────────────────────────────────┐                        │
│  │           Filesystem Access            │                        │
│  │  /var/www/staging/*/config.json        │                        │
│  │  /var/www/staging/*/.env               │                        │
│  │  PM2 CLI (pm2 jlist, pm2 restart)      │                        │
│  └────────────────────────────────────────┘                        │
└─────────────────────────────────────────────────────────────────────┘
```

### 2.2 Datenfluss

```
Browser Request
      │
      ▼
┌─────────────────┐
│  Astro SSR      │
│  API Endpoint   │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌───────┐ ┌──────────┐
│  fs   │ │ pm2 CLI  │
│ read  │ │ exec     │
└───┬───┘ └────┬─────┘
    │          │
    ▼          ▼
┌─────────────────┐
│  JSON Response  │
└─────────────────┘
```

---

## 3. DATEISTRUKTUR

```
/var/www/staging/_dashboard/
├── src/
│   ├── pages/
│   │   ├── index.astro              # Dashboard Home (Projekt-Liste)
│   │   ├── login.astro              # Login-Seite
│   │   ├── new.astro                # Neues Projekt Wizard
│   │   ├── projects/
│   │   │   └── [slug].astro         # Projekt-Detail-Seite
│   │   └── api/
│   │       ├── projects.ts          # GET: Liste aller Projekte
│   │       ├── project/[slug].ts    # GET: Einzelnes Projekt
│   │       ├── pm2/
│   │       │   ├── status.ts        # GET: PM2 Status
│   │       │   ├── restart.ts       # POST: PM2 Restart
│   │       │   ├── logs.ts          # GET: Letzte Logs
│   │       │   └── rebuild.ts       # POST: pnpm build + restart
│   │       ├── generate-prompt.ts   # POST: Claude Prompt generieren
│   │       └── auth/
│   │           ├── login.ts         # POST: Login
│   │           └── logout.ts        # POST: Logout
│   │
│   ├── components/
│   │   ├── layout/
│   │   │   ├── DashboardLayout.astro
│   │   │   ├── Sidebar.astro
│   │   │   └── Header.astro
│   │   ├── projects/
│   │   │   ├── ProjectCard.astro
│   │   │   ├── ProjectList.astro
│   │   │   └── StatusBadge.astro
│   │   ├── wizard/
│   │   │   ├── NewProjectWizard.astro
│   │   │   ├── StepBasicInfo.astro
│   │   │   ├── StepContact.astro
│   │   │   ├── StepFeatures.astro
│   │   │   └── StepInputs.astro
│   │   ├── modals/
│   │   │   ├── PromptModal.astro
│   │   │   ├── LogsModal.astro
│   │   │   └── ConfirmModal.astro
│   │   └── ui/
│   │       ├── Button.astro
│   │       ├── Input.astro
│   │       ├── Card.astro
│   │       └── Badge.astro
│   │
│   ├── lib/
│   │   ├── projects.ts              # Projekt-Scanner
│   │   ├── pm2.ts                   # PM2 Wrapper
│   │   ├── prompt-generator.ts      # Claude Prompt Builder
│   │   ├── auth.ts                  # Auth Helpers
│   │   └── server-stats.ts          # CPU, RAM, Disk
│   │
│   ├── middleware/
│   │   └── auth.ts                  # Auth Middleware
│   │
│   └── styles/
│       └── global.css               # Tailwind + Custom Styles
│
├── public/
│   └── favicon.svg
│
├── data/
│   ├── sessions.json                # Active Sessions (oder SQLite)
│   └── project-meta.json            # Zusätzliche Metadaten
│
├── astro.config.mjs
├── tailwind.config.mjs
├── package.json
├── ecosystem.config.cjs
├── .env
└── README.md
```

---

## 4. DATENMODELLE

### 4.1 Project (aus Filesystem gelesen)

```typescript
interface Project {
  // Basis (aus Verzeichnisname)
  slug: string;                    // "forstinger-haus-bad"
  path: string;                    // "/var/www/staging/forstinger-haus-bad"

  // Aus config.json
  config: {
    company: {
      name: string;                // "Forstinger Haus & Bad"
      fullLegalName?: string;
      owner?: string;
      industry?: string;
    };
    contact: {
      email: string;
      phone: string;
      website?: string;
      address?: {
        street: string;
        zip: string;
        city: string;
      };
    };
    theme?: {
      primary: string;
      accent: string;
    };
  } | null;

  // Aus .env (Keys nur, keine Werte!)
  envKeys: string[];               // ["BREVO_API_KEY", "META_PIXEL_ID"]

  // Aus package.json
  packageJson: {
    name: string;
    version: string;
    scripts: Record<string, string>;
  } | null;

  // Filesystem Status
  hasDistFolder: boolean;          // Wurde gebaut?
  hasEnvFile: boolean;
  hasConfigJson: boolean;
  lastModified: Date;

  // PM2 Status (live)
  pm2: {
    status: 'online' | 'stopped' | 'errored' | 'not_found';
    pid?: number;
    memory?: number;               // Bytes
    cpu?: number;                  // Prozent
    uptime?: number;               // ms seit Start
    restarts?: number;
    port?: number;
  };

  // URLs
  previewUrl: string | null;       // https://customers.../slug/
  liveUrl: string | null;          // https://slug.at (aus config)
}
```

### 4.2 NewProjectForm (Wizard Input)

```typescript
interface NewProjectForm {
  // Step 1: Basis
  companyName: string;             // "Müller Sanitär GmbH"
  industry: string;                // "Sanitär, Heizung, Klima"
  location: string;                // "Dornbirn, Vorarlberg"

  // Step 2: Kontakt
  email: string;
  phone: string;
  website: string;                 // ohne https://
  address: {
    street: string;
    zip: string;
    city: string;
  };

  // Step 3: Features
  features: {
    contactForm: boolean;          // Brevo
    cookieBanner: boolean;         // Klaro
    metaPixel: boolean;
    googleAnalytics: boolean;
  };

  // Step 4: Inputs
  inputs: {
    hasStitchExport: boolean;
    hasLogo: boolean;
    hasImages: boolean;
    notes: string;
  };
}
```

### 4.3 GeneratedPrompt

```typescript
interface GeneratedPrompt {
  slug: string;
  prompt: string;                  // Markdown-formatierter Prompt
  createdAt: Date;
}
```

---

## 5. API ENDPOINTS

### 5.1 Projects API

| Endpoint | Method | Beschreibung |
|----------|--------|--------------|
| `/api/projects` | GET | Liste aller Projekte |
| `/api/project/[slug]` | GET | Einzelnes Projekt mit Details |

### 5.2 PM2 API

| Endpoint | Method | Body | Beschreibung |
|----------|--------|------|--------------|
| `/api/pm2/status` | GET | - | Status aller PM2 Prozesse |
| `/api/pm2/restart` | POST | `{slug}` | Projekt neustarten |
| `/api/pm2/rebuild` | POST | `{slug}` | Build + Restart |
| `/api/pm2/logs` | GET | `?slug=x&lines=100` | Letzte Logs |

### 5.3 Generator API

| Endpoint | Method | Body | Beschreibung |
|----------|--------|------|--------------|
| `/api/generate-prompt` | POST | `NewProjectForm` | Claude Prompt generieren |

### 5.4 Auth API

| Endpoint | Method | Body | Beschreibung |
|----------|--------|------|--------------|
| `/api/auth/login` | POST | `{password}` | Login |
| `/api/auth/logout` | POST | - | Logout |

---

## 6. KERN-IMPLEMENTIERUNGEN

### 6.1 Projekt-Scanner (lib/projects.ts)

```typescript
import { readdir, readFile, stat } from 'fs/promises';
import { join } from 'path';
import { execSync } from 'child_process';

const STAGING_PATH = '/var/www/staging';
const IGNORED_DIRS = ['_system', '_template', '_archive', '_dashboard'];

export async function getAllProjects(): Promise<Project[]> {
  const entries = await readdir(STAGING_PATH, { withFileTypes: true });

  const projectDirs = entries
    .filter(e => e.isDirectory())
    .filter(e => !IGNORED_DIRS.includes(e.name))
    .map(e => e.name);

  const projects = await Promise.all(
    projectDirs.map(slug => getProject(slug))
  );

  return projects.filter(p => p !== null);
}

export async function getProject(slug: string): Promise<Project | null> {
  const path = join(STAGING_PATH, slug);

  try {
    // Config lesen
    const configPath = join(path, 'config.json');
    let config = null;
    try {
      config = JSON.parse(await readFile(configPath, 'utf-8'));
    } catch {}

    // Package.json lesen
    const pkgPath = join(path, 'package.json');
    let packageJson = null;
    try {
      packageJson = JSON.parse(await readFile(pkgPath, 'utf-8'));
    } catch {}

    // .env Keys extrahieren (keine Werte!)
    const envPath = join(path, '.env');
    let envKeys: string[] = [];
    try {
      const envContent = await readFile(envPath, 'utf-8');
      envKeys = envContent
        .split('\n')
        .filter(line => line.includes('=') && !line.startsWith('#'))
        .map(line => line.split('=')[0].trim());
    } catch {}

    // Filesystem Checks
    const hasDistFolder = await exists(join(path, 'dist'));
    const hasEnvFile = await exists(envPath);
    const hasConfigJson = config !== null;
    const stats = await stat(path);

    // PM2 Status
    const pm2Status = await getPM2Status(slug);

    // URLs
    const previewUrl = `https://customers.lisn-agentur.com/${slug}/`;
    const liveUrl = config?.contact?.website
      ? `https://${config.contact.website}`
      : null;

    return {
      slug,
      path,
      config,
      packageJson,
      envKeys,
      hasDistFolder,
      hasEnvFile,
      hasConfigJson,
      lastModified: stats.mtime,
      pm2: pm2Status,
      previewUrl,
      liveUrl
    };
  } catch (error) {
    console.error(`Error reading project ${slug}:`, error);
    return null;
  }
}

async function exists(path: string): Promise<boolean> {
  try {
    await stat(path);
    return true;
  } catch {
    return false;
  }
}
```

### 6.2 PM2 Wrapper (lib/pm2.ts)

```typescript
import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

interface PM2Process {
  name: string;
  status: 'online' | 'stopped' | 'errored';
  pid: number;
  memory: number;
  cpu: number;
  uptime: number;
  restarts: number;
  port?: number;
}

export async function getPM2List(): Promise<PM2Process[]> {
  try {
    const { stdout } = await execAsync('pm2 jlist');
    const processes = JSON.parse(stdout);

    return processes.map((p: any) => ({
      name: p.name,
      status: p.pm2_env?.status || 'stopped',
      pid: p.pid,
      memory: p.monit?.memory || 0,
      cpu: p.monit?.cpu || 0,
      uptime: Date.now() - (p.pm2_env?.pm_uptime || Date.now()),
      restarts: p.pm2_env?.restart_time || 0,
      port: p.pm2_env?.PORT
    }));
  } catch (error) {
    console.error('PM2 list error:', error);
    return [];
  }
}

export async function getPM2Status(name: string): Promise<Project['pm2']> {
  const processes = await getPM2List();
  const process = processes.find(p => p.name === name);

  if (!process) {
    return { status: 'not_found' };
  }

  return {
    status: process.status,
    pid: process.pid,
    memory: process.memory,
    cpu: process.cpu,
    uptime: process.uptime,
    restarts: process.restarts,
    port: process.port
  };
}

export async function restartPM2(name: string): Promise<boolean> {
  try {
    await execAsync(`pm2 restart ${name}`);
    return true;
  } catch {
    return false;
  }
}

export async function rebuildProject(slug: string): Promise<{success: boolean, output: string}> {
  const path = `/var/www/staging/${slug}`;

  try {
    const { stdout, stderr } = await execAsync(
      `cd ${path} && pnpm build 2>&1`,
      { timeout: 120000 } // 2 Minuten Timeout
    );

    // Nach Build PM2 neustarten
    await restartPM2(slug);

    return { success: true, output: stdout + stderr };
  } catch (error: any) {
    return { success: false, output: error.message };
  }
}

export async function getPM2Logs(name: string, lines: number = 50): Promise<string> {
  try {
    const { stdout } = await execAsync(
      `pm2 logs ${name} --lines ${lines} --nostream 2>&1`
    );
    return stdout;
  } catch (error: any) {
    return error.message;
  }
}
```

### 6.3 Prompt Generator (lib/prompt-generator.ts)

```typescript
import type { NewProjectForm } from './types';

export function generateSlug(companyName: string): string {
  return companyName
    .toLowerCase()
    .replace(/ä/g, 'ae')
    .replace(/ö/g, 'oe')
    .replace(/ü/g, 'ue')
    .replace(/ß/g, 'ss')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/(gmbh|kg|og|e\.u\.|eu)$/i, '')
    .replace(/-+/g, '-')
    .replace(/^-|-$/g, '');
}

export function generatePrompt(form: NewProjectForm): string {
  const slug = generateSlug(form.companyName);

  const features = [];
  if (form.features.contactForm) features.push('- [x] Kontaktformular (Brevo)');
  if (form.features.cookieBanner) features.push('- [x] Cookie Banner (Klaro)');
  if (form.features.metaPixel) features.push('- [x] Meta Pixel + Conversions API');
  if (form.features.googleAnalytics) features.push('- [x] Google Analytics');

  const inputs = [];
  inputs.push(form.inputs.hasStitchExport
    ? '- [x] Stitch-Export vorhanden → Design 1:1 übernehmen!'
    : '- [ ] Stitch-Export: NICHT vorhanden → Standard-Template nutzen');
  inputs.push(form.inputs.hasLogo
    ? '- [x] Logo vorhanden'
    : '- [ ] Logo: Noch hochladen nach /inputs/');
  inputs.push(form.inputs.hasImages
    ? '- [x] Bilder vorhanden'
    : '- [ ] Bilder: Noch hochladen nach /inputs/');

  return `# Neues LISN Projekt: ${form.companyName}

## Server-Zugang
\`\`\`bash
ssh hetzner
# oder: ssh root@46.224.27.249
\`\`\`

## Projekt-Pfad
\`\`\`
/var/www/staging/${slug}
\`\`\`

## Kunde

| Feld | Wert |
|------|------|
| **Firma** | ${form.companyName} |
| **Branche** | ${form.industry} |
| **Standort** | ${form.location} |
| **E-Mail** | ${form.email} |
| **Telefon** | ${form.phone} |
| **Domain** | ${form.website} |
| **Adresse** | ${form.address.street}, ${form.address.zip} ${form.address.city} |

## Features
${features.join('\n')}

## Inputs
${inputs.join('\n')}
${form.inputs.notes ? `\n**Notizen:** ${form.inputs.notes}` : ''}

## Anweisungen

### 1. ZUERST die Dokumentation lesen:
\`\`\`bash
cat /var/www/staging/_system/MASTER_PROMPT.md
\`\`\`

### 2. Projekt erstellen nach WORKFLOW.md

### 3. Wichtige Referenzen:
- \`/var/www/staging/_system/WORKFLOW.md\` - Schritt-für-Schritt
- \`/var/www/staging/_system/BREVO_INTEGRATION.md\` - Formular
- \`/var/www/staging/_system/KLARO_COOKIE_BANNER.md\` - Cookie Banner
- \`/var/www/staging/_system/templates/\` - Vorlagen

### 4. Preview-URL wird sein:
\`\`\`
https://customers.lisn-agentur.com/${slug}/
\`\`\`

### 5. Nach Fertigstellung:
- [ ] Alle Seiten funktionieren
- [ ] Formular sendet (Test)
- [ ] Cookie Banner funktioniert
- [ ] Lighthouse Score > 80
- [ ] Mobile responsive

---
*Generiert am: ${new Date().toLocaleString('de-AT')}*
*Dashboard: LISN Website Factory*
`;
}
```

### 6.4 Einfache Auth (lib/auth.ts)

```typescript
import { readFile, writeFile } from 'fs/promises';
import { randomUUID } from 'crypto';

const SESSIONS_PATH = '/var/www/staging/_dashboard/data/sessions.json';
const SESSION_DURATION = 24 * 60 * 60 * 1000; // 24 Stunden

interface Session {
  token: string;
  createdAt: number;
  expiresAt: number;
}

async function getSessions(): Promise<Session[]> {
  try {
    const content = await readFile(SESSIONS_PATH, 'utf-8');
    return JSON.parse(content);
  } catch {
    return [];
  }
}

async function saveSessions(sessions: Session[]): Promise<void> {
  await writeFile(SESSIONS_PATH, JSON.stringify(sessions, null, 2));
}

export async function login(password: string): Promise<string | null> {
  const correctPassword = process.env.DASHBOARD_PASSWORD;

  if (!correctPassword || password !== correctPassword) {
    return null;
  }

  const token = randomUUID();
  const now = Date.now();

  const sessions = await getSessions();
  sessions.push({
    token,
    createdAt: now,
    expiresAt: now + SESSION_DURATION
  });

  // Alte Sessions entfernen
  const validSessions = sessions.filter(s => s.expiresAt > now);
  await saveSessions(validSessions);

  return token;
}

export async function validateSession(token: string): Promise<boolean> {
  if (!token) return false;

  const sessions = await getSessions();
  const session = sessions.find(s => s.token === token);

  if (!session) return false;
  if (session.expiresAt < Date.now()) return false;

  return true;
}

export async function logout(token: string): Promise<void> {
  const sessions = await getSessions();
  const filtered = sessions.filter(s => s.token !== token);
  await saveSessions(filtered);
}
```

---

## 7. UI KOMPONENTEN

### 7.1 Dashboard Layout

```astro
---
// src/components/layout/DashboardLayout.astro
interface Props {
  title: string;
}
const { title } = Astro.props;
---

<!DOCTYPE html>
<html lang="de">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{title} | LISN Dashboard</title>
  <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
</head>
<body class="bg-gray-100 min-h-screen">
  <div class="flex">
    <!-- Sidebar -->
    <aside class="w-64 bg-slate-900 text-white min-h-screen p-4">
      <div class="text-xl font-bold mb-8">LISN Dashboard</div>
      <nav class="space-y-2">
        <a href="/" class="block px-4 py-2 rounded hover:bg-slate-800">
          Projekte
        </a>
        <a href="/new" class="block px-4 py-2 rounded hover:bg-slate-800">
          + Neues Projekt
        </a>
      </nav>

      <div class="absolute bottom-4 left-4 right-4 text-sm text-slate-400">
        Server: 46.224.27.249
      </div>
    </aside>

    <!-- Main Content -->
    <main class="flex-1 p-8">
      <h1 class="text-2xl font-bold text-gray-800 mb-6">{title}</h1>
      <slot />
    </main>
  </div>

  <script src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js" defer></script>
</body>
</html>
```

### 7.2 Project Card

```astro
---
// src/components/projects/ProjectCard.astro
import StatusBadge from './StatusBadge.astro';

interface Props {
  project: Project;
}
const { project } = Astro.props;

const memoryMB = project.pm2.memory
  ? Math.round(project.pm2.memory / 1024 / 1024)
  : 0;
---

<div class="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition-shadow">
  <div class="flex justify-between items-start mb-4">
    <div>
      <h3 class="text-lg font-semibold text-gray-900">
        {project.config?.company?.name || project.slug}
      </h3>
      <p class="text-sm text-gray-500">{project.slug}</p>
    </div>
    <StatusBadge status={project.pm2.status} />
  </div>

  <div class="space-y-2 text-sm text-gray-600 mb-4">
    {project.config?.company?.industry && (
      <p>📁 {project.config.company.industry}</p>
    )}
    {project.pm2.status === 'online' && (
      <p>💾 {memoryMB} MB | CPU {project.pm2.cpu}%</p>
    )}
    {project.previewUrl && (
      <a href={project.previewUrl} target="_blank" class="text-blue-600 hover:underline block">
        🔗 Preview öffnen
      </a>
    )}
  </div>

  <div class="flex gap-2 pt-4 border-t">
    <a href={`/projects/${project.slug}`}
       class="px-3 py-1 bg-slate-100 hover:bg-slate-200 rounded text-sm">
      Details
    </a>
    <button
      x-data
      @click="$dispatch('rebuild', {slug: '${project.slug}'})"
      class="px-3 py-1 bg-blue-100 hover:bg-blue-200 text-blue-700 rounded text-sm">
      Rebuild
    </button>
    <button
      x-data
      @click="$dispatch('restart', {slug: '${project.slug}'})"
      class="px-3 py-1 bg-green-100 hover:bg-green-200 text-green-700 rounded text-sm">
      Restart
    </button>
  </div>
</div>
```

### 7.3 Status Badge

```astro
---
// src/components/projects/StatusBadge.astro
interface Props {
  status: 'online' | 'stopped' | 'errored' | 'not_found';
}
const { status } = Astro.props;

const styles = {
  online: 'bg-green-100 text-green-800',
  stopped: 'bg-yellow-100 text-yellow-800',
  errored: 'bg-red-100 text-red-800',
  not_found: 'bg-gray-100 text-gray-800'
};

const labels = {
  online: '● Online',
  stopped: '○ Stopped',
  errored: '✕ Error',
  not_found: '? Not Found'
};
---

<span class={`px-2 py-1 rounded-full text-xs font-medium ${styles[status]}`}>
  {labels[status]}
</span>
```

---

## 8. SEITEN

### 8.1 Dashboard Home (index.astro)

```astro
---
// src/pages/index.astro
import DashboardLayout from '../components/layout/DashboardLayout.astro';
import ProjectCard from '../components/projects/ProjectCard.astro';
import { getAllProjects } from '../lib/projects';

const projects = await getAllProjects();
const onlineCount = projects.filter(p => p.pm2.status === 'online').length;
---

<DashboardLayout title="Projekte">
  <div class="mb-6 flex justify-between items-center">
    <p class="text-gray-600">
      {projects.length} Projekte | {onlineCount} online
    </p>
    <a href="/new" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
      + Neues Projekt
    </a>
  </div>

  <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
    {projects.map(project => (
      <ProjectCard project={project} />
    ))}
  </div>

  {projects.length === 0 && (
    <div class="text-center py-12 text-gray-500">
      Noch keine Projekte vorhanden.
      <a href="/new" class="text-blue-600 hover:underline ml-2">
        Erstes Projekt erstellen →
      </a>
    </div>
  )}
</DashboardLayout>
```

### 8.2 Neues Projekt (new.astro)

```astro
---
// src/pages/new.astro
import DashboardLayout from '../components/layout/DashboardLayout.astro';
---

<DashboardLayout title="Neues Projekt">
  <div class="max-w-2xl mx-auto bg-white rounded-lg shadow-md p-8" x-data="newProjectWizard()">

    <!-- Progress Steps -->
    <div class="flex justify-between mb-8">
      <template x-for="(stepName, index) in steps" :key="index">
        <div class="flex items-center">
          <div
            :class="step > index ? 'bg-blue-600 text-white' : 'bg-gray-200 text-gray-600'"
            class="w-8 h-8 rounded-full flex items-center justify-center text-sm font-medium">
            <span x-text="index + 1"></span>
          </div>
          <span class="ml-2 text-sm" x-text="stepName"></span>
          <div x-show="index < steps.length - 1" class="w-8 h-px bg-gray-300 mx-2"></div>
        </div>
      </template>
    </div>

    <!-- Step 1: Basis -->
    <div x-show="step === 0">
      <h2 class="text-xl font-semibold mb-4">Basis-Informationen</h2>
      <div class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Firmenname *</label>
          <input type="text" x-model="form.companyName"
                 class="w-full px-3 py-2 border rounded focus:ring-2 focus:ring-blue-500"
                 placeholder="Müller Sanitär GmbH">
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Branche *</label>
          <input type="text" x-model="form.industry"
                 class="w-full px-3 py-2 border rounded focus:ring-2 focus:ring-blue-500"
                 placeholder="Sanitär, Heizung, Klima">
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Standort *</label>
          <input type="text" x-model="form.location"
                 class="w-full px-3 py-2 border rounded focus:ring-2 focus:ring-blue-500"
                 placeholder="Dornbirn, Vorarlberg">
        </div>
      </div>
    </div>

    <!-- Step 2: Kontakt -->
    <div x-show="step === 1">
      <h2 class="text-xl font-semibold mb-4">Kontaktdaten</h2>
      <div class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">E-Mail *</label>
          <input type="email" x-model="form.email"
                 class="w-full px-3 py-2 border rounded focus:ring-2 focus:ring-blue-500"
                 placeholder="office@mueller-sanitaer.at">
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Telefon *</label>
          <input type="tel" x-model="form.phone"
                 class="w-full px-3 py-2 border rounded focus:ring-2 focus:ring-blue-500"
                 placeholder="+43 5572 12345">
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Domain (ohne https://)</label>
          <input type="text" x-model="form.website"
                 class="w-full px-3 py-2 border rounded focus:ring-2 focus:ring-blue-500"
                 placeholder="mueller-sanitaer.at">
        </div>
        <div class="grid grid-cols-3 gap-4">
          <div class="col-span-2">
            <label class="block text-sm font-medium text-gray-700 mb-1">Straße</label>
            <input type="text" x-model="form.address.street"
                   class="w-full px-3 py-2 border rounded focus:ring-2 focus:ring-blue-500">
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">PLZ</label>
            <input type="text" x-model="form.address.zip"
                   class="w-full px-3 py-2 border rounded focus:ring-2 focus:ring-blue-500">
          </div>
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Stadt</label>
          <input type="text" x-model="form.address.city"
                 class="w-full px-3 py-2 border rounded focus:ring-2 focus:ring-blue-500">
        </div>
      </div>
    </div>

    <!-- Step 3: Features -->
    <div x-show="step === 2">
      <h2 class="text-xl font-semibold mb-4">Features</h2>
      <div class="space-y-3">
        <label class="flex items-center">
          <input type="checkbox" x-model="form.features.contactForm" class="mr-3">
          <span>Kontaktformular (Brevo Integration)</span>
        </label>
        <label class="flex items-center">
          <input type="checkbox" x-model="form.features.cookieBanner" class="mr-3">
          <span>Cookie Banner (Klaro, DSGVO-konform)</span>
        </label>
        <label class="flex items-center">
          <input type="checkbox" x-model="form.features.metaPixel" class="mr-3">
          <span>Meta Pixel + Conversions API</span>
        </label>
        <label class="flex items-center">
          <input type="checkbox" x-model="form.features.googleAnalytics" class="mr-3">
          <span>Google Analytics</span>
        </label>
      </div>
    </div>

    <!-- Step 4: Inputs -->
    <div x-show="step === 3">
      <h2 class="text-xl font-semibold mb-4">Vorhandene Inputs</h2>
      <div class="space-y-3">
        <label class="flex items-center">
          <input type="checkbox" x-model="form.inputs.hasStitchExport" class="mr-3">
          <span>Stitch-Export vorhanden (Design 1:1 übernehmen)</span>
        </label>
        <label class="flex items-center">
          <input type="checkbox" x-model="form.inputs.hasLogo" class="mr-3">
          <span>Logo vorhanden</span>
        </label>
        <label class="flex items-center">
          <input type="checkbox" x-model="form.inputs.hasImages" class="mr-3">
          <span>Bilder vorhanden</span>
        </label>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Notizen</label>
          <textarea x-model="form.inputs.notes" rows="3"
                    class="w-full px-3 py-2 border rounded focus:ring-2 focus:ring-blue-500"
                    placeholder="Besondere Anforderungen, Links zu Referenzen, etc."></textarea>
        </div>
      </div>
    </div>

    <!-- Navigation Buttons -->
    <div class="flex justify-between mt-8 pt-4 border-t">
      <button
        x-show="step > 0"
        @click="step--"
        class="px-4 py-2 text-gray-600 hover:text-gray-800">
        ← Zurück
      </button>
      <div x-show="step === 0"></div>

      <button
        x-show="step < 3"
        @click="step++"
        class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
        Weiter →
      </button>

      <button
        x-show="step === 3"
        @click="generatePrompt()"
        class="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700">
        Prompt generieren
      </button>
    </div>

    <!-- Generated Prompt Modal -->
    <div x-show="showPrompt" x-cloak
         class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4">
      <div class="bg-white rounded-lg shadow-xl max-w-4xl w-full max-h-[90vh] overflow-hidden">
        <div class="flex justify-between items-center p-4 border-b">
          <h3 class="text-lg font-semibold">Claude Code Prompt</h3>
          <button @click="showPrompt = false" class="text-gray-500 hover:text-gray-700">✕</button>
        </div>
        <div class="p-4 overflow-auto max-h-[70vh]">
          <pre class="bg-gray-900 text-gray-100 p-4 rounded text-sm whitespace-pre-wrap" x-text="generatedPrompt"></pre>
        </div>
        <div class="flex justify-end gap-2 p-4 border-t">
          <button @click="copyPrompt()" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
            In Zwischenablage kopieren
          </button>
          <button @click="showPrompt = false" class="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300">
            Schließen
          </button>
        </div>
      </div>
    </div>
  </div>

  <script is:inline>
    function newProjectWizard() {
      return {
        step: 0,
        steps: ['Basis', 'Kontakt', 'Features', 'Inputs'],
        showPrompt: false,
        generatedPrompt: '',
        form: {
          companyName: '',
          industry: '',
          location: '',
          email: '',
          phone: '',
          website: '',
          address: { street: '', zip: '', city: '' },
          features: {
            contactForm: true,
            cookieBanner: true,
            metaPixel: false,
            googleAnalytics: false
          },
          inputs: {
            hasStitchExport: false,
            hasLogo: false,
            hasImages: false,
            notes: ''
          }
        },

        async generatePrompt() {
          const response = await fetch('/api/generate-prompt', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(this.form)
          });
          const data = await response.json();
          this.generatedPrompt = data.prompt;
          this.showPrompt = true;
        },

        copyPrompt() {
          navigator.clipboard.writeText(this.generatedPrompt);
          alert('Prompt kopiert!');
        }
      };
    }
  </script>
</DashboardLayout>
```

---

## 9. DEPLOYMENT

### 9.1 Astro Config

```javascript
// astro.config.mjs
import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';
import node from '@astrojs/node';

export default defineConfig({
  output: 'server',
  adapter: node({ mode: 'standalone' }),
  vite: {
    plugins: [tailwindcss()]
  }
});
```

### 9.2 PM2 Ecosystem

```javascript
// ecosystem.config.cjs
module.exports = {
  apps: [{
    name: 'lisn-dashboard',
    script: './dist/server/entry.mjs',
    cwd: '/var/www/staging/_dashboard',
    env: {
      NODE_ENV: 'production',
      HOST: '127.0.0.1',
      PORT: 4400
    },
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '200M'
  }]
};
```

### 9.3 Nginx Config

```nginx
# /etc/nginx/sites-available/dashboard.lisn-agentur.com

server {
    server_name dashboard.lisn-agentur.com;

    location / {
        proxy_pass http://127.0.0.1:4400;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    listen 443 ssl http2;
    ssl_certificate /etc/letsencrypt/live/dashboard.lisn-agentur.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/dashboard.lisn-agentur.com/privkey.pem;
}

server {
    listen 80;
    server_name dashboard.lisn-agentur.com;
    return 301 https://$server_name$request_uri;
}
```

### 9.4 Environment Variables

```env
# /var/www/staging/_dashboard/.env
DASHBOARD_PASSWORD=sicheres-passwort-hier
```

---

## 10. IMPLEMENTIERUNGS-REIHENFOLGE

### Phase 1: Grundgerüst (30-45 min)
- [ ] Astro-Projekt erstellen in `/var/www/staging/_dashboard/`
- [ ] Dependencies: `@astrojs/node`, `tailwindcss`
- [ ] Basis-Layout erstellen
- [ ] lib/projects.ts implementieren (Projekt-Scanner)
- [ ] Index-Seite mit Projekt-Liste

### Phase 2: PM2 Integration (30 min)
- [ ] lib/pm2.ts implementieren
- [ ] API Endpoints: status, restart
- [ ] Status-Badges in ProjectCard
- [ ] Restart-Button funktional

### Phase 3: Neues Projekt Wizard (45 min)
- [ ] new.astro mit Multi-Step Form
- [ ] lib/prompt-generator.ts
- [ ] API Endpoint: generate-prompt
- [ ] Prompt-Modal mit Copy-Funktion

### Phase 4: Projekt-Details (30 min)
- [ ] projects/[slug].astro
- [ ] Config-Anzeige
- [ ] Env-Keys Anzeige
- [ ] Logs-Viewer (Modal)

### Phase 5: Auth & Deploy (30 min)
- [ ] Login-Seite
- [ ] Auth Middleware
- [ ] PM2 Ecosystem Config
- [ ] Nginx Config
- [ ] SSL einrichten

### Phase 6: Polish (optional)
- [ ] Server-Stats (CPU, RAM, Disk)
- [ ] Rebuild-Funktion
- [ ] Error Handling verbessern
- [ ] Dark Mode

---

## 11. SICHERHEIT

### 11.1 Authentication
- Einfaches Passwort-Login (für V1 ausreichend)
- Session-Token in Cookie
- 24h Gültigkeit

### 11.2 Input Validation
- Alle API-Inputs validieren
- Keine Shell-Injection möglich (nur vordefinierte Commands)
- Slugs sanitizen

### 11.3 Access Control
- Dashboard nur über HTTPS
- Kein Zugriff auf .env Werte (nur Keys)
- PM2 Commands nur für existierende Projekte

---

## 12. ZUKÜNFTIGE ERWEITERUNGEN (V2+)

- [ ] Multi-User mit Rollen
- [ ] Projekt-Templates auswählen
- [ ] Direktes File-Upload für Inputs
- [ ] Automated Testing (Lighthouse)
- [ ] Deployment-Logs History
- [ ] Webhook für GitHub Integration
- [ ] Mobile-optimierte Version

---

## ANHANG: Quick Reference Commands

```bash
# Dashboard starten (nach Implementation)
cd /var/www/staging/_dashboard
pnpm build
pm2 start ecosystem.config.cjs

# Dashboard neustarten
pm2 restart lisn-dashboard

# Logs anzeigen
pm2 logs lisn-dashboard

# Nginx aktivieren
ln -s /etc/nginx/sites-available/dashboard.lisn-agentur.com /etc/nginx/sites-enabled/
nginx -t && systemctl reload nginx

# SSL einrichten
certbot --nginx -d dashboard.lisn-agentur.com
```

---

**Dokument-Ende**

*Bei Fragen oder nach Context-Compaction: Dieses Dokument enthält alle Informationen zur Implementierung des LISN Dashboards. Starte mit Phase 1 und arbeite sequentiell durch.*
