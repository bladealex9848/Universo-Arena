# Optimización PageSpeed — Universo-Arena (2026-06-15)

**Sitio**: https://universo-arena.alexanderoviedofadul.dev
**Auditor**: skill `pagespeed-100`
**Herramientas**: `wc360 perf` (PageSpeed Insights v5 server-side, mobile) + Chrome headless (verificación CSP)
**Reportes raw**:
- [`pagespeed-2026-06-15/before-wc360.json`](pagespeed-2026-06-15/before-wc360.json) (baseline)
- [`pagespeed-2026-06-15/after-wc360.json`](pagespeed-2026-06-15/after-wc360.json) (post-fix)

## Resumen ejecutivo

Sitio estático (HTML/CSS/JS vanilla, BabylonJS por CDN) servido por Caddy con
`encode zstd gzip`. El baseline ya era excelente en 3 de 4 categorías; el único
bloqueante para el 100 % global era un fallo de **contraste de color** en
Accessibility. Tras un ajuste de una variable CSS:

| Categoría (PSI mobile) | Antes | Después |
|---|---|---|
| **Performance** | 100 | **100** |
| **Accessibility** | 91 | **100** ✅ |
| **Best Practices** | 100 | **100** |
| **SEO** | 100 | **100** |

**Core Web Vitals (después):** LCP **1.1 s** · FCP **1.1 s** · CLS **0** · TBT **0 ms** · Speed Index **1.2 s** — todas en verde.

Verificación manual PSI (field/lab data):
- mobile · https://pagespeed.web.dev/analysis?url=https%3A%2F%2Funiverso-arena.alexanderoviedofadul.dev%2F&form_factor=mobile
- desktop · https://pagespeed.web.dev/analysis?url=https%3A%2F%2Funiverso-arena.alexanderoviedofadul.dev%2F&form_factor=desktop

## Por qué cada métrica mejoró

### Accessibility (91 → 100) — guía: https://web.dev/articles/color-contrast
- **Causa raíz**: la variable `--faint: #6b78a8`, usada en 9 textos pequeños
  (12 px, peso normal: etiquetas "líneas de código", pies de ficha, créditos),
  daba un contraste de **4.41:1** sobre el fondo de tarjeta `#0c0f1f` — por debajo
  del mínimo WCAG AA de **4.5:1**. El audit `color-contrast` marcaba 15 nodos `<span>`.
- **Fix**: `--faint` → `#7884b5`, que eleva el contraste a **5.22:1** sobre `#0c0f1f`
  (y 5.55:1 sobre `#05060f`, 5.29:1 sobre `#0a0d1f`), conservando el tono visual.
- **Archivo**: [`index.html`](../index.html) `:root` (línea 243, token `--faint`).
- **Resultado**: audit `color-contrast` → `score=1`, `items=0`.

### Performance (100, conservado) — guías: https://web.dev/articles/lcp · https://web.dev/articles/cls
- El sitio ya cargaba con LCP 1.1 s y CLS 0. Contribuyen: HTML único sin build,
  `encode zstd gzip` en Caddy, imágenes de preview servidas con dimensiones
  estables y fondo estrellado en `<canvas>`/CSS (sin reflow). No se requirieron
  cambios; se evitó tocar lo que ya estaba óptimo.

### Best Practices (100, conservado)
- HTTPS forzado, headers de seguridad completos (HSTS, CSP, COOP, CORP,
  Permissions-Policy — ver [`security-audit-2026-06-15.md`](security-audit-2026-06-15.md)),
  sin errores de consola en la galería.

### SEO (100, conservado)
- Metadatos, canonical, `robots.txt`, `sitemap.xml` y JSON-LD ya aplicados en la
  fase SEO/GEO (ver [`seo-geo-2026-06-15.md`](seo-geo-2026-06-15.md)).

## Anti-patterns evitados (registro explícito)

- ❌ **No** se cacheó HTML público de forma agresiva (no hay sesiones/CSRF, pero se
  respeta la revalidación; el sitio es estático puro).
- ❌ **No** se aplicó `loading="lazy"` a ningún elemento LCP.
- ❌ **No** se recomprimió ningún PNG con parámetros JPEG (`-sampling-factor`).
- ❌ **No** se "optimizó" Performance que ya estaba en 100 (riesgo de regresión sin beneficio).
- ❌ **No** se editaron las 14 demos: son artefactos inmutables del benchmark; el
  fix de contraste vive solo en la galería raíz.

## Nota de medición

El snapshot DESPUÉS se tomó contra `…/?v=ps2` para forzar un análisis PSI fresco y
evitar la caché de 5 min de `wc360`/PSI (el `file_server` de Caddy sirve el mismo
`index.html` para cualquier query string, por lo que la medición es equivalente a
la raíz). Las "insights" informativas de PSI (`image-delivery`, `cache-insight`,
`forced-reflow`) no afectan al score de Performance, que se mantiene en 100.

## Pendientes (operador)

- Ninguno para alcanzar 100/100/100/100. Opcional: re-auditar tras cambios futuros
  con `WC360_FORMAT=json wc360 perf https://universo-arena.alexanderoviedofadul.dev`.

## Reproducir

```bash
# Baseline + verificación
WC360_FORMAT=json wc360 perf https://universo-arena.alexanderoviedofadul.dev \
  > docs/pagespeed-2026-06-15/before-wc360.json
# (aplicar fix de contraste --faint)
WC360_FORMAT=json wc360 perf "https://universo-arena.alexanderoviedofadul.dev/?v=ps2" \
  > docs/pagespeed-2026-06-15/after-wc360.json
# Scores:
jq -r '.[]|select(.endpoint=="quality")|.data.lighthouseResult.categories
  |"P:\(.performance.score*100)  A:\(.accessibility.score*100)  BP:\(.["best-practices"].score*100)  SEO:\(.seo.score*100)"' \
  docs/pagespeed-2026-06-15/after-wc360.json
```
