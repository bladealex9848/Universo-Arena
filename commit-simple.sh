#!/bin/bash
if [ -z "$1" ]; then
  echo "Error: Debes proporcionar un mensaje para el commit."
  echo "Uso: ./commit-simple.sh \"Mensaje de commit\""
  exit 1
fi

git add .
git commit -m "$1"
echo "Commit realizado exitosamente con el mensaje: '$1'"
