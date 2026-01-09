#!/bin/bash

# Detener el script si ocurre algún error
set -e

echo "🚀 Iniciando la instalación de Docker..."

# 1. Limpieza de versiones antiguas
echo "🧹 Eliminando versiones antiguas de Docker si existen..."
sudo apt-get remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true

# 2. Actualización de paquetes e instalación de dependencias
echo "📦 Actualizando repositorios e instalando dependencias..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

# 3. Configuración de la clave GPG y el Repositorio oficial
echo "🔑 Configurando la clave GPG de Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "📂 Agregando el repositorio de Docker a las fuentes de APT..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 4. Instalación de Docker Engine y Plugins
echo "⚙️ Instalando Docker Engine, CLI y Docker Compose..."
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 5. Configuración de permisos para el usuario actual
echo "👤 Configurando el grupo docker para el usuario $USER..."
if ! getent group docker > /dev/null; then
    sudo groupadd docker
fi
sudo usermod -aG docker $USER

echo "✅ Instalación completada con éxito."
echo "-------------------------------------------------------"
echo "⚠️  IMPORTANTE: Para aplicar los cambios de grupo sin reiniciar,"
echo "   ejecuta el siguiente comando ahora mismo:"
echo ""
echo "   newgrp docker"
echo "-------------------------------------------------------"

# 6. Verificación rápida
docker --version
