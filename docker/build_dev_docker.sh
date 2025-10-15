#!/bin/bash

# Cargar variables de entorno desde un archivo .env si existe
if [ -f ../.env ]; then
    set -a  # auto-export todas las variables
    source ../.env
    set +a
fi

# Construyendo imagen
echo "Construyendo imagen docker para desarrollo"

docker buildx build . -f $DOCKERFILE_DEV_NAME \
                --progress=plain \
                --build-arg IMG_BASE_NAME=$IMAGE_BASE_NAME \
                --build-arg VENV_NAME=$VENV_NAME \
                --build-arg PYTHON_VER=$PYTHON_VERSION \
                --build-arg RUFF_VER=$RUFF_VERSION \
                -t $IMAGE_DEV_NAME

#docker buildx build . -f $DOCKERFILE_DEV_NAME \
#                --platform linux/amd64,linux/arm64 \
#                --no-cache \
#                --progress=plain \
#                --build-arg IMG_BASE_NAME=$IMAGE_BASE_NAME \
#                --build-arg VENV_NAME=$VENV_NAME \
#                --build-arg PYTHON_VER=$PYTHON_VERSION \
#                --build-arg RUFF_VER=$RUFF_VERSION \
#                -t $IMAGE_DEV_NAME

if [[ $? = 0 ]] ; then
    echo "Subiendo imagen docker..."
    echo docker push $IMAGE_DEV_NAME
else
    echo "Fallo construyendo imagen Docker"
fi