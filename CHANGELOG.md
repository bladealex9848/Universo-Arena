# Changelog

Todos los cambios notables de **Universo-Arena**. El formato sigue
[Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/) y el proyecto usa
[Versionado Semántico](https://semver.org/lang/es/).

## [Unreleased]

### Añadido — Segunda tanda: 14 → 17 entradas (2026-06-17)

- **3 entradas nuevas** integradas en el benchmark y la galería:
  `Opencode-GLM-5.2` (GLM 5.2 · OpenCode, **95**, 🥉 #3), `Antigravity-Gemini-3.5-High`
  (Gemini 3.5 High · Antigravity, **92**, #5) y `Zcode-GML-5.2-Max`
  (GLM 5.2 Max · Zcode, **89**, #9). Las tres aciertan los puntos críticos
  (cola opuesta al Sol, elipses al foco, *instancing*) con **0 errores de consola**.
- **Re-ranking completo a 17 entradas** preservando el empate de cabeza (97):
  🥇 GPT-5.5 · Codex y 🥈 Claude Opus 4.8 · Ultracode. Ahora **15/17** sin errores.
- **Calibración verificada por *runtime***: los jurados de esta tanda puntuaban
  ~3-4 pts generoso; tras verificación adversarial se ajustaron 99→95, 95→92, 92→89,
  para no destronar el 97 calibrado sin re-baremar. Registro en
  [`docs/segunda-tanda-2026-06-17.md`](docs/segunda-tanda-2026-06-17.md).
- **Hallazgo:** **GLM 5.2** queda representado por 4 combinaciones con dispersión
  de **41 puntos** según el agente (OpenCode 95 · Claude Code 89 · Zcode 89 · Z.ai 54):
  el andamiaje del agente pesa tanto como el modelo base.
- **Artefactos regenerados** desde `assets/benchmark.json`: `index.html` (17 fichas,
  contadores dinámicos, JSON-LD/metas), `README.md`, `docs/results.md`,
  `docs/conclusions.md`, `docs/methodology.md`, `sitemap.xml`, `llms.txt`,
  `llms-full.txt` y 3 capturas en `assets/previews/`.

### Añadido — SEO + GEO/AEO (2026-06-15)

- **Compartición social por red:** `<head>` con **Open Graph** completo
  (Facebook, LinkedIn, WhatsApp, Telegram, Slack, Discord) y **Twitter/X Card**
  `summary_large_image`, con imagen social dedicada `assets/og-image.png` (1200×630).
- **Amigable con buscadores:** `robots.txt`, `sitemap.xml` (home + 14 demos, con
  imágenes), `canonical` y `meta robots`.
- **Amigable con LLMs:** `llms.txt` (resumen citable < 2 000 tokens) y
  `llms-full.txt` (contexto extendido), más política explícita de bots de
  búsqueda/citación de IA en `robots.txt`.
- **Datos estructurados** JSON-LD `@graph`: `WebSite`, `Dataset`, `ItemList`
  (ranking) y `FAQPage`.
- **`humans.txt`** y documento de auditoría [`docs/seo-geo-2026-06-15.md`](docs/seo-geo-2026-06-15.md)
  con before/after, comandos de validación y pendientes (alta en Search Console / Bing).

### Seguridad — websec-100 (2026-06-15)

- **Redirect HTTP→HTTPS** explícito (`308`): el bloque `:80` global de Caddy
  anulaba el auto-redirect y servía HTTP plano sin headers.
- **Bloqueo de paths sensibles** (`404`): `CLAUDE.md`, `commit-simple.sh`,
  `/.claude/*` y backups `*.bak/*.old/*.swp/*.swo/*.orig/*.rej`.
- **Headers de seguridad** añadidos: `Permissions-Policy`,
  `Cross-Origin-Opener-Policy`, `Cross-Origin-Resource-Policy`; CSP endurecida
  (`form-action`, `frame-src`, `worker-src`, `manifest-src`, `media-src`,
  `upgrade-insecure-requests`). Se conserva `unsafe-eval` (BabylonJS lo requiere).
- **`/.well-known/security.txt`** (RFC 9116) publicado.
- Verificado en navegador headless real: **0 violaciones CSP** en galería y demos.
- Informe: [`docs/security-audit-2026-06-15.md`](docs/security-audit-2026-06-15.md) + snapshots `docs/websec-2026-06-15/`.

### Rendimiento y accesibilidad — pagespeed-100 (2026-06-15)

- **PageSpeed/Lighthouse 100/100/100/100** (Performance, Accessibility, Best
  Practices, SEO; PSI mobile). LCP 1.1 s · CLS 0 · TBT 0 ms.
- **Corregido contraste WCAG AA:** token CSS `--faint` `#6b78a8` → `#7884b5`
  (4.41:1 → 5.22:1), que subió Accessibility de 91 a 100. Audit `color-contrast`
  sin ítems pendientes.
- Informe: [`docs/pagespeed-2026-06-15.md`](docs/pagespeed-2026-06-15.md) + snapshots `docs/pagespeed-2026-06-15/`.

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
