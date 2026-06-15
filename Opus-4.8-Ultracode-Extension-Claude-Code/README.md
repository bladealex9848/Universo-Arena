# 🌌 Universo 3D — Sistema Solar Interactivo (BabylonJS)

> Implementación de **Opus 4.8 (Ultracode + Extensión Claude Code)** para la
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
| **Sol central** | Núcleo emisivo + corona de partículas radiales (`createSphereEmitter`), rotación lenta en Y, pulsado de escala 1.0↔1.05 cada ~3 s, `PointLight` propia. |
| **8 planetas + Plutón** | Mercurio, Venus, Tierra, Marte, Júpiter, Saturno, Urano, Neptuno y el planeta enano Plutón. |
| **Órbitas elípticas** | El Sol está en el **foco** de cada elipse; velocidad orbital **inversamente proporcional a la distancia** (Kepler simplificado). Plano orbital inclinado por planeta. |
| **Rotación axial** | Cada planeta gira sobre su eje inclinado; Venus y Urano con casos especiales (retrógrado / 90°). |
| **Atmósferas** | Esferas semitransparentes emisivas en Tierra, Venus, Marte y Neptuno. |
| **Anillos de Saturno y Urano** | Plano plano con textura procedural de bandas concéntricas y agujero central transparente. |
| **Luna** | La Tierra incluye una luna que la orbita (extra). |
| **Cinturón de asteroides** | 260 instancias de una malla base compartida (eficiente), entre Marte y Júpiter, con rotación global lenta + giro individual. |
| **Cometa Halley** | Órbita muy excéntrica (e=0.85), período ~18 s. **La cola siempre apunta en dirección opuesta al Sol** (vector recalculado cada frame). Gradiente de color blanco→cian→transparente. |
| **3 600 estrellas** | Campo estático de partículas distribuidas en una caja 2000³, con tamaños y tonos variados. |
| **4 nebulosas** | Planos enormes y distantes (billboard) con `DynamicTexture` procedural en tonos rosados/morados/azules. |
| **Post-procesado** | `GlowLayer` + `DefaultRenderingPipeline` con bloom, FXAA y tone mapping ACES. |

---

## 🎛️ Panel de configuración

Esquina superior derecha (colapsable con el botón ⚙, responsive en móvil):

- **Tiempo y velocidad** — velocidad global (0–10×), velocidad orbital (0.1–3×), botón pausar/reanudar.
- **Visualización** — mostrar/ocultar órbitas, nombres, cometa, cola, cinturón, nebulosas; selector de **6 vistas de cámara** (Sistema Solar, Sol cercano, Tierra, Saturno, Panorámica, Seguir a Halley); slider de tamaño relativo (0.5–3×).
- **Estética** — selector de tema (futurista/clásico/oscuro), toggle de bloom/glow, selector de color del sol (amarillo/blanco/naranja/rojo).
- **Información** (esquina inferior izquierda) — FPS en vivo (coloreado), número de objetos en escena y ayuda de controles.

### Controles de cámara
`Click izquierdo + arrastrar` → rotar · `Rueda` → zoom · `Click derecho + arrastrar` → pan ·
auto-rotación lenta cuando no hay interacción.

---

## 🧭 Regla absoluta cumplida: documentación oficial primero

El prompt exige consultar la documentación oficial de BabylonJS vía **context7**
*antes* de escribir código, y no inventar APIs. Se consultó
`/babylonjs/documentation` y se validaron las firmas y constantes críticas
**antes** de implementar:

- `ParticleSystem` (constructor, `emitter`, `minEmitBox/maxEmitBox`, `color1/color2/colorDead`,
  `minSize/maxSize`, `emitRate`, `direction1/direction2`, `addColorGradient`,
  `createSphereEmitter`, `blendMode`, `preWarmCycles`).
- `MeshBuilder.CreateLines` (objeto de opciones `{ points, colors, updatable }`),
  `CreateSphere`, `CreatePlane`, `CreateTorus`.
- `ArcRotateCamera` (constructor `alpha, beta, radius, target`) +
  `useAutoRotationBehavior` / `autoRotationBehavior.idleRotationSpeed`.
- `DefaultRenderingPipeline` (`bloomEnabled`, `bloomThreshold`, `bloomWeight`,
  `imageProcessing.toneMappingEnabled`, `ImageProcessingConfiguration.TONEMAPPING_ACES`).
- `DynamicTexture` (`getContext()`, `drawText()`, `update()`, `hasAlpha`).

### Decisión de ingeniería: corona del Sol

El prompt sugiere `BABYLON.ParticleHelper.CreateSystem("sun")`. La documentación
confirma que los *presets* (`"sun"`, `"galaxy"`, …) se cargan con
`ParticleHelper.CreateAsync`, que **descarga una textura remota** del servidor de
assets de Babylon. Eso rompe el requisito de funcionar offline en `file://` y
puede generar errores de consola sin red.

**Solución:** la corona se construye con un `ParticleSystem` propio y una textura
de destello **procedural** (`DynamicTexture`), totalmente autocontenida y sin
dependencias de red, envuelta en `try/catch` para degradar con elegancia. Se
cumple el espíritu del requisito (corona del Sol por partículas) garantizando
robustez offline y cero errores de consola.

---

## 🏗️ Arquitectura del código

El `<script>` sigue el **orden estricto** indicado en el prompt:

1. Constantes y datos (`PLANETS`, `BELT`, `HALLEY`, `SUN_COLORS`, `THEMES`) + estado global.
2. `Engine` + `Scene` + `clearColor`.
3. `ArcRotateCamera` con behaviors y límites.
4. Luces (`HemisphericLight` tenue + `PointLight` solar).
5. Funciones auxiliares de texturas procedurales (`makeLabelTexture`, `makeFlareTexture`, `makeNebulaTexture`, `makeRingTexture`, `makeBandsTexture`).
6. `createStars()`.
7. `createSun()`.
8. `createPlanets()` (+ `createOrbitLine`, `createPlanetRings`).
9. `createAsteroidBelt()`.
10. `createHalley()`.
11. `createNebulas()`.
12. `setupPostProcessing()`.
13. `setupUI()`.
14. Bucle de render (`scene.onBeforeRenderObservable`).
15. `engine.runRenderLoop` + `resize`.

### Jerarquía de nodos por planeta

```
orbitNode (TransformNode)        ← inclinación del plano orbital
  └─ pivot (TransformNode)       ← posición sobre la elipse (se mueve cada frame)
      ├─ tiltNode (TransformNode)← inclinación del eje axial
      │    ├─ mesh               ← esfera del planeta (rotación propia)
      │    ├─ atmosphere         ← esfera mayor semitransparente
      │    └─ rings              ← anillos (Saturno / Urano)
      ├─ moon                    ← luna (Tierra)
      └─ label                   ← etiqueta billboard con el nombre
```

Este diseño permite combinar limpiamente **posición orbital**, **inclinación del
plano**, **inclinación axial** y **rotación propia** sin acoplar transformaciones.

### Animación independiente del frame rate

Todas las velocidades se multiplican por `engine.getDeltaTime() / 1000`
(acotado a 0.05 s para evitar saltos al recuperar el foco de la pestaña). La
pausa congela la simulación poniendo el factor a 0, pero la cámara puede seguir
moviéndose.

---

## 🛡️ Calidad y robustez

- Comentarios **JSDoc en español** en cada función; nombres descriptivos;
  constantes en `MAYÚSCULAS_SNAKE_CASE`.
- Sin código muerto ni `console.log` de depuración (solo `console.error/warn`
  para fallos reales).
- `try/catch` en los puntos que pueden fallar (corona, glow, pipeline) con
  **degradación elegante**: si el bloom no está disponible, el resto sigue
  funcionando.
- **Rendimiento:** ninguna malla, material o textura se crea dentro del bucle de
  render — solo se transforman objetos existentes. El cinturón usa instancias de
  geometría compartida.

---

## ✅ Proceso de verificación (Ultracode)

Tras la implementación se ejecutó una **revisión adversarial multi-agente**
(22 subagentes) que auditó el archivo en cuatro dimensiones independientes
—corrección de la API de BabylonJS (contrastada de nuevo con context7),
completitud frente al spec, riesgo de errores en tiempo de ejecución y calidad
del código— y verificó cada hallazgo de forma adversarial para descartar falsos
positivos. Resultado: **16 hallazgos confirmados, 2 rechazados**. Todos los
confirmados quedaron corregidos en `index.html`. Los más relevantes:

| # | Severidad | Corrección aplicada |
|---|---|---|
| Cámara | mayor | Las vistas con interpolación por frame ya **no bloquean** el zoom/pan del usuario: la transición es de un solo disparo y, al llegar, devuelve el control. Las vistas de acercamiento (Sol, Tierra) relajan dinámicamente `lowerRadiusLimit` para alcanzar su radio. |
| Cola del cometa | mayor | El emisor de la cola pasó a ser un `Vector3` para que `direction1/2` se interpreten en espacio **mundo**; así la cola apunta exactamente en sentido opuesto al sol (antes la matriz de mundo del núcleo la rotaba dos veces). |
| Pausa | mayor | La rotación del sol ahora usa el mismo `factor` que el resto, por lo que **pausar congela también el sol**. |
| Pulsado del sol | menor | La escala oscila de **1.0 a 1.05** (antes 0.975↔1.025). |
| Estrellas | menor | Se añadió el tono **amarillo** (cálido) además de blanco y azul. |
| Luna | menor | La Luna hereda el slider de tamaño relativo. |
| Robustez | menor | Guarda que muestra un mensaje claro si el CDN de BabylonJS no carga. |
| Varios | nit | `colorDead` de la corona al recolorear el sol, frescura de la matriz de mundo (sin retardo de un frame), comentario de niebla y renumeración consecutiva de secciones. |

---

## 📁 Archivos

```
Opus-4.8-Ultracode-Extension-Claude-Code/
├── index.html   ← la simulación completa (único entregable ejecutable)
└── README.md    ← este documento
```
