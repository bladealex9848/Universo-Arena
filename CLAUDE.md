# CLAUDE.md

Guidance for Claude Code (and other agents) working in this repository.

## What this repo is

**Universo-Arena** is an open benchmark: many combinations of **LLM + coding agent** each implement the *same* prompt — a 3D Solar System simulation in BabylonJS, as a single self-contained `index.html` — and are scored and ranked. The repo also contains a showcase website and full documentation of the benchmark.

- The challenge: [`Prompt-Maestro_v2.txt`](Prompt-Maestro_v2.txt).
- Each entry lives in its own folder; **the folder name encodes the model and agent used** (e.g. `Opus-4.8-Claude-Code`, `codex-gpt-5.5`, `mini-agent-MiniMax-M3`).

## Repository layout

```
Universo-Arena/
├── index.html                  # showcase gallery (data embedded; works on file://)
├── README.md                   # benchmark summary + ranking tables (data-driven)
├── CHANGELOG.md                # Keep a Changelog format
├── CLAUDE.md                   # this file
├── LICENSE                     # MIT
├── Prompt-Maestro_v2.txt       # the challenge every entry implements
├── assets/
│   ├── benchmark.json          # SINGLE SOURCE OF TRUTH for the ranking
│   ├── runtime.json            # objective runtime data (meshes, console errors, webgl)
│   ├── universo_arena_banner.png
│   └── previews/<folder>.png   # real screenshot per entry
├── docs/                       # methodology, rubric, results, harness, conclusions, contributing
└── <Modelo>-<Agente>/index.html   # one folder per benchmark entry
```

## Conventions (important)

- **Language:** all user-facing text, comments and docs are in **Spanish**.
- **Folder naming = the entry's identity.** Format `<Modelo>-<Agente>`. Don't rename without updating `benchmark.json`, previews and links.
- **Each entry is ONE self-contained `index.html`** (HTML+CSS+JS, BabylonJS via CDN). No local assets, no server, opens with double-click. **Original work per folder** — never copy one entry into another.
- **The showcase `index.html` embeds data inline** (a `const DATA = [...]`), NOT via `fetch`. This is deliberate: `fetch` of a local JSON fails under `file://` (CORS). After editing `assets/benchmark.json`, you MUST re-inject it into `index.html` (replace the `DATA` array).
- **`assets/benchmark.json` is the source of truth.** README tables, `docs/results.md` and the gallery all derive from it. Regenerate downstream artifacts when it changes.
- **Previews are committed** so the gallery looks complete offline; only the live demos need internet (CDN).
- Avoid global-name collisions in the gallery JS (e.g. don't declare `const top`/`const name` at top level — they clash with `window.*`).

## The "regla absoluta" when authoring a new simulation

Before writing BabylonJS code, **consult the official docs** (Context7 library id `/babylonjs/documentation`) and do not invent APIs. In this benchmark, invented APIs (`emissionRange`, `mesh.diameter`) were the direct cause of visible bugs. The two correctness traps that decide the ranking:

1. **Sun at the ellipse focus**, not the center: `x = a·cosθ − a·e`, `z = b·sinθ`, `b = a·√(1−e²)`.
2. **Comet tail points AWAY from the Sun** (`cometa − Sol`), recalculated each frame. Watch out for `Vector3.normalize()` mutating in place.

## How to verify / regenerate

- **Verify a single sim:** `open "<folder>/index.html"` (macOS) and check the browser console.
- **Regenerate screenshots + runtime data:** see [`docs/harness.md`](docs/harness.md) (Puppeteer + system Chrome, headless WebGL via SwiftShader). Outputs `assets/previews/*.png` and `assets/runtime.json`.
- **After changing `benchmark.json`:** regenerate README tables + `docs/results.md`, and re-inject the JSON into the root `index.html`.
- **Add a new entry:** follow [`docs/contributing.md`](docs/contributing.md).

## Build / runtime

There is **no build step and no runtime dependencies** for the site — it's vanilla HTML/CSS/JS using modern browser features. The only tooling is the optional benchmark harness (Node + Puppeteer) used to capture screenshots; that lives in a temp dir, not in the repo.

## Git

- The project is published at `github.com/bladealex9848/Universo-Arena`; history is on `main`.
- Commit/push only when the user asks. End commit messages with the required `Co-Authored-By` trailer.
- **Despliegue y CD:** El sitio web se expone en `https://universo-arena.alexanderoviedofadul.dev`. Cuenta con un auto-despliegue continuo (CD) mediante un webhook en Node.js que escucha en el puerto `3020` del VPS y actualiza automáticamente los archivos locales en la rama `main` tras recibir el evento push de GitHub.
