# 🤝 Cómo contribuir una nueva entrada

¿Quieres añadir otra combinación de LLM + agente al benchmark? Es sencillo.

## 1. Crea la carpeta con el nombre correcto

El nombre de la carpeta **es** la etiqueta de la entrada: codifica el modelo y el agente/herramienta usados.

```
<Modelo>-<Agente>/
```

Ejemplos existentes:

| Carpeta | Modelo | Agente |
|:--|:--|:--|
| `Opus-4.8-Claude-Code` | Claude Opus 4.8 | Claude Code |
| `codex-gpt-5.5` | GPT-5.5 | Codex |
| `Agy-Gemini-3.5-Flash-Antigravity-CLI` | Gemini 3.5 Flash | Antigravity CLI |
| `mini-agent-MiniMax-M3` | MiniMax M3 | mini-agent |

Usa un nombre claro y consistente; de él se infiere la ficha en el ranking.

## 2. Genera la entrega

Pásale a tu LLM + agente el reto íntegro de [`../Prompt-Maestro_v2.txt`](../Prompt-Maestro_v2.txt). Reglas del juego:

- **Una sola pasada** (sin iterar manualmente el resultado).
- Resultado: **un único `index.html` autocontenido** dentro de la carpeta.
- Sin assets locales ni servidor: HTML + CSS + JS, y BabylonJS por CDN oficial.
- Debe **abrirse con doble clic** (`file://`) y funcionar.
- **Trabajo original** por carpeta (no copiar otra entrada).

```
<Modelo>-<Agente>/
└── index.html
```

## 3. Regenera capturas y datos

Con Node.js y Google Chrome instalados (ver [harness.md](harness.md)):

1. Ejecuta el script de captura → produce `assets/previews/<Modelo>-<Agente>.png` y actualiza `assets/runtime.json`.
2. Evalúa la entrada con la [rúbrica](rubric.md) (idealmente con el mismo pipeline multi-agente, contrastando contra el runtime).
3. Añade su objeto a `assets/benchmark.json` (incluyendo `rank`, `tier`, `scores`, `features`, `fortalezas`, `debilidades`, `veredicto`, `runtime`, `preview`, `color`, `modelo`, `agente`).
4. Re-inyecta `benchmark.json` en `index.html` (la galería embebe los datos para funcionar en `file://`).
5. Regenera las tablas del [README](../README.md) y la ficha en [results.md](results.md).

## 4. Verifica

- [ ] La simulación abre sin errores de consola.
- [ ] La captura no es negra y muestra la escena.
- [ ] La galería (`index.html` raíz) muestra la nueva ficha y su modal funciona.
- [ ] Los enlaces de "demo en vivo" apuntan a la carpeta correcta.

## Estilo y licencia

- Comentarios y UI en **español** (como el resto del repo).
- Código bajo [MIT](../LICENSE).
- Sé honesto en la evaluación: la credibilidad del benchmark depende de ello (incluida la corrección por runtime cuando la revisión estática se equivoca).
