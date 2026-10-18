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

## 🔧 Falla conocida: Android TV no arranca (pantalla en negro)

**Síntoma**: Waydroid abre la ventana pero Android nunca termina de
arrancar. En `sudo waydroid shell "logcat -d -b crash"` todos los
procesos (zygote, keystore2, keymaster…) mueren con
`BORINGSSL_FIPS_abort` dentro de `rand_get_seed`.

**Causa**: bug de AMD Ryzen — tras suspender/reanudar el equipo, la
instrucción RDRAND del CPU queda atascada devolviendo siempre
`0xFFFFFFFFFFFFFFFF`. El BoringSSL FIPS de Android lo detecta y aborta
todos los procesos criptográficos, así que el sistema nunca bootea.
El reinicio normal (warm reboot) NO lo repara.

**Solución**:
1. Verificar el estado: `./verificar-rdrand.sh`
2. Si está roto: **apagado en frío** — apagar del todo, desconectar el
   cargador y mantener pulsado el botón de encendido ~30 s; luego
   encender y volver a verificar.
3. Prevenir: actualizar el BIOS de Dell (la corrección oficial de AMD
   viene vía AGESA en las actualizaciones de BIOS).

## Archivos de este respaldo

- `config/waydroid.cfg` — configuración principal (ruta de imágenes,
  binder, suspend_action=freeze, overlays montados)
- `config/waydroid.prop` — propiedades del dispositivo
- `config/waydroid_base.prop` — propiedades base
- `imagenes-checksums.txt` — SHA-256 de las imágenes de ~/waydroid-atv
  para comprobar que tus copias externas están intactas.

Sesión de origen: "Instalar Waydroid con imagen Android TV en Ubuntu".

## ☕ Donaciones

Si este proyecto te sirve, apóyame en Ko-fi:

[![Ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/F1F81BZQDW)
