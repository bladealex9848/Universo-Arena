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
| **[deployment.md](deployment.md)** | Infraestructura de despliegue en producción y webhook de auto-despliegue continuo (CD). |

## Enlaces rápidos

- 🌐 **Galería interactiva:** [`../index.html`](../index.html)
- 🏆 **Resumen y ranking:** [`../README.md`](../README.md)
- 📜 **El reto:** [`../Prompt-Maestro_v2.txt`](../Prompt-Maestro_v2.txt)
- 🗂️ **Datos crudos:** [`../assets/benchmark.json`](../assets/benchmark.json) · [`../assets/runtime.json`](../assets/runtime.json)

## En una frase

> Un mismo prompt exigente (una simulación 3D del Sistema Solar con BabylonJS en un único `index.html`), 14 combinaciones distintas de **LLM + agente de código**, evaluadas con una rúbrica y, sobre todo, **ejecutándolas de verdad** en un navegador.
