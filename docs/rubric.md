# 📏 Rúbrica de evaluación

Cada entrega se puntúa sobre **100 puntos**, repartidos en **10 categorías**. La nota total es la suma de las categorías. Cada jurado verifica el **código real y la ejecución**, no los comentarios del autor.

| # | Categoría | Máx. | Qué evalúa |
|--:|:--|:--:|:--|
| 1 | **Completitud de escena** | 20 | Sol central, 8 planetas + Plutón (enano), cinturón de asteroides (200+), Saturno con anillos, cometa Halley con cola, 3000+ estrellas de fondo y nebulosas. Se resta por cada elemento ausente o pobre. |
| 2 | **Fidelidad orbital** | 12 | Órbitas **elípticas reales** (no círculos), velocidad orbital tipo **Kepler** (inversa a la distancia), inclinación del plano orbital, inclinación axial por planeta y animación basada en `deltaTime`/`getDeltaTime`. |
| 3 | **Cometa Halley** | 8 | Existe el cometa, órbita excéntrica y, sobre todo, que la **cola apunte en sentido opuesto al Sol**, recalculada cada frame. 0 si no hay cometa. |
| 4 | **Estética / wow** | 15 | Impacto visual, materiales emisivos, atmósferas, bloom/glow real, calidad de las texturas procedurales y sensación inmersiva. |
| 5 | **Panel UI** | 15 | Las 4 secciones del spec con **todos** sus controles funcionales: 2 sliders + pausa; 6 checkboxes + dropdown de 6 vistas + slider de tamaño; tema + bloom + color del sol; panel de info con FPS/objetos/ayuda. |
| 6 | **Cámara y controles** | 8 | `ArcRotateCamera`, auto-rotación, límites de zoom, vistas de cámara y suavidad de los controles. |
| 7 | **Post-procesado** | 6 | `DefaultRenderingPipeline` con bloom, `GlowLayer`, tone mapping; y degradación elegante si falla. |
| 8 | **Rendimiento** | 6 | No crear mallas/materiales/texturas cada frame; uso de **instancias** para el cinturón de asteroides; eficiencia general. |
| 9 | **Robustez** | 5 | `try/catch` donde puede fallar, degradación elegante, manejo de errores y que funcione en `file://`. |
| 10 | **Calidad de código** | 5 | Modularidad, comentarios en español, nombres descriptivos, constantes, sin código muerto ni `console.log` de depuración. |

## Las dos "trampas" de corrección

El spec esconde dos detalles que separan a las entregas excelentes de las meramente vistosas:

1. **El Sol en el foco de la elipse.** Posición correcta: `x = a·cosθ − a·e`, `z = b·sinθ` con `b = a·√(1−e²)`. Centrar el Sol parece correcto pero es física falsa.
2. **La cola del cometa.** El vector "lejos del Sol" es `cometa − Sol`. Invertir el signo (`.negate()`, `.scale(-1)`, o un `normalize()` que muta la posición) hace que la cola apunte hacia el Sol — el bug más común y discriminante del benchmark.

### Un tercer discriminador (hallado en la 6.ª tanda)

La auditoría de la 6.ª tanda destapó un error que **ninguna captura delata** y que
no estaba en la lista original: el **sentido de giro**. BabylonJS usa un sistema
de coordenadas **levógiro**, donde una rotación positiva sobre Y lleva **+X → −Z**
(comprobado en runtime). Si la elipse se recorre con `z = +b·sinE` y la rotación
propia se aplica con `rotation.y += …`, **la revolución y la rotación van en
sentidos opuestos**: los planetas prógrados giran retrógrados, y Venus, Urano y
Plutón —que deberían ser retrógrados por su inclinación axial > 90°— acaban
prógrados. El arreglo es un signo (`z = −b·sinE`), pero encontrarlo exige razonar
sobre la convención del motor, no mirar la pantalla.

No se ha reabierto la puntuación del resto del campo por este motivo: queda
documentado como criterio disponible para futuras tandas.

## Señales objetivas complementarias

Además de la rúbrica, se registran datos de **ejecución real** que ajustan o confirman la nota (ver [methodology.md](methodology.md)):

- **Errores de consola / excepciones** al abrir en navegador (penaliza robustez y completitud).
- **Mallas en escena** (detecta escenas incompletas: p. ej. 29 objetos = sin cinturón ni Plutón).
- **WebGL inicializado** y captura no negra.

## Tiers

| Tier | Rango | Lectura |
|:--:|:--:|:--|
| **S** | 90–100 | Fiel al spec y correcto en los detalles difíciles. |
| **A** | 82–89 | Muy completo con algún fallo concreto. |
| **B** | 75–81 | Completo pero con un requisito nuclear incumplido (típicamente la cola del cometa). |
| **C** | 60–74 | Funciona pero con varios bugs reales. |
| **D** | <60 | Entrega parcial o con fallos graves. |
