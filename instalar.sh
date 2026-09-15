#!/bin/bash
# Reinstala Waydroid con la configuración de Android TV respaldada
set -e
echo "== Instalando Waydroid =="
sudo apt install -y waydroid

echo "== Restaurando configuración =="
sudo mkdir -p /var/lib/waydroid
sudo cp "$(dirname "$0")/config/waydroid.cfg" "$(dirname "$0")/config/waydroid.prop" "$(dirname "$0")/config/waydroid_base.prop" /var/lib/waydroid/

echo "== Imágenes del sistema =="
IMG=~/waydroid-atv
if [ ! -d "$IMG" ] || [ -z "$(ls -A "$IMG" 2>/dev/null)" ]; then
    echo "AVISO: $IMG está vacío. Restaura tus imágenes de Android TV ahí"
    echo "       (verifica su integridad con imagenes-checksums.txt)"
else
    echo "Imágenes presentes en $IMG:"
    ls -lh "$IMG" | awk 'NR>1{print "  ", $5, $9}'
fi

echo "== Inicializando Waydroid =="
sudo waydroid init -f
echo "Listo. Arranca con:  waydroid show-full-ui"
