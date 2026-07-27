# 📋 Resultados detallados por entrega

Ficha completa de cada combinación **modelo + agente**, con su desglose de rúbrica, datos de ejecución real (Chrome headless), fortalezas, debilidades y veredicto. Datos crudos en [`../assets/benchmark.json`](../assets/benchmark.json).

> Orden por puntuación final (0–100). El nombre de la carpeta indica el modelo y el agente usados. 🆕 = entrada de tanda posterior.


---


## 1. GPT-5.5 · Codex — **97/100** · Tier S

📁 [`codex-gpt-5.5/`](../codex-gpt-5.5/index.html) · 1496 líneas · runtime: **302 objetos**, **0 errores de consola**, WebGL ✓

> _Implementacion sobresaliente y muy completa: cola del cometa y orbitas elipticas resueltas correctamente, UI integra y codigo limpio y robusto; pierde puntos solo por no evidenciar el uso de context7/ParticleHelper y por texturas planetarias simples._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 19 / 20 |
| Fidelidad orbital | 12 / 12 |
| Cometa Halley | 8 / 8 |
| Estética / wow | 13 / 15 |
| Panel UI | 15 / 15 |
| Cámara y controles | 8 / 8 |
| Post-procesado | 6 / 6 |
| Rendimiento | 6 / 6 |
| Robustez | 5 / 5 |
| Calidad de código | 5 / 5 |
| **Total** | **97 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ✅ Plutón · ✅ Cinturón · ✅ Instancing · ✅ Anillos Saturno · ✅ Cola Halley · ✅ Cola opuesta al Sol · ✅ 3000+ estrellas · ✅ Nebulosas · ✅ Órbitas elípticas · ✅ Bloom/Glow · ✅ Panel completo · ✅ Vistas cámara · ✅ deltaTime · ❌ Consulta docs

**Fortalezas**

- Cola del cometa CORRECTA: dir = comet - sol (vector desde el sol hacia el cometa) recalculado cada frame en las lineas 1430-1435, con emisor Vector3 en espacio mundo y comentario que demuestra entender por que Babylon no rota las direcciones; la cola apunta de verdad en sentido opuesto al sol.
- Orbitas elipticas reales via posicionEliptica (b=a*sqrt(1-e^2), foco en el sol con x=a*cos-c), usadas tanto para el movimiento como para las lineas de orbita; velocidad Kepleriana 12/distance, doble inclinacion (orbitTilt axial via tilt, Urano a 1.57 rad).
- Panel UI completo y 100% cableado: las 4 secciones, 6 checkboxes, dropdown de 6 vistas con transiciones suaves y seguimiento, sliders, tema/bloom/color-sol, panel info con FPS coloreado y conteo de objetos.
- Robustez y rendimiento solidos: try/catch en corona/glow/pipeline, guarda de CDN, manejo de contexto WebGL perdido, texturas creadas una sola vez, asteroides como instancias (createInstance), animacion acotada por deltaTime.

**Debilidades**

- No se evidencia consulta real a context7 mas alla de un comentario afirmativo (lineas 18-20); ademas no usa ParticleHelper.CreateSystem('sun') que el spec pedia explicitamente (la corona es un ParticleSystem manual, aceptable pero se desvia del requisito).
- Estrellas: minSize/maxSize 1.2-6.0 en lugar del rango 0.3-1.5 del spec (justificado en comentario), y el numero real visible depende de emitRate x lifetime + preWarm, no se garantizan 3000+ instancias simultaneas explicitamente.
- Texturas procedurales de planetas pobres: solo Jupiter tiene bandas; el resto son colores planos sin mapa de superficie, lo que limita el factor wow.
- Anillos de Saturno/Urano son un plano texturizado (no torus 3D); funcional pero menos volumetrico, y las nebulosas son gradientes radiales simples.

---

## 2. Claude Opus 4.8 · Ultracode + Claude Code — **97/100** · Tier S

📁 [`Opus-4.8-Ultracode-Extension-Claude-Code/`](../Opus-4.8-Ultracode-Extension-Claude-Code/index.html) · 1496 líneas · runtime: **302 objetos**, **0 errores de consola**, WebGL ✓

> _Implementacion sobresaliente y muy fiel al spec: cola de cometa correctamente opuesta al sol recalculada por frame y orbitas elipticas reales con el sol en el foco, panel UI completo, post-procesado real y codigo modular bien comentado en espanol._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 19 / 20 |
| Fidelidad orbital | 12 / 12 |
| Cometa Halley | 8 / 8 |
| Estética / wow | 13 / 15 |
| Panel UI | 15 / 15 |
| Cámara y controles | 8 / 8 |
| Post-procesado | 6 / 6 |
| Rendimiento | 6 / 6 |
| Robustez | 5 / 5 |
| Calidad de código | 5 / 5 |
| **Total** | **97 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ✅ Plutón · ✅ Cinturón · ✅ Instancing · ✅ Anillos Saturno · ✅ Cola Halley · ✅ Cola opuesta al Sol · ✅ 3000+ estrellas · ✅ Nebulosas · ✅ Órbitas elípticas · ✅ Bloom/Glow · ✅ Panel completo · ✅ Vistas cámara · ✅ deltaTime · ✅ Consulta docs

**Fortalezas**

- Cola del cometa correctamente recalculada por frame: dir = posMundoCometa - posSol (sol en origen), emitida con potencia positiva 14-22 hacia ese vector, por lo que SIEMPRE apunta en sentido opuesto al sol; el comentario explica con precisión por qué un emisor Vector3 mantiene las direcciones en espacio mundo (lineas 1066-1090, 1430-1435)
- Orbitas elipticas reales con el sol en el FOCO via posicionEliptica (x = a*cos(t) - a*e, z = b*sin(t), b = a*sqrt(1-e^2)); las lineas de orbita usan la misma funcion, asi que coinciden con el movimiento. Velocidad orbital tipo Kepler (12/distance), orbitTilt por planeta, tilt axial por planeta (Urano 1.57 rad ~90deg), todo basado en getDeltaTime()/1000 acotado a 0.05
- Panel UI completo y 100% cableado: 4 secciones, 2 sliders + pausa, 6 checkboxes + dropdown de 6 vistas + slider de tamano, tema + bloom + color de sol, panel info con FPS coloreado y conteo de objetos; ademas loader, panel colapsable y media query <600px
- Rendimiento y robustez solidos: asteroides como createInstance (260) sobre malla base oculta, texturas procedurales creadas una sola vez, sin creacion de mallas/materiales por frame; try/catch en corona/GlowLayer/DefaultRenderingPipeline, guarda de BABYLON undefined y handlers de contexto WebGL perdido/restaurado

**Debilidades**

- No se usa BABYLON.ParticleHelper.CreateSystem('sun') que el spec pide explicitamente para la corona; en su lugar se construye un ParticleSystem manual con createSphereEmitter (funciona y es mas robusto offline, pero se desvia del requisito literal)
- Estrellas y nebulosas algo modestas frente al objetivo wow: estrellas con tamanos 1.2-6.0 (el spec sugiere 0.3-1.5, justificado por la escala pero se aleja del enunciado) y solo 4 nebulosas planas; sin via lactea ni capas de polvo adicionales
- Anillos de Saturno/Urano resueltos como un plano con textura en vez de torus 3D; convincente de frente pero se ve plano en angulos rasantes
- La etiqueta billboard del cometa Halley no existe (solo los planetas tienen label); detalle menor frente al spec que centra los nombres en planetas

---

## 3. Claude Opus 5 · Ultracode + Claude Code — **97/100** · Tier S 🆕

📁 [`Opus-5-Claude-Code-Ultracode/`](../Opus-5-Claude-Code-Ultracode/index.html) · 2432 líneas · runtime: **305 objetos**, **0 errores de consola**, WebGL ✓

> _La entrega mas rigurosa del benchmark: unica con la ecuacion de Kepler resuelta por Newton-Raphson, cinturon de 250 asteroides con orbita propia, preset oficial ParticleHelper cargando de verdad y cero reservas de memoria en el bucle de render, todo verificado en ejecucion con 0 errores, 0 excepciones y cola anti-solar de producto escalar 1.000. Pierde justo donde mas se ve: por respetar al pie de la letra el rango 0.3-1.5 del spec el cielo queda mas tenue que el de sus rivales. Empata en cabeza con 97: gana al lider en fisica, cumplimiento del spec de camara, preset oficial y robustez, y le cede el impacto visual inmediato y 2 fps._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 20 / 20 |
| Fidelidad orbital | 12 / 12 |
| Cometa Halley | 8 / 8 |
| Estética / wow | 13 / 15 |
| Panel UI | 15 / 15 |
| Cámara y controles | 8 / 8 |
| Post-procesado | 6 / 6 |
| Rendimiento | 6 / 6 |
| Robustez | 5 / 5 |
| Calidad de código | 4 / 5 |
| **Total** | **97 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ✅ Plutón · ✅ Cinturón · ✅ Instancing · ✅ Anillos Saturno · ✅ Cola Halley · ✅ Cola opuesta al Sol · ✅ 3000+ estrellas · ✅ Nebulosas · ✅ Órbitas elípticas · ✅ Bloom/Glow · ✅ Panel completo · ✅ Vistas cámara · ✅ deltaTime · ✅ Consulta docs

**Fortalezas**

- Las dos trampas resueltas con margen y verificadas en ejecucion: posicionEnElipse (L1302-1314) usa x = a*(cosE - e), z = -b*sinE con b = a*raiz(1-e^2) y es la MISMA funcion que dibuja la linea de orbita (L1514), asi que cuerpo y elipse no pueden discrepar; y direccionAntiSolar.copyFrom(posicionMundo).normalize() (L2276) copia antes de normalizar, sin negate() ni scale(-1), con producto escalar 1.000 medido contra (cometa - Sol).
- Fisica orbital por encima del lider: resolverKepler (L1280-1290) resuelve M = E - e*senE por Newton-Raphson (2a ley) y movimientoMedio (L1322-1324) aplica n = K/a^1.5 (3a ley), mientras codex-gpt-5.5 avanza un angulo uniforme con orbitalSpeed = 12/p.distance (L922, L1396); ademas cada uno de los 250 asteroides tiene elipse, excentricidad e inclinacion propias (L2238-2250) frente al beltNode.rotation.y += factor*0.03 del lider (L1413).
- Unica entrada que hace funcionar el preset OFICIAL del spec: ParticleHelper.CreateAsync("sun") en L1228-1264, con guarda navigator.onLine, try/catch, corona procedural de respaldo y recoloreo de las paradas de colorGradients para heredar el color del Sol (L1937-1950); el runtime confirma 3 sistemas extra cargados y 0 errores. El lider no usa ParticleHelper en absoluto.
- Respeta los limites de camara del spec como INVARIANTES (lowerRadiusLimit = 30, L660) y consigue los primeros planos bajando el fov a modo de teleobjetivo (0.16 Tierra, 0.42 Saturno, L603-604), mientras el lider los rebaja a 16 con Math.min (L1244); la robustez tambien es superior: try/catch en new BABYLON.Engine (L635), isSupported del pipeline (L1798) y UI real de contexto WebGL perdido frente al simple console.warn del lider (L1484).

**Debilidades**

- El fotograma por defecto se queda vacio: con minSize 0.3 / maxSize 1.5 literales del spec (L1100-1108) las 3600 estrellas caen por debajo del pixel a 1000-1700 unidades y las 5 nebulosas apenas registran a radio 180. El lider incumple ese rango (minSize 1.2 / maxSize 6.0, L733-734) y entrega un cielo mucho mas rico: fidelidad literal ganada, impacto visual perdido.
- El precio de la fidelidad literal al spec: con minSize 0.3 / maxSize 1.5 exactos, las 3600 estrellas son puntos de 1-3 px y el cielo se lee mas tenue que en las entregas que inflaron el rango a proposito (el lider usa 1.2-6.0); las 5 nebulosas, a radio 1500-1800, quedan como neblina y no como manchas definidas.
- Los cuatro desajustes comentario-codigo que detecto el jurado (sprite estelar en anillo por paradas de degradado desordenadas, color1/color2 de las colas anulados por addColorGradient, tema con nebulosas 1.35 que el material satura a 1 y resincronizacion del DOM sin chkBloom) se corrigieron DESPUES de fijar la nota, y la nota no se subio por ello: quedan como aviso de que 2432 lineas son mucha superficie donde los comentarios pueden desfasarse del codigo.
- 6 fps frente a los 8 del lider en el mismo arnes y con 305 mallas: 10 sistemas y 7100 particulas vivas son la carga mas alta del campo, de las cuales 3600 son un campo estelar ESTATICO simulado en CPU y resubido cada frame, mas 250 resoluciones completas de Kepler por frame (L2238-2244) y preserveDrawingBuffer: true (L636). A esto se suman los anillos como torus aplastados (scaling.y = 0.035, L1355), cuya cara superior recibe la luz solar a contra-normal y se lee oscura en la vista que el spec les dedica.

---

## 4. GLM 5.2 · OpenCode — **95/100** · Tier S

📁 [`Opencode-GLM-5.2/`](../Opencode-GLM-5.2/index.html) · 1080 líneas · runtime: **263 objetos**, **0 errores de consola**, WebGL ✓

> _Sobresaliente y muy concisa (1080 líneas): Sol en el foco y cola del cometa opuesta al Sol con Vector3.Normalize estático (sin mutar), instancing real, post-procesado completo y código limpio. Verificada: 263 objetos, 0 errores. Nota ajustada de 99 a 95 por defectos menores._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 19 / 20 |
| Fidelidad orbital | 12 / 12 |
| Cometa Halley | 8 / 8 |
| Estética / wow | 13 / 15 |
| Panel UI | 14 / 15 |
| Cámara y controles | 8 / 8 |
| Post-procesado | 6 / 6 |
| Rendimiento | 6 / 6 |
| Robustez | 4 / 5 |
| Calidad de código | 5 / 5 |
| **Total** | **95 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ✅ Plutón · ✅ Cinturón · ✅ Instancing · ✅ Anillos Saturno · ✅ Cola Halley · ✅ Cola opuesta al Sol · ✅ 3000+ estrellas · ✅ Nebulosas · ✅ Órbitas elípticas · ✅ Bloom/Glow · ✅ Panel completo · ✅ Vistas cámara · ✅ deltaTime · ❌ Consulta docs

**Fortalezas**

- Cola del cometa correcta: Vector3.Normalize estático (no muta la posición), Sol en el origen, recalculada por frame
- Órbitas elípticas con el Sol en el foco (x=a·cosθ−a·e, b=a√(1−e²)); misma fórmula en la línea y el movimiento
- Cinturón con createInstance reales (220 instancias comparten geometría); nada se crea en el render loop
- Post-procesado completo (bloom + tone mapping + vignette + FXAA) y GlowLayer, en try/catch con degradación
- Muy concisa y limpia, JSDoc en español, IIFE con 'use strict'

**Debilidades**

- Al ocultar el cometa, la cola no se detiene: las partículas vivas siguen ~2 s
- El checkbox de bloom apaga también tone mapping y vignette, no solo el bloom
- Etiquetas/atmósfera son hijas del mesh escalado: la etiqueta flota lejos en Júpiter/Saturno
- Las 3000+ estrellas tardan ~1 s en llenarse por la rampa de emisión
- Sin evidencia verificable de consulta a context7

---

## 5. MiniMax M3 · OpenCode — **95/100** · Tier S

📁 [`Opencode-Minimax-M3/`](../Opencode-Minimax-M3/index.html) · 1165 líneas · runtime: **264 objetos**, **0 errores de consola**, WebGL ✓

> _Sólida y calibrada (1165 líneas): clava los tres puntos críticos —cola opuesta al Sol con Vector3.Normalize estático, elipses al foco e instancias reales— con panel completo y degradación elegante. Verificada: 264 objetos, 0 errores._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 19 / 20 |
| Fidelidad orbital | 11 / 12 |
| Cometa Halley | 8 / 8 |
| Estética / wow | 13 / 15 |
| Panel UI | 15 / 15 |
| Cámara y controles | 8 / 8 |
| Post-procesado | 6 / 6 |
| Rendimiento | 6 / 6 |
| Robustez | 5 / 5 |
| Calidad de código | 4 / 5 |
| **Total** | **95 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ✅ Plutón · ✅ Cinturón · ✅ Instancing · ✅ Anillos Saturno · ✅ Cola Halley · ✅ Cola opuesta al Sol · ✅ 3000+ estrellas · ✅ Nebulosas · ✅ Órbitas elípticas · ✅ Bloom/Glow · ✅ Panel completo · ✅ Vistas cámara · ✅ deltaTime · ❌ Consulta docs

**Fortalezas**

- Cola del cometa correcta: Vector3.Normalize estático (no muta), recalculada por frame, alejándose del Sol en el foco
- Órbitas elípticas reales (x=a·cosθ−a·e, b=a√(1−e²)); misma fórmula en línea y movimiento, con inclinación de plano y eje axial por planeta
- Cinturón con createInstance reales (220 instancias sobre malla base oculta), no cientos de mallas
- Panel UI completo y 100% funcional: 4 secciones, 6 checkboxes, dropdown de 6 vistas, temas, bloom y color de Sol

**Debilidades**

- Corona del Sol depende de ParticleHelper.CreateAsync (red); en file:// offline cae al fallback manual
- Kepler simplificado lineal (1/distancia) en vez de 1/√distancia; texturas procedurales modestas
- Usa userData en vez del idiomático mesh.metadata (funciona, no es API nativa)
- Sin evidencia verificable de consulta a context7

---

## 6. Claude Opus 4.8 · Claude Code — **95/100** · Tier S

📁 [`Opus-4.8-Claude-Code/`](../Opus-4.8-Claude-Code/index.html) · 995 líneas · runtime: **260 objetos**, **0 errores de consola**, WebGL ✓

> _Implementacion sobresaliente y casi completa: cola del cometa correctamente opuesta al sol y orbitas elipticas reales bien resueltas, con codigo limpio, modular y robusto; solo le falta Kepler dinamico real y un detalle menor en el color de las estrellas._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 19 / 20 |
| Fidelidad orbital | 10 / 12 |
| Cometa Halley | 8 / 8 |
| Estética / wow | 13 / 15 |
| Panel UI | 15 / 15 |
| Cámara y controles | 8 / 8 |
| Post-procesado | 6 / 6 |
| Rendimiento | 6 / 6 |
| Robustez | 5 / 5 |
| Calidad de código | 5 / 5 |
| **Total** | **95 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ✅ Plutón · ✅ Cinturón · ✅ Instancing · ✅ Anillos Saturno · ✅ Cola Halley · ✅ Cola opuesta al Sol · ✅ 3000+ estrellas · ✅ Nebulosas · ✅ Órbitas elípticas · ✅ Bloom/Glow · ✅ Panel completo · ✅ Vistas cámara · ✅ deltaTime · ❌ Consulta docs

**Fortalezas**

- Cola del cometa CORRECTA: el vector se calcula desde el sol (origen) hacia el cometa y se normaliza, asignandose a direction1/direction2 cada frame, por lo que las particulas salen siempre en sentido OPUESTO al sol (lineas 959-964).
- Orbitas ELIPTICAS reales con el sol en un foco: ellipsePoint() usa x=c+a*cos(t), z=b*sin(t) con b=a*sqrt(1-e^2) y c=a*e; la misma funcion genera la linea de orbita y la posicion del planeta, garantizando coherencia (lineas 462-466, 626, 939).
- Animacion totalmente independiente del frame rate: engine.getDeltaTime()/1000 multiplica todas las velocidades, con factor global y pausa (linea 927-928).
- Rendimiento solido: cinturon de asteroides con createInstance (220 instancias de una sola malla base), texturas procedurales creadas una sola vez, y el render loop solo transforma, no crea geometria.
- Panel UI completo y funcional con las 4 secciones, 6 checkboxes, dropdown de 6 vistas, sliders y panel de info FPS/objetos/ayuda; degradacion robusta con try/catch en ParticleHelper y post-procesado.

**Debilidades**

- Kepler solo parcial: la velocidad orbital es una constante hardcodeada por planeta (decreciente con la distancia) pero la velocidad ANGULAR es constante a lo largo de la elipse; no se aplica la segunda ley de Kepler (mas rapido en perihelio), por lo que el movimiento no acelera cerca del sol.
- Las estrellas amarillas no se renderizan realmente: la variacion blanco/azul esta en color1/color2 pero el tono amarillo solo esta en colorDead, que nunca se aplica porque el lifetime es MAX_VALUE (las particulas no mueren).
- No hay evidencia de consulta a context7/docs oficiales (sin comentarios al respecto), pese a ser REGLA ABSOLUTA del spec, aunque las APIs usadas son correctas.
- Las vistas de camara dinamicas (Tierra/Saturno/Halley) fijan el target cada frame en el render loop, compitiendo con el autoRotationBehavior y con la interaccion del usuario, lo que puede sentirse algo brusco.

---

## 7. MiMo v2.5 Pro · MiMoCode — **95/100** · Tier S

📁 [`Mimo-V2.5-Pro-MimoCode/`](../Mimo-V2.5-Pro-MimoCode/index.html) · 1151 líneas · runtime: **280 objetos**, **0 errores de consola**, WebGL ✓

> _Implementación sobresaliente y muy fiel al spec: cola del cometa correctamente opuesta al Sol recalculada por frame, órbitas elípticas reales con el Sol en el foco, instancing real para asteroides, texturas procedurales para Tierra y Júpiter, panel UI completo y post-procesado robusto con degradación elegante. Verificada: 0 errores de consoma._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 19 / 20 |
| Fidelidad orbital | 11 / 12 |
| Cometa Halley | 8 / 8 |
| Estética / wow | 12 / 15 |
| Panel UI | 15 / 15 |
| Cámara y controles | 8 / 8 |
| Post-procesado | 6 / 6 |
| Rendimiento | 6 / 6 |
| Robustez | 5 / 5 |
| Calidad de código | 5 / 5 |
| **Total** | **95 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ✅ Plutón · ✅ Cinturón · ✅ Instancing · ✅ Anillos Saturno · ✅ Cola Halley · ✅ Cola opuesta al Sol · ✅ 3000+ estrellas · ✅ Nebulosas · ✅ Órbitas elípticas · ✅ Bloom/Glow · ✅ Panel completo · ✅ Vistas cámara · ✅ deltaTime · ❌ Consulta docs

**Fortalezas**

- Cola del cometa CORRECTA: vector away = hPos.subtract(Zero()).normalize() apunta desde el Sol hacia el cometa, asignado a direction1/direction2 cada frame; la cola siempre apunta en sentido opuesto al Sol (líneas 1073-1079).
- Órbitas elípticas reales con el Sol en el foco: ellipticalPosition() usa x=a·cos(θ)−a·e, z=b·sin(θ), b=a·√(1−e²); la misma función genera las líneas de órbita y la posición del planeta, garantizando coherencia total.
- Asteroides con createInstance reales (240 instancias sobre malla base oculta), sin creación de meshes por frame; texturas procedurales para Tierra (continentes) y Júpiter (bandas horizontales).
- Panel UI completo y 100% funcional: 4 secciones con 2 sliders + pausa, 6 checkboxes + dropdown de 6 vistas + slider de tamaño, tema + bloom + color del sol, y panel de info con FPS y conteo de objetos.
- Post-procesado robusto: DefaultRenderingPipeline (bloom + tone mapping ACES + FXAA) y GlowLayer, todo en try/catch con degradación elegante.

**Debilidades**

- No se evidencia consulta real a Context7/documentación oficial (sin comentarios al respecto), aunque todas las APIs usadas son correctas.
- Kepler simplificado lineal (1/distancia) en vez de la segunda ley real (variación de velocidad angular en la elipse).
- Las nebulosas son 4 planos simples con gradiente radial; estética aceptable pero sin capas adicionales de polvo o vía láctea.
- Los anillos de Saturno son un torus 3D (correcto) pero sin textura de partículas ni separación de anillos A/B/C.

---

## 8. Claude Fable 5 · Ultracode + Claude Code — **95/100** · Tier S

📁 [`Fable-5-Claude-Code-Ultracode/`](../Fable-5-Claude-Code-Ultracode/index.html) · 1355 líneas · runtime: **310 objetos**, **0 errores de consola**, WebGL ✓

> _Entrega de primer nivel: fidelidad orbital excepcional (Kepler 1ª+2ª+3ª ley por Newton-Raphson, unica en el campo), cola del cometa correctamente opuesta al Sol con normalizeToNew() que no muta, instancing real, robustez ejemplar (contexto WebGL perdido, degradacion elegante) y panel completo. No alcanza el 97 por las vistas de camara de seguimiento que no hacen zoom. Verificada: 310 mallas, 0 errores de consola._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 19 / 20 |
| Fidelidad orbital | 12 / 12 |
| Cometa Halley | 8 / 8 |
| Estética / wow | 13 / 15 |
| Panel UI | 14 / 15 |
| Cámara y controles | 7 / 8 |
| Post-procesado | 6 / 6 |
| Rendimiento | 6 / 6 |
| Robustez | 5 / 5 |
| Calidad de código | 5 / 5 |
| **Total** | **95 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ✅ Plutón · ✅ Cinturón · ✅ Instancing · ✅ Anillos Saturno · ✅ Cola Halley · ✅ Cola opuesta al Sol · ✅ 3000+ estrellas · ✅ Nebulosas · ✅ Órbitas elípticas · ✅ Bloom/Glow · ✅ Panel completo · ✅ Vistas cámara · ✅ deltaTime · ✅ Consulta docs

**Fortalezas**

- Fidelidad orbital sobresaliente: resuelve la ecuacion de Kepler M=E-e·sinE por Newton-Raphson (1ª, 2ª y 3ª ley), con aceleracion real en el perihelio y movimiento medio proporcional a a^-1.5; algo que casi ninguna otra entrega del campo implementa (lineas 786-920).
- Cola del cometa CORRECTA y a prueba de la trampa: lejosDelSol = posH.normalizeToNew() (NO muta), recalculada cada frame con el Sol en el origen; sin .negate() ni .scale(-1) (linea 1285).
- Sol en el foco de la elipse: posicionOrbital usa x=a·(cosE-e), z=b·sinE, b=a·√(1-e²); la misma funcion genera la linea de orbita y la posicion, garantizando coincidencia exacta (lineas 804-808).
- Robustez ejemplar: try/catch en corona, glow, pipeline y cola; guarda de CDN caido; manejo de webglcontextlost/restored; instancias reales para el cinturon y texturas creadas una sola vez.

**Debilidades**

- Las vistas de seguimiento (Tierra, Saturno, Halley) solo reencuadran el target de la camara pero no hacen zoom (radius/alpha/beta quedan libres); el spec pedia acercarse a la Tierra y a Saturno con anillos visibles (lineas 1215-1226).
- Tamanos de estrellas fuera del rango del spec (1.2-5.2 en vez de 0.3-1.5), decision estetica justificada en comentario pero desviacion real (lineas 710-712).
- Doble control de nebulosas (visibility por tema vs setEnabled por checkbox) que pueden desincronizarse tras cambiar de tema.
- El 'wow' del Sol descansa en un sistema de particulas radial + esfera emisiva: correcto pero no espectacular frente a lo mejor del campo.

---

## 9. Gemini 3.5 (High) · Antigravity — **92/100** · Tier S

📁 [`Antigravity-Gemini-3.5-High/`](../Antigravity-Gemini-3.5-High/index.html) · 1533 líneas · runtime: **42 objetos**, **0 errores de consola**, WebGL ✓

> _Muy completa y pulida (1533 líneas): cola opuesta al Sol (normalizeToNew), elipses al foco y asteroides con thin instances, panel completo y post-pro real. Verificada: renderiza con 0 errores. Nota ajustada de 95 a 92 por Júpiter sin bandas y detalles del spec._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 18 / 20 |
| Fidelidad orbital | 12 / 12 |
| Cometa Halley | 8 / 8 |
| Estética / wow | 11 / 15 |
| Panel UI | 15 / 15 |
| Cámara y controles | 7 / 8 |
| Post-procesado | 6 / 6 |
| Rendimiento | 6 / 6 |
| Robustez | 4 / 5 |
| Calidad de código | 5 / 5 |
| **Total** | **92 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ✅ Plutón · ✅ Cinturón · ✅ Instancing · ✅ Anillos Saturno · ✅ Cola Halley · ✅ Cola opuesta al Sol · ✅ 3000+ estrellas · ✅ Nebulosas · ✅ Órbitas elípticas · ✅ Bloom/Glow · ✅ Panel completo · ✅ Vistas cámara · ✅ deltaTime · ❌ Consulta docs

**Fortalezas**

- Cola del cometa correcta con normalizeToNew (sin mutar), recalculada por frame; modula tamaño según distancia al Sol
- Órbitas elípticas con el Sol en el foco; misma fórmula en línea y movimiento; Kepler + inclinación axial por planeta
- Asteroides con thinInstanceSetBuffer (1 malla base + 220 instancias): óptimo en rendimiento
- Panel UI completo con 6 vistas de cámara y transición suave; post-pro bloom+glow+ACES en try/catch
- Código modular y limpio, JSDoc en español

**Debilidades**

- Júpiter sin bandas horizontales (color plano), pese a pedirlo el spec
- Estrellas justo en el piso de 3000 (3×1000); estética buena pero no espectacular
- Anillos de Saturno como disco plano (CreateDisc), no torus
- Corona del Sol depende de ParticleHelper.CreateAsync (red), con fallback; pulso del Sol por performance.now, no deltaTime
- Contador de objetos aproximado; sin evidencia de consulta a context7

---

## 10. MiniMax M3 · Claude Code — **92/100** · Tier S

📁 [`Minimax-M3-Claude-Code/`](../Minimax-M3-Claude-Code/index.html) · 1062 líneas · runtime: **299 objetos**, **0 errores de consola**, WebGL ✓

> _Implementación sobresaliente y muy fiel al spec: órbitas elípticas reales, cola del cometa correctamente opuesta al sol, post-procesado robusto y panel UI completo; pierde puntos sobre todo por usar clones en vez de instancias en el cinturón de asteroides y una estética algo contenida._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 19 / 20 |
| Fidelidad orbital | 11 / 12 |
| Cometa Halley | 8 / 8 |
| Estética / wow | 12 / 15 |
| Panel UI | 14 / 15 |
| Cámara y controles | 8 / 8 |
| Post-procesado | 6 / 6 |
| Rendimiento | 4 / 6 |
| Robustez | 5 / 5 |
| Calidad de código | 5 / 5 |
| **Total** | **92 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ✅ Plutón · ✅ Cinturón · ❌ Instancing · ✅ Anillos Saturno · ✅ Cola Halley · ✅ Cola opuesta al Sol · ✅ 3000+ estrellas · ✅ Nebulosas · ✅ Órbitas elípticas · ✅ Bloom/Glow · ✅ Panel completo · ✅ Vistas cámara · ✅ deltaTime · ✅ Consulta docs

**Fortalezas**

- Órbitas elípticas reales con el sol en el foco (x = a(cos θ - e), b = a·√(1-e²)) más inclinación de plano y eje axial por planeta, todo con deltaTime cap a 0.1 s
- Cola del cometa recalculada por frame en sentido correctamente OPUESTO al sol (away = posición normalizada desde el origen aplicada a direction1/2 y gravity)
- Post-procesado completo y robusto: DefaultRenderingPipeline (bloom + tone mapping + FXAA) y GlowLayer acotado a sol y cometa, ambos en try/catch con degradación elegante; ParticleHelper.CreateAsync('sun') con corona procedural de respaldo
- Código muy limpio: 17 secciones numeradas igual que el spec, JSDoc en español, constantes en MAYÚSCULAS, sin console.log de debug (solo console.warn de errores reales), IIFE con 'use strict'

**Debilidades**

- Cinturón de asteroides usa proto.clone() para los 260 cuerpos en vez de instancias (createInstance/thinInstance), lo que penaliza eficiencia y draw calls; el rubric pide explícitamente instancias
- Estética algo conservadora: planetas sin texturas de superficie reales salvo las bandas de Júpiter; el 'tema' (Brasa/Plasma/Escarcha/Vacío) solo repinta acentos del panel CSS, no la estética 3D de la escena
- Inclinaciones de plano orbital muy pequeñas (0.00-0.30 rad) y velocidad orbital usa Kepler simplificado lineal (1/distancia) en lugar de 1/distancia^1.5, ambos aceptables por el spec pero modestos
- ParticleHelper.CreateAsync('sun') hace fetch al CDN; sobre file:// puede fallar y emitir un console.warn (capturado, sin romper la escena)

---

## 11. MiMo v2.5 Pro · Claude Code — **90/100** · Tier S

📁 [`Mimo-V2.5-Pro-Claude-Code/`](../Mimo-V2.5-Pro-Claude-Code/index.html) · 1005 líneas · runtime: **260 objetos**, **0 errores de consola**, WebGL ✓

> _Entrega S en el limite inferior: correcta en los dos detalles dificiles (cola opuesta al Sol con .clone(), orbitas elipticas con el Sol en el foco), muy completa (9 planetas, 220 asteroides con instancing, 3200 estrellas) y con codigo limpio. Le falta pulido estetico y arrastra un bug menor de zoom en las vistas de seguimiento. Verificada: 260 mallas, 0 errores de consola._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 18 / 20 |
| Fidelidad orbital | 11 / 12 |
| Cometa Halley | 8 / 8 |
| Estética / wow | 11 / 15 |
| Panel UI | 13 / 15 |
| Cámara y controles | 7 / 8 |
| Post-procesado | 6 / 6 |
| Rendimiento | 6 / 6 |
| Robustez | 5 / 5 |
| Calidad de código | 5 / 5 |
| **Total** | **90 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ✅ Plutón · ✅ Cinturón · ✅ Instancing · ✅ Anillos Saturno · ✅ Cola Halley · ✅ Cola opuesta al Sol · ✅ 3000+ estrellas · ✅ Nebulosas · ✅ Órbitas elípticas · ✅ Bloom/Glow · ✅ Panel completo · ✅ Vistas cámara · ✅ deltaTime · ❌ Consulta docs

**Fortalezas**

- Ambas trampas resueltas correctamente: cola away = cometCore.position.clone().normalize() (usa .clone() para no mutar la posicion) recalculada cada frame; Sol en el foco via ellipsePoint con b=a·√(1-e²) (lineas 970-974, 463-467).
- Degradacion robusta: corona manual garantizada + intento opcional de ParticleHelper.CreateAsync en try/catch; funciona en file:// sin red.
- Rendimiento correcto: 220 asteroides como createInstance reales sobre malla base, cero creacion de mallas en el bucle de render.
- Codigo muy limpio: constantes en MAYUSCULAS, JSDoc en espanol, sin console.log de depuracion, sin APIs inventadas.

**Debilidades**

- Bug de camara: en vistas 'Tierra'/'Saturno' el radius se fija cada frame, impidiendo al usuario hacer zoom mientras sigue esos planetas (lineas 985-988).
- applyCameraView solo cubre sun/wide/system; earth/saturn/halley caen al default y producen un frame de salto antes de que el loop los corrija.
- Estetica correcta pero no deslumbrante: colores planos, sin texturas planetarias reales (solo bandas procedurales para Jupiter).
- Kepler es velocidad hardcodeada decreciente por planeta, no derivada de la segunda ley real.

---

## 12. Gemini 3.5 Flash · Antigravity CLI — **89/100** · Tier A

📁 [`Agy-Gemini-3.5-Flash-Antigravity-CLI/`](../Agy-Gemini-3.5-Flash-Antigravity-CLI/index.html) · 1637 líneas · runtime: **291 objetos**, **0 errores de consola**, WebGL ✓

> _Implementacion muy completa y visualmente solida que cumple los dos puntos criticos (cola del cometa opuesta al sol recalculada por frame y orbitas elipticas reales), con buen post-procesado e instanciacion; pierde puntos por Kepler solo aproximado (sol en el centro, no en foco), robustez escasa y nula evidencia de consulta documental._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 19 / 20 |
| Fidelidad orbital | 9 / 12 |
| Cometa Halley | 8 / 8 |
| Estética / wow | 12 / 15 |
| Panel UI | 14 / 15 |
| Cámara y controles | 8 / 8 |
| Post-procesado | 6 / 6 |
| Rendimiento | 5 / 6 |
| Robustez | 4 / 5 |
| Calidad de código | 4 / 5 |
| **Total** | **89 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ✅ Plutón · ✅ Cinturón · ✅ Instancing · ✅ Anillos Saturno · ✅ Cola Halley · ✅ Cola opuesta al Sol · ✅ 3000+ estrellas · ✅ Nebulosas · ✅ Órbitas elípticas · ✅ Bloom/Glow · ✅ Panel completo · ✅ Vistas cámara · ✅ deltaTime · ❌ Consulta docs

**Fortalezas**

- La cola del cometa Halley se recalcula cada frame y apunta correctamente en sentido OPUESTO al sol: dirOpposite = pos.subtract(Vector3.Zero()).normalize() (sol en origen) escalado positivo en direction1/direction2 (linea 1610-1612)
- Orbitas ELIPTICAS reales via getOrbitPoint con x=a*cos(theta), z=b*sin(theta) y b=a*sqrt(1-e^2); velocidades por planeta inversas a la distancia (Mercurio 0.08 -> Pluton 0.004) cumpliendo Kepler simplificado; animacion basada en engine.getDeltaTime()/1000
- Escena casi completa: sol con corona (ParticleHelper.CreateAsync + fallback), 8 planetas + Pluton enano, 250 asteroides como instancias reales (createInstance), Saturno con anillos, 3500 estrellas fijas, 4 nebulosas con DynamicTexture, texturas procedurales para Tierra/Jupiter
- Post-procesado solido: DefaultRenderingPipeline con bloom + GlowLayer + tone mapping ACES, toggle funcional via bloomEnabled y glowLayer.isEnabled; instanciacion eficiente para asteroides, sin creacion de mallas/materiales por frame

**Debilidades**

- El sol se situa en el CENTRO geometrico de la elipse, no en un foco, y el cuerpo avanza con theta lineal: no hay aceleracion real en perihelio/afelio (Kepler de segunda ley ausente), solo velocidad media inversa a distancia
- Sin evidencia de consulta a context7/docs (regla absoluta del spec): no hay comentarios ni mencion; aunque las APIs usadas son correctas, no se demuestra el proceso de investigacion exigido
- Robustez limitada: un solo try/catch (envuelve ParticleHelper); el resto de la creacion de escena (pipeline, glow, texturas) no tiene proteccion y no hay degradacion elegante si DefaultRenderingPipeline o GlowLayer fallan
- Codigo muerto menor: en el slider de tamano se calcula finalScale (linea 1389) pero nunca se usa; getActiveMeshes() se invoca cada frame solo para el contador, generando overhead innecesario

---

## 13. GLM 5.2 · Claude Code — **89/100** · Tier A

📁 [`GLM-5.2-Claude-Code/`](../GLM-5.2-Claude-Code/index.html) · 1306 líneas · runtime: **279 objetos**, **0 errores de consola**, WebGL ✓

> _Sólida, completa y verificada en runtime real (279 meshes, 0 errores, UI completa, bloom activo). Único defecto real: normalize() in-place colapsa la posición del cometa al origen cada frame. La evaluación previa de 'pantalla negra' fue refutada por la ejecución._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 20 / 20 |
| Fidelidad orbital | 11 / 12 |
| Cometa Halley | 4 / 8 |
| Estética / wow | 13 / 15 |
| Panel UI | 15 / 15 |
| Cámara y controles | 8 / 8 |
| Post-procesado | 6 / 6 |
| Rendimiento | 4 / 6 |
| Robustez | 4 / 5 |
| Calidad de código | 4 / 5 |
| **Total** | **89 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ✅ Plutón · ✅ Cinturón · ❌ Instancing · ✅ Anillos Saturno · ✅ Cola Halley · ❌ Cola opuesta al Sol · ✅ 3000+ estrellas · ✅ Nebulosas · ✅ Órbitas elípticas · ✅ Bloom/Glow · ✅ Panel completo · ✅ Vistas cámara · ✅ deltaTime · ❌ Consulta docs

**Fortalezas**

- Escena completa verificada en runtime: 279 meshes, 0 excepciones, UI con 4 secciones operativa
- Órbitas elípticas reales con el Sol en el foco e inclinación de plano por planeta
- Post-procesado robusto (DefaultRenderingPipeline + GlowLayer) en try/catch con degradación grácil
- Sun con doble estrategia: corona procedural + ParticleHelper.CreateAsync('sun') si hay red

**Debilidades**

- BUG real: nucleoHalley.position.normalize() muta la posición a longitud ~1, pegando el cometa al Sol
- Asteroides por .clone() en vez de instancias → 240 draw calls extra
- 2 de 5 paletas de nebulosa con strings rgba mal cerrados (cosmético, Chrome lo tolera)
- Sin evidencia verificable de consulta a context7

---

## 14. GLM 5.2 (Max) · Zcode — **89/100** · Tier A

📁 [`Zcode-GML-5.2-Max/`](../Zcode-GML-5.2-Max/index.html) · 1275 líneas · runtime: **262 objetos**, **0 errores de consola**, WebGL ✓

> _Completa y bien estructurada (1275 líneas): cola opuesta al Sol (cometa−Sol con .clone()) y elipses al foco, con instancing real y post-pro. Verificada: 262 objetos, 0 errores. Nota ajustada de 92 a 89 porque la inclinación del plano orbital queda anulada (y=0)._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 18 / 20 |
| Fidelidad orbital | 9 / 12 |
| Cometa Halley | 8 / 8 |
| Estética / wow | 11 / 15 |
| Panel UI | 15 / 15 |
| Cámara y controles | 7 / 8 |
| Post-procesado | 6 / 6 |
| Rendimiento | 6 / 6 |
| Robustez | 4 / 5 |
| Calidad de código | 5 / 5 |
| **Total** | **89 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ✅ Plutón · ✅ Cinturón · ✅ Instancing · ✅ Anillos Saturno · ✅ Cola Halley · ✅ Cola opuesta al Sol · ✅ 3000+ estrellas · ✅ Nebulosas · ✅ Órbitas elípticas · ✅ Bloom/Glow · ✅ Panel completo · ✅ Vistas cámara · ✅ deltaTime · ❌ Consulta docs

**Fortalezas**

- Cola del cometa correcta (cometa−Sol, .subtract no muta, .clone antes de asignar), recalculada por frame
- Órbitas elípticas con el Sol en el foco; misma fórmula en línea y movimiento
- Asteroides con createInstance reales (220, prototipo oculto)
- Panel UI con las 4 secciones completas y funcionales; post-pro + GlowLayer + ACES en try/catch
- Animación basada en deltaTime en todo el loop

**Debilidades**

- La inclinación del plano orbital está en los datos pero se anula a y=0 en dibujo y movimiento: órbitas coplanares (incumple el spec)
- El seguimiento de cámara para Tierra/Saturno está anidado bajo if(showHalley): ocultar el cometa lo congela
- Vistas de cámara apuntan a mesh.position (origen local) en vez de pivot.position
- Contador de objetos aproximado/hardcodeado (244 vs 262 reales)
- Sin evidencia de consulta a context7

---

## 15. MiMo v2.5 Pro · OpenCode — **89/100** · Tier A

📁 [`Mimo-V2.5-Pro-OpenCode/`](../Mimo-V2.5-Pro-OpenCode/index.html) · 1239 líneas · runtime: **263 objetos**, **0 errores de consola**, WebGL ✓

> _Entrega A en el techo del tier: correcta en los dos detalles dificiles (cola opuesta al Sol con Vector3.Normalize estatico, Sol en el foco elíptico consistente en toda la escena), panel completo y ingenieria solida. La separa de S la falta de pulido estetico y un aro de Saturno con bloom excesivo que domina la captura. Verificada: 263 mallas, 0 errores de consola._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 17 / 20 |
| Fidelidad orbital | 11 / 12 |
| Cometa Halley | 8 / 8 |
| Estética / wow | 11 / 15 |
| Panel UI | 14 / 15 |
| Cámara y controles | 7 / 8 |
| Post-procesado | 6 / 6 |
| Rendimiento | 5 / 6 |
| Robustez | 5 / 5 |
| Calidad de código | 5 / 5 |
| **Total** | **89 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ✅ Plutón · ✅ Cinturón · ✅ Instancing · ✅ Anillos Saturno · ✅ Cola Halley · ✅ Cola opuesta al Sol · ✅ 3000+ estrellas · ✅ Nebulosas · ✅ Órbitas elípticas · ✅ Bloom/Glow · ✅ Panel completo · ✅ Vistas cámara · ✅ deltaTime · ✅ Consulta docs

**Fortalezas**

- Ambas trampas resueltas y consistentes en toda la escena: away = Vector3.Normalize(h.position) (forma estatica que NO muta) para la cola, y ellipsePoint con x=a·cos-a·e para el foco, usado igual en orbitas, planetas y Halley (lineas 1161-1163, 679-681).
- Panel UI completo y funcional: las 4 secciones cableadas, incluida degradacion de bloom/glow y sizeScale que reescala planetas en vivo.
- Ingenieria solida: instancias para asteroides, texturas compartidas, post-pro y ParticleHelper envueltos en try/catch con fallback de corona manual.
- Codigo limpio y modular con IIFE + use strict, JSDoc en espanol y constantes en MAYUSCULAS, sin logs de depuracion.

**Debilidades**

- Anillos de Saturno con bloom excesivo: en la captura real un aro blanco sobreexpuesto domina el primer plano y tapa parte de la escena, restando en estetica/wow.
- Estetica meramente correcta: texturas procedurales en canvas simples (gradientes/bandas), no espectaculares.
- Orbitas con velocidad angular constante: no modela la segunda ley de Kepler (mas rapido en perihelio).
- La corona del Sol depende de ParticleHelper.CreateAsync('sun') que hace fetch remoto; bajo file:// sin red cae al fallback (aceptable, pero la corona 'oficial' puede no aparecer).

---

## 16. Gemini 3.6 Flash (High) · Antigravity — **89/100** · Tier A 🆕

📁 [`Antigravity-Gemini-3.6-Flash-High/`](../Antigravity-Gemini-3.6-Flash-High/index.html) · 1249 líneas · runtime: **259 objetos**, **0 errores de consola**, WebGL ✓

> _Tier A sólido (89). Acierta las DOS trampas decisivas —Sol en el foco (b=a·√(1−e²), x=a·cosθ−a·e) en órbita y animación, y cola del cometa opuesta al Sol sin mutación (cometa−Sol por frame)— con escena completa (259 mallas, 0 errores), post-procesado y panel de 4 secciones íntegros. Queda por debajo de su hermana 3.5-High (92) principalmente porque NO usa instancing: los 220 asteroides son mallas por-asteroide, lo que rebaja rendimiento, sumado a una velocidad orbital tuneada a mano en vez de Kepler estricto._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 19 / 20 |
| Fidelidad orbital | 11 / 12 |
| Cometa Halley | 7 / 8 |
| Estética / wow | 13 / 15 |
| Panel UI | 14 / 15 |
| Cámara y controles | 7 / 8 |
| Post-procesado | 6 / 6 |
| Rendimiento | 4 / 6 |
| Robustez | 4 / 5 |
| Calidad de código | 4 / 5 |
| **Total** | **89 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ✅ Plutón · ✅ Cinturón · ❌ Instancing · ✅ Anillos Saturno · ✅ Cola Halley · ✅ Cola opuesta al Sol · ✅ 3000+ estrellas · ✅ Nebulosas · ✅ Órbitas elípticas · ✅ Bloom/Glow · ✅ Panel completo · ✅ Vistas cámara · ✅ deltaTime · ❌ Consulta docs

**Fortalezas**

- Ambas trampas correctas: Sol en el foco con la fórmula canónica (b=a·√(1−e²), focusOffset=a·e, x=a·cosθ−focusOffset, z=b·sinθ) tanto en la línea de órbita como en la animación por frame; Plutón (e=0.248) y Halley (e=0.85) muestran elipses claramente excéntricas con el Sol desplazado.
- Cola del cometa opuesta al Sol sin bug de mutación: normaliza el Vector3 NUEVO que devuelve nucleo.position.subtract(sunPos) (cometa−Sol) y lo recalcula cada frame.
- Escena muy completa (259 mallas, 0 errores): Sol, 8 planetas + Plutón enano, 3200 estrellas, 4 nebulosas, anillos de Saturno, cometa; post-procesado real (DefaultRenderingPipeline bloom + ACES + GlowLayer) envuelto en try/catch con degradación elegante.
- Panel UI con las 4 secciones y todos los controles cableados (2 sliders + pausa, 6 checkboxes + dropdown de 6 vistas + slider de escala, tema + bloom + color del Sol, overlay FPS/objetos); animación acotada por deltaTime.

**Debilidades**

- Sin instancing real del cinturón: crea 220 mallas individuales con MeshBuilder.CreateSphere('asteroid_'+i) (comparten material pero no usan thinInstances ni createInstance) — penaliza rendimiento.
- Velocidad orbital asignada a mano por planeta (campo speed), no derivada de Kepler (v∝1/√a); el comentario lo afirma pero el código no lo calcula.
- Leves recuadros oscuros tras las etiquetas billboard (fondo redondeado semiopaco), visibles en la captura.
- Sin evidencia de consulta a Context7; el seguimiento de cámara solo apunta al origen cambiando el radio, sin reencuadres diferenciados por vista.

---

## 17. DeepSeek V4 Pro · CodeWhale — **88/100** · Tier A

📁 [`codewhale-deepseek-v4-pro/`](../codewhale-deepseek-v4-pro/index.html) · 1251 líneas · runtime: **288 objetos**, **0 errores de consola**, WebGL ✓

> _Implementacion solida y muy completa que acierta en los dos puntos criticos (cola del cometa opuesta al sol recalculada por frame y orbitas elipticas reales con foco en el sol), con codigo limpio y UI completa; su mayor lastre es el rendimiento por no instanciar los 250 asteroides._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 19 / 20 |
| Fidelidad orbital | 11 / 12 |
| Cometa Halley | 8 / 8 |
| Estética / wow | 11 / 15 |
| Panel UI | 14 / 15 |
| Cámara y controles | 7 / 8 |
| Post-procesado | 6 / 6 |
| Rendimiento | 3 / 6 |
| Robustez | 4 / 5 |
| Calidad de código | 5 / 5 |
| **Total** | **88 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ✅ Plutón · ✅ Cinturón · ❌ Instancing · ✅ Anillos Saturno · ✅ Cola Halley · ✅ Cola opuesta al Sol · ✅ 3000+ estrellas · ✅ Nebulosas · ✅ Órbitas elípticas · ✅ Bloom/Glow · ✅ Panel completo · ✅ Vistas cámara · ✅ deltaTime · ❌ Consulta docs

**Fortalezas**

- Cola del cometa Halley correctamente recalculada cada frame apuntando en sentido OPUESTO al sol: usa cometPos.normalize() desde el origen (sol) como direccion del emisor (lineas 927-934), tecnicamente correcta
- Orbitas elipticas reales con semi-eje menor b=a*sqrt(1-e^2) y desplazamiento del foco cOffset=a*e tanto en las lineas de orbita (createOrbitLine) como en el movimiento (lineas 871-888); el sol queda en el foco
- Panel UI muy completo: las 4 secciones del spec con todos los controles cableados (2 sliders + pausa, 6 checkboxes + dropdown 6 vistas + slider tamano, tema + bloom + color sol, panel info con FPS/objetos/ayuda)
- Codigo limpio y modular: JSDoc en espanol, constantes en UPPER_SNAKE_CASE (PLANETS, SUN_COLORS, CAMERA_VIEWS), nombres descriptivos, sin console.log de debug (solo console.warn legitimos en catch), sin codigo muerto

**Debilidades**

- Cinturon de asteroides creado como 250 mallas CreateSphere independientes, cada una con su propio StandardMaterial (lineas 686-700); el spec pedia instancias. Genera ~250 draw calls y 250 materiales: gran ineficiencia de rendimiento, no usa createInstance/thinInstance ni SolidParticleSystem
- Velocidad orbital constante en angulo a lo largo de cada orbita: no implementa la 2a ley de Kepler (mas rapido en perihelio); el factor Kepler solo se aplica planeta-a-planeta via orbitalSpeed
- scene.clearColor recibe Color3 (lineas 1091, 1160) cuando Babylon espera Color4; tolerado por el motor pero tecnicamente incorrecto. Ademas falta texturizado real en planetas (colores difusos planos, sin bandas en Jupiter pese al spec)
- Sin evidencia de consulta a Context7/docs oficiales (regla absoluta del spec); las APIs son correctas pero no hay indicios de la investigacion exigida

---

## 18. DeepSeek V4 Pro · Pi — **88/100** · Tier A

📁 [`Pi-DeepSeek-v4-pro/`](../Pi-DeepSeek-v4-pro/index.html) · 1575 líneas · runtime: **301 objetos**, **0 errores de consola**, WebGL ✓

> _Sólida y correcta (1575 líneas): acierta las dos trampas (foco elíptico y cola anti-solar) donde la otra entrada DeepSeek falló; pierde puntos por el zoom de cámara anulado en varias vistas, Kepler aproximado y logs de debug. Verificada: 301 objetos, 0 errores._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 19 / 20 |
| Fidelidad orbital | 10 / 12 |
| Cometa Halley | 8 / 8 |
| Estética / wow | 12 / 15 |
| Panel UI | 13 / 15 |
| Cámara y controles | 6 / 8 |
| Post-procesado | 6 / 6 |
| Rendimiento | 5 / 6 |
| Robustez | 5 / 5 |
| Calidad de código | 4 / 5 |
| **Total** | **88 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ✅ Plutón · ✅ Cinturón · ✅ Instancing · ✅ Anillos Saturno · ✅ Cola Halley · ✅ Cola opuesta al Sol · ✅ 3000+ estrellas · ✅ Nebulosas · ✅ Órbitas elípticas · ✅ Bloom/Glow · ✅ Panel completo · ✅ Vistas cámara · ✅ deltaTime · ✅ Consulta docs

**Fortalezas**

- Cola del cometa CORRECTA (cometa−Sol con vector fresco, sin mutación in-place), recalculada por frame; corrige el fallo de la otra entrada DeepSeek
- Órbitas elípticas con el Sol en el foco; la MISMA función alimenta línea, planetas y Halley, con inclinación de plano por planeta
- Asteroides con createInstance reales (260, geometría/material compartidos); post-pro completo (bloom+glow+tonemap+FXAA) con guard y degradación
- UI de 4 secciones completa y cableada; robustez sólida (file://, contexto WebGL perdido, optional chaining)

**Debilidades**

- El render loop fija camera.radius cada frame en vistas Sol/Tierra/Saturno/Halley/Panorámica, anulando el zoom con rueda en esas vistas
- Kepler aproximado: velocidades constantes hand-tuned, sin aceleración real en perihelio
- 5 console.log decorativos de arranque (el spec prohíbe logs de debug)
- Excentricidades muy bajas en varios planetas hacen sus órbitas casi circulares

---

## 19. Claude Sonnet 4.6 · Antigravity IDE — **86/100** · Tier A

📁 [`Claude-Sonnet-4.6-Antigravity-IDE/`](../Claude-Sonnet-4.6-Antigravity-IDE/index.html) · 1592 líneas · runtime: **263 objetos**, **0 errores de consola**, WebGL ✓

> _Implementacion muy completa, pulida y bien estructurada con UI y post-procesado sobresalientes, penalizada sobre todo por un bug clave: la cola del cometa Halley apunta hacia el sol en lugar de en sentido opuesto._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 18 / 20 |
| Fidelidad orbital | 9 / 12 |
| Cometa Halley | 4 / 8 |
| Estética / wow | 12 / 15 |
| Panel UI | 15 / 15 |
| Cámara y controles | 8 / 8 |
| Post-procesado | 6 / 6 |
| Rendimiento | 5 / 6 |
| Robustez | 4 / 5 |
| Calidad de código | 5 / 5 |
| **Total** | **86 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ✅ Plutón · ✅ Cinturón · ✅ Instancing · ✅ Anillos Saturno · ✅ Cola Halley · ❌ Cola opuesta al Sol · ✅ 3000+ estrellas · ✅ Nebulosas · ✅ Órbitas elípticas · ✅ Bloom/Glow · ✅ Panel completo · ✅ Vistas cámara · ✅ deltaTime · ✅ Consulta docs

**Fortalezas**

- Panel de UI completo y 100% funcional: las 4 secciones con todos los controles conectados (2 sliders + pausa, 6 checkboxes + dropdown de 6 vistas + slider de tamano, tema + bloom + color de sol, panel info con FPS/objetos/ayuda)
- Orbitas elipticas reales mediante posicionElipse (semieje mayor a, semieje menor b = a*sqrt(1-e^2)); las lineas de orbita usan la misma funcion que el movimiento, por lo que coinciden visualmente
- Post-procesado solido y real: DefaultRenderingPipeline con bloom, GlowLayer dirigido al sol y cometa, y tone mapping ACES, todo envuelto en try/catch con degradacion elegante
- Codigo muy limpio y modular: JSDoc en espanol, nombres descriptivos, constantes en MAYUSCULAS, asteroides con createInstance (instancing), sin console.log de debug (solo 2 console.error para fallos reales)

**Debilidades**

- BUG critico en la cola del cometa: dirDesdeCometa = pos.negate().normalize() apunta DESDE el cometa HACIA el sol (hacia el origen), y ese vector se usa como direccion de emision, por lo que la cola apunta hacia el sol en vez de en sentido opuesto; el comentario 'negado = lejos del sol' es erroneo. Requisito clave del spec incumplido
- Fidelidad orbital parcial: el sol queda en el CENTRO geometrico de la elipse, no en un foco; la velocidad angular es constante por orbita (no hay aceleracion en perihelio tipo Kepler real); varios planetas tienen excentricidad minima (0.01-0.02) por lo que sus orbitas se ven casi circulares
- El cinturon de asteroides orbita sobre circulos (cos/sin con distancia fija) en lugar de usar el helper eliptico; las 'bandas horizontales' de Jupiter son solo un color plano, sin bandas reales (textura procedural ausente)
- Pequenas asignaciones por frame en la cola (nuevos Vector3 en direction1/2 cada frame) y lowerRadiusLimit=8 en vez del 30 que pide el spec; no usa ParticleHelper.CreateSystem('sun') que el spec menciona explicitamente (sustituido por ParticleSystem manual)

---

## 20. Gemini 3.6 Flash · Antigravity CLI — **85/100** · Tier A 🆕

📁 [`Agy-Gemini-3.6-Flash-Antigravity-CLI/`](../Agy-Gemini-3.6-Flash-Antigravity-CLI/index.html) · 1510 líneas · runtime: **320 objetos**, **0 errores de consola**, WebGL ✓

> _Tier A (85). Resuelve correctamente las DOS trampas —Sol en el foco (c=a·e, x=a·cosθ−c, b=a·√(1−e²)) y cola opuesta al Sol con vector nuevo cometa−Sol recalculado cada frame— y usa instancing real vía createInstance (280 instancias), deltaTime y Kepler inverso a la distancia, con panel de 4 secciones completo y post-procesado con degradación elegante (320 mallas, 0 errores). No alcanza a su hermana 3.5-Flash (89) por el detractor estético real y visible —parches blancos tras las etiquetas— que penaliza la estética, más pequeñas ineficiencias de asignaciones por frame._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 18 / 20 |
| Fidelidad orbital | 11 / 12 |
| Cometa Halley | 7 / 8 |
| Estética / wow | 10 / 15 |
| Panel UI | 14 / 15 |
| Cámara y controles | 7 / 8 |
| Post-procesado | 5 / 6 |
| Rendimiento | 5 / 6 |
| Robustez | 4 / 5 |
| Calidad de código | 4 / 5 |
| **Total** | **85 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ✅ Plutón · ✅ Cinturón · ✅ Instancing · ✅ Anillos Saturno · ✅ Cola Halley · ✅ Cola opuesta al Sol · ✅ 3000+ estrellas · ✅ Nebulosas · ✅ Órbitas elípticas · ✅ Bloom/Glow · ✅ Panel completo · ✅ Vistas cámara · ✅ deltaTime · ❌ Consulta docs

**Fortalezas**

- Ambas trampas correctas: en calculateOrbitalPosition el Sol queda en el FOCO (c=a·e, x=a·cosθ−c, z=b·sinθ con b=a·√(1−e²)) — física orbital verdadera, no centrada.
- Cola del cometa físicamente correcta: tailDir = hPos.subtract(Zero).normalize() apunta desde el Sol hacia el cometa (cometa−Sol) y se recalcula cada frame; subtract() devuelve un vector nuevo, así que el normalize() in-place no corrompe la posición.
- Instancing real del cinturón: baseAsteroid.createInstance('ast_'+i) con 280 instancias sobre una malla base deshabilitada — sin mallas por-asteroide; escena más rica del par (320 mallas, 0 errores).
- Animación 100% basada en deltaTime con Kepler inverso a la distancia, inclinación orbital y axial por planeta; panel UI completísimo (13 controles cableados en las 4 secciones) y post-procesado bloom + ACES + GlowLayer en try/catch.

**Debilidades**

- Parches blancos prominentes tras las etiquetas de planetas en la ejecución real: el plano billboard de label usa flare/emissive que no resuelve bien el alpha del fondo — detractor estético visible que resta en estética pese a la escena rica.
- Asignaciones de Vector3 nuevas cada frame por planeta generan garbage; no crea mallas/materiales pero es ineficiente.
- La 'consulta a docs' solo aparece como bloque de comentarios listando APIs; sin evidencia verificable de consulta a Context7.
- El cinturón rota como bloque (contenedor) en lugar de órbitas individuales; sin try/catch global alrededor de la inicialización.

---

## 21. Kimi K2.7 · Claude Code — **80/100** · Tier B

📁 [`Kimi-k.7-code-Claude-Code/`](../Kimi-k.7-code-Claude-Code/index.html) · 696 líneas · runtime: **277 objetos**, **1 errores de consola**, WebGL ✓

> _Implementacion solida, completa y bien estructurada con UI y post-procesado ejemplares, pero con un fallo clave: la cola del cometa apunta hacia el sol en vez de en sentido opuesto, ademas de asteroides sin instanciar y estrellas con emision dudosa._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 17 / 20 |
| Fidelidad orbital | 9 / 12 |
| Cometa Halley | 3 / 8 |
| Estética / wow | 11 / 15 |
| Panel UI | 15 / 15 |
| Cámara y controles | 7 / 8 |
| Post-procesado | 6 / 6 |
| Rendimiento | 3 / 6 |
| Robustez | 4 / 5 |
| Calidad de código | 5 / 5 |
| **Total** | **80 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ✅ Plutón · ✅ Cinturón · ❌ Instancing · ✅ Anillos Saturno · ✅ Cola Halley · ❌ Cola opuesta al Sol · ✅ 3000+ estrellas · ✅ Nebulosas · ✅ Órbitas elípticas · ✅ Bloom/Glow · ✅ Panel completo · ✅ Vistas cámara · ✅ deltaTime · ❌ Consulta docs

**Fortalezas**

- Panel de configuracion completo y funcional: las 4 secciones del spec con sus 2 sliders+pausa, 6 checkboxes+dropdown de 6 vistas+slider de tamano, tema+bloom+color de sol, y panel info con FPS/objetos/ayuda; todos los listeners conectados al estado y a la escena.
- Animacion correctamente independiente del frame rate usando engine.getDeltaTime()/1000 en sol, planetas, asteroides y cometa; velocidad orbital inversa a la distancia (Mercurio 4.0 -> Pluton 0.38).
- Post-procesado completo y robusto: DefaultRenderingPipeline con bloom (threshold/weight/kernel), GlowLayer y tone mapping/exposure/contrast, todo envuelto en try/catch con degradacion elegante.
- Codigo limpio y modular: constantes en MAYUSCULAS (PLANETS, ASTEROID_BELT, HALLEY_CONFIG, CAMERA_CONFIG), JSDoc en espanol por funcion, nombres descriptivos, sin console.log de debug ni codigo muerto.

**Debilidades**

- BUG CRITICO en la cola del cometa: en updateHalleyPosition() el vector 'away' = position.subtract(Zero()).normalize().negate() apunta DESDE el cometa HACIA el sol; tanto direction1/2 como gravity usan ese vector, por lo que la cola apunta hacia el sol en vez de en sentido opuesto (el .negate() esta de mas). Se recalcula por frame pero en la direccion equivocada.
- Asteroides creados como 240 mallas CreateSphere independientes (comparten material pero NO usan instancias/SPS), penalizando el rendimiento que el spec premia explicitamente.
- Estrellas con riesgo de no renderizar: ParticleSystem con updateSpeed=0 y sin manualEmitCount; al no avanzar el tiempo del sistema la emision puede quedar nula o muy escasa, comprometiendo el fondo de 3000+ estrellas.
- Orbitas elipticas centradas en el origen (sol en el centro, no en el foco) y de baja excentricidad para la mayoria de planetas, por lo que visualmente casi no se distinguen de circulos; el cometa si usa la ecuacion polar con foco correcto.

---

## 22. Kimi K2.7 · Kimi Code CLI — **79/100** · Tier B

📁 [`kimi-k2.7-code-Kimi-Code-CLI/`](../kimi-k2.7-code-Kimi-Code-CLI/index.html) · 541 líneas · runtime: **277 objetos**, **1 errores de consola**, WebGL ✓

> _Implementación muy completa y visualmente sólida con UI fiel y post-procesado correcto, pero con el bug clave de que la cola del cometa apunta hacia el sol en vez de en sentido opuesto, sin instancing para asteroides y sin evidencia de consulta a context7._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 18 / 20 |
| Fidelidad orbital | 9 / 12 |
| Cometa Halley | 4 / 8 |
| Estética / wow | 11 / 15 |
| Panel UI | 14 / 15 |
| Cámara y controles | 7 / 8 |
| Post-procesado | 6 / 6 |
| Rendimiento | 3 / 6 |
| Robustez | 4 / 5 |
| Calidad de código | 3 / 5 |
| **Total** | **79 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ✅ Plutón · ✅ Cinturón · ❌ Instancing · ✅ Anillos Saturno · ✅ Cola Halley · ❌ Cola opuesta al Sol · ✅ 3000+ estrellas · ✅ Nebulosas · ✅ Órbitas elípticas · ✅ Bloom/Glow · ✅ Panel completo · ✅ Vistas cámara · ✅ deltaTime · ❌ Consulta docs

**Fortalezas**

- Escena muy completa: sol con corona por ParticleHelper, 8 planetas + Plutón enano, cinturón de 240 asteroides, Saturno con torus de anillos, cometa Halley, 4000 estrellas y 4 nebulosas billboard; todo en un solo archivo file://.
- Post-procesado correcto y completo: DefaultRenderingPipeline con bloom (threshold/weight/kernel), GlowLayer y tone mapping/exposure/contrast, todo dentro de try/catch con degradación elegante.
- Animación 100% basada en deltaTime (engine.getDeltaTime()/1000); velocidades orbitales decrecientes con la distancia (Kepler simplificado) y asteroides con 1/sqrt(r) real; texturas procedurales reales para Tierra y bandas de Júpiter.
- Panel UI muy fiel al spec: 4 secciones con 2 sliders + pausa, 6 checkboxes + dropdown de 6 vistas + slider tamaño, tema + bloom + color sol, e info con FPS/objetos/ayuda; cámara ArcRotate con autoRotationBehavior y límites de zoom.

**Debilidades**

- BUG CRÍTICO en la cola del cometa: en updateHalleyPosition la variable 'away' se calcula como position.normalize().negate(), que apunta HACIA el sol (no en sentido opuesto). direction1/direction2/gravity usan ese vector invertido, por lo que la cola apunta hacia el sol, justo lo contrario al requisito.
- Rendimiento: el cinturón crea 240 mallas independientes con MeshBuilder.CreateSphere en bucle en vez de usar instancias/thin instances; no hay instancing pese a compartir material.
- Ningún indicio de consulta a context7/documentación oficial; además ParticleHelper.CreateSystem se invoca con un objeto de config como primer argumento (la firma real es CreateSystem(type, ...)), lo que probablemente lanza y deja al sol sin corona (capturado por try/catch).
- El slider de tamaño relativo (state.sizeScale) y el dropdown de tema apenas tienen efecto real sobre las mallas; órbitas centradas en el sol (centro de la elipse) en planetas en vez de en el foco, y bugs menores en countSceneObjects (refs.saturnRings y m.atmosphere nunca se cumplen). Comentarios escasos, sin JSDoc en español.

---

## 23. MiniMax M3 · mini-agent — **79/100** · Tier B

📁 [`mini-agent-MiniMax-M3/`](../mini-agent-MiniMax-M3/index.html) · 1100 líneas · runtime: **260 objetos**, **0 errores de consola**, WebGL ✓

> _Implementacion solida y completa con orbitas elipticas reales y UI excelente, pero falla el requisito clave del cometa (la cola apunta hacia el sol en vez de en sentido opuesto) y no usa instancias para los asteroides._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 17 / 20 |
| Fidelidad orbital | 9 / 12 |
| Cometa Halley | 3 / 8 |
| Estética / wow | 11 / 15 |
| Panel UI | 14 / 15 |
| Cámara y controles | 7 / 8 |
| Post-procesado | 6 / 6 |
| Rendimiento | 3 / 6 |
| Robustez | 4 / 5 |
| Calidad de código | 5 / 5 |
| **Total** | **79 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ✅ Plutón · ✅ Cinturón · ❌ Instancing · ✅ Anillos Saturno · ✅ Cola Halley · ❌ Cola opuesta al Sol · ✅ 3000+ estrellas · ✅ Nebulosas · ✅ Órbitas elípticas · ✅ Bloom/Glow · ✅ Panel completo · ✅ Vistas cámara · ✅ deltaTime · ❌ Consulta docs

**Fortalezas**

- Orbitas elipticas REALES con el sol en uno de los focos: x=a*cos(t)-a*e, z=b*sin(t) con b=a*sqrt(1-e^2), aplicado de forma consistente tanto al dibujar las lineas (lineas 668-673) como a posicionar los planetas en el render loop (lineas 892-893); Mercurio (e=0.20) y Pluton (e=0.45) se ven claramente elipticos.
- Panel de UI muy completo y bien cableado: las 4 secciones del spec con sus 2 sliders + pausa, 6 checkboxes + dropdown de 6 vistas + slider de tamano, tema + bloom + color del sol, y panel de info con FPS/objetos/ayuda; todos los listeners existen y modifican el estado real.
- Post-procesado correcto y robusto: DefaultRenderingPipeline con bloom configurable, GlowLayer, tone mapping ACES y FXAA, todo envuelto en try/catch para degradar elegantemente (lineas 833-855).
- Codigo modular y limpio: funciones helper separadas, JSDoc en espanol, constantes PLANETS/STATE, nombres descriptivos y sin console.log de debug (solo console.warn para errores reales).

**Debilidades**

- FALLO CRITICO del cometa: la cola apunta HACIA el sol, no en sentido opuesto. En linea 783 'toSun' = Vector3.Zero().subtract(position) apunta del cometa al sol, y se asigna directamente a direction1/direction2 (lineas 785-786). El comentario dice 'direccion opuesta al sol' pero el codigo emite hacia el sol; faltaria un .scale(-1).
- Sin instancias para los asteroides: createAsteroidBelt crea 220 CreateSphere individuales, cada uno con su propio StandardMaterial (lineas 698-705). El spec pedia explicitamente instancias; esto es ineficiente (220 mallas + 220 materiales).
- Estrellas en riesgo de no renderizarse: el ParticleSystem de estrellas usa updateSpeed = 0 (linea 464), lo que en BabylonJS suele impedir que el sistema emita/actualice particulas, por lo que el fondo de 3000+ estrellas podria no aparecer.
- Inclinacion del plano orbital simulada con un bamboleo en Y (yOff = sin(angle*2)*tilt*0.3, linea 895) en vez de un plano realmente inclinado; la inclinacion axial es solo una rotacion.z estatica y el tamano se reaplica cada frame duplicando el factor planetSize.

---

## 24. DeepSeek V4 Pro · Pi Coding Agent — **78/100** · Tier B

📁 [`deepseek-v4-pro-Pi-Coding-Agent/`](../deepseek-v4-pro-Pi-Coding-Agent/index.html) · 1276 líneas · runtime: **289 objetos**, **0 errores de consola**, WebGL ✓

> _Implementación sólida y completa con buen post-procesado y UI, pero falla en los dos puntos clave del spec: la cola del cometa apunta hacia el sol (signo invertido) y las órbitas son círculos salvo Plutón._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 19 / 20 |
| Fidelidad orbital | 5 / 12 |
| Cometa Halley | 4 / 8 |
| Estética / wow | 12 / 15 |
| Panel UI | 13 / 15 |
| Cámara y controles | 7 / 8 |
| Post-procesado | 6 / 6 |
| Rendimiento | 3 / 6 |
| Robustez | 5 / 5 |
| Calidad de código | 4 / 5 |
| **Total** | **78 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ✅ Plutón · ✅ Cinturón · ❌ Instancing · ✅ Anillos Saturno · ✅ Cola Halley · ❌ Cola opuesta al Sol · ✅ 3000+ estrellas · ✅ Nebulosas · ❌ Órbitas elípticas · ✅ Bloom/Glow · ✅ Panel completo · ✅ Vistas cámara · ✅ deltaTime · ✅ Consulta docs

**Fortalezas**

- Escena muy completa: sol con corona ParticleHelper.CreateAsync (con fallback manual), 8 planetas + Plutón, 250 asteroides, anillos de Saturno (doble torus), cometa Halley, 3000 estrellas en caja 2000³ y 5 nebulosas con DynamicTexture radial
- Post-procesado solido y bien guardado: DefaultRenderingPipeline con bloom, glowLayer, tone mapping, FXAA y contraste, todo bajo if (pipeline.isSupported); el checkbox de bloom alterna bloomEnabled y glowLayerEnabled en caliente
- Robustez correcta: try/catch alrededor de ParticleHelper con corona de fallback, guardas isSupported, animaciones basadas en engine.getDeltaTime()/1000, y diseño autocontenido que funciona en file://
- Panel UI completo con las 4 secciones y todos los controles cableados (2 sliders + pausa, 6 checkboxes + dropdown de 6 vistas + slider de tamaño, tema + bloom + color del sol, info con FPS/objetos/ayuda), código modular con JSDoc en español y constantes en SNAKE_CASE

**Debilidades**

- BUG critico en la cola del cometa: en el render loop sunToComet = comet.position - origen apunta ALEJÁNDOSE del sol, pero luego tailDir = sunToComet.scale(-1) la invierte, de modo que la cola apunta HACIA el sol, justo lo OPUESTO a lo que pide el spec (la intención y el comentario son correctos, pero el signo está invertido)
- Órbitas NO elípticas: 8 de los 9 cuerpos tienen eccentricity: 0.0 en el array PLANETS, por lo que tanto createOrbits como el bucle de animación generan círculos perfectos; solo Plutón (e=0.25) es elíptico. Además no hay inclinación del plano orbital (todos los planetas en y=0)
- Asteroides creados como 250 mallas y 250 materiales individuales con MeshBuilder.CreateSphere en bucle, sin usar instancias (createInstance/thin instances) como pide la rúbrica; impacto en rendimiento, agravado por asignaciones new Vector3 por frame
- Dos vistas de cámara del dropdown ('Sol cercano' y 'Panorámica') no hacen nada: el render loop solo gestiona Tierra/Saturno/Halley y el resto cae al else (target al origen) sin ajustar radio/zoom. Menor: variable muerta baseSize en el slider de tamaño y dos console.log decorativos al final

---

## 25. Devstral · Vibe — **70/100** · Tier C

📁 [`vibe-devstral/`](../vibe-devstral/index.html) · 960 líneas · runtime: **234 objetos**, **0 errores de consola**, WebGL ✓

> _Renderiza con 0 errores y amplitud completa, pero con bugs reales: cola del cometa hacia el sol, mesh.diameter inexistente (anillos y labels en NaN) y emissionRange no-op (estrellas sin distribuir), más selector Tema muerto y textos truncados._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 15 / 20 |
| Fidelidad orbital | 9 / 12 |
| Cometa Halley | 3 / 8 |
| Estética / wow | 10 / 15 |
| Panel UI | 11 / 15 |
| Cámara y controles | 7 / 8 |
| Post-procesado | 6 / 6 |
| Rendimiento | 4 / 6 |
| Robustez | 2 / 5 |
| Calidad de código | 3 / 5 |
| **Total** | **70 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ✅ Plutón · ✅ Cinturón · ❌ Instancing · ❌ Anillos Saturno · ✅ Cola Halley · ❌ Cola opuesta al Sol · ❌ 3000+ estrellas · ✅ Nebulosas · ✅ Órbitas elípticas · ✅ Bloom/Glow · ❌ Panel completo · ✅ Vistas cámara · ✅ deltaTime · ❌ Consulta docs

**Fortalezas**

- Arranca y renderiza con 0 errores; sistema solar completo (8 planetas + Plutón)
- Animación basada en deltaTime; pausa y velocidades funcionales
- Panel UI de 4 secciones con 6 vistas de cámara y panel inferior de info
- Post-procesado real (bloom + GlowLayer) con degradación en try/catch

**Debilidades**

- BUG: cola del cometa apunta HACIA el sol (sunDirection invertido con .scale(-1))
- BUG: mesh.diameter no existe → anillos de Saturno (NaN) y labels en y=NaN
- BUG: emissionRange no es API real → estrellas agrupadas cerca del origen, sin caja 2000³
- Selector 'Tema' sin listener; textos truncados ('Amari', 'REAUDAR'); APIs inventadas = no consultó docs

---

## 26. Z.ai GLM 5.2 · Claude Code — **54/100** · Tier D

📁 [`Zai-GLM-5.2-Claude-Code/`](../Zai-GLM-5.2-Claude-Code/index.html) · 624 líneas · runtime: **29 objetos**, **0 errores de consola**, WebGL ✓

> _Base orbital excelente y codigo muy limpio, pero entrega parcial: faltan Pluton, asteroides, nebulosas, post-procesado y casi todo el panel UI, ademas de un bug que normaliza la posicion del cometa cada frame._

**Desglose de rúbrica**

| Categoría | Puntos |
|:--|:--:|
| Completitud de escena | 9 / 20 |
| Fidelidad orbital | 11 / 12 |
| Cometa Halley | 5 / 8 |
| Estética / wow | 7 / 15 |
| Panel UI | 4 / 15 |
| Cámara y controles | 6 / 8 |
| Post-procesado | 0 / 6 |
| Rendimiento | 4 / 6 |
| Robustez | 3 / 5 |
| Calidad de código | 5 / 5 |
| **Total** | **54 / 100** |

**Cumplimiento:** ✅ Sol · ✅ 8 planetas · ❌ Plutón · ❌ Cinturón · ❌ Instancing · ✅ Anillos Saturno · ✅ Cola Halley · ✅ Cola opuesta al Sol · ❌ 3000+ estrellas · ❌ Nebulosas · ✅ Órbitas elípticas · ❌ Bloom/Glow · ❌ Panel completo · ❌ Vistas cámara · ✅ deltaTime · ✅ Consulta docs

**Fortalezas**

- Mecanica orbital de altisima fidelidad: elipses reales con el Sol en el foco (x=a(cosE-e), z=b senE) y ecuacion de Kepler resuelta por Newton-Raphson, lo que produce variacion de velocidad tipo 2a ley de Kepler real; ademas inclinacion orbital y axial por planeta
- Animacion correctamente basada en deltaTime (performance.now() con tope de 100ms) multiplicado por la velocidad global, independiente del frame rate
- Codigo limpio y modular: IIFE con 'use strict', comentarios JSDoc en espanol, nombres descriptivos, constantes de datos, sin console.log de debug ni codigo muerto
- La cola del cometa calcula correctamente el vector radial alejandose del Sol y lo recalcula cada frame (direccion conceptualmente opuesta al Sol), con texturas procedurales y blending aditivo

**Debilidades**

- Faltan elementos clave de la escena: NO hay Pluton (solo 8 planetas), NO hay cinturon de asteroides (200+), NO hay nebulosas, y las estrellas son 2400 (por debajo del minimo de 3000). Tampoco hay atmosferas en los planetas
- Bug real en la cola del cometa: usa nucleo.position.normalize() que MUTA la posicion del nucleo a longitud 1 justo antes de scene.render(), colapsando visualmente el cometa cerca del Sol cada frame; ademas cola.maxSize usa length() sobre el vector ya normalizado (~1.0)
- Panel UI muy incompleto frente a las 4 secciones del spec: solo 1 slider (velocidad global) + 1 toggle pausa + 4 checkboxes + boton de tamano binario. Faltan slider de velocidad orbital, checkboxes de cola/asteroides/nebulosas, dropdown de 6 vistas de camara, slider de tamano 0.5-3x, selector de tema, toggle de bloom, selector de color del Sol y panel de info con FPS/numero de objetos
- Sin post-procesado alguno (ni DefaultRenderingPipeline, ni GlowLayer, ni tone mapping) y sin try/catch alrededor de ParticleHelper pese a que el spec lo marca como punto de fallo; limites de zoom (8-900) no coinciden con el spec (30-2000)

---
