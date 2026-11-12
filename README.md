# mi-stack-claude

Mi entorno y flujo de trabajo con Claude Code, empaquetado para reinstalar en cualquier máquina o proyecto.

## Instalación en una máquina nueva

```bash
gh repo clone jeffrey94lopez/mi-stack-claude ~/proyectos/mi-stack-claude
cd ~/proyectos/mi-stack-claude
GIT_NAME="..." GIT_EMAIL="..." ./bootstrap.sh
```

Solo las skills y plugins (si las herramientas ya están): `./bootstrap.sh --solo-claude`.
Solo el plugin propio: `claude plugin marketplace add jeffrey94lopez/mi-stack-claude && claude plugin install mi-stack@mi-stack-claude`.

## Qué instala

| Tipo | Qué |
|---|---|
| Herramientas | git, Node 22, Python + pipx, gh, Vercel CLI, Supabase CLI, Docker, Semgrep, Chromium (Playwright) |
| Plugins | superpowers · Trail of Bits: differential-review, insecure-defaults, sharp-edges, supply-chain-risk-auditor, static-analysis · **mi-stack** (este repo) |
| Skills | supabase, supabase-postgres-best-practices · grill-me, diagnosing-bugs, prototype (mattpocock) · frontend-design, xlsx (anthropics) · design-taste-frontend · find-skills |
| MCP | Playwright |

Las skills de terceros se instalan desde sus repos originales (no se copian aquí): reciben actualizaciones y se respetan sus licencias.

## Plugin `mi-stack`

| Skill | Para qué |
|---|---|
| `flujo-trabajo` | Las fases: entender → planear → implementar con TDD → verificar → puerta de seguridad → publicar |
| `puerta-seguridad` | Revisión obligatoria antes de mergear a producción |
| `nuevo-proyecto` | Prepara un proyecto: tests, vincula Supabase/Vercel y crea su `CLAUDE.md` desde la plantilla |

## Cómo mejorarlo
1. Editar la skill en `plugins/mi-stack/skills/` (o agregar una carpeta nueva con su `SKILL.md`).
2. Subir la versión en `plugins/mi-stack/.claude-plugin/plugin.json` y en `.claude-plugin/marketplace.json`.
3. Commit + push. En cada máquina: `claude plugin marketplace update mi-stack-claude && claude plugin update mi-stack@mi-stack-claude`.
4. Si se agrega una skill o plugin de terceros, sumarlo a `bootstrap.sh` y a la tabla de arriba.

## Qué NO va aquí
Tokens, `.env`, la carpeta de memoria de Claude (`~/.claude/projects/`) ni datos de clientes.
Lo específico de cada proyecto va en el `CLAUDE.md` de ese proyecto.
