#!/usr/bin/env bash
#
# create-structure.sh — bootstrap idempotente para o projeto TaintGovernor
# Uso: ./create-structure.sh [--dry-run]

set -euo pipefail

#####################################################################
# Configuração
#####################################################################

BASE_DIR="$(pwd)"           # diretório de trabalho (repo root)
DRY_RUN=false               # se true, não cria nada

# Parse de argumentos simples
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
fi

# Diretórios que precisamos
DIRECTORIES=(
  "api/v1alpha1"
  "cmd"
  "config/crd"
  "config/default"
  "config/manager"
  "config/rbac"
  "config/samples"
  "controllers"
  "charts/taintgovernor"
  "docs"
  "hack"
  "pkg/utils"
  "scripts"
  ".github/ISSUE_TEMPLATE"
  ".github/workflows"
)

# Arquivos vazios que valerá a pena comitar já
FILES=(
  "README.md"
  "LICENSE"
  ".gitignore"
  "CONTRIBUTING.md"
  "Makefile"
  "Dockerfile"
  "go.mod"
  "go.sum"
  # “stubs” Go
  "api/v1alpha1/taintpolicy_types.go"
  "api/v1alpha1/zz_generated.deepcopy.go"
  "controllers/taintpolicy_controller.go"
  "cmd/manager.go"
  "pkg/utils/helpers.go"
)

#####################################################################
# Funções utilitárias
#####################################################################

log()  { printf ' • %s\n' "$1"; }
info() { printf '\n==> %s\n' "$1"; }

create_dir() {
  local dir="$1"
  if [[ -d "$dir" ]]; then
    log "Diretório já existe: $dir"
  else
    $DRY_RUN || mkdir -p "$dir"
    log "Criado diretório:  $dir"
  fi
}

create_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    log "Arquivo já existe:  $file"
  else
    $DRY_RUN || touch "$file"
    log "Criado arquivo:    $file"
  fi
}

#####################################################################
# Execução
#####################################################################

info "Inicializando estrutura em: $BASE_DIR"
$DRY_RUN && log "(modo dry-run – nada será criado)"

info "Criando diretórios:"
for dir in "${DIRECTORIES[@]}"; do
  create_dir "$dir"
done

info "Criando arquivos vazios:"
for file in "${FILES[@]}"; do
  create_file "$file"
done

info "Gerando templates do GitHub (bug / feature / PR)"
TEMPLATE_DIR=".github/ISSUE_TEMPLATE"
create_file "${TEMPLATE_DIR}/bug_report.md"
cat > "${TEMPLATE_DIR}/bug_report.md" <<'EOF'
---
name: Bug Report
about: Report a problem with TaintGovernor
---
**Describe the bug**
A clear and concise description of what the bug is.

**Expected behavior**
What you expected to happen.

**Environment**
- Kubernetes version:
- TaintGovernor version:
EOF

create_file "${TEMPLATE_DIR}/feature_request.md"
cat > "${TEMPLATE_DIR}/feature_request.md" <<'EOF'
---
name: Feature Request
about: Suggest an idea for TaintGovernor
---
**Describe the feature**
A clear and concise description of what you want to happen.

**Use case**
Why is this feature important?
EOF

create_file ".github/PULL_REQUEST_TEMPLATE.md"
cat > ".github/PULL_REQUEST_TEMPLATE.md" <<'EOF'
## Description
Summary of the change and which issue is fixed.

## Type of change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Checklist
- [ ] Tests added/updated
- [ ] Documentation added/updated
EOF

info "✅ Estrutura concluída."
$DRY_RUN && info "(nenhuma alteração física foi feita — dry-run)"

