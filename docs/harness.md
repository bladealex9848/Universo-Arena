# ⚙️ El arnés del benchmark

Cómo se generaron las notas, las capturas y la galería, y cómo reproducirlo.

## Visión general

```
                    ┌─────────────────────────────┐
   14 carpetas      │  1) Captura + runtime (Chrome│  → assets/previews/*.png
   <Modelo-Agente>/ │     headless, WebGL)         │  → assets/runtime.json
   index.html  ─────┤                              │
                    │  2) Jurado por entrega (LLM) │  → 14 scorecards
                    │     en paralelo              │
                    │                              │
                    │  3) Calibración + corrección │  → ranking normalizado
                    │     por runtime              │
                    └─────────────────────────────┘
                                 │
                                 ▼
              assets/benchmark.json  →  README.md + index.html (galería) + docs/
```

## 1) Captura de pantalla + datos de ejecución

Un script de **Puppeteer (puppeteer-core) sobre el Chrome del sistema** abre cada `index.html` vía `file://`, espera a que la escena se construya (red ociosa + margen para varios frames de WebGL) y registra:

- `screenshot` → `assets/previews/<carpeta>.png`
- `scene.meshes.length`, `engine.getFps()`, disponibilidad de `webgl`/`BABYLON`
- **errores de consola** (`console` tipo error) y **excepciones** (`pageerror`)

WebGL en headless se habilita con `--use-angle=swiftshader --enable-unsafe-swiftshader --ignore-gpu-blocklist`. SwiftShader es renderizado por software: **lento pero suficiente** para producir capturas reales y verificar que la escena arranca sin errores. Salida agregada en [`../assets/runtime.json`](../assets/runtime.json).

## 2) Jurado por entrega (en paralelo)

Un subagente-jurado por carpeta lee el spec y el `index.html` completo y emite un **scorecard estructurado** (las 10 categorías de la [rúbrica](rubric.md) + matriz de features + fortalezas/debilidades + veredicto + riesgo de errores). Se ejecutan en paralelo (un *pipeline* multi-agente).

## 3) Calibración + corrección por runtime

Un juez final:

1. **Normaliza** las notas entre jurados (corrige durezas dispares).
2. Identifica modelo y agente desde el nombre de carpeta.
3. Produce el **ranking** con tier y resumen por entrada.

Donde la revisión estática contradijo la ejecución real (caso GLM-5.2), se lanzó una **re-evaluación dirigida** con el contexto objetivo de runtime, y mandó la ejecución. El resultado consolidado se fusiona con `runtime.json` en [`../assets/benchmark.json`](../assets/benchmark.json), que alimenta tanto el README como la galería.

## Artefactos generados

| Artefacto | Origen | Uso |
|:--|:--|:--|
| `assets/previews/*.png` | Paso 1 | Miniaturas de la galería y banner |
| `assets/runtime.json` | Paso 1 | Señal objetiva (objetos, errores, WebGL) |
| `assets/benchmark.json` | Pasos 2–3 + merge | Fuente única de verdad del ranking |
| `index.html` (raíz) | `benchmark.json` embebido | Galería interactiva |
| `README.md` / `docs/results.md` | `benchmark.json` | Tablas y fichas |

## Reproducir las capturas

Requiere Node.js y Google Chrome instalado (macOS).

```bash
mkdir -p /tmp/shotter && cd /tmp/shotter
npm init -y && npm i puppeteer-core
# colocar el script de captura (abre cada carpeta/index.html, espera y hace screenshot)
node shoot.js   # escribe assets/previews/*.png y assets/runtime.json
```

> La galería embebe los datos directamente en `index.html` (no usa `fetch`) para funcionar abierta como `file://` sin caer en restricciones CORS de los navegadores. Por eso, al regenerar `benchmark.json`, hay que **re-inyectar** los datos en el `index.html`.

## Notas de diseño

- **Sin build, sin dependencias de runtime en la web:** la galería es HTML/CSS/JS vanilla con técnicas modernas (gradientes cónicos, `backdrop-filter`, radar en SVG, `IntersectionObserver`).
- **Capturas versionadas:** se commitean para que la galería se vea completa **sin conexión**; solo las *demos en vivo* requieren internet (BabylonJS por CDN).
