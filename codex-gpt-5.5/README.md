# Universo 3D - codex-gpt-5.5

Implementacion documentada para la carpeta `codex-gpt-5.5`, basada en los requisitos de `Prompt-Maestro_v2.txt`.

## Entregable

- `index.html`: archivo unico autocontenido con HTML, CSS y JavaScript inline.
- Dependencia externa unica: BabylonJS desde `https://cdn.babylonjs.com/babylon.js`.
- No requiere build, servidor local ni assets locales.
- Puede abrirse directamente con doble click en el navegador.

## Como ejecutarlo

1. Abre `codex-gpt-5.5/index.html` en Chrome, Firefox o Edge.
2. Mantener conexion a internet para cargar BabylonJS desde el CDN oficial.
3. Interactua con la escena usando mouse o trackpad:
   - Click izquierdo + arrastrar: rotar.
   - Rueda: zoom.
   - Click derecho + arrastrar: pan.

## Requisitos implementados

- Sol central con esfera emisiva, luz puntual, corona de particulas, rotacion lenta y pulsado sutil.
- Sistema solar con Mercurio, Venus, Tierra, Marte, Jupiter, Saturno, Urano, Neptuno y Pluton.
- Orbitas elipticas con inclinacion orbital, velocidad tipo Kepler simplificada y etiquetas flotantes.
- Rotacion axial propia por planeta, incluyendo Venus retrogrado y Urano inclinado.
- Atmosferas procedurales en planetas seleccionados.
- Saturno y Urano con anillos procedurales.
- Cinturon de asteroides con mas de 200 cuerpos.
- Cometa Halley con orbita muy excentrica y cola de particulas que apunta en direccion opuesta al Sol.
- Campo estelar con mas de 3000 estrellas.
- Nebulosas procedurales con `DynamicTexture`.
- Camara `ArcRotateCamera` con limites, auto-rotacion y controles suaves.
- Iluminacion con `HemisphericLight` y `PointLight`.
- Post-procesado con `GlowLayer` y `DefaultRenderingPipeline` cuando esta disponible.
- Panel de configuracion con controles de tiempo, visualizacion, estetica e informacion.
- Animaciones basadas en `engine.getDeltaTime() / 1000`.

## Documentacion oficial consultada

El prompt exige validar las APIs de BabylonJS antes de escribir codigo. En este entorno, el identificador literal `/websites/babylonjs` no estuvo disponible en Context7, por lo que se resolvio el paquete oficial equivalente:

- Context7: `/babylonjs/documentation`

APIs validadas:

- `BABYLON.ParticleHelper`: preset `sun` validado como `CreateAsync("sun", scene)`.
- `BABYLON.ParticleSystem`: constructor, `emitter`, textura, `minEmitBox`, `maxEmitBox`, direcciones, colores, gradientes, `emitRate`, vida, tamano, `start()`.
- `BABYLON.MeshBuilder`: `CreateSphere`, `CreateBox`, `CreateLines`, `CreatePlane`, `CreateTorus`.
- `BABYLON.StandardMaterial`: `diffuseColor`, `emissiveColor`, `specularColor`, `diffuseTexture`, `alpha`.
- `BABYLON.ArcRotateCamera`: constructor, `attachControl`, `useAutoRotationBehavior`, `autoRotationBehavior.idleRotationSpeed`, limites de radio, zoom y pan.
- `BABYLON.HemisphericLight` y `BABYLON.PointLight`.
- `BABYLON.DynamicTexture`: `getContext()`, dibujo 2D, `update()`, `hasAlpha`.
- `BABYLON.Color3`, `BABYLON.Color4` y `BABYLON.Vector3`.
- `BABYLON.DefaultRenderingPipeline` y `BABYLON.GlowLayer`.

## Decision tecnica sobre la corona del Sol

`Prompt-Maestro_v2.txt` pide usar `BABYLON.ParticleHelper.CreateSystem("sun")`. La documentacion oficial disponible en Context7 valida el preset `sun` mediante `BABYLON.ParticleHelper.CreateAsync("sun", scene)`, no mediante `CreateSystem`. Ese helper suele depender de recursos remotos de assets. Para preservar el requisito de archivo autocontenido y evitar errores al abrir por `file://`, la corona se implemento con `BABYLON.ParticleSystem` y textura procedural creada con `DynamicTexture`.

La escena mantiene el comportamiento requerido: corona solar por particulas, sin assets locales y sin crear dependencias adicionales.

## Estructura del codigo

El `index.html` sigue el orden solicitado por el prompt:

1. Constantes y datos (`PLANETS`, configuracion de Halley, temas y colores).
2. `Engine`, `Scene` y color de fondo.
3. Camara orbital.
4. Luces.
5. Funciones auxiliares para texturas procedurales.
6. Estrellas.
7. Sol.
8. Planetas y orbitas.
9. Cinturon de asteroides.
10. Cometa Halley.
11. Nebulosas.
12. Post-procesado.
13. UI.
14. Bucle de animacion.
15. Render loop y resize.

## Calidad y robustez

- Comentarios en espanol dentro del codigo.
- Funciones separadas por responsabilidad.
- No se crean mallas ni texturas dentro del render loop.
- Degradacion controlada si falla una caracteristica avanzada como bloom/glow.
- Mensaje visible si BabylonJS no carga desde el CDN.
- Sin `console.log()` de depuracion.

## Archivos

```text
codex-gpt-5.5/
├── index.html
└── README.md
```
