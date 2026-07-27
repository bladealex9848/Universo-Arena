# 🌌 Universo 3D — Sistema Solar interactivo (BabylonJS)

> Implementación de **Claude Opus 5 (Claude Code · Ultracode)** para la
> *Universo-Arena*, siguiendo [`Prompt-Maestro_v2.txt`](../Prompt-Maestro_v2.txt).

Simulación 3D completa del Sistema Solar en **un único `index.html`
autocontenido**: se abre con doble clic (`file://`) en cualquier navegador
moderno, sin servidor, sin build y sin assets locales. La única dependencia es
**BabylonJS** desde su CDN oficial; todas las texturas son procedurales
(generadas con `DynamicTexture` en tiempo de ejecución).

---

## ▶️ Cómo ejecutarlo

1. Doble clic en `index.html` (Chrome, Edge o Firefox).
2. Solo hace falta internet para descargar `https://cdn.babylonjs.com/babylon.js`.
3. Si el CDN no responde, la página lo detecta y lo dice en pantalla en vez de
   quedarse en negro.

---

## ✨ Qué hay en la escena

| Elemento | Detalle |
|---|---|
| **Sol** | Núcleo emisivo con **granulación, fáculas y manchas solares** procedurales, halo billboard aditivo, **corona de partículas** propia, `PointLight` en el origen, rotación lenta y pulsado de escala **1.0 ↔ 1.05 cada 3 s**. Además intenta cargar el preset **oficial** `ParticleHelper.CreateAsync("sun")` como capa extra (ver más abajo). |
| **8 planetas + Plutón** | Mercurio, Venus, Tierra, Marte, Júpiter, Saturno, Urano, Neptuno y el enano Plutón, cada uno con tamaño, color, textura, excentricidad, inclinación orbital y **eje axial** propios. |
| **Órbitas keplerianas** | El Sol está en el **foco** de cada elipse y se resuelve la **ecuación de Kepler** `M = E − e·sinE` (Newton-Raphson): los cuerpos **aceleran de verdad en el perihelio** (2.ª ley) y el movimiento medio es `n ∝ a^(−3/2)` (3.ª ley). |
| **Rotación axial real** | Venus (177.4°), Urano (97.8°) y Plutón (122.5°) giran **retrógrados** por su propia inclinación axial, no por un signo negativo ad hoc. |
| **Atmósferas** | Esferas semitransparentes emisivas en Venus, Tierra, Marte, Júpiter, Saturno, Urano y Neptuno. |
| **Anillos** | Saturno con **6 bandas de torus 3D aplanados** (con hueco tipo división de Cassini) y Urano con 2 bandas verticales: volumen real, no un plano texturizado. |
| **Luna** | La Tierra lleva su Luna, con textura de cráteres y órbita propia (extra sobre el spec). |
| **Cinturón de asteroides** | **250 instancias** (`createInstance`, un solo draw call) entre Marte y Júpiter, cada una con su elipse, inclinación, escala y **color propio** (`registerInstancedBuffer`). |
| **Cometa Halley** | Órbita muy excéntrica (**e = 0.85**), período visible ~18 s, núcleo helado + coma, **cola de iones** (1400 partículas) y **cola de polvo** (700). Su actividad crece cerca del Sol (∝ 1/d², presión de radiación). |
| **3 600 estrellas** | Tres capas de partículas (blanca, azul y cálida) emitidas de una sola vez en una caja **2000×2000×2000**, con tamaños **exactamente en el rango 0.3–1.5** del spec y vida prácticamente infinita ⇒ estrellas fijas. |
| **5 nebulosas** | Planos enormes y distantes (billboard) con textura procedural de gas y polvo, mezcla aditiva y **máscara radial** para que no se vea el borde del plano. |
| **Post-procesado** | `DefaultRenderingPipeline` (bloom + FXAA + tone mapping **ACES** + viñeta) y `GlowLayer` limitado al Sol y al cometa, ambos con degradación elegante. |

---

## 🎛️ Panel de configuración

Arriba a la derecha, 300 px, fondo `rgba(10,15,30,.85)` con `backdrop-filter`,
plegable y adaptado a móvil (`< 600px`).

- **1 · Tiempo y velocidad** — velocidad global (0–10×), velocidad orbital
  (0.1–3×) y botón **Pausar/Reanudar** (congela la simulación; la cámara sigue
  siendo libre).
- **2 · Visualización** — 6 interruptores (órbitas, nombres, cometa, cola,
  cinturón, nebulosas), selector de **6 vistas de cámara** y slider de **tamaño
  relativo** (0.5–3×) que reescala cuerpos y reubica sus etiquetas.
- **3 · Estética** — **tema** (futurista / clásico / oscuro) que cambia de verdad
  la escena 3D (fondo, luz ambiente, bloom, glow, intensidad de nebulosas),
  interruptor de **bloom/glow** y **color del Sol** (blanco / amarillo / naranja /
  rojo), que afecta a la vez al núcleo, al halo, a la corona y a la luz puntual.
- **4 · Información** (abajo a la izquierda) — **FPS** en vivo (coloreado),
  **objetos en escena**, cuerpo enfocado y ayuda de controles.

**Controles:** `clic izq` rotar · `rueda` zoom · `clic der` pan · auto-rotación
al estar inactivo. **Atajos:** `Espacio` pausar · `O` órbitas · `P` panel.

### Vistas de cámara: teleobjetivo en vez de romper el límite del spec

Las 6 vistas hacen una transición suave (`CubicEase`) de `radius`, `alpha`,
`beta` y `fov`. Hay una tensión real en el spec: exige `lowerRadiusLimit = 30`
**y** un "zoom a la Tierra", que con un planeta de radio 1.1 a 30 unidades sería
un punto. La solución aquí **no rompe ninguno de los dos requisitos**:

- `lowerRadiusLimit = 30` y `upperRadiusLimit = 2000` son **invariantes**: nunca
  se tocan.
- El primer plano se consigue con **teleobjetivo**, reduciendo el campo de
  visión (`camera.fov`: 0.16 rad para la Tierra, 0.42 para Saturno, 0.5 para
  Halley, frente a los 0.8 por defecto). La cámara sigue a 32 unidades, pero la
  Tierra ocupa media pantalla.
- El zoom de rueda usa **`wheelPrecision`** (la propiedad que pide el spec), pero
  reajustada cada frame en función del radio, para que el paso sea proporcional
  en todo el rango 30–2000 sin recurrir a `wheelDeltaPercentage`, que la anularía.

Las vistas de seguimiento (Tierra, Saturno, Halley) además:

- fijan el objetivo **exactamente** sobre el cuerpo (forzando la matriz mundo del
  frame en curso), así que no se quedan rezagadas por más rápido que orbite;
- **acompañan al cuerpo en su vuelta alrededor del Sol**: cada frame se suma a
  `alpha` el incremento de longitud heliocéntrica del planeta. Así el ángulo
  respecto al Sol se conserva y **siempre se ve el hemisferio iluminado**, aunque
  el planeta recorra media órbita; y como es un incremento y no un valor
  absoluto, lo que el usuario gire con el ratón se mantiene encima.

---

## 🧭 Regla absoluta: documentación oficial antes que código

El reto prohíbe inventar APIs. Aquí se hizo en dos capas:

1. **Documentación oficial** (context7, `/babylonjs/documentation` y
   `/websites/babylonjs`): seis consultas paralelas cubriendo partículas,
   mallas/materiales, cámara/luces, post-procesado, engine/matemáticas y
   rendimiento.
2. **Verificación por introspección en el runtime real** (Babylon 9.18 del CDN,
   Chrome headless) de cada firma y constante antes de usarla — porque "la doc no
   lo menciona" no equivale a "no existe", y al revés.

Hallazgos que **cambiaron el diseño** (todos comprobados, no supuestos):

| Hallazgo | Consecuencia en el código |
|---|---|
| **`BABYLON.ParticleHelper.CreateSystem` NO EXISTE** (el spec la pide). La API real es `CreateAsync` / `CreateDefault` / `CreateFromSnippetAsync` / `ExportSet`. | La corona es un `ParticleSystem` procedural; el preset oficial `CreateAsync("sun")` se intenta aparte, protegido. |
| `ParticleHelper.CreateAsync` **descarga por red** su JSON y sus texturas desde `assets.babylonjs.com`; y `CreateDefault` —comprobado en runtime— **también descarga** `assets.babylonjs.com/core/textures/flare.png` y crea un sistema genérico de 30 partículas, no una corona solar. | Ninguna sirve como corona autocontenida. Se llama a `CreateAsync` dentro de `try/catch` + `.catch()` y solo si `navigator.onLine !== false`: si hay red suma detalle; si no, la corona procedural ya está en pantalla. |
| `Animation.CreateAndStartAnimation` devuelve un **`Animatable`**, no una `Animation`: no tiene `setEasingFunction`. | Las transiciones de cámara usan `new Animation` + `setKeys` + `setEasingFunction` + `scene.beginDirectAnimation`. *Detectado en ejecución: cada cambio de vista lanzaba una excepción.* |
| Babylon es **levógiro**: una rotación positiva sobre Y lleva **+X → −Z** (verificado en runtime). | La elipse se recorre en ese mismo sentido (`z = −b·sinE`) para que revolución y rotación propia sean **prógradas** — y que Venus, Urano y Plutón salgan retrógrados *por su inclinación axial*, no por un signo ad hoc. |
| `Vector3.normalize()` **muta el receptor** y devuelve `this`. | La dirección anti-solar se copia a un vector temporal **antes** de normalizar: normalizar la posición del cometa lo teletransportaría a la esfera unidad. |
| `mesh.diameter` no existe (`diameter` solo es opción de `CreateSphere`). | El tamaño se cambia con `mesh.scaling`. |
| `DynamicTexture.drawText(..., clearColor, ...)` pinta un `fillRect` **opaco**. | Las etiquetas se dibujan con `getContext()` + `clearRect()` + `fillText()` + `hasAlpha` + `useAlphaFromDiffuseTexture`. |
| Sin el 4.º y 5.º parámetro, `DynamicTexture` no genera **mipmaps**. | Las texturas de superficie se crean con mipmaps y muestreo trilineal (los planetas centelleaban al alejarse); las de destello, **a propósito sin mipmaps**: una estrella de 1-2 px caía en un mip promediado y se apagaba. |
| **Con `disableLighting = true`, `StandardMaterial` ignora `emissiveTexture`** y solo aplica `emissiveColor` plano. | Sol, halo y nebulosas usan `diffuseTexture` + `diffuseColor` blanco + `emissiveColor` como tinte. *Este fallo se detectó en la captura real: producía un **cuadrado luminoso** alrededor del Sol y rectángulos blancos en las nebulosas.* |
| Un degradado radial que solo varía el **alfa** deja el RGB blanco constante. | Las texturas de destello se pintan sobre **negro opaco**: en mezcla aditiva el negro no suma nada y no hay parches. |
| `Animation.CreateAndStartAnimation` devuelve un **`Animatable`**, que no tiene `setEasingFunction`. | Las transiciones de cámara usan `new Animation` + `setKeys` + `setEasingFunction` + `scene.beginDirectAnimation`. *Detectado en ejecución: cada cambio de vista lanzaba una excepción.* |
| El pipeline no lanza excepciones en hardware pobre: el contrato es `isSupported`. | Se comprueba `isSupported` **y** se envuelve en `try/catch`. |

---

## 🏗️ Arquitectura del código

El `<script>` sigue el **orden estricto** del prompt: constantes y datos → engine
y escena → cámara → luces → helpers de textura → estrellas → Sol → planetas →
órbitas → cinturón → anillos → Halley → nebulosas → post-procesado → UI → bucle
de render → `runRenderLoop` + `resize`.

### Jerarquía de nodos por planeta

```
planoOrbital (TransformNode)   ← inclinación del plano + nodo ascendente
  ├─ órbita (LinesMesh)        ← MISMOS puntos que la animación ⇒ nunca discrepan
  └─ pivote (TransformNode)    ← posición sobre la elipse (se mueve cada frame)
       ├─ ejeAxial (TransformNode)  ← inclinación axial (relativa al plano orbital)
       │    ├─ núcleo    (Mesh)     ← textura procedural + rotación propia
       │    ├─ atmósfera (Mesh)     ← esfera mayor semitransparente emisiva
       │    └─ anillos   (TransformNode → torus 3D)
       ├─ pivoteLuna (TransformNode → Mesh)   ← solo la Tierra
       └─ etiqueta (Plane billboard)          ← NO se escala con el planeta
```

La línea de órbita **cuelga del mismo nodo** que el pivote y se genera con la
misma función `posicionEnElipse()`, así que la trayectoria dibujada y la real son
la misma por construcción.

### Independencia del frame rate

Todo se multiplica por `engine.getDeltaTime() / 1000`, acotado a **0.05 s** para
que recuperar el foco de la pestaña no produzca un salto. La pausa pone el factor
a 0 (congela Sol, planetas, cinturón, Luna y cometa) sin bloquear la cámara.

---

## 🎯 Las dos trampas de corrección — resueltas y medidas

**1. El Sol en el foco de la elipse.**

```js
destino.x = a * (Math.cos(E) - e);        // el centro se desplaza: el foco cae en el origen
destino.z = a * Math.sqrt(1 - e * e) * Math.sin(E);
```

`E` es la anomalía excéntrica obtenida resolviendo `M = E − e·sinE` por
Newton-Raphson (6 iteraciones, tolerancia 1e-10), de modo que además se cumple la
2.ª ley: el cuerpo va más rápido en el perihelio. El signo de `z` es negativo a
propósito: en el sistema **levógiro** de Babylon una rotación positiva sobre Y
lleva +X → −Z, así que recorrer la elipse en ese sentido hace que **revolución y
rotación propia sean prógradas** (y que los cuerpos de inclinación axial > 90°
salgan retrógrados de verdad).

**2. La cola del cometa, siempre opuesta al Sol.**

Con el Sol en el origen, el vector Sol→cometa **es** la posición del cometa:

```js
halley.nucleo.computeWorldMatrix(true);            // posición de ESTE frame
direccionAntiSolar.copyFrom(posicionMundo).normalize();   // copia y luego normaliza
colaIones.direction1.copyFrom(direccionAntiSolar).scaleInPlace(potencia);
```

Sin `.negate()`, sin `.scale(-1)` y sin normalizar la posición del núcleo.
**Medición objetiva en ejecución:** producto escalar entre `direction1` de la cola
y `(cometa − Sol)` normalizado = **1.000** (paralelos ⇒ la cola huye del Sol).
La cola de polvo da **0.984** *a propósito*: va también en sentido anti-solar pero
retrasada hacia la trayectoria, que es justo su curvatura característica real.

---

## 🛡️ Rendimiento y robustez

- **Cero reservas de memoria en el bucle de render**: vectores temporales
  reutilizados (`copyFrom` / `scaleInPlace` / `subtractToRef`), nunca `new`.
- Ninguna malla, material o textura se crea por frame; el cinturón usa
  **instancias** con geometría y material compartidos.
- El HUD (FPS y objetos) se refresca **4 veces por segundo**, no cada frame.
- `try/catch` en corona, preset remoto, `GlowLayer` y pipeline; guarda si el CDN
  no carga; manejo de `onContextLostObservable` / `onContextRestoredObservable`.
- Comentarios **JSDoc en español**, constantes en `MAYÚSCULAS_SNAKE_CASE`, IIFE
  con `"use strict"`, sin código muerto ni `console.log` de depuración (solo
  `console.warn` en los `catch` de fallos reales).
- Texturas deterministas: un PRNG **xorshift32 con semilla fija** hace que la
  escena sea idéntica entre recargas y capturas.

---

## ✅ Verificación en ejecución real

Chrome headless + SwiftShader (mismo arnés que [`docs/harness.md`](../docs/harness.md)),
1366×860:

| Señal | Resultado |
|---|---|
| Errores de consola / excepciones | **0 / 0** |
| Peticiones de red fallidas | **0** |
| BabylonJS | 9.18.0 · WebGL ✓ |
| Mallas en escena | **305** |
| Instancias de asteroide activas | **250** |
| Partículas vivas | **~7 100** (3 600 estrellas + colas + corona + preset) |
| Cola de iones opuesta al Sol | **producto escalar = 1.000** |
| Vistas de cámara | 6/6 verificadas (radio, objetivo y etiqueta correctos) |
| Controles del panel | 13/13 verificados en ejecución (pausa congela y reanuda, bloom apaga pipeline y glow, tamaño escala a 2.4×, los 6 interruptores encienden y apagan sus objetos, tema y color del Sol cambian la escena) |
| Seguimiento de cuerpo | distancia objetivo–Tierra = **0.00** unidades (bloqueo exacto) |
| Móvil (390×844) | panel 366 px, sin desbordamiento horizontal, ayuda táctil visible, 0 errores |

### Proceso multi-agente (Ultracode)

1. **Investigación**: 6 subagentes en paralelo validaron la API de BabylonJS
   contra la documentación oficial vía context7.
2. **Verificación de runtime**: introspección de las APIs "no confirmadas por la
   doc" contra el motor real antes de escribir el código.
3. **Implementación** y captura headless iterativa: cada defecto visual
   (cuadrado del Sol, nebulosas rectangulares, excepción al cambiar de vista) se
   detectó **midiendo la ejecución**, no leyendo el código.
4. **Auditoría adversarial**: 5 auditores independientes (spec, API, física,
   rendimiento, calidad) produjeron 34 hallazgos, con un escéptico por hallazgo
   encargado de **refutarlo**. De ahí salieron correcciones reales que la
   ejecución por sí sola no delataba, entre ellas:
   - el **sentido de giro** invertido entre revolución y rotación propia
     (Babylon es levógiro) — el arreglo fue un signo en `posicionEnElipse`;
   - un comentario del encabezado que **mentía** (decía `normalizeToNew()` cuando
     el código ya usaba `copyFrom(...).normalize()`);
   - la órbita del cometa **reapareciendo** al reactivar «Mostrar órbitas» con el
     cometa oculto (ahora los seis interruptores comparten una única función de
     visibilidad, así que no existen estados incoherentes);
   - la **pausa que no pausaba** los sistemas de partículas (ahora su
     `updateSpeed` sigue a la velocidad global y se congela del todo);
   - falta de **mipmaps**, foco de teclado invisible, `resize` sin *debounce*,
     ausencia de red de seguridad si WebGL no arranca y código muerto.

---

## 📁 Archivos

```
Opus-5-Claude-Code-Ultracode/
├── index.html   ← la simulación completa (único entregable ejecutable)
└── README.md    ← este documento
```

Licencia [MIT](../LICENSE), como el resto del repositorio.
