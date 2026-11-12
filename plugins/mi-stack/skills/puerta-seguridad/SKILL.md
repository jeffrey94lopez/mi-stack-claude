---
name: puerta-seguridad
description: Revisión de seguridad obligatoria antes de mergear una rama a producción. Usar cuando se va a mergear o desplegar a producción, o cuando el usuario pide una revisión de seguridad de los cambios.
---

# Puerta de seguridad

Corre sobre el diff `<rama-produccion>...<rama>` (por ejemplo `master...sandbox`).

## Pasos
1. **Siempre:** `differential-review` sobre el diff (impacto y radio de explosión de cada cambio).
2. **Siempre:** `/security-review`.
3. **Si hubo cambios de base de datos, RLS, Storage o Auth (Supabase):**
   - Correr los advisors de seguridad del proyecto (`get_advisors` del MCP de Supabase, tipo `security`).
   - Toda tabla nueva necesita RLS activado y políticas explícitas; la anon key es pública.
4. **Si cambió `package.json`, un lockfile o hay librerías nuevas copiadas a mano (`vendor/`):** `supply-chain-risk-auditor`.
5. **Si se tocaron endpoints serverless, webhooks o configuración (`vercel.json`, CSP, headers):** `insecure-defaults` sobre esos archivos.

## Resultado
Reportar al usuario una tabla: hallazgo · severidad · archivo:línea · acción.
- **Crítico / alto:** se corrige antes del merge.
- **Medio / bajo:** el usuario decide; anotar los pendientes.
- Sin hallazgos: decirlo explícitamente y qué se revisó.
