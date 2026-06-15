# 🧭 Análisis, conclusiones y estado del arte

Versión extendida del análisis. Para el resumen y las tablas, ver el [README](../README.md); para las fichas por entrega, [results.md](results.md).

## Lo que separó a los mejores

Casi todas las entregas "se ven bien". El spec, sin embargo, esconde detalles que solo se resuelven con **razonamiento de dominio**, y ahí se decidió el ranking.

### La cola del cometa Halley — el bug más discriminante

El vector "lejos del Sol" es `cometa − Sol`. Numerosas entregas lo invirtieron — con `.negate()`, `.scale(-1)` o un `Vector3.normalize()` que **muta** la posición del núcleo — y la cola acabó apuntando **hacia** el Sol, justo lo contrario de la física real.

- **Lo resolvieron** (cola correcta): GPT-5.5/Codex, ambos Opus 4.8, MiniMax M3/Claude Code, Gemini 3.5 Flash, DeepSeek V4 Pro/CodeWhale.
- **Lo fallaron:** Claude Sonnet 4.6, ambos Kimi K2.7, MiniMax M3/mini-agent, DeepSeek V4 Pro/Pi, Devstral, y por mutación de `normalize()`, GLM 5.2 y Z.ai GLM 5.2.

### El Sol en el foco, no en el centro

Una elipse con el Sol centrado es trivial y *parece* correcta. Ponerlo en el **foco** (`x = a·cosθ − a·e`) exige entender la órbita. El grupo de cabeza lo hizo; algunos (Gemini, Sonnet 4.6) dejaron el Sol en el centro y perdieron fidelidad orbital.

### Instancing — la trampa de rendimiento

El cinturón de 200–260 asteroides es un caso de libro para `createInstance`/*thin instances*. Solo **GPT-5.5, los dos Opus 4.8 y Gemini** lo hicieron bien; el resto creó cientos de mallas y materiales independientes (cientos de *draw calls*), lo que explica los FPS bajos en la captura.

## El agente importa tanto como el modelo

El mismo LLM rinde distinto según su andamiaje (planificación, consulta de docs, auto-verificación):

| Modelo | Con un agente | Con otro |
|:--|:--|:--|
| **MiniMax M3** | **92** (Claude Code) | 79 (mini-agent) |
| **Kimi K2.7** | 80 (Claude Code) | 79 (Kimi Code CLI, con error de consola) |
| **GLM 5.2** | 89 (Claude Code) | 54 (otra ejecución / variante) |

El andamiaje no es un detalle: es un **multiplicador** que puede mover una entrega un tier entero.

## La "regla absoluta" predijo los fallos

Las entregas que ignoraron la consulta de documentación tendieron a **inventar APIs**: `emissionRange` (estrellas sin distribuir), `mesh.diameter` (anillos y labels en `NaN`) en Devstral. Verificar la documentación no fue burocracia: fue **corrección**.

## Profundidad vs. amplitud

La mejor mecánica orbital del benchmark — **Z.ai GLM 5.2**, con Kepler real resuelto por Newton-Raphson — se quedó en el **tier D** por **entregar una escena incompleta** (sin Plutón, sin asteroides, sin nebulosas, sin post-procesado, panel mínimo: 29 objetos en escena). Resolver lo difícil no compensa dejar lo fácil a medias.

## El caso GLM-5.2: cuando el juez-LLM alucina

La revisión estática declaró "pantalla negra / no arranca" a `GLM-5.2-Claude-Code`. La **ejecución real** mostró 279 objetos, **0 errores** y UI completa con bloom. Los *strings* de color mal cerrados existen, pero el navegador los tolera y solo afectan a 2 de 5 nebulosas. La nota se **corrigió de 38 a 89**. Es la prueba viva de por qué un benchmark de agentes necesita **ejecución real**, no solo lectura de código.

## Conclusiones

- **El listón base es altísimo:** las **14** entregas arrancan y renderizan una escena WebGL compleja (≈1.1k líneas) en una sola pasada, y **12 de 14 con cero errores de consola**.
- **La frontera ya no es "¿funciona?" sino "¿acierta los detalles difíciles?":** foco orbital, signo de un vector, *instancing*, degradación elegante.
- **El andamiaje del agente es un multiplicador**, no un detalle.
- **Evaluar agentes exige ejecutarlos:** la revisión estática y la ejecución real discrepan, y la verdad está en el *runtime*.

## Estado del arte (junio 2026)

La generación *one-shot* de una experiencia 3D web compleja y autocontenida ha dejado de ser una hazaña: es el comportamiento **esperable** de un agente de código frontera. La pregunta ha pasado de *"¿puede escribir 1500 líneas de WebGL que ni siquiera lancen una excepción?"* a **"¿acierta los detalles difíciles?"**.

Los diferenciadores ya no son sintácticos sino **de razonamiento**: física, geometría y arquitectura de rendimiento. Y de forma reveladora, el **agente/andamiaje pesa tanto como el modelo base**. La cabeza de la tabla la comparten un *Claude Opus 4.8* y un *GPT-5.5* prácticamente empatados, con *MiniMax M3* y *Gemini 3.5 Flash* demostrando que el pelotón frontera es ancho y multi-proveedor.

Por último, una lección sobre **cómo medir** a los agentes: el *LLM-as-judge* sobre código estático es rápido pero falible. El estándar emergente, y el que aquí se aplica, es **juzgar por ejecución**. El estado del arte de los agentes es excelente; el de su *evaluación* apenas empieza a ponerse a su altura.
