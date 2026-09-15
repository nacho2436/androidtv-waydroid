# 📺 Android TV con Waydroid en Ubuntu

Instalación de una imagen **Android TV** dentro de Waydroid
(contenedor Android en Linux) del equipo jose-Vostro-3405.

## Componentes

- Waydroid instalado por apt, vendor MAINLINE, sistema GAPPS.
- Imágenes del sistema ubicadas en `/home/jose/waydroid-atv/`
  (por seguridad NO se suben a git: pesan ~6 GB; ver
  `imagenes-checksums.txt` para verificar integridad de tus copias
  locales).
- Datos/apps instaladas dentro de Android: en
  `~/.local/share/waydroid/data` (1.4 GB, tampoco van a git).

## Reinstalación completa

```bash
# 1. Waydroid
sudo apt install waydroid

# 2. Configuración respaldada (imágenes, binder, OTA)
sudo mkdir -p /var/lib/waydroid
sudo cp config/waydroid.cfg config/waydroid.prop config/waydroid_base.prop /var/lib/waydroid/

# 3. Imágenes del sistema (restaurarlas en /home/jose/waydroid-atv
#    desde tu respaldo externo o descargarlas de:
#    https://docs.waydro.id/  — y verificar con imagenes-checksums.txt)

# 4. Inicializar y arrancar
sudo waydroid init -f
waydroid show-full-ui
```

## Archivos de este respaldo

- `config/waydroid.cfg` — configuración principal (ruta de imágenes,
  binder, suspend_action=freeze, overlays montados)
- `config/waydroid.prop` — propiedades del dispositivo
- `config/waydroid_base.prop` — propiedades base
- `imagenes-checksums.txt` — SHA-256 de las imágenes de ~/waydroid-atv
  para comprobar que tus copias externas están intactas.

Sesión de origen: "Instalar Waydroid con imagen Android TV en Ubuntu".
