#!/usr/bin/env bash -x
QUARTO_VERSION=$1 

echo "Installing Quarto version $QUARTO_VERSION"

# Identify the CPU type (M1 vs Intel)
if [[ $(uname -m) ==  "aarch64" ]] ; then
  CPU="arm64"
elif [[ $(uname -m) ==  "arm64" ]] ; then
  CPU="arm64"
else
  CPU="amd64"
fi

echo TEMP_QUARTO=$(mktemp) && \
  echo wget -q  -O $TEMP_QUARTO https://github.com/quarto-dev/quarto-cli/releases/download/v$QUARTO_VERSION/quarto-${QUARTO_VERSION}-linux-${CPU}.deb && \
  echo dpkg -i $TEMP_QUARTO && \
  echo rm -f $TEMP_QUARTO