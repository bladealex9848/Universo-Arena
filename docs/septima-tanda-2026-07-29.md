# 🆕 Séptima tanda — Kimi K3 (Claude Code y OpenCode) (2026-07-29)

Registro de la ampliación del benchmark de **26 → 28 entradas**. Se integran las dos
combinaciones nuevas de **Kimi K3** —con Claude Code y con OpenCode—, generadas con la
misma metodología de siempre (rúbrica + ejecución real + verificación contra runtime).

## Las dos nuevas

| Carpeta | Modelo | Agente | Nota | Tier | Puesto |
|:--|:--|:--|:--:|:--:|:--:|
| `Kimi-K3-Claude-Code` | Kimi K3 | **Claude Code** | **92** | S | #11 |
| `Kimi-K3-Open-Code` | Kimi K3 | **OpenCode** | **87** | A | #20 |

Ambas resuelven los **dos puntos críticos** del reto —cola del cometa **opuesta al Sol**
(vector `cometa − Sol` recalculado cada frame, sin `.negate()`/`.scale(-1)` ni mutación
in-place) y órbitas **elípticas con el Sol en el foco** (`x = a·cosθ − a·e`,
`b = a·√(1−e²)`)— usan **instancing** real para el cinturón y arrancan con **0 errores
de consola**. El triple empate de cabeza (97: GPT-5.5 · Codex, Opus 4.8 · Ultracode y
Opus 5 · Ultracode) queda intacto.

## Datos de ejecución real (Chrome headless, SwiftShader)

| Carpeta | Objetos en escena | Errores consola | WebGL |
|:--|:--:|:--:|:--:|
| `Kimi-K3-Claude-Code` | 279 | 0 | ✓ |
| `Kimi-K3-Open-Code` | 302 | 0 | ✓ |

## Calibración: estricta, con el tercer discriminador en juego

Un jurado por entrega leyó el `index.html` completo verificando el **código real** y un
juez calibrador cerró las notas contra la ejecución, con el campo a la vista (triple 97
… hasta 54) y sin anclar a las viejas Kimi K2.7.

- **Kimi K3 · Claude Code (92, S).** Ambas trampas limpias —Sol en el foco en
  `posicionOrbita` (aplicado a planetas, órbitas y cometa) y cola anti-solar con
  `normalizeToNew()` sin mutación—, instancing real (`createInstance`), post-procesado
  completo (bloom + GlowLayer + ACES) y panel de 4 secciones cableado, todo con código
  muy limpio y texturas procedurales ricas (bandas de Júpiter, Gran Mancha Roja,
  casquetes). No llega más arriba por el **tercer discriminador** —posible desajuste del
  sentido de giro en el sistema levógiro de Babylon (revolución vs. rotación propia)—,
  asteroides en círculos puros y avance angular uniforme (2.ª ley no modelada).
- **Kimi K3 · OpenCode (87, A).** También acierta las dos trampas y usa instancing, pero
  se le descuenta más: el **sentido de giro queda invertido de forma confirmada**
  (`z = −b·sin` con `rotation.y −=` dejan revolución y rotación propias opuestas, y el
  comentario que lo justifica es erróneo), y un `normalizeToNew(tmpDir)` **mal invocado**
  deja la cola sin normalizar (descontrola su magnitud, aunque no invierte la dirección).

## Hallazgo: Kimi salta de tier B a S/A en una generación

Las dos combinaciones previas de **Kimi K2.7** se quedaron en el **tier B** (80 y 79).
Kimi **K3** sube con claridad:

| Modelo | Mejor agente | Nota | Tier |
|:--|:--|:--:|:--:|
| Kimi K2.7 | Claude Code | 80 | B |
| **Kimi K3** | **Claude Code** | **92** | **S** |
| **Kimi K3** | **OpenCode** | **87** | **A** |

Un salto generacional nítido —resolver las dos trampas nucleares y usar instancing— que
mueve al modelo de "funciona con bugs" a "fiel en los detalles difíciles". Y, de nuevo,
el **agente pesa**: la misma base K3 rinde 92 con Claude Code y 87 con OpenCode
(la diferencia la marcan el sentido de giro y la magnitud de la cola).

## Artefactos regenerados

Tras editar la fuente de verdad [`../assets/benchmark.json`](../assets/benchmark.json)
(28 entradas) se regeneraron, derivándolos de ella:

- **Web principal** [`../index.html`](../index.html): 28 fichas, podio, radares;
  contadores dinámicos (28 entregas · 26/28 sin errores · media 88); bloque "estado del
  arte" (28/28 · 26/28); JSON-LD (`ItemList` de 28, `numberOfItems`) y metas a "28
  combinaciones".
- [`../assets/runtime.json`](../assets/runtime.json) y 2 capturas en `assets/previews/`.
- [`../README.md`](../README.md): tablas (ranking, categorías, matriz) y badges (28, 26/28).
- [`results.md`](results.md) (28 fichas), [`conclusions.md`](conclusions.md),
  [`methodology.md`](methodology.md).
- SEO/GEO: `sitemap.xml` (28 demos), `llms.txt` y `llms-full.txt`.

## Cómo reproducir / añadir más

Mismo flujo de [`harness.md`](harness.md), [`contributing.md`](contributing.md) y las
tandas anteriores ([2.ª](segunda-tanda-2026-06-17.md), [3.ª](tercera-tanda-2026-06-18.md),
[4.ª](cuarta-tanda-2026-07-05.md), [5.ª](quinta-tanda-2026-07-23.md),
[6.ª](sexta-tanda-2026-07-27.md)): capturar en Chrome headless → puntuar con la
[`rúbrica`](rubric.md) → **verificar contra el runtime** → fusionar en `benchmark.json`
→ regenerar los artefactos derivados (incluida la **re-inyección** de los datos en
`index.html` y el bloque "estado del arte", que es hardcodeado).
