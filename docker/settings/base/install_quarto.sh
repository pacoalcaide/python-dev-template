#!/usr/bin/env bash

QUARTO_VERSION=$1 
TEMP_QUARTO=$(mktemp)

# Identify the CPU type (M1 vs Intel)
if [[ $(uname -m) ==  "aarch64" ]] ; then
  CPU="arm64"
elif [[ $(uname -m) ==  "arm64" ]] ; then
  CPU="arm64"
else
  CPU="amd64"
fi

URL_QUARTO="https://github.com/quarto-dev/quarto-cli/releases/download/v$QUARTO_VERSION/quarto-${QUARTO_VERSION}-linux-${CPU}.deb"

# Download and install Quarto
echo "Downloading and Installing Quarto version from $URL_QUARTO"
#wget -q --no-check-certificate -O $TEMP_QUARTO $URL_QUARTO && \
wget -q -O $TEMP_QUARTO $URL_QUARTO && \
dpkg -i $TEMP_QUARTO && \
rm -f $TEMP_QUARTO