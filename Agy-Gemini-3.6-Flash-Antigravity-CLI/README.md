# Universo 3D - Agy-Gemini-3.6-Flash-Antigravity-CLI

Implementación completa y documentada para la carpeta `Agy-Gemini-3.6-Flash-Antigravity-CLI`, basada en las especificaciones estrictas de [`Prompt-Maestro_v2.txt`](../Prompt-Maestro_v2.txt).

## 🚀 Entregable

- `index.html`: archivo único autocontenido con HTML5, CSS3 y JavaScript Inline (ES6+).
- Dependencias CDN oficiales: BabylonJS (`https://cdn.babylonjs.com/babylon.js`) y BabylonJS Loaders (`https://cdn.babylonjs.com/loaders/babylonjs.loaders.min.js`).
- Sin assets locales, sin servidores y sin herramientas de compilación.
- Listo para abrir directamente mediante doble click en cualquier navegador moderno (`file://`).

## 🎮 Cómo ejecutarlo

1. Abre `Agy-Gemini-3.6-Flash-Antigravity-CLI/index.html` en tu navegador (Chrome, Firefox, Safari o Edge).
2. Asegúrate de disponer de conexión a internet para descargar BabylonJS desde el CDN oficial.
3. Controles interactivos de navegación 3D:
   - **Click izquierdo + Arrastrar**: Rotación orbital de la cámara.
   - **Rueda del ratón / Pinch**: Zoom in / Zoom out.
   - **Click derecho + Arrastrar**: Panoramización (Pan).

## 🌟 Características Implementadas (`Prompt-Maestro_v2.txt`)

- ☀️ **Sol Central Emisivo**: Esfera 3D con textura granular solar procedural, luz puntual (`PointLight`) cálida de alta intensidad, rotación lenta y pulso sinusoidal de escala (1.0 ↔ 1.05 cada ~3s). Corona de partículas integrada vía `BABYLON.ParticleSystem`.
- 🪐 **Sistema Solar Completo (8 Planetas + Plutón Enano)**:
  - Órbitas Keplerianas elípticas reales ($x = a \cos\theta - a e$, $z = b \sin\theta$).
  - Velocidad orbital inversamente proporcional a la distancia ($v \propto 1 / r\sqrt{r}$).
  - Inclinación de planos orbitales y ejes axiales propios por planeta (incluyendo rotación retrógrada en Venus e inclinación de ~90° en Urano).
  - Atmósferas procedimentales semi-transparentes (Tierra, Venus, Marte).
  - Anillos procedimentales con textura alpha (Saturno y Urano).
  - Etiquetas flotantes billboard (`TransformNode.BILLBOARDMODE_ALL`) con nombres.
- 🌑 **Cinturón de Asteroides**: Más de 280 asteroides rocosos distribuidos en anillo orbital entre Marte y Júpiter, instanciados con `createInstance` para optimización de renderizado (1 solo draw call).
- ☄️ **Cometa Halley**: Órbita de altísima excentricidad ($e = 0.85$) con cola de partículas vectorial (`BABYLON.ParticleSystem`) cuya dirección se calcula en cada frame **siempre opuesta a la posición del Sol** ($\vec{d} = \text{Pos}_{\text{Halley}} - \text{Pos}_{\text{Sol}}$).
- 🌌 **Fondo Cosmos y Nebulosas**:
  - Más de 3500 estrellas estáticas distribuidas uniformemente en una caja espacial de $3600^3$ unidades.
  - 4 planos lejanos de nebulosa profunda con gradientes de color procedurales y alpha blending.
- 🎥 **Cámara e Iluminación**:
  - `BABYLON.ArcRotateCamera` con límites de zoom, controles suaves y auto-rotación orbital (*idle speed* = 0.03).
  - Iluminación hemisférica tenue de relleno + punto de luz solar central.
- 🎬 **Post-Procesado de Alta Fidelidad**:
  - `BABYLON.DefaultRenderingPipeline` con Bloom, Glow Layer y Tone Mapping ACES.
- ⚙️ **Panel de Configuración Glassmorphism (UI)**:
  - **Sección 1 (Tiempo)**: Sliders de velocidad global, multiplicador orbital y botón toggle Pausar/Reanudar.
  - **Sección 2 (Visualización)**: Toggles independientes de órbitas, etiquetas, cometa, cola, asteroides, nebulosas, selector de vistas de cámara (Sistema Solar, Sol, Tierra, Saturno, Panorámica, Seguir a Halley) y escala de planetas.
  - **Sección 3 (Estética)**: Temas de color de la UI (Neo-futurista, Clásico, Oscuro), toggle post-procesado y selector de tipo/color de Sol.
  - **Sección 4 (Información)**: Métrica en tiempo real de FPS (coloreada según rendimiento) y conteo de mallas en escena.

## 📚 Documentación Oficial Consultada (Regla Absoluta)

APIs de BabylonJS validadas mediante documentación oficial para garantizar firmas y parámetros exactos:

1. `BABYLON.ParticleSystem`: Constructor `(name, capacity, scene)`, asignación de `particleTexture` procedural, `minEmitBox`, `maxEmitBox`, `color1`, `color2`, `colorDead`, `blendMode = BLENDMODE_ONEONE`, `emitRate` y `start()`.
2. `BABYLON.ParticleHelper`: `CreateAsync("sun", scene)` utilizado con bloque `try/catch` para degradación graceful a `ParticleSystem` manual si falla la carga remota.
3. `BABYLON.MeshBuilder`: `CreateSphere`, `CreateLines`, `CreatePlane`, `CreateDisc`.
4. `BABYLON.StandardMaterial`: Propiedades `diffuseColor`, `emissiveColor`, `specularColor`, `diffuseTexture`, `alpha` y `backFaceCulling`.
5. `BABYLON.ArcRotateCamera`: Firma del constructor, `attachControl`, `useAutoRotationBehavior`, `autoRotationBehavior.idleRotationSpeed`, `lowerRadiusLimit` y `upperRadiusLimit`.
6. `BABYLON.DynamicTexture`: Creación en memoria para texturas de superficie planetaria, anillos de Saturno, flare de partículas, nebulosas y etiquetas billboard.
7. `BABYLON.DefaultRenderingPipeline` y `BABYLON.GlowLayer`: Post-procesado con bloom, resplandor y mapeo de tonos.

## 🛠️ Estructura del Proyecto

```text
Agy-Gemini-3.6-Flash-Antigravity-CLI/
├── index.html   # Código fuente autocontenido (HTML + CSS + JS)
└── README.md    # Documentación técnica de la entrega
```
