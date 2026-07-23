# 🆕 Quinta tanda — 2 entradas nuevas (2026-07-23)

Registro de la ampliación del benchmark de **23 → 25 entradas**. Se integraron las
dos combinaciones **Gemini 3.6 Flash** que estaban sin fusionar y se re-rankeó el
conjunto completo, con la misma metodología (rúbrica + ejecución real + verificación).

> Nota extra de higiene: en esta tanda se regeneró además el preview faltante de
> `Mimo-V2.5-Pro-MimoCode` (#6), cuyo PNG nunca se había commiteado pese a estar en
> el ranking; su nota y datos no cambian.

## Las dos nuevas

| Carpeta | Modelo | Agente | Nota | Tier | Puesto |
|:--|:--|:--|:--:|:--:|:--:|
| `Antigravity-Gemini-3.6-Flash-High` | Gemini 3.6 Flash (High) | **Antigravity** | **89** | A | #15 |
| `Agy-Gemini-3.6-Flash-Antigravity-CLI` | Gemini 3.6 Flash | **Antigravity CLI** | **85** | A | #19 |

Las dos aciertan los **dos puntos críticos** del reto (cola del cometa **opuesta al
Sol**, sin mutación in-place, y órbitas **elípticas con el Sol en el foco**:
`x = a·cosθ − a·e`, `b = a·√(1−e²)`) y arrancan con **0 errores de consola**.

## Datos de ejecución real (Chrome headless, SwiftShader)

| Carpeta | Objetos en escena | Errores consola | WebGL |
|:--|:--:|:--:|:--:|
| `Antigravity-Gemini-3.6-Flash-High` | 259 | 0 | ✓ |
| `Agy-Gemini-3.6-Flash-Antigravity-CLI` | 320 | 0 | ✓ |
| `Mimo-V2.5-Pro-MimoCode` (preview regenerado) | 278 | 0 | ✓ |

## Calibración: estricta y sin destronar el podio

Como en tandas anteriores, los jurados se instruyeron **estrictos y calibrados desde
el inicio**, conociendo el campo (97/95/92/89/…) y con los datos de runtime a la vista.
Un jurado por entrega leyó el `index.html` completo verificando el **código real**, y
un juez calibrador cerró las notas contra la ejecución. El empate de cabeza (97) de
GPT-5.5/Codex y Opus 4.8/Ultracode se mantiene intacto: ninguna nota nueva lo alcanza.

- **Gemini 3.6 Flash (High) · Antigravity (89, A).** Escena completa (259 mallas, 0
  errores) con ambas trampas resueltas —Sol en el foco (`b=a·√(1−e²)`, `x=a·cosθ−a·e`)
  en órbita y animación, y cola del cometa opuesta al Sol sin mutación (vector nuevo
  `cometa−Sol` por frame)— más post-procesado real y panel de 4 secciones íntegro.
  Se queda **por debajo de su hermana 3.5-High (92, S)** sobre todo porque **NO usa
  instancing**: los 220 asteroides son mallas por-asteroide (`CreateSphere` en bucle),
  lo que rebaja rendimiento, sumado a una velocidad orbital tuneada a mano en vez de
  Kepler estricto.
- **Gemini 3.6 Flash · Antigravity CLI (85, A).** La entrega más rica del par (320
  mallas, la mayor cuenta del campo) y **con instancing real** (`createInstance`, 280
  instancias), ambas trampas limpias, deltaTime y Kepler inverso a la distancia, panel
  completísimo (13 controles cableados). Pierde en **estética** por un detractor real y
  visible en la ejecución: **parches blancos** tras las etiquetas de planetas (el plano
  billboard de label no resuelve bien el alpha del fondo), más pequeñas ineficiencias
  de asignaciones por frame. Queda **por debajo de su hermana 3.5-Flash (89, A)**.

## Hallazgo: Gemini 3.6 Flash no supera a Gemini 3.5

Con esta tanda, **Gemini 3.6 Flash** queda representado por dos combinaciones y en
**ambas cae por debajo de su predecesora 3.5** con el mismo andamiaje:

| Agente | Gemini 3.5 | Gemini 3.6 Flash | Δ |
|:--|:--:|:--:|:--:|
| Antigravity (High) | **92** (S) | **89** (A) | −3 |
| Antigravity CLI (Flash) | **89** (A) | **85** (A) | −4 |

Un recordatorio de que "modelo más nuevo" no implica "mejor entrega": aquí la variante
**Flash** (más rápida/pequeña) no alcanza a la generación anterior en este reto, y el
andamiaje del agente sigue pesando tanto como el modelo (misma lección central del
benchmark). Ninguna de las dos toca el empate de cabeza (97).

## Artefactos regenerados

Tras editar la fuente de verdad [`../assets/benchmark.json`](../assets/benchmark.json)
(25 entradas) se regeneraron, derivándolos de ella:

- **Web principal** [`../index.html`](../index.html): 25 fichas, podio, radares;
  contadores dinámicos (25 entregas · 23/25 sin errores · media 87); JSON-LD
  (`ItemList` de 25, `numberOfItems`) y metas a "25 combinaciones".
- [`../assets/runtime.json`](../assets/runtime.json) y 3 capturas en `assets/previews/`
  (las 2 nuevas + el preview faltante de `Mimo-V2.5-Pro-MimoCode`).
- [`../README.md`](../README.md): tablas (ranking, categorías, matriz) y badges (25, 23/25).
- [`results.md`](results.md) (25 fichas), [`conclusions.md`](conclusions.md),
  [`methodology.md`](methodology.md).
- SEO/GEO: `sitemap.xml` (25 demos), `llms.txt` y `llms-full.txt` (ranking + contadores).

## Cómo reproducir / añadir más

Mismo flujo de [`harness.md`](harness.md), [`contributing.md`](contributing.md) y las
tandas anteriores ([2.ª](segunda-tanda-2026-06-17.md), [3.ª](tercera-tanda-2026-06-18.md),
[4.ª](cuarta-tanda-2026-07-05.md)): capturar en Chrome headless → puntuar con la
[`rúbrica`](rubric.md) → **verificar contra el runtime** → fusionar en `benchmark.json`
→ regenerar artefactos derivados (incluida la **re-inyección** de los datos en `index.html`).
