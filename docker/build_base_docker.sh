#!/bin/bash

# Cargar variables de entorno desde un archivo .env si existe
if [ -f .env ]; then
    set -a  # auto-export todas las variables
    source .env
    set +a
fi

# Construyendo imagen
echo "Construir la imagen docker"

docker buildx build . -f $DOCKERFILE_BASE_NAME \
                --progress=plain \
                --build-arg IMG_ORG=$IMAGE_ORIGEN \
                --build-arg QUARTO_VER=$QUARTO_VERSION \
                --build-arg USER_NAME=$USER_NAME \
                --build-arg USER_EMAIL=$USER_EMAIL \
                -t $IMAGE_BASE_NAME

#docker buildx build . -f $DOCKERFILE_BASE_NAME \
#                --platform linux/amd64,linux/arm64 \
#                --no-cache \
#                --progress=plain \
#                --build-arg IMG_ORG=$IMAGE_ORIGEN \
#                --build-arg QUARTO_VER=$QUARTO_VERSION \
#                --build-arg USER_NAME=$USER_NAME \
#                --build-arg USER_EMAIL=$USER_EMAIL \
#                -t $IMAGE_BASE_NAME

if [[ $? = 0 ]] ; then
    echo "Subiendo imagen docker..."
    echo docker push $IMAGE_BASE_NAME
else
    echo "Fallo en la construcción de la imagen Docker"
fi