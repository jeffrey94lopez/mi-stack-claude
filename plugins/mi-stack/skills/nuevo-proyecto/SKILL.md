---
name: nuevo-proyecto
description: Prepara un proyecto (nuevo o recién clonado) para trabajar con Claude — crea su CLAUDE.md a partir de la plantilla, vincula Supabase y Vercel si aplica, y verifica que los tests corran. Usar al empezar un proyecto o al clonar uno que no tiene CLAUDE.md.
---

# Nuevo proyecto

1. **Reconocer el proyecto:** leer README, `package.json` (o equivalente), estructura de carpetas, ramas
   (`git branch -a`) y los últimos commits. Detectar la rama de producción y cómo se despliega.
2. **Tests:** encontrar el comando de tests y correrlo. Anotar el comando exacto que funciona.
3. **Vincular servicios (si el proyecto los usa):**
   - Supabase: `supabase projects list` → `supabase link --project-ref <ref>`.
   - Vercel: `vercel project ls` → `vercel link --yes --project <nombre>`.
   - Asegurar que `.env*`, `.vercel/` y `supabase/.temp/` estén en `.gitignore`.
4. **CLAUDE.md:** si no existe, crearlo con `plantilla-CLAUDE.md` (en la carpeta de esta skill), llenando cada
   sección con lo que se encontró. Verificar que todo nombre de archivo o función mencionado exista.
   Mantenerlo corto: solo lo que no se deduce leyendo el código.
5. Mostrar el CLAUDE.md al usuario y hacer commit solo si lo aprueba.
