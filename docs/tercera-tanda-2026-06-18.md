# 🆕 Tercera tanda — 2 entradas nuevas (2026-06-18)

Registro de la ampliación del benchmark de **17 → 19 entradas**. Se añadieron dos
combinaciones que estaban sin integrar y se re-rankeó el conjunto completo,
manteniendo la misma metodología (rúbrica + ejecución real + verificación).

## Las dos nuevas

| Carpeta | Modelo | Agente | Nota | Tier | Puesto |
|:--|:--|:--|:--:|:--:|:--:|
| `Opencode-Minimax-M3` | MiniMax M3 | **OpenCode** | **95** | S | #4 |
| `Pi-DeepSeek-v4-pro` | DeepSeek V4 Pro | **Pi** | **88** | A | #12 |

Ambas aciertan los dos puntos críticos del reto (cola del cometa **opuesta al Sol**
y órbitas **elípticas con el Sol en el foco**) y usan **instancing** real para el
cinturón. Las dos arrancan con **0 errores de consola**.

## Datos de ejecución real (Chrome headless)

| Carpeta | Objetos en escena | Errores consola | WebGL |
|:--|:--:|:--:|:--:|
| `Opencode-Minimax-M3` | 264 | 0 | ✓ |
| `Pi-DeepSeek-v4-pro` | 301 | 0 | ✓ |

## Calibración: esta vez sin recortes

A diferencia de la 2.ª tanda (donde los jurados puntuaron generoso y hubo que
ajustar a la baja), aquí los jurados se instruyeron para ser **estrictos y
calibrados desde el inicio**, conociendo el campo (97/95/92/89/88/86…). Sus notas
(95 y 88) quedaron **confirmadas por la ejecución real** (264 y 301 objetos, 0
errores), sin contradicciones que obligaran a corregir. El empate de cabeza (97)
de GPT-5.5/Codex y Opus 4.8/Ultracode se mantiene intacto.

## Hallazgos

**OpenCode es un agente muy fuerte.** Con estas entradas, OpenCode acumula **dos
95**: uno con GLM 5.2 y otro con MiniMax M3. El mismo andamiaje saca lo mejor de
modelos base distintos.

**El andamiaje (o la varianza) decide — caso DeepSeek V4 Pro.** El modelo aparece
ahora en tres entradas, y el resultado depende del agente/ejecución:

| Carpeta | Agente | Nota | ¿Acierta las trampas? |
|:--|:--|:--:|:--|
| `Pi-DeepSeek-v4-pro` | Pi | **88** | ✅ cola anti-solar + foco elíptico |
| `codewhale-deepseek-v4-pro` | CodeWhale | 88 | ✅ |
| `deepseek-v4-pro-Pi-Coding-Agent` | Pi Coding Agent | 78 | ❌ cola hacia el Sol, órbitas circulares |

La entrada `Pi-DeepSeek-v4-pro` **resuelve** exactamente las dos trampas que la
otra entrada del mismo modelo con un agente "Pi" había fallado: una ilustración
directa de cuánto pesa el andamiaje (y la varianza entre ejecuciones).

## Artefactos regenerados

Tras editar la fuente de verdad [`../assets/benchmark.json`](../assets/benchmark.json)
(19 entradas) se regeneraron, derivándolos de ella:

- **Web principal** [`../index.html`](../index.html): 19 fichas, podio, radares;
  contadores dinámicos (19 entregas · 17/19 sin errores · media 86); JSON-LD y
  metas a "19 combinaciones". Verificada: **0 errores** en navegador.
- [`../assets/runtime.json`](../assets/runtime.json) y 2 capturas en `assets/previews/`.
- [`../README.md`](../README.md): tablas (ranking, categorías, matriz) y badges.
- [`results.md`](results.md), [`conclusions.md`](conclusions.md), [`methodology.md`](methodology.md).
- SEO: `sitemap.xml` (19 demos), `llms.txt` y `llms-full.txt` (ranking + contadores).

## Cómo reproducir / añadir más

Mismo flujo de [`harness.md`](harness.md), [`contributing.md`](contributing.md) y la
[2.ª tanda](segunda-tanda-2026-06-17.md): capturar en Chrome headless → puntuar con
la [`rúbrica`](rubric.md) → **verificar contra el runtime** → fusionar en
`benchmark.json` → regenerar artefactos derivados (incluida la **re-inyección** de
los datos en `index.html`).
