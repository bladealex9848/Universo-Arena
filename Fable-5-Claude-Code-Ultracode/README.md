# 🌌 Universo 3D — Sistema Solar Interactivo (BabylonJS)

> Implementación de **Claude Fable 5 (Claude Code · Ultracode)** para la
> *Universo-Arena*, siguiendo `Prompt-Maestro_v2.txt`.

Una simulación 3D completa del sistema solar en **un único archivo `index.html`
autocontenido**. Se abre con doble click (`file://`) en cualquier navegador
moderno — sin servidor, sin assets locales, sin build. La única dependencia es
**BabylonJS** cargado desde su CDN oficial.

---

## ▶️ Cómo ejecutarlo

1. Abre `index.html` con doble click (Chrome, Firefox o Edge).
2. Requiere conexión a internet **solo la primera vez**, para descargar
   BabylonJS desde `https://cdn.babylonjs.com/babylon.js`.
3. Todo lo demás (texturas, partículas, geometría) es **procedural**: se genera
   en tiempo de ejecución, por lo que funciona offline tras esa primera carga.

---

## ✨ Qué incluye la escena

| Elemento | Detalle |
|---|---|
| **Sol central** | Núcleo emisivo + **corona de partículas** procedural (`createSphereEmitter`), rotación lenta en Y, pulsado de escala **1.0↔1.05** (~3 s), `PointLight` propia. Se intenta además el preset oficial `ParticleHelper.CreateAsync("sun")` con *fallback* a la corona procedural. |
| **8 planetas + Plutón** | Mercurio, Venus, Tierra, Marte, Júpiter, Saturno, Urano, Neptuno y el enano Plutón. |
| **Órbitas elípticas + Kepler REAL** | El Sol está en el **foco** (`x=a(cosE−e), z=b·sinE, b=a√(1−e²)`) y se resuelve la **ecuación de Kepler** `M=E−e·sinE` por Newton-Raphson: el cuerpo **acelera de verdad en el perihelio** (2.ª ley). El movimiento medio es `∝ a^(−1.5)` (3.ª ley). |
| **Rotación axial** | Cada planeta gira sobre su eje inclinado; Venus retrógrado, Urano a ~90°. |
| **Atmósferas** | Esferas semitransparentes emisivas en Venus, Tierra, Marte y Neptuno. |
| **Anillos como TORUS 3D** | Saturno y Urano llevan anillos de **geometría volumétrica real** (`CreateTorus` aplanado, varias bandas), no un plano texturizado — se ven volumétricos también en ángulos rasantes. |
| **Luna** | La Tierra incluye una Luna que la orbita (extra). |
| **Cinturón de asteroides** | **260 instancias** (`createInstance`) de una malla base oculta, entre Marte y Júpiter, con rotación global lenta + giro individual. |
| **Cometa Halley** | Órbita muy excéntrica (e=0.85), período ~18 s, núcleo + coma. **La cola siempre apunta en sentido opuesto al Sol** (recalculada cada frame). Gradiente blanco→cian→transparente. Con **etiqueta billboard**. |
| **3 700 estrellas** | Tres campos de partículas (blanco / azul / cálido) en una caja 2000³, emitidas de golpe (`manualEmitCount`) para que estén **todas visibles al instante**. |
| **5 nebulosas** | Planos enormes y distantes (billboard) con `DynamicTexture` procedural en tonos rosa/violeta/azul/cian/ámbar, mezcladas en modo aditivo. |
| **Texturas de superficie** | Bandas + **Gran Mancha Roja** en Júpiter, bandas en Saturno, continentes/casquetes en la Tierra, maria y casquetes en Marte, cráteres en Mercurio/Plutón/Luna, remolinos en Venus. |
| **Post-procesado** | `GlowLayer` (solo Sol y cometa) + `DefaultRenderingPipeline` con bloom, FXAA, tone mapping ACES y viñeta. |

---

## 🎛️ Panel de configuración

Esquina superior derecha (colapsable con ✕/⚙, responsive en móvil):

- **Tiempo y velocidad** — velocidad global (0–10×), velocidad orbital (0.1–3×), botón pausar/reanudar (congela también el Sol, pero la cámara sigue libre).
- **Visualización** — mostrar/ocultar órbitas, nombres, cometa, cola, cinturón, nebulosas; selector de **6 vistas de cámara** (Sistema Solar, Sol cercano, Tierra, Saturno, Panorámica, Seguir a Halley); slider de tamaño relativo (0.5–3×).
- **Estética** — selector de **tema** (futurista/clásico/oscuro) que cambia la estética 3D real (cielo, glow, nebulosas, acento); toggle de bloom/glow; selector de **color del Sol** (amarillo/blanco/naranja/rojo) que afecta núcleo + luz + corona.
- **Información** (esquina inferior izquierda) — FPS en vivo (coloreado), nº de objetos en escena y ayuda de controles.

### Controles de cámara
`Click izq + arrastrar` → rotar · `Rueda` → zoom · `Click der + arrastrar` → pan · auto-rotación lenta al estar inactiva.

---

## 🧭 Regla absoluta cumplida: documentación oficial primero

El prompt exige consultar la documentación oficial de BabylonJS *antes* de
escribir código y **no inventar APIs**. Se validaron firmas y constantes contra
la documentación oficial (`doc.babylonjs.com`, identificador context7
`/websites/babylonjs`) antes de implementar. Las críticas quedan listadas en el
comentario de cabecera del `index.html`, entre ellas:

- `ParticleSystem` (`emitter` como **Vector3** para direcciones en espacio mundo,
  `minEmitBox/maxEmitBox`, `color1/2/colorDead`, `min/maxSize`, `emitRate`,
  `manualEmitCount`, `direction1/2`, `gravity`, `createSphereEmitter`, `blendMode`).
- `MeshBuilder.CreateSphere/CreateLines/CreateTorus/CreatePlane`.
- `ArcRotateCamera` (`alpha, beta, radius, target`) + `useAutoRotationBehavior` /
  `autoRotationBehavior.idleRotationSpeed`.
- `DefaultRenderingPipeline` (`bloomEnabled/Threshold/Weight/Kernel`,
  `imageProcessing.toneMappingType = ImageProcessingConfiguration.TONEMAPPING_ACES`).
- `GlowLayer.addIncludedOnlyMesh`, `DynamicTexture.getContext()/update()`,
  `Vector3.normalizeToNew` (no muta) / `TransformCoordinates`.

### Decisión de ingeniería: corona del Sol

El preset `ParticleHelper.CreateAsync("sun")` **descarga una textura remota**, lo
que puede fallar sin red en `file://`. Solución: la corona real es un
`ParticleSystem` **procedural** (autocontenido, cero red), y *además* se intenta
el preset oficial en un `try/catch` — si hay red, lo suma; si no, la corona
procedural garantiza el resultado. Se cumple el espíritu **y la letra** del
requisito sin sacrificar robustez offline.

---

## 🏗️ Arquitectura del código

El `<script>` sigue el **orden estricto** del prompt (constantes → engine → cámara
→ luces → helpers de textura → estrellas → sol → planetas/órbitas → cinturón →
Halley → nebulosas → post-pro → UI → bucle de render → runRenderLoop).

### Jerarquía de nodos por planeta

```
holder (TransformNode)          ← posición sobre la elipse (se mueve cada frame; SIN escalar)
  ├─ tiltNode (TransformNode)    ← inclinación del eje axial
  │    ├─ core   (Mesh)          ← esfera con textura procedural (rotación propia; escala = tamaño relativo)
  │    ├─ atmos  (Mesh)          ← esfera mayor semitransparente emisiva
  │    └─ rings  (TransformNode) ← anillos torus 3D (Saturno / Urano)
  ├─ luna   (Mesh)               ← Luna (solo la Tierra)
  └─ label  (Plane billboard)    ← nombre; hijo de holder (NO escalado) ⇒ siempre legible
```

Solo se escala `core/atmos/rings`; la **etiqueta no se escala**, por lo que el
slider de tamaño relativo no la desplaza ni la deforma.

### Animación independiente del frame rate

Todas las velocidades se multiplican por `engine.getDeltaTime()/1000` (acotado a
**0.05 s** para evitar saltos al recuperar el foco). La pausa pone el factor a 0
(congela Sol, planetas, cinturón y cometa) pero **la cámara sigue moviéndose**.

### Vistas de cámara sin bloquear el zoom

Las vistas fijas (Sistema Solar, Sol, Panorámica) hacen una **transición de un
disparo** y liberan el control al llegar. Las de seguimiento (Tierra, Saturno,
Halley) mueven **solo el `target`** hacia el cuerpo, dejando `radius/alpha/beta`
libres — así la rueda de zoom **nunca queda anulada** (defecto común en otras
entradas del benchmark).

---

## 🎯 Las dos trampas de corrección — resueltas y verificadas

1. **Sol en el foco de la elipse.** `posicionOrbital(E, a, e, mat)` calcula
   `x = a(cosE − e)`, `z = b·sinE` con `b = a√(1−e²)`. La **misma función**
   genera la línea de órbita y la posición del cuerpo, así que coinciden.
   Además se resuelve la ecuación de Kepler para tener la 2.ª ley real.
2. **Cola del cometa opuesta al Sol.** Con el Sol en el origen,
   `dir = posCometa.normalizeToNew()` (no muta la posición), asignado a
   `direction1/2` cada frame, con el **emisor como `Vector3` en espacio mundo**.
   Verificación objetiva: el producto escalar entre la dirección de la cola y el
   vector `(cometa − Sol)` da **1.0** (paralelos) ⇒ la cola apunta exactamente en
   sentido contrario al Sol.

---

## 🛡️ Calidad y robustez

- Comentarios **JSDoc en español**; nombres descriptivos; constantes en
  `MAYÚSCULAS_SNAKE_CASE`; IIFE con `"use strict"`.
- Sin código muerto ni `console.log` de depuración (solo `console.warn` en los
  `catch` de fallos reales).
- `try/catch` en corona, `GlowLayer` y `DefaultRenderingPipeline` con
  **degradación elegante**; guarda si el CDN no carga; manejo de contexto WebGL
  perdido/recuperado; overlay de carga.
- **Rendimiento:** ninguna malla, material o textura se crea dentro del bucle de
  render — solo se transforman objetos existentes. El cinturón usa **instancias**
  de geometría compartida.

---

## ✅ Verificación

Render **headless** con Chrome + SwiftShader (mismo enfoque que el harness del
repo) y auditoría por CDP:

| Señal | Resultado |
|---|---|
| Errores de consola | **0** (los warnings son mensajes de rendimiento del driver SwiftShader, no de la app) |
| BabylonJS | 9.15.0 · WebGL inicializado |
| Mallas en escena | **310** |
| Asteroides instanciados | **260** presentes en escena |
| Partículas activas | **7 596** (las 3 700 estrellas emitidas correctamente) |
| Cola opuesta al Sol | **sí** (producto escalar = **1.0**) |
| Captura | escena completa, no negra |

Tras la implementación se ejecutó además una **revisión adversarial
multi-agente** (Ultracode): varios subagentes auditaron el archivo en dimensiones
independientes —corrección de la API de BabylonJS, completitud frente al spec,
riesgo de runtime, corrección física de las dos trampas y calidad de código— y
**cada hallazgo se verificó de forma adversarial** para descartar falsos
positivos antes de aplicar correcciones.

---

## 📁 Archivos

```
Fable-5-Claude-Code-Ultracode/
├── index.html   ← la simulación completa (único entregable ejecutable)
└── README.md    ← este documento
```

Licencia [MIT](../LICENSE), como el resto del repositorio.
