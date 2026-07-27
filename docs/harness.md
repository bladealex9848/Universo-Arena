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

### Señales adicionales (desde la 6.ª tanda)

Al `evaluate()` del arnés se le añadieron medidas que permiten **verificar
afirmaciones concretas** en vez de creerlas:

| Señal | Para qué |
|:--|:--|
| `scene.meshes.filter(getClassName() === "InstancedMesh").length` | Comprueba que el *instancing* del cinturón es real, no un comentario |
| Suma de `getActiveCount()` de todos los `particleSystems` | Verifica que las "3000+ estrellas" existen de verdad |
| `materials.length`, `textures.length`, `lights.length` | Detecta escenas infladas o materiales duplicados |
| `requestfailed` del navegador | Delata assets remotos que no cargan (ninguna entrega debería depender de ellos) |
| `BABYLON.Engine.Version` | Fija la versión real del CDN con la que se midió |
| **Producto escalar** entre `direction1` de la cola y `(cometa − Sol)` normalizado | Convierte la trampa nº 2 del reto en un **número comprobable**: 1.000 = cola exactamente anti-solar |

```js
const cometa = sc.meshes.find((m) => /halley|cometa/i.test(m.name));
const antiSolar = cometa.getAbsolutePosition().normalizeToNew();   // el Sol está en el origen
const dot = BABYLON.Vector3.Dot(colaIones.direction1.normalizeToNew(), antiSolar);
```

### Verificación del panel y de las vistas

Un segundo script conduce la UI con Puppeteer y comprueba **efectos, no
apariencias**: selecciona las 6 vistas de cámara y lee `camera.radius`,
`camera.target` y la etiqueta del panel; acciona los 6 interruptores y comprueba
`isEnabled()` de la malla correspondiente y `isStarted()` de cada sistema de
partículas; pulsa *Pausar* y verifica que la posición de la Tierra **deja de
cambiar**; apaga el bloom y lee `pipeline.bloomEnabled` y `glowLayer.isEnabled`;
mueve el slider de tamaño y lee `mesh.scaling`. También se abre la página a
**390×844** para comprobar que el panel responsive no desborda.

### Sondas de API

Antes de escribir código, un tercer script carga BabylonJS del CDN en Chrome
headless y hace **introspección** (`typeof`, `in`, constantes) sobre `Engine`,
`Scene`, `ArcRotateCamera`, `ParticleSystem`, `GlowLayer`,
`DefaultRenderingPipeline`, `DynamicTexture`, `Vector3` y `Color3`. Es lo que
permitió afirmar con evidencia —y no por costumbre— que
`ParticleHelper.CreateSystem` no existe, que `Vector3.normalize()` muta el
receptor o que una rotación positiva sobre Y lleva **+X → −Z** en el sistema
levógiro de Babylon.

## 2) Jurado por entrega (en paralelo)

Un subagente-jurado por carpeta lee el spec y el `index.html` completo y emite un **scorecard estructurado** (las 10 categorías de la [rúbrica](rubric.md) + matriz de features + fortalezas/debilidades + veredicto + riesgo de errores). Se ejecutan en paralelo (un *pipeline* multi-agente).

### Auditoría adversarial (desde la 6.ª tanda)

Para las entregas producidas dentro del propio repositorio se intercala una fase
extra entre el jurado y la calibración: **auditores por dimensión** (spec, API,
física, rendimiento, calidad) y **un escéptico por hallazgo** encargado de
refutarlo con código literal. Solo se corrige lo que sobrevive al intento de
refutación. Ver [`methodology.md`](methodology.md#ampliación-del-método-desde-la-6ª-tanda-2026-07-27).

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
