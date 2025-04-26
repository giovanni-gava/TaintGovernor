#!/bin/bash

set -euo pipefail

# Diretório base (assume que você já está dentro do repositório clonado)
BASE_DIR="$(pwd)"

echo "🔧 Criando estrutura inicial do projeto TaintGovernor em: $BASE_DIR"

# Função para criar diretórios se não existirem
create_dir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        echo "📁 Criado diretório: $1"
    else
        echo "✅ Diretório já existe: $1"
    fi
}

# Função para criar arquivos se não existirem
create_file() {
    if [ ! -f "$1" ]; then
        touch "$1"
        echo "📝 Criado arquivo: $1"
    else
        echo "✅ Arquivo já existe: $1"
    fi
}

# Estruturas principais
create_dir "api/v1alpha1"
create_dir "cmd"
create_dir "config/{crd,default,manager,rbac,samples}"
create_dir "controllers"
create_dir "charts/taintgovernor"
create_dir "docs"
create_dir "hack"
create_dir "pkg/utils"
create_dir "scripts"
create_dir ".github/ISSUE_TEMPLATE"
create_dir ".github/workflows"

# Arquivos importantes
create_file "README.md"
create_file "LICENSE"
create_file "Dockerfile"
create_file "Makefile"
create_file ".gitignore"
create_file "CONTRIBUTING.md"
create_file "go.mod"
create_file "go.sum"

# Arquivos Go iniciais
create_file "api/v1alpha1/taintpolicy_types.go"
create_file "api/v1alpha1/zz_generated.deepcopy.go"
create_file "controllers/taintpolicy_controller.go"
create_file "cmd/manager.go"
create_file "pkg/utils/helpers.go"

# Templates do GitHub
cat <<EOF > .github/ISSUE_TEMPLATE/bug_report.md
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

cat <<EOF > .github/ISSUE_TEMPLATE/feature_request.md
---
name: Feature Request
about: Suggest an idea for TaintGovernor
---

**Describe the feature**
A clear and concise description of what you want to happen.

**Use case**
Why is this feature important?
EOF

cat <<EOF > .github/PULL_REQUEST_TEMPLATE.md
## Description

Please include a summary of the change and which issue is fixed.

## Type of change

- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Checklist

- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] I have added necessary documentation (if appropriate)
EOF

echo "🎯 Estrutura inicial criada com sucesso!"

