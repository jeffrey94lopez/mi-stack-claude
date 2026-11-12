---
name: flujo-trabajo
description: Flujo de trabajo de Jeffrey para cualquier cambio de código — entender, planear, implementar con TDD, verificar en navegador y pasar la puerta de seguridad antes de producción. Usar al empezar una funcionalidad, un arreglo o cualquier tarea de varios pasos.
---

# Flujo de trabajo

Aplica a todo cambio que no sea trivial. Comunicate en español.

## 1. Entender
- Si el pedido es ambiguo, usar `grill-me` hasta que el objetivo y los criterios de "terminado" estén claros.
- Para algo nuevo: `superpowers:brainstorming` → diseño en `docs/superpowers/specs/AAAA-MM-DD-<tema>-design.md`.

## 2. Planear
- `superpowers:writing-plans` → plan en `docs/superpowers/plans/AAAA-MM-DD-<tema>.md`, por tareas pequeñas.

## 3. Implementar
- `superpowers:executing-plans` o `superpowers:subagent-driven-development`, con TDD (test que falla → código → test verde).
- Trabajar en una rama (`sandbox` o `feature/<tema>`), nunca directo en la rama de producción.
- UI: `frontend-design` + `design-taste-frontend`. Bugs: `diagnosing-bugs`. Prototipos rápidos: `prototype`.
- Commits pequeños en español: `tipo(alcance): descripcion`; el cuerpo explica el *por qué*.

## 4. Verificar
- Suite completa de tests verde.
- Probar en navegador real (Playwright MCP) los flujos tocados, incluido celular (~400px).
- No decir "listo" sin evidencia: mostrar la salida de los tests o lo que se vio en el navegador.

## 5. Puerta de seguridad
Antes de mergear a la rama de producción, ejecutar la skill `puerta-seguridad`.

## 6. Publicar
- Merge y push a producción **solo cuando el usuario lo pide**.
- Si hay migraciones de base de datos, recordarle al usuario aplicarlas y en qué orden respecto al deploy.

## Mantenimiento mensual
`insecure-defaults` y `sharp-edges` sobre todo el repo; `static-analysis` (Semgrep) si hay tiempo.
