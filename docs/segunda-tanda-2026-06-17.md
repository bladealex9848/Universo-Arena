# 🆕 Segunda tanda — 3 entradas nuevas (2026-06-17)

Registro de la ampliación del benchmark de **14 → 17 entradas**. Se añadieron tres
combinaciones que estaban sin integrar y se re-rankeó el conjunto completo,
manteniendo la misma metodología (rúbrica + ejecución real + calibración).

## Las tres nuevas

| Carpeta | Modelo | Agente | Nota | Tier | Puesto |
|:--|:--|:--|:--:|:--:|:--:|
| `Opencode-GLM-5.2` | GLM 5.2 | **OpenCode** | **95** | S | 🥉 #3 |
| `Antigravity-Gemini-3.5-High` | Gemini 3.5 (High) | **Antigravity** | **92** | S | #5 |
| `Zcode-GML-5.2-Max` | GLM 5.2 (Max) | **Zcode** | **89** | A | #9 |

Las tres aciertan los dos puntos críticos del reto (cola del cometa **opuesta al
Sol** y órbitas **elípticas con el Sol en el foco**) y usan **instancing** real
para el cinturón de asteroides. Las tres arrancan con **0 errores de consola**.

## Datos de ejecución real (Chrome headless)

| Carpeta | Objetos en escena | Errores consola | WebGL |
|:--|:--:|:--:|:--:|
| `Opencode-GLM-5.2` | 263 | 0 | ✓ |
| `Antigravity-Gemini-3.5-High` | 42 (asteroides por *thin instances*) | 0 | ✓ |
| `Zcode-GML-5.2-Max` | 262 | 0 | ✓ |

> Las 42 mallas de Antigravity no indican escena incompleta: usa *thin instances*
> para los 220 asteroides (1 sola malla base), de ahí el conteo bajo y eficiente.

## Calibración: por qué bajaron las notas del jurado

Los jurados de esta tanda puntuaron **~3-4 puntos por encima** de la escala
calibrada de la primera tanda. Antes de integrar, se verificó cada entrada de
forma adversarial **contra el código real y la ejecución**, ajustando a la baja:

| Entrada | Jurado | Verificada | Motivo del ajuste |
|:--|:--:|:--:|:--|
| Opencode-GLM-5.2 | 99 | **95** | la cola no se detiene al ocultar el cometa; el toggle de bloom apaga también el tone mapping; rampa de emisión de estrellas |
| Antigravity-Gemini-3.5-High | 95 | **92** | Júpiter sin bandas; estrellas justo en el piso de 3000; anillos como disco plano |
| Zcode-GML-5.2-Max | 92 | **89** | la inclinación del plano orbital queda anulada (`y=0`): órbitas coplanares; seguimiento de cámara acoplado a la visibilidad del cometa |

**Decisión clave:** no se permitió que un **99 sin calibrar destronara el empate de
cabeza (97)** de GPT-5.5/Codex y Claude Opus 4.8/Ultracode sin re-baremar a esos
con el mismo rigor. El podio quedó: 🥇 GPT-5.5 (97) · 🥈 Opus 4.8 Ultracode (97) ·
🥉 GLM 5.2 · OpenCode (95).

## Hallazgo: el agente pesa tanto como el modelo (caso GLM 5.2)

Con estas entradas, **GLM 5.2** queda representado por **cuatro** combinaciones,
con una dispersión enorme según el agente que lo conduce:

| Agente | Nota |
|:--|:--:|
| OpenCode | **95** |
| Claude Code | 89 |
| Zcode (Max) | 89 |
| Z.ai | 54 |

Es la mejor ilustración del benchmark de que **el andamiaje del agente** (planificación,
consulta de docs, auto-verificación) puede mover al mismo modelo base **41 puntos**.

## Artefactos regenerados

Tras editar la fuente de verdad [`../assets/benchmark.json`](../assets/benchmark.json)
(17 entradas) se regeneraron, derivándolos de ella:

- **Web principal** [`../index.html`](../index.html): 17 fichas, podio, radares;
  contadores dinámicos (17 entregas · 15/17 sin errores · media 85); JSON-LD y
  metas a "17 combinaciones". Verificada: **0 errores** en navegador.
- [`../assets/runtime.json`](../assets/runtime.json) y 3 capturas en `assets/previews/`.
- [`../README.md`](../README.md): tablas (ranking, categorías, matriz) y badges.
- [`results.md`](results.md), [`conclusions.md`](conclusions.md), [`methodology.md`](methodology.md).
- SEO: `sitemap.xml` (17 demos), `llms.txt` y `llms-full.txt` (ranking + contadores).

## Cómo reproducir / añadir más

Mismo flujo de [`harness.md`](harness.md) y [`contributing.md`](contributing.md):
capturar en Chrome headless → puntuar con la [`rúbrica`](rubric.md) → **verificar
contra el runtime** → fusionar en `benchmark.json` → regenerar artefactos
derivados (incluida la **re-inyección** de los datos en `index.html`).
