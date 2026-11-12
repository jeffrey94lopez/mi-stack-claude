#!/usr/bin/env bash
# Prepara una máquina Debian/Ubuntu (x86_64) para programar con Claude Code.
# Idempotente: se puede correr varias veces. Uso:
#   GIT_NAME="tu nombre" GIT_EMAIL="tu@correo" ./bootstrap.sh
#   ./bootstrap.sh --solo-claude    # salta herramientas del sistema; solo skills y plugins
set -euo pipefail

SOLO_CLAUDE=0
[[ "${1:-}" == "--solo-claude" ]] && SOLO_CLAUDE=1

paso() { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }
tiene() { command -v "$1" >/dev/null 2>&1; }

export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:$PATH"

if [[ $SOLO_CLAUDE -eq 0 ]]; then
  . /etc/os-release
  DISTRO="$ID"; CODENAME="${VERSION_CODENAME:-}"

  paso "Paquetes base, git y Python"
  sudo apt-get update -qq
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    git python3-pip python3-venv pipx build-essential ca-certificates gnupg unzip curl
  sudo install -m 0755 -d /etc/apt/keyrings

  if ! tiene gh; then
    paso "GitHub CLI"
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
      | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    NUEVOS_REPOS=1
  fi

  if ! tiene docker; then
    paso "Docker (repositorio oficial)"
    curl -fsSL "https://download.docker.com/linux/$DISTRO/gpg" | sudo gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$DISTRO $CODENAME stable" \
      | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    NUEVOS_REPOS=1
  fi

  if ! tiene node; then
    paso "Node.js 22 LTS"
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - >/dev/null
    NUEVOS_REPOS=1
  fi

  if [[ "${NUEVOS_REPOS:-0}" -eq 1 ]]; then
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq nodejs gh \
      docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker "$USER"
  fi

  paso "npm global sin sudo + Vercel CLI"
  mkdir -p "$HOME/.npm-global"
  npm config set prefix "$HOME/.npm-global"
  grep -q npm-global "$HOME/.bashrc" || echo 'export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
  tiene vercel || npm install -g vercel --silent

  if ! tiene supabase; then
    paso "Supabase CLI"
    TMP=$(mktemp -d)
    URL=$(curl -fsSL https://api.github.com/repos/supabase/cli/releases/latest | grep -o 'https://[^"]*linux_amd64.deb' | head -1)
    curl -fsSL -o "$TMP/supabase.deb" "$URL"
    sudo dpkg -i "$TMP/supabase.deb" >/dev/null
    rm -rf "$TMP"
  fi

  paso "Semgrep"
  tiene semgrep || pipx install semgrep

  paso "Chromium para Playwright"
  npx -y playwright install --with-deps chromium

  if [[ -n "${GIT_NAME:-}" && -n "${GIT_EMAIL:-}" ]]; then
    paso "Identidad de git"
    git config --global user.name "$GIT_NAME"
    git config --global user.email "$GIT_EMAIL"
  fi
  git config --global init.defaultBranch main
fi

tiene claude || { echo "Falta Claude Code: https://claude.com/claude-code"; exit 1; }

paso "Plugins de Claude Code"
claude plugin marketplace add obra/superpowers-marketplace || true
claude plugin install superpowers@superpowers-marketplace || true
claude plugin marketplace add trailofbits/skills || true
for p in differential-review insecure-defaults sharp-edges supply-chain-risk-auditor static-analysis; do
  claude plugin install "$p@trailofbits" || true
done
claude plugin marketplace add jeffrey94lopez/mi-stack-claude || true
claude plugin install mi-stack@mi-stack-claude || true

paso "Skills (desde sus repos originales)"
S="-g -a claude-code -y"
npx -y skills add supabase/agent-skills $S
npx -y skills add mattpocock/skills --skill grill-me --skill diagnosing-bugs --skill prototype $S
npx -y skills add anthropics/skills --skill frontend-design --skill xlsx $S
npx -y skills add Leonxlnx/taste-skill --skill design-taste-frontend $S
npx -y skills add vercel-labs/skills --skill find-skills $S

paso "MCP de Playwright"
claude mcp get playwright >/dev/null 2>&1 || claude mcp add playwright -s user -- npx -y @playwright/mcp@latest

cat <<'FIN'

Listo. Pasos manuales:
  1. Cerrar y abrir la terminal (PATH y grupo docker).
  2. gh auth login · vercel login · supabase login
  3. Reiniciar Claude Code para cargar skills y plugins.
FIN
