#!/usr/bin/env bash

#Parámetros: nombre de usuario y correo electrónico
user_name=$1
user_email=$2

# Setting up Git
git config --global user.name $user
git config --global user.email $user_email
git config --global init.defaultBranch main
touch ~/.gitignore

git config --global core.excludesFile ~/.gitignore
git config --global core.editor "vim"