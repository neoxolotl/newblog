#!/bin/bash

# =============================================================================
# get-giscus-ids.sh
# Script para obtener los IDs necesarios para configurar Giscus
# =============================================================================

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# =============================================================================
# CONFIGURACIÓN - EDITA ESTOS VALORES
# =============================================================================
GITHUB_USERNAME="neoxolotl"
GITHUB_REPO="newblog"
GITHUB_TOKEN=""  # ⚠️ Opcional para repos públicos, REQUIRED para categorías
CATEGORY_NAME="General"

# =============================================================================
# Funciones
# =============================================================================

print_header() {
    echo -e "${BLUE}=============================================================${NC}"
    echo -e "${BLUE}  📋 Obtener IDs para Giscus${NC}"
    echo -e "${BLUE}=============================================================${NC}"
    echo ""
}

print_error() {
    echo -e "${RED}❌ Error: $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

# Verificar dependencias
check_dependencies() {
    if ! command -v curl &> /dev/null; then
        print_error "curl no está instalado. Instálalo con: sudo apt install curl"
        exit 1
    fi

    if ! command -v jq &> /dev/null; then
        print_error "jq no está instalado. Instálalo con: sudo apt install jq"
        echo ""
        print_info "jq es necesario para parsear JSON"
        exit 1
    fi
}

# Obtener Repo ID (funciona sin token para repos públicos)
get_repo_id() {
    echo -e "${YELLOW}🔍 Obteniendo Repo ID...${NC}"
    
    local url="https://api.github.com/repos/${GITHUB_USERNAME}/${GITHUB_REPO}"
    
    local response=$(curl -s "$url")
    
    # Verificar error
    if echo "$response" | jq -e '.message' &> /dev/null; then
        local msg=$(echo "$response" | jq -r '.message')
        print_error "No se pudo acceder al repositorio: $msg"
        return 1
    fi
    
    REPO_ID=$(echo "$response" | jq -r '.node_id')
    REPO_NAME=$(echo "$response" | jq -r '.full_name')
    
    if [ "$REPO_ID" = "null" ] || [ -z "$REPO_ID" ]; then
        print_error "No se pudo obtener el Repo ID"
        return 1
    fi
    
    print_success "Repo ID obtenido: $REPO_ID"
    return 0
}

# Obtener Category ID (requiere token con permisos de discussions)
get_category_id() {
    echo -e "${YELLOW}🔍 Obteniendo Category ID...${NC}"
    
    if [ -z "$GITHUB_TOKEN" ]; then
        print_error "Se requiere GITHUB_TOKEN para obtener el Category ID"
        print_info "Crea un token en: https://github.com/settings/tokens"
        print_info "Permisos necesarios: read:discussion"
        echo ""
        echo -e "${YELLOW}¿Quieres ingresar un token ahora? (y/n)${NC}"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            echo -e "${YELLOW}Ingresa tu token: ${NC}"
            read -s GITHUB_TOKEN
            echo ""
        else
            print_info "Puedes obtener el Category ID manualmente desde giscus.app"
            return 1
        fi
    fi
    
    # Usar GraphQL API para obtener las categorías
    local query="{
        repository(owner: \\\"${GITHUB_USERNAME}\\\", name: \\\"${GITHUB_REPO}\\\") {
            discussionCategories(first: 10) {
                nodes {
                    id
                    name
                    slug
                }
            }
        }
    }"
    
    local response=$(curl -s -X POST \
        -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        -H "Content-Type: application/json" \
        -d "{\"query\": \"$query\"}" \
        "https://api.github.com/graphql")
    
    # Verificar error
    if echo "$response" | jq -e '.errors' &> /dev/null; then
        local msg=$(echo "$response" | jq -r '.errors[0].message')
        print_error "Error en GraphQL: $msg"
        print_info "Verifica que tu token tenga permisos de 'read:discussion'"
        return 1
    fi
    
    # Buscar la categoría específica
    CATEGORY_ID=$(echo "$response" | jq -r ".data.repository.discussionCategories.nodes[] | select(.name == \"${CATEGORY_NAME}\") | .id")
    
    if [ "$CATEGORY_ID" = "null" ] || [ -z "$CATEGORY_ID" ]; then
        print_error "No se encontró la categoría '${CATEGORY_NAME}'"
        echo ""
        print_info "Categorías disponibles:"
        echo "$response" | jq -r '.data.repository.discussionCategories.nodes[] | "  - \(.name) (slug: \(.slug))"'
        echo ""
        print_info "Asegúrate de que Discussions esté activado en tu repo"
        return 1
    fi
    
    print_success "Category ID obtenido: $CATEGORY_ID"
    return 0
}

# Mostrar resultado
show_result() {
    echo ""
    echo -e "${BLUE}=============================================================${NC}"
    echo -e "${GREEN}🎉 ¡IDs Obtenidos Exitosamente!${NC}"
    echo -e "${BLUE}=============================================================${NC}"
    echo ""
    echo -e "${YELLOW}📋 Información del Repositorio:${NC}"
    echo "   Repositorio: $REPO_NAME"
    echo ""
    echo -e "${YELLOW}🔑 IDs para Giscus:${NC}"
    echo "   data-repo=\"${GITHUB_USERNAME}/${GITHUB_REPO}\""
    echo "   data-repo-id=\"${REPO_ID}\""
    echo "   data-category=\"${CATEGORY_NAME}\""
    echo "   data-category-id=\"${CATEGORY_ID}\""
    echo ""
    echo -e "${YELLOW}📝 Código para tu index.html:${NC}"
    echo "-----------------------------------------------------------"
    cat << EOF
<script src="https://giscus.app/client.js"
        data-repo="${GITHUB_USERNAME}/${GITHUB_REPO}"
        data-repo-id="${REPO_ID}"
        data-category="${CATEGORY_NAME}"
        data-category-id="${CATEGORY_ID}"
        data-mapping="pathname"
        data-strict="0"
        data-reactions-enabled="1"
        data-emit-metadata="0"
        data-input-position="bottom"
        data-theme="light"
        data-lang="es"
        crossorigin="anonymous"
        async>
</script>
EOF
    echo "-----------------------------------------------------------"
    echo ""
}

# Guardar en archivo
save_to_file() {
    echo -e "${YELLOW}¿Quieres guardar esto en un archivo? (y/n)${NC}"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        local filename="giscus-config.html"
        cat << EOF > "$filename"
<!-- Copia y pega esto en tu index.html antes de </body> -->
<script src="https://giscus.app/client.js"
        data-repo="${GITHUB_USERNAME}/${GITHUB_REPO}"
        data-repo-id="${REPO_ID}"
        data-category="${CATEGORY_NAME}"
        data-category-id="${CATEGORY_ID}"
        data-mapping="pathname"
        data-strict="0"
        data-reactions-enabled="1"
        data-emit-metadata="0"
        data-input-position="bottom"
        data-theme="light"
        data-lang="es"
        crossorigin="anonymous"
        async>
</script>
EOF
        print_success "Configuración guardada en: $filename"
    fi
}

# =============================================================================
# Main
# =============================================================================

main() {
    print_header
    
    echo -e "${YELLOW}Configuración:${NC}"
    echo "   Username: $GITHUB_USERNAME"
    echo "   Repo: $GITHUB_REPO"
    echo "   Category: $CATEGORY_NAME"
    echo "   Token: $([ -z "$GITHUB_TOKEN" ] && echo '(no configurado)' || echo '***configurado***')"
    echo ""
    
    check_dependencies
    
    echo ""
    
    # Obtener Repo ID (siempre funciona para repos públicos)
    if ! get_repo_id; then
        exit 1
    fi
    
    echo ""
    
    # Obtener Category ID (opcional, puede hacerse manual)
    if ! get_category_id; then
        echo ""
        print_info "Puedes obtener el Category ID manualmente en: https://giscus.app/es"
        echo ""
        echo -e "${YELLOW}Mostrando solo Repo ID:${NC}"
        echo "   data-repo-id=\"${REPO_ID}\""
        echo ""
        echo "El script continuará sin Category ID (Giscus puede detectarlo automáticamente)"
        CATEGORY_ID=""
    fi
    
    echo ""
    show_result
    
    save_to_file
    
    echo ""
    print_success "¡Listo! Ahora actualiza tu index.html y haz git push"
}

# Ejecutar
main "$@"
