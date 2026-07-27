# 🆕 Sexta tanda — Claude Opus 5 · Ultracode (2026-07-27)

Registro de la ampliación del benchmark de **25 → 26 entradas**. Se integra una
combinación nueva, **Claude Opus 5 con Claude Code en modo Ultracode**, generada
con la misma metodología de siempre (rúbrica + ejecución real + verificación) y,
por primera vez, con el ciclo completo de **auditoría adversarial antes de
puntuar** y **repuntuación sobre el archivo final**.

## La entrada nueva

| Carpeta | Modelo | Agente | Nota | Tier | Puesto |
|:--|:--|:--|:--:|:--:|:--:|
| `Opus-5-Claude-Code-Ultracode` | Claude Opus 5 | **Ultracode + Claude Code** | **97** | S | #3 |

**Empata en cabeza con 97/100**, junto a `codex-gpt-5.5` (GPT-5.5 · Codex) y
`Opus-4.8-Ultracode-Extension-Claude-Code` (Claude Opus 4.8 · Ultracode). Queda
en el **#3** por respetar la regla de la casa: **ante empate no se adelanta a las
notas ya calibradas**. Los cuatro jurados independientes dieron 98, 98, 97 y 96;
el juez calibrador fijó **97** —+1 en completitud de escena (20/20) y −1 en
calidad de código (4/5)— y descartó el sorpasso: la superioridad técnica sobre el
líder es citable, pero se compensa con 2 fps menos y un cielo estrellado más
tenue.

| Categoría | Escena /20 | Órbitas /12 | Halley /8 | Estética /15 | UI /15 | Cámara /8 | Post-pro /6 | Rend. /6 | Robustez /5 | Código /5 | **Total** |
|:--|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Claude Opus 5 · Ultracode | 20 | 12 | 8 | 13 | 15 | 8 | 6 | 6 | 5 | 4 | **97** |

## Datos de ejecución real (Chrome headless, SwiftShader, 1366×860)

| Señal | Valor |
|:--|:--|
| Mallas en escena | **305** |
| Instancias de asteroide | **250** (`createInstance`, un solo draw call) |
| Partículas vivas | **~7 100** en 10 sistemas |
| Errores de consola / excepciones | **0 / 0** |
| Peticiones de red fallidas | **0** |
| BabylonJS · WebGL | 9.18.0 · ✓ |
| Cola de iones vs (cometa − Sol) | **producto escalar = 1.000** |
| Vistas de cámara | 6/6 verificadas (radio, objetivo y etiqueta) |
| Controles del panel | 13/13 accionados y comprobados en ejecución |
| Móvil (390×844) | sin desbordamiento, ayuda táctil, 0 errores |

Las dos trampas del reto quedan resueltas y **medidas**, no afirmadas: el Sol
está en el foco (`x = a(cosE − e)`, `z = −b·sinE`, con la **misma** función
generando la línea de órbita y la posición del cuerpo) y la cola apunta
exactamente en sentido contrario al Sol (producto escalar 1.000, sin `.negate()`
ni mutaciones in-place).

## Lo que aporta esta entrada al campo

- **Ecuación de Kepler resuelta por Newton-Raphson** (2.ª ley) y movimiento medio
  `n ∝ a^(−3/2)` (3.ª ley), aplicados también a **cada una de las 250 rocas** del
  cinturón: cada asteroide recorre su propia elipse, en vez de girar un aro
  circular en bloque como hace el resto del campo.
- **Los límites de cámara del spec como invariantes.** `lowerRadiusLimit = 30` y
  `upperRadiusLimit = 2000` no se tocan nunca; los primeros planos de la Tierra,
  Saturno y Halley se consiguen con **teleobjetivo** (`camera.fov`), no bajando
  el límite —que es lo que hacen las dos entradas de cabeza—.
- **Cero reservas de memoria por frame** (cinco `Vector3` temporales
  reutilizados) frente a los `new Vector3` por planeta y frame del resto.
- **El preset oficial `ParticleHelper.CreateAsync("sun")`**, que el spec pedía
  bajo un nombre inexistente (`CreateSystem`), cargado de verdad y protegido.
- Texturas procedurales por cuerpo (bandas y Gran Mancha Roja en Júpiter,
  continentes y casquetes en la Tierra, cráteres en Mercurio/Plutón/Luna, Valles
  Marineris en Marte), anillos como **torus 3D** en Saturno y Urano, Luna, coma y
  **dos colas** (iones y polvo) en el cometa.

## Metodología: auditoría adversarial + jurado sobre el archivo final

Además del flujo habitual, esta tanda añadió dos fases:

1. **Investigación previa obligatoria.** Seis subagentes validaron la API de
   BabylonJS contra la documentación oficial (context7) y, después, se
   comprobaron por **introspección en el runtime real** todas las firmas que la
   documentación no confirmaba. De ahí salieron decisiones de diseño con
   evidencia: `ParticleHelper.CreateSystem` no existe; `CreateDefault` tampoco
   sirve offline (descarga `flare.png`); `Vector3.normalize()` muta;
   `Animation.CreateAndStartAnimation` devuelve un `Animatable` sin
   `setEasingFunction`; y con `disableLighting = true` el `StandardMaterial`
   **ignora `emissiveTexture`**.
2. **Auditoría adversarial (5 auditores + escépticos).** 38 hallazgos, cada uno
   sometido a un agente encargado de **refutarlo**. Los defectos reales se
   corrigieron antes de puntuar. Los más valiosos:
   - **sentido de giro invertido**: Babylon es levógiro (una rotación positiva
     sobre Y lleva +X → −Z), así que la revolución iba al revés que la rotación
     propia; se corrigió con un signo en `posicionEnElipse`;
   - un comentario del encabezado que **mentía** sobre el código;
   - la órbita del cometa **reapareciendo** al reactivar «Mostrar órbitas» con el
     cometa oculto;
   - la **pausa que no pausaba** los sistemas de partículas;
   - un tinte del preset solar que era **no-op** porque esos sistemas usan
     `colorGradients` (refutación con Babylon ejecutado en Node).
3. **Jurado calibrado, dos veces.** Cuatro jurados independientes —cada uno
   anclado a una entrega ya calibrada distinta (los dos 97 y dos 95)— más un juez
   calibrador. La primera ronda dio **96** y señaló defectos visuales concretos
   (campo de estrellas invisible por los mipmaps, cola desproporcionada,
   etiquetas ilegibles, código muerto). Se corrigieron **y se volvió a puntuar
   sobre el archivo final**, para que la nota corresponda al código entregado.

> **Nota de honestidad.** El juez calibrador señaló, además, cuatro desajustes
> entre comentarios y código (sprite estelar convertido en anillo por paradas de
> degradado desordenadas; `color1/color2` de las colas anulados por
> `addColorGradient`; un valor de tema que el material satura a 1; y la
> resincronización inicial del DOM olvidando el interruptor de bloom). Se
> corrigieron **después** de fijar la nota y **la nota no se subió por ello**: el
> 97 se queda como está, que es el lado conservador. La ficha de
> [`results.md`](results.md) refleja el estado real del archivo entregado.

### Lo que este método sí y no garantiza

El pipeline (documentación → runtime → auditoría adversarial → jurado calibrado)
detecta cosas que ni la ejecución ni la lectura por separado ven —el sentido de
giro invertido salió de un razonamiento sobre el sistema levógiro de Babylon, no
de la pantalla—. Pero tiene un límite conocido: **los verificadores leen el
archivo ya corregido**, así que confirman el estado final más que arbitran el
hallazgo original. Por eso el criterio de cierre siguió siendo el de siempre:
medir en ejecución y quedarse con la nota más baja defendible.

## Artefactos regenerados

Tras editar la fuente de verdad [`../assets/benchmark.json`](../assets/benchmark.json)
(26 entradas) se regeneraron, derivándolos de ella:

- **Web principal** [`../index.html`](../index.html): 26 fichas, podio, radares,
  contadores dinámicos, JSON-LD (`ItemList` de 26) y metas.
- [`../README.md`](../README.md): tablas (ranking, categorías, matriz) y badges.
- [`results.md`](results.md) (26 fichas), [`conclusions.md`](conclusions.md),
  [`methodology.md`](methodology.md).
- SEO/GEO: `sitemap.xml` (26 demos), `llms.txt` y `llms-full.txt`.
- Captura real en `assets/previews/Opus-5-Claude-Code-Ultracode.png`.

## Cómo reproducir / añadir más

Mismo flujo de [`harness.md`](harness.md), [`contributing.md`](contributing.md) y
las tandas anteriores ([2.ª](segunda-tanda-2026-06-17.md),
[3.ª](tercera-tanda-2026-06-18.md), [4.ª](cuarta-tanda-2026-07-05.md),
[5.ª](quinta-tanda-2026-07-23.md)): capturar en Chrome headless → puntuar con la
[`rúbrica`](rubric.md) → **verificar contra el runtime** → fusionar en
`benchmark.json` → regenerar los artefactos derivados (incluida la
**re-inyección** de los datos en `index.html`).
