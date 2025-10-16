# =================================================================
# ETAPA 1: BUILD BASE (Equivalente a Dockerfile_Base)
# =================================================================

# en el docker compose superior se define el valor por defecto para que nunca venga vacío
ARG IMG_ORG
FROM ${IMG_ORG} AS base

# Arguments
ARG QUARTO_VER
ARG USER_NAME
ARG USER_EMAIL

# "Copiando archivos de certificados a la imagen docker..."
# necesario para que ciertas aplicaciones pueda acceder a repositorios https con certificados autofirmados
# - los certificados se copian en /usr/local/share/ca-certificates/ inicialmente
# - desde donde el comando "update-ca-certificates" los carga finalmente en /etc/ssl/certs/ca-certificates.crt
# - que es el fichero que usan las aplicaciones (git, curl, wget, etc.) para validar los certificados ssl
# - PARECE que el comando "update-ca-certificates" se ejecuta al instalar el paquete "software-properties-common"
# - en este caso, se ejecuta al final del "apt-get install" que se hace en la shell "install_dependencies.sh"
COPY docker/settings/base/certificates/*.crt /usr/local/share/ca-certificates/

# "Copiando archivos de configuracion a la imagen ..."
RUN mkdir -p settings/base
COPY docker/settings/base/*.sh settings/base

# Install dependencies and set bash as default shell
RUN bash ./settings/base/install_dependencies.sh

# Install Quarto
#RUN bash -c "set -ex && ./settings/base/install_quarto.sh $QUARTO_VER"
RUN bash ./settings/base/install_quarto.sh $QUARTO_VER

# Set git settings
RUN bash ./settings/base/setting_git.sh $USER_NAME $USER_EMAIL

# =================================================================
# ETAPA 2: BUILD DEV (Equivalente a Dockerfile_Dev)
# =================================================================

# La imagen base es la etapa construida anteriormente ("base")
FROM base AS dev

# Arguments
ARG PYTHON_VER
ARG VENV_NAME
ARG RUFF_VER

# Set Python environment
RUN mkdir -p settings/dev
COPY docker/settings/dev/* settings/dev/
RUN bash ./settings/dev/install_uv.sh $PYTHON_VER $VENV_NAME $RUFF_VER