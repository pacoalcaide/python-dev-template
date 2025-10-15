#!/bin/bash
set -e

ENV_FILE=".env"
OUTPUT_FILE=".devcontainer/devcontainer.env"
REQUIRED_VARS=("IMAGE_DEV_NAME" "VENV_NAME" "PYTHON_INTERPRETER" "SSL_CERT_FILE" "NODE_EXTRA_CA_CERTS") # Añade las variables clave que quieres en el output

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=== Preparando variables de entorno (Solo obligatorias) ==="

# Verifica que existe el .env
if [ ! -f "$ENV_FILE" ]; then
    echo -e "${RED}❌ ERROR: No se encuentra $ENV_FILE${NC}"
    exit 1
fi

# Crea el directorio si no existe
mkdir -p .devcontainer

# Carga el .env en el entorno actual para interpolación
# (Debe hacerse para que las variables ${!var} y eval funcionen)
set -a
source "$ENV_FILE"
set +a

# Valida y procesa solo las variables obligatorias
echo -e "\n${YELLOW}Validando e interpolando variables obligatorias...${NC}"
> "$OUTPUT_FILE"

# Itera SOLAMENTE sobre el array de variables requeridas
for key in "${REQUIRED_VARS[@]}"; do
    value="${!key}" # Obtiene el valor de la variable del entorno actual

    # 1. Valida si la variable está definida
    if [ -z "$value" ]; then
        echo -e "${RED}❌ ERROR: Variable obligatoria $key no definida o vacía en $ENV_FILE${NC}"
        exit 1
    fi

    # 2. Evalúa el valor para interpolar variables anidadas (ej: VAR_B=$VAR_A)
    # Usamos eval y comillas dobles para asegurar la interpolación de las variables ya cargadas
    eval "resolved_value=\"$value\"" 
    
    # 3. Escribe al archivo resuelto
    echo "$key=$resolved_value" >> "$OUTPUT_FILE"
    echo -e "${GREEN}  ✓ $key=$resolved_value${NC}"
done

# --- Sección de Depuración y Finalización ---

# Exporta las variables al entorno actual (solo para el shell donde se ejecuta el script)
set -a
source "$OUTPUT_FILE"
set +a

echo -e "\n${GREEN}✅ Proceso completado${NC}"
echo -e "    Archivo generado con variables clave: ${YELLOW}$OUTPUT_FILE${NC}"

# Muestra variables clave para debug (Nota: PYTHON_INTERPRETER debe estar definido en .env)
echo -e "\n${YELLOW}Variables clave disponibles:${NC}"
for var in "${REQUIRED_VARS[@]}"; do
    if [ -n "${!var}" ]; then
        echo "    $var=${!var}"
    fi
done