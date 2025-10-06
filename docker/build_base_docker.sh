#!/bin/bash

# Image settings
user_name=pacoalcaide
image_label=python-base
tag=0.0.1
quarto_ver="1.8.24"
dockerfile="Dockerfile_Base"

image_name="$user_name/$image_label:$tag"

echo "Construir la imagen docker"

docker buildx build  . -f $dockerfile \
                --platform linux/amd64,linux/arm64 \
                --progress=plain \
                --build-arg QUARTO_VER=$quarto_ver \
                -t $image_name

if [[ $? = 0 ]] ; then
echo "Subiendo imagen docker..."
docker push $image_name
else
echo "Fallo en la construcción de la imagen Docker"
fi