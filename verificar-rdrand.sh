#!/bin/bash
# Verifica que RDRAND (generador aleatorio del CPU) funcione.
# Si RDRAND queda atascado (bug de AMD tras suspender), Android no arranca:
# todos los procesos mueren con BORINGSSL_FIPS_abort en rand_get_seed.
# Uso: ./verificar-rdrand.sh
set -e
SRC=$(mktemp /tmp/rdrand_test_XXXX.c)
BIN=${SRC%.c}
trap 'rm -f "$SRC" "$BIN"' EXIT
cat > "$SRC" <<'EOF'
#include <stdio.h>
#include <stdint.h>
#include <immintrin.h>
int main(void) {
    unsigned long long v, prev = 0;
    int sospechosos = 0;
    for (int i = 0; i < 10; i++) {
        if (_rdrand64_step(&v) == 0) { printf("RDRAND fallo (CF=0)\n"); return 2; }
        if (v == prev || v == 0 || v == 0xffffffffffffffffULL) sospechosos++;
        prev = v;
    }
    if (sospechosos > 0) {
        printf("RDRAND ROTO: devuelve valores constantes/invalidos (%d/10)\n", sospechosos);
        printf("Android NO arrancara. Hace falta apagado en FRIO (ver README).\n");
        return 1;
    }
    printf("RDRAND OK: valores aleatorios correctos\n");
    return 0;
}
EOF
gcc -O2 -mrdrnd -o "$BIN" "$SRC"
"$BIN"
