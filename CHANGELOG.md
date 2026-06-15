# Changelog

Todos los cambios notables de **Universo-Arena**. El formato sigue
[Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/) y el proyecto usa
[Versionado Semántico](https://semver.org/lang/es/).

## [1.0.0] — 2026-06-15

Primera versión pública del benchmark, con galería web y documentación completa.

### Añadido

- **Benchmark de 14 entregas** (combinaciones LLM + agente de código) del reto
  `Prompt-Maestro_v2.txt`, cada una en su carpeta `<Modelo>-<Agente>/index.html`.
- **Metodología de tres señales:** rúbrica de 100 puntos (10 categorías), ejecución
  real en Chrome headless (capturas, nº de objetos, FPS y errores de consola) y
  calibración adversarial con corrección por *runtime*.
- **Galería interactiva** ([`index.html`](index.html)) con UI moderna: hero animado,
  podio, 14 fichas con captura real y anillo de puntuación, modal con radar SVG de
  10 categorías, fortalezas/debilidades, datos de ejecución y demos en vivo. Datos
  embebidos para funcionar en `file://`.
- **README** con ranking global, desglose por categoría y matriz de cumplimiento.
- **Documentación** en [`docs/`](docs/): metodología, rúbrica, resultados detallados
  por entrega, arnés técnico/reproducibilidad, conclusiones y guía de contribución.
- **Datos crudos** versionados: [`assets/benchmark.json`](assets/benchmark.json) y
  [`assets/runtime.json`](assets/runtime.json), más capturas en `assets/previews/`.
- **Despliegue y auto-despliegue continuo (CD):** Publicado el benchmark en producción en `https://universo-arena.alexanderoviedofadul.dev` mediante el servidor web Caddy e implementado un webhook en NodeJS (puerto 3020) con firma criptográfica de seguridad en GitHub para actualizaciones automáticas en caliente.
- **Documentación de despliegue:** Creado [`docs/deployment.md`](docs/deployment.md) detallando la infraestructura y pasos para configurar el webhook de integración continua.
- **Banner** del proyecto y scaffolding GitHub (`LICENSE` MIT, `.gitignore`, `CLAUDE.md`).

### Resultados destacados

- 🥇 **GPT-5.5 · Codex** y 🥈 **Claude Opus 4.8 · Ultracode** empatan en cabeza (97/100).
- **14/14** entregas arrancan y renderizan; **12/14** sin un solo error de consola.
- El bug más discriminante: la **cola del cometa Halley apuntando hacia el Sol**.

### Corregido

- **Caso GLM-5.2:** una revisión estática inicial declaró erróneamente "pantalla
  negra / no arranca" a `GLM-5.2-Claude-Code`. La ejecución real (279 objetos, 0
  errores, UI completa) lo desmintió; su nota se corrigió de 38 a **89** mediante
  re-evaluación con contexto de *runtime*. Documentado como lección metodológica.

### Notas

- Las puntuaciones reflejan **una sola ejecución** por entrega (no se mide varianza).
- Los FPS se miden bajo SwiftShader (software) y son solo una señal cualitativa.

[1.0.0]: https://github.com/bladealex9848/Universo-Arena/releases/tag/v1.0.0
