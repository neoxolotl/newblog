# 🤖 Tu Propia IA Local con llama.cpp

> Guía completa para instalar y ejecutar modelos de lenguaje grandes (LLMs) en tu propia máquina, sin depender de servicios en la nube.

---

## 📋 ¿Qué es llama.cpp?

[llama.cpp](https://github.com/ggml-org/llama.cpp) es una implementación en C/C++ optimizada para ejecutar modelos de lenguaje como Llama 3, Mistral, Gemma y otros, directamente en tu hardware local. 

### ✅ Ventajas de ejecutar tu propia IA:
- 🔒 **Privacidad total**: Tus datos nunca salen de tu máquina
- 💰 **Sin costos recurrentes**: Una vez instalado, es gratis
- 🌐 **Funciona offline**: Ideal para entornos sin conexión
- ⚡ **Baja latencia**: Sin esperas por respuestas de API remotas
- 🛠️ **Control total**: Ajusta parámetros, prompts y comportamiento

---

## 🚀 Instalación Automática

Este proyecto incluye un script instalador que configura todo por ti.

### Requisitos previos:
- Sistema operativo: Debian/Ubuntu, Arch Linux o Fedora
- Conexión a internet (para descargar dependencias y el repositorio)
- Mínimo 8 GB de RAM (16+ GB recomendado)
- Espacio en disco: ~5 GB para el código + espacio para modelos

### Ejecutar el instalador:

```bash
# Copiar este script instalador 
# Dar permisos de ejecución
chmod +x install-llama.sh
```
### Script.

```bash
#!/usr/bin/env bash

set -e

echo "========================================="
echo " Instalador automático de llama.cpp"
echo "========================================="

INSTALL_DIR="$HOME/llama.cpp"

# ─────────────────────────────────────────
# Detectar distro
# ─────────────────────────────────────────

if [ -f /etc/debian_version ]; then
    DISTRO="debian"
elif [ -f /etc/arch-release ]; then
    DISTRO="arch"
elif [ -f /etc/fedora-release ]; then
    DISTRO="fedora"
else
    echo "[ERROR] Distribución no soportada."
    exit 1
fi

echo "[INFO] Distro detectada: $DISTRO"

# ─────────────────────────────────────────
# Instalar dependencias
# ─────────────────────────────────────────

echo "[INFO] Instalando dependencias..."

case $DISTRO in
    debian)
        sudo apt update
        sudo apt install -y \
            git build-essential cmake \
            curl wget \
            libopenblas-dev \
            vulkan-tools libvulkan-dev
        ;;
    arch)
        sudo pacman -Sy --noconfirm \
            git base-devel cmake \
            curl wget \
            openblas \
            vulkan-tools vulkan-headers
        ;;
    fedora)
        sudo dnf install -y \
            git gcc gcc-c++ make cmake \
            curl wget \
            openblas-devel \
            vulkan-tools vulkan-loader-devel
        ;;
esac

# ─────────────────────────────────────────
# Detectar backend
# ─────────────────────────────────────────

BACKEND="CPU"

if command -v nvidia-smi >/dev/null 2>&1; then
    BACKEND="CUDA"
elif command -v vulkaninfo >/dev/null 2>&1; then
    BACKEND="VULKAN"
fi

echo "[INFO] Backend detectado: $BACKEND"

# ─────────────────────────────────────────
# Clonar repositorio
# ─────────────────────────────────────────

if [ ! -d "$INSTALL_DIR" ]; then
    git clone https://github.com/ggml-org/llama.cpp.git "$INSTALL_DIR"
else
    echo "[INFO] llama.cpp ya existe. Actualizando..."
    cd "$INSTALL_DIR"
    git pull
fi

cd "$INSTALL_DIR"

# ─────────────────────────────────────────
# Compilar
# ─────────────────────────────────────────

echo "[INFO] Compilando llama.cpp..."

rm -rf build

case $BACKEND in

    CUDA)
        cmake -B build \
            -DGGML_CUDA=ON \
            -DGGML_BLAS=ON \
            -DGGML_BLAS_VENDOR=OpenBLAS

        cmake --build build --config Release -j$(nproc)
        ;;

    VULKAN)
        cmake -B build \
            -DGGML_VULKAN=ON \
            -DGGML_BLAS=ON \
            -DGGML_BLAS_VENDOR=OpenBLAS

        cmake --build build --config Release -j$(nproc)
        ;;

    CPU)
        cmake -B build \
            -DGGML_BLAS=ON \
            -DGGML_BLAS_VENDOR=OpenBLAS

        cmake --build build --config Release -j$(nproc)
        ;;

esac

# ─────────────────────────────────────────
# Verificación
# ─────────────────────────────────────────

echo
echo "[INFO] Verificando instalación..."

if [ -f "$INSTALL_DIR/build/bin/llama-cli" ]; then
    echo "[OK] llama.cpp instalado correctamente."
else
    echo "[ERROR] No se encontró llama-cli."
    exit 1
fi

# ─────────────────────────────────────────
# Crear carpeta modelos
# ─────────────────────────────────────────

mkdir -p "$HOME/models"

echo
echo "========================================="
echo " Instalación completada"
echo "========================================="
echo
echo "Binarios:"
echo "  $INSTALL_DIR/build/bin/"
echo
echo "Modelos GGUF:"
echo "  $HOME/models/"
echo
echo "Ejemplo de uso:"
echo
echo "  ./build/bin/llama-cli \\"
echo "      -m ~/models/modelo.gguf \\"
echo "      -p 'Hola' \\"
echo "      -n 128"
echo
echo "Servidor OpenAI-compatible:"
echo
echo "  ./build/bin/llama-server \\"
echo "      -m ~/models/modelo.gguf \\"
echo "      --host 0.0.0.0 \\"
echo "      --port 8080"
echo
echo "========================================="  
```


# Ejecutar (pedirá contraseña para sudo si es necesario)
./install-llama.sh
