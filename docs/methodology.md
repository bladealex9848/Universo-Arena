# 🧪 Metodología

El objetivo de Universo-Arena es comparar, de forma **justa y verificable**, qué combinación de modelo de lenguaje (LLM) y agente de código produce la mejor implementación de un mismo reto complejo en una sola pasada.

El reto está definido en [`Prompt-Maestro_v2.txt`](../Prompt-Maestro_v2.txt): una simulación 3D del Sistema Solar con BabylonJS, en un **único `index.html` autocontenido**, abrible con doble clic.

## Por qué no basta con un juez-LLM

Pedirle a un LLM que lea el código y ponga una nota es rápido, pero **poco fiable**: el juez puede alucinar bugs que no existen, o pasar por alto fallos que solo se manifiestan al ejecutar. En este benchmark ocurrió de forma flagrante (ver *El caso GLM-5.2*). Por eso la evaluación combina **tres señales independientes**.

## Las tres señales

### 1. Rúbrica de 100 puntos (revisión de código)

Un jurado-LLM por implementación lee el `index.html` **completo** y el spec, y puntúa **10 categorías** (ver [rubric.md](rubric.md)) verificando el código real, no los comentarios. Énfasis en los dos puntos críticos del spec:

- Órbitas **elípticas reales** con el Sol en el **foco** (no en el centro).
- Cola del cometa Halley **siempre opuesta al Sol**, recalculada cada frame.

### 2. Ejecución real (verdad de campo)

Cada una de las 14 entregas se **abre en Chrome headless** (WebGL por SwiftShader) y se mide objetivamente:

- **Captura de pantalla** real (las que ves en la galería y los `assets/previews/`).
- Número de **mallas en escena** (`scene.meshes.length`) — delata escenas incompletas.
- **FPS** y disponibilidad de WebGL.
- **Errores de consola y excepciones** — la prueba más dura de "¿funciona de verdad?".

Ningún archivo se juzga solo por su código: se juzga por **lo que hace al abrirse**.

### 3. Calibración adversarial + corrección por runtime

Un juez final normaliza las notas entre jurados (unos son más duros que otros) y produce el ranking. **Regla de oro:** donde la revisión estática contradice la ejecución real, **manda la ejecución real**.

## El caso GLM-5.2 (por qué la señal 2 es imprescindible)

La revisión estática inicial sentenció a `GLM-5.2-Claude-Code` con un *"bug fatal, pantalla negra"* por unos *strings* de color mal cerrados en una función de texturas. La **ejecución real lo desmintió**: 279 mallas en escena, **0 excepciones**, UI completa y bloom activo.

Investigando: los *strings* defectuosos existen, pero (a) el navegador los tolera y (b) afectan solo al color de 2 de 5 nebulosas. La escena se construye entera. La nota se **corrigió de un injusto 38 a 89** mediante una re-evaluación dirigida con el contexto de runtime.

**Lección metodológica:** un juez-LLM sobre código estático sobre-penaliza. Sin ejecución real, un benchmark de agentes no es fiable. Esta corrección está documentada en el [README](../README.md#el-caso-glm52-cuando-el-juezllm-alucina-y-el-runtime-corrige) y en [conclusions.md](conclusions.md).

## Escala y tiers

- Cada entrega obtiene un **total 0–100** (suma de las 10 categorías).
- Tiers: **S** (≥90) · **A** (82–89) · **B** (75–81) · **C** (60–74) · **D** (<60).
- En empates en cabeza, se evita el auto-favoritismo: la entrada creada por el propio sistema que ejecuta el benchmark (`Opus-4.8-Ultracode-Extension-Claude-Code`) se sitúa **por debajo** de la otra con idéntica nota.

## Límites y honestidad metodológica

- **Una sola ejecución por entrega.** No se mide la varianza run-to-run (que existe: dos entregas del mismo GLM 5.2 puntúan 89 y 54).
- **SwiftShader** rinde mucho menos que una GPU real; los **FPS medidos no son representativos** del rendimiento en hardware del usuario. Se usan solo como señal cualitativa, no se puntúa por FPS absoluto.
- El **jurado es un LLM**: la rúbrica reduce la subjetividad, pero no la elimina. La señal de runtime es el contrapeso objetivo.
- La identificación de modelo/agente se infiere del **nombre de la carpeta**; cualquier ambigüedad de nomenclatura se hereda de ahí.

## Reproducibilidad

El arnés completo (pipeline multi-agente + capturas) se describe en [harness.md](harness.md). Los datos crudos están versionados en [`../assets/benchmark.json`](../assets/benchmark.json) y [`../assets/runtime.json`](../assets/runtime.json).
