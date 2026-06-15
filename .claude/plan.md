# Plan: Simulación 3D del Universo — Kimi-k.7-code-Claude-Code

## Objetivo
Crear un único archivo `index.html` autocontenido en `/Volumes/NVMe1TB/GitHub/Universo-Arena/Kimi-k.7-code-Claude-Code/` que cumpla todos los requisitos de `Prompt-Maestro_v2.txt`.

## Enfoque
- Basarme en la implementación hermana (`kimi-k2.7-code-Kimi-Code-CLI/index.html`) como referencia probada, pero crear una versión nueva y pulida para el directorio objetivo.
- Validar las APIs críticas de Babylon.js contra la documentación oficial vía WebFetch/WebSearch (alternativa a context7, que no está disponible en este entorno).
- Mejorar la adherencia exacta al prompt: pulsado solar 1.0↔1.05 en ~3 s, anillos de Saturno más realistas (disco plano/multianillo), JSDoc en español en cada función, conteo correcto de objetos.

## Pasos de implementación
1. **Validación de APIs**: consultar docs de Babylon.js para `ParticleHelper.CreateSystem`, `ParticleSystem`, `DefaultRenderingPipeline`, `ArcRotateCamera.autoRotationBehavior` y `MeshBuilder`.
2. **Estructura HTML/CSS**: panel en esquina superior derecha (300 px), secciones de Tiempo/Velocidad, Visualización, Estética e Información; responsive <600 px.
3. **Escena base**: `Engine`, `Scene`, `ArcRotateCamera` con auto-rotación, `HemisphericLight` y `PointLight`.
4. **Sol**: esfera emisiva + corona con `ParticleHelper.CreateSystem("sun")`, rotación y pulsado.
5. **Estrellas de fondo**: `ParticleSystem` con 4000 partículas estáticas en caja 2000³.
6. **Planetas**: 8 planetas + Plutón, cada uno con órbita elíptica inclinada, rotación axial, atmósfera opcional y label billboard.
7. **Cinturón de asteroides**: 240+ esferas pequeñas en órbita.
8. **Saturno**: anillos planos más realistas (disco texturizado o múltiples toros finos).
9. **Cometa Halley**: órbita excéntrica, núcleo y cola con `ParticleSystem` cuya dirección se recalcula cada frame opuesta al sol.
10. **Nebulosas**: 4 planos billboard con `DynamicTexture` procedimental.
11. **Post-procesado**: `DefaultRenderingPipeline` bloom + `GlowLayer`, con toggle en UI.
12. **UI y render loop**: conectar controles, cámara preset, tema, color del sol, FPS/contador.
13. **Verificación**: revisar sintaxis, ausencia de `console.log` de debug, comentarios JSDoc en español, funcionamiento offline vía CDN.

## Entregable
- `/Volumes/NVMe1TB/GitHub/Universo-Arena/Kimi-k.7-code-Claude-Code/index.html`

## Nota sobre context7
El prompt exige usar `context7`, pero esa herramienta no está disponible en este entorno. Se usará WebFetch/WebSearch como alternativa para validar las firmas de las APIs críticas antes de escribir código.
