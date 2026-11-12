# <Nombre del proyecto> — guía para Claude

<Una o dos líneas: qué es y para quién.>

## Stack y comandos
- <Tecnologías principales>
- Tests: `<comando exacto>`
- Servidor local: `<comando>` → <url>
- Servicios vinculados: Supabase `<ref>`, Vercel `<proyecto>`

## Ramas y despliegue
- **`<rama-produccion>` = producción.** <Cómo se despliega.> Nunca hacer push sin pasar la puerta de seguridad
  y sin que el usuario lo pida.
- Trabajo en curso en `<rama>`.

## Convenciones
- Commits en español: `tipo(alcance): descripcion`.
- Diseños en `docs/superpowers/specs/`, planes en `docs/superpowers/plans/`.

## Flujo de trabajo
Seguir la skill `mi-stack:flujo-trabajo`; antes de producción, `mi-stack:puerta-seguridad`.

## Puntos sensibles
- <Secretos, endpoints, RLS, datos de clientes, cosas que ya rompieron antes>
