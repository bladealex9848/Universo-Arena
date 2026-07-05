# 🆕 Cuarta tanda — 3 entradas nuevas (2026-07-05)

Registro de la ampliación del benchmark de **20 → 23 entradas**. Se integraron tres
combinaciones que estaban sin fusionar y se re-rankeó el conjunto completo,
manteniendo la misma metodología (rúbrica + ejecución real + verificación).

> Nota: `Mimo-V2.5-Pro-MimoCode` (95, #6) ya se había integrado antes de esta tanda
> (paso de 19 → 20); las tres de abajo son las que faltaban por fusionar.

## Las tres nuevas

| Carpeta | Modelo | Agente | Nota | Tier | Puesto |
|:--|:--|:--|:--:|:--:|:--:|
| `Fable-5-Claude-Code-Ultracode` | Claude Fable 5 | **Ultracode + Claude Code** | **95** | S | #7 |
| `Mimo-V2.5-Pro-Claude-Code` | MiMo v2.5 Pro | **Claude Code** | **90** | S | #10 |
| `Mimo-V2.5-Pro-OpenCode` | MiMo v2.5 Pro | **OpenCode** | **89** | A | #14 |

Las tres aciertan los dos puntos críticos del reto (cola del cometa **opuesta al
Sol** y órbitas **elípticas con el Sol en el foco**) y usan **instancing** real
para el cinturón de asteroides. Las tres arrancan con **0 errores de consola**.

## Datos de ejecución real (Chrome headless)

| Carpeta | Objetos en escena | Errores consola | WebGL |
|:--|:--:|:--:|:--:|
| `Fable-5-Claude-Code-Ultracode` | 310 | 0 | ✓ |
| `Mimo-V2.5-Pro-Claude-Code` | 260 | 0 | ✓ |
| `Mimo-V2.5-Pro-OpenCode` | 263 | 0 | ✓ |

## Calibración: estricta y sin destronar el podio

Como en la 3.ª tanda, los jurados se instruyeron **estrictos y calibrados desde el
inicio**, conociendo el campo (97/95/92/89/88/86…). Sus notas quedaron confirmadas
por la ejecución real (310/260/263 objetos, 0 errores) sin contradicciones que
obligaran a corregir. El empate de cabeza (97) de GPT-5.5/Codex y Opus 4.8/Ultracode
se mantiene intacto: ninguna nota nueva lo alcanza.

- **Fable 5 · Ultracode (95).** La entrega con **mejor mecánica orbital de todo el
  campo**: resuelve la ecuación de Kepler `M = E − e·sinE` por Newton-Raphson, con
  aceleración real en el perihelio (2.ª ley) y movimiento medio ∝ a^-1.5 (3.ª ley),
  algo que ni siquiera los líderes de 97 implementan. Cola del cometa a prueba de la
  trampa (`normalizeToNew()`, que **no muta**). No alcanza el 97 porque las vistas de
  cámara de seguimiento (Tierra, Saturno, Halley) solo reencuadran pero **no hacen
  zoom**, y el spec pedía acercarse. Empata la cohorte de 95, no la supera.
- **MiMo v2.5 Pro · Claude Code (90).** S en el límite inferior: ambas trampas limpias
  (cola con `.clone()` para no mutar), 9 planetas, 220 asteroides con instancing,
  3200 estrellas y código muy limpio. Le resta el pulido estético (colores planos,
  sin texturas planetarias reales) y un bug menor de zoom en las vistas de seguimiento.
- **MiMo v2.5 Pro · OpenCode (89).** A en el techo del tier: correcto en los dos
  detalles difíciles y con panel completo, pero un **aro de Saturno con bloom
  excesivo** domina la captura real y resta en estética/wow.

## Hallazgo: MiMo v2.5 Pro, tres agentes, tres resultados

Con esta tanda, **MiMo v2.5 Pro** queda representado por **tres** combinaciones, y de
nuevo el andamiaje del agente decide dónde cae la misma base:

| Agente | Nota | Tier |
|:--|:--:|:--:|
| MiMoCode | **95** | S |
| Claude Code | **90** | S |
| OpenCode | **89** | A |

MiMoCode (el agente propio del modelo) saca la mejor versión —texturas procedurales
de Tierra y Júpiter, más pulido— mientras que las otras dos, correctas en la física,
se quedan cortas en estética. Consistente con la lección central del benchmark: el
agente pesa tanto como el modelo.

## Artefactos regenerados

Tras editar la fuente de verdad [`../assets/benchmark.json`](../assets/benchmark.json)
(23 entradas) se regeneraron, derivándolos de ella:

- **Web principal** [`../index.html`](../index.html): 23 fichas, podio, radares;
  contadores dinámicos (23 entregas · 21/23 sin errores · media 87); JSON-LD
  (`ItemList` de 23, `numberOfItems`) y metas a "23 combinaciones".
- [`../assets/runtime.json`](../assets/runtime.json) y 3 capturas en `assets/previews/`.
- [`../README.md`](../README.md): tablas (ranking, categorías, matriz) y badges (23, 21/23).
- [`results.md`](results.md) (23 fichas), [`conclusions.md`](conclusions.md),
  [`methodology.md`](methodology.md).
- SEO/GEO: `sitemap.xml` (23 demos), `llms.txt` y `llms-full.txt` (ranking + contadores).

## Cómo reproducir / añadir más

Mismo flujo de [`harness.md`](harness.md), [`contributing.md`](contributing.md) y las
tandas anteriores ([2.ª](segunda-tanda-2026-06-17.md), [3.ª](tercera-tanda-2026-06-18.md)):
capturar en Chrome headless → puntuar con la [`rúbrica`](rubric.md) → **verificar
contra el runtime** → fusionar en `benchmark.json` → regenerar artefactos derivados
(incluida la **re-inyección** de los datos en `index.html`).
