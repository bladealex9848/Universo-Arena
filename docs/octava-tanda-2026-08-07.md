# 🆕 Octava tanda — GPT-5.6 Terra · Codex (2026-08-07)

Registro de la ampliación del benchmark de **28 → 29 entradas**. Se integra una
combinación nueva, **GPT-5.6 Terra con Codex** (`codex-gpt-5.6-terra`), con la misma
metodología de siempre (rúbrica + ejecución real + verificación contra runtime).

## La entrada nueva

| Carpeta | Modelo | Agente | Nota | Tier | Puesto |
|:--|:--|:--|:--:|:--:|:--:|
| `codex-gpt-5.6-terra` | GPT-5.6 Terra | **Codex** | **79** | B | #26 |

## Datos de ejecución real (Chrome headless, SwiftShader)

| Señal | Valor |
|:--|:--|
| Mallas en escena | **282** |
| Errores de consola / excepciones | **0 / 0** |
| WebGL · BabylonJS | ✓ · ✓ |
| Instancias de asteroide | 240 (`createInstance`) |
| Cola del cometa vs (cometa − Sol) | **opuesta al Sol** (correcta) |
| Órbitas planetarias con el Sol en el foco | **no** (círculos centrados en el Sol) |

## Por qué tier B: acierta la cola, falla el foco

Es un **caso de manual** de cómo la clasificación depende de las dos trampas, no del
acabado. La entrega es **completa y muy vistosa** —Sol con corona, 9 planetas con
atmósferas y bandas, anillos de Saturno, cinturón de 240 asteroides por `createInstance`,
3200 estrellas, 4 nebulosas, Halley con cola de 1200 partículas, panel de 4 secciones
íntegro, post-procesado con bloom + GlowLayer— y arranca con **0 errores**. Pero:

- **Cola del cometa (correcta).** Órbita polar con el foco en el Sol
  (`r = a·(1−e²)/(1+e·cosθ)`) y `away = halley.position.clone().normalize()` —clona antes
  de normalizar, sin `.negate()`/`.scale(-1)` ni mutación in-place—, recalculada cada
  frame. La cola apunta de verdad en sentido opuesto al Sol.
- **Sol en el foco (fallado).** Los planetas cuelgan de un `pivot` en el origen con la
  malla anclada a radio fijo (`mesh.position.x = distance·(1−e)`) y la animación solo hace
  `pivot.rotation.y = phase`: eso describe un **círculo centrado en el Sol**, física falsa.
  La línea de órbita dibuja además una elipse **centrada** en el origen (tampoco con foco)
  y ni siquiera coincide con el movimiento circular real del planeta.

La rúbrica es explícita: incumplir un requisito nuclear (foco **o** cola) deja la entrega
en **tier B** por bueno que sea el resto. El jurado la fijó en **79** (17 escena · **4**
órbitas · 8 cometa · 12 estética · 14 UI · 7 cámara · 6 post · 4 rend · 3 robustez · 4
código), quedando **por debajo de los 79 ya calibrados** (Kimi K2.7 · CLI y MiniMax M3 ·
mini-agent) por la regla de empate.

## Hallazgo: GPT-5.6 Terra regresa frente a GPT-5.5

El hermano `codex-gpt-5.5` (GPT-5.5 · Codex) **acertó el foco** y comparte la cabeza con
**97**. Esta variante GPT-5.6 Terra, con el mismo agente Codex, **cae a 79** (−18) por
fallar justamente el foco que la generación anterior clavó — un recordatorio de que
"modelo más nuevo" no garantiza acertar los detalles físicos, y de que el foco elíptico
sigue siendo uno de los discriminadores más duros del reto.

## Artefactos regenerados

Tras editar la fuente de verdad [`../assets/benchmark.json`](../assets/benchmark.json)
(29 entradas) se regeneraron, derivándolos de ella:

- **Web principal** [`../index.html`](../index.html): 29 fichas, podio, radares;
  contadores dinámicos (29 entregas · 27/29 sin errores · media 87); bloque "estado del
  arte" (29/29 · 27/29); JSON-LD (`ItemList` de 29, `numberOfItems`) y metas a "29
  combinaciones".
- [`../assets/runtime.json`](../assets/runtime.json) y la captura en `assets/previews/`.
- [`../README.md`](../README.md): tablas (ranking, categorías, matriz) y badges (29, 27/29).
- [`results.md`](results.md) (29 fichas), [`conclusions.md`](conclusions.md),
  [`methodology.md`](methodology.md).
- SEO/GEO: `sitemap.xml` (29 demos), `llms.txt` y `llms-full.txt`.

## Cómo reproducir / añadir más

Mismo flujo de [`harness.md`](harness.md), [`contributing.md`](contributing.md) y las
tandas anteriores ([2.ª](segunda-tanda-2026-06-17.md), [3.ª](tercera-tanda-2026-06-18.md),
[4.ª](cuarta-tanda-2026-07-05.md), [5.ª](quinta-tanda-2026-07-23.md),
[6.ª](sexta-tanda-2026-07-27.md), [7.ª](septima-tanda-2026-07-29.md)): capturar en Chrome
headless → puntuar con la [`rúbrica`](rubric.md) → **verificar contra el runtime** →
fusionar en `benchmark.json` → regenerar los artefactos derivados (incluida la
**re-inyección** de los datos en `index.html` y el bloque "estado del arte", que es
hardcodeado).
