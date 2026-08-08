# 🆕 Novena tanda — DeepSeek V4 Flash y Claude Opus 4.6 (2026-08-07)

Registro de la ampliación del benchmark de **29 → 31 entradas**. Se integran dos
combinaciones nuevas con la metodología de siempre (rúbrica + ejecución real +
verificación), y esta tanda deja **dos lecciones de calibración** de manual.

## Las dos nuevas

| Carpeta | Modelo | Agente | Nota | Tier | Puesto |
|:--|:--|:--|:--:|:--:|:--:|
| `Opencode-DeepSeek-V4-Flash` | DeepSeek V4 Flash | **OpenCode** | **92** | S | #12 |
| `Antigravity-Claude-Opus-4.6` | Claude Opus 4.6 | **Antigravity** | **78** | B | #29 |

## Datos de ejecución real (Chrome headless, SwiftShader)

| Carpeta | Objetos | Errores consola | WebGL |
|:--|:--:|:--:|:--:|
| `Opencode-DeepSeek-V4-Flash` | 281 | 0 | ✓ |
| `Antigravity-Claude-Opus-4.6` | 295 | 0 | ✓ |

## DeepSeek V4 Flash · OpenCode — 92 (re-verificado de 96)

Esta entrada llegó **pre-puntuada en 96 (#4)**, lo que la habría colocado por encima de
los **siete 95 ya calibrados**. Por la regla de la casa —*no dejar que una nota sin
calibrar adelante a los líderes calibrados*— se **re-verificó con jurado**.

Lo que el jurado **confirmó como cierto** (no exagerado):

- **Ambas trampas correctas.** Sol en el foco con la **misma** fórmula para la línea de
  órbita y el movimiento del cuerpo (`x = a·cosθ − a·e`, `z = −b·sinθ`, `b = a·√(1−e²)`),
  y cola del cometa por `(cometa − Sol)` con `normalizeToNew()` sin mutación, recalculada
  cada frame.
- **Tercer discriminador** (sistema levógiro de Babylon): revolución `+X→−Z` coherente con
  la rotación axial por **quaternion**; Venus (tilt ~176°) gira retrógrado de verdad.
- Corona **oficial** `ParticleHelper.CreateAsync("sun")` real con fallback, **3600
  estrellas** en caja 2000³ (emitRate = capacity), 240 asteroides por `createInstance`,
  post-procesado ACES + bloom + GlowLayer.

Lo que el 96 preliminar **pasó por alto** y bajó la nota a **92**:

- **Bug visible:** las etiquetas de nombres se cuelgan del `pivot` en posición local fija y
  **no siguen la posición orbital** del planeta; al cargar se **apilan sobre el Sol**,
  separadas de sus planetas. En corrección iguala a los líderes, pero en un elemento visible
  del spec (los nombres) es **peor** que los siete 95 limpios → queda **por debajo** de los
  95, en el clúster de 92 (#12), no en #4. El sesgo del jurado preliminar (~+4) es el
  documentado en [`methodology.md`](methodology.md).

## Claude Opus 4.6 · Antigravity — 78 (falla las dos trampas)

Entrega **vistosa y muy completa** en UI, estética y post-procesado (295 objetos, 0
errores, 3500 estrellas por SolidParticleSystem, 5 nebulosas, ArcRotate con 6 vistas),
pero **falla los dos discriminadores nucleares**:

- **Foco (fallado).** Los 8 planetas orbitan elipses **centradas en el Sol**
  (`x = a·cosθ`, `z = b·sinθ`, **sin** offset `−c`, líneas 1107-1108) — física falsa.
  Solo el **Halley** aplica el foco correctamente (línea 1342).
- **Cola del cometa (defectuosa).** Usa `halleyMesh.position.normalize()` (línea 1351),
  que **muta la posición del núcleo in-place** (lo reduce a magnitud 1, dentro del Sol) y
  corrompe el cálculo de distancia cada frame. El signo de la cola es correcto, pero el
  núcleo queda corrupto — el anti-patrón exacto que la rúbrica advierte.
- Sin **instancing**: 250 `CreateSphere` individuales (fps 7).

Cae a **78 (tier B)**, por debajo del clúster de 92 y de los 95, pese al panel y el
post-procesado sobresalientes: el acabado visual no compensa fallar el foco y mutar la
posición del cometa.

## Lecciones de la tanda

1. **La re-verificación paga.** Un 96 sin calibrar habría destronado a siete entradas
   calibradas por un detalle visible que el jurado inicial no vio. Medir contra los
   calibrados y buscar el defecto que las distingue mantuvo el ranking honesto.
2. **Modelo grande ≠ detalles físicos resueltos.** Opus 4.6 entrega la escena más pulida
   de su rango pero falla las dos trampas; el foco elíptico y el `normalize()` mutante
   siguen siendo los discriminadores más duros del reto, independientes del tamaño del
   modelo.

## Artefactos regenerados

Tras editar la fuente de verdad [`../assets/benchmark.json`](../assets/benchmark.json)
(31 entradas) se regeneraron, derivándolos de ella:

- **Web principal** [`../index.html`](../index.html): 31 fichas, podio, radares;
  contadores dinámicos (31 entregas · 29/31 sin errores · media 87); bloque "estado del
  arte" (31/31 · 29/31); JSON-LD (`ItemList` de 31) y metas a "31 combinaciones".
- [`../assets/runtime.json`](../assets/runtime.json) y 2 capturas en `assets/previews/`.
- [`../README.md`](../README.md): tablas (ranking, categorías, matriz) y badges (31, 29/31).
- [`results.md`](results.md) (31 fichas), [`conclusions.md`](conclusions.md),
  [`methodology.md`](methodology.md).
- SEO/GEO: `sitemap.xml` (31 demos), `llms.txt` y `llms-full.txt`.

## Cómo reproducir / añadir más

Mismo flujo de [`harness.md`](harness.md), [`contributing.md`](contributing.md) y las
tandas anteriores ([6.ª](sexta-tanda-2026-07-27.md), [7.ª](septima-tanda-2026-07-29.md),
[8.ª](octava-tanda-2026-08-07.md)): capturar en Chrome headless → puntuar con la
[`rúbrica`](rubric.md) → **verificar contra el runtime** (y re-verificar las notas que
adelanten a líderes calibrados) → fusionar en `benchmark.json` → regenerar los artefactos
derivados (incluida la **re-inyección** de los datos en `index.html` y el bloque "estado
del arte", que es hardcodeado).
