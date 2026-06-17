# 📚 Documentación · Universo-Arena

Documentación completa del benchmark, su metodología y cómo reproducirlo o ampliarlo.

| Documento | Contenido |
|:--|:--|
| **[methodology.md](methodology.md)** | Cómo se evaluó: las tres señales (rúbrica, ejecución real, calibración), por qué y sus límites. |
| **[rubric.md](rubric.md)** | La rúbrica de 100 puntos: las 10 categorías, sus máximos y criterios de puntuación. |
| **[results.md](results.md)** | Ficha detallada de las 14 entregas: desglose, runtime, fortalezas, debilidades y veredicto. |
| **[harness.md](harness.md)** | El arnés técnico: pipeline multi-agente, capturas con Chrome headless y reproducibilidad. |
| **[conclusions.md](conclusions.md)** | Análisis comparativo, conclusiones y estado del arte (versión extendida). |
| **[contributing.md](contributing.md)** | Cómo añadir una nueva entrada y regenerar el benchmark y la galería. |
| **[segunda-tanda-2026-06-17.md](segunda-tanda-2026-06-17.md)** | Ampliación 14→17: las 3 entradas nuevas, su calibración verificada por *runtime* y el hallazgo de la familia GLM 5.2. |
| **[deployment.md](deployment.md)** | Infraestructura de despliegue en producción y webhook de auto-despliegue continuo (CD). |
| **[seo-geo-2026-06-15.md](seo-geo-2026-06-15.md)** | Auditoría y mejora SEO + GEO/AEO: Open Graph/Twitter por red social, `llms.txt`, `sitemap.xml`, `robots.txt` y JSON-LD. |
| **[security-audit-2026-06-15.md](security-audit-2026-06-15.md)** | Auditoría de ciberseguridad (websec-100): redirect HTTP→HTTPS, bloqueo de paths sensibles, headers OWASP, CSP y `security.txt`. |
| **[pagespeed-2026-06-15.md](pagespeed-2026-06-15.md)** | Optimización PageSpeed/Lighthouse a **100/100/100/100** (Performance, Accessibility, Best Practices, SEO). |

## Enlaces rápidos

- 🌐 **Galería interactiva:** [`../index.html`](../index.html)
- 🏆 **Resumen y ranking:** [`../README.md`](../README.md)
- 📜 **El reto:** [`../Prompt-Maestro_v2.txt`](../Prompt-Maestro_v2.txt)
- 🗂️ **Datos crudos:** [`../assets/benchmark.json`](../assets/benchmark.json) · [`../assets/runtime.json`](../assets/runtime.json)

## En una frase

> Un mismo prompt exigente (una simulación 3D del Sistema Solar con BabylonJS en un único `index.html`), 14 combinaciones distintas de **LLM + agente de código**, evaluadas con una rúbrica y, sobre todo, **ejecutándolas de verdad** en un navegador.
