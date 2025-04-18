#!/bin/bash

# LTE Simulation Setup Script - Versión Mejorada

# Colores para mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar root
[ "$EUID" -ne 0 ] && echo -e "${RED}Ejecuta como root/sudo${NC}" && exit 1

# 1. Instalar dependencias
echo -e "${YELLOW}Instalando dependencias...${NC}"
apt-get update

if ! command -v docker &> /dev/null; then
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io
fi

if ! command -v docker-compose &> /dev/null; then
    curl -L "https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

# 2. Crear estructura del proyecto
echo -e "${YELLOW}Creando estructura...${NC}"
BASE_DIR="lte-simulation-docker"
mkdir -p ${BASE_DIR}/{config,scripts}
mkdir -p ${BASE_DIR}/config/{hss,mme,sgw,pgw,enb,ue}

# 3. Crear archivos de configuración esenciales
echo -e "${YELLOW}Generando configuraciones...${NC}"

# docker-compose.yml
cat > ${BASE_DIR}/docker-compose.yml <<'EOF'
version: '3.8'

services:
  hss:
    image: open5gs/hss
    container_name: hss
    networks:
      lte-net:
        ipv4_address: 172.18.0.10
    ports:
      - "3868:3868"
    volumes:
      - ./config/hss:/etc/open5gs

  mme:
    image: open5gs/mme
    container_name: mme
    networks:
      lte-net:
        ipv4_address: 172.18.0.20
    ports:
      - "36412:36412"
      - "3870:3870"
    depends_on:
      - hss
    volumes:
      - ./config/mme:/etc/open5gs

  pgw:
    image: open5gs/pgw
    container_name: pgw
    networks:
      lte-net:
        ipv4_address: 172.18.0.40
    ports:
      - "2152:2152"
    volumes:
      - ./config/pgw:/etc/open5gs
EOF

# Script de monitoreo básico
cat > ${BASE_DIR}/scripts/monitor.sh <<'EOF'
#!/bin/bash
echo "Contenedores LTE:"
docker ps -a --filter "name=hss\|name=mme\|name=pgw" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
EOF

# Dar permisos
chmod +x ${BASE_DIR}/scripts/monitor.sh

echo -e "${GREEN}Configuración completada!${NC}"
echo -e "\nSiguientes pasos:"
echo -e "1. cd ${BASE_DIR}"
echo -e "2. docker network create lte-net --subnet=172.18.0.0/16"
echo -e "3. docker-compose up -d"
echo -e "\nPara ver el estado: ./scripts/monitor.sh"