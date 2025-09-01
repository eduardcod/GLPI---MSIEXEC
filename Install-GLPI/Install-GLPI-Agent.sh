#!/bin/bash
# ===============================================
# Instalação do GLPI Agent
# ===============================================

set -e

# Definir variáveis
LOG_FILE="/var/log/glpi-agent-install.log"
GLPI_SERVER="http://10.123.87.5/marketplace/glpiinventory/"
AGENT_TAG="PDV"
GLPI_VERSION="1.15"
INSTALLER="/tmp/glpi-agent-1.15-x86_64.AppImage"

# Redirecionar saída para log e terminal
exec > >(tee -a "$LOG_FILE") 2>&1

echo "==============================================="
echo "   INÍCIO DA INSTALAÇÃO DO GLPI AGENT $GLPI_VERSION"
echo "==============================================="

# Baixar instalador AppImage
echo "[INFO] Baixando instalador AppImage..."
wget -O "$INSTALLER" "https://github.com/glpi-project/glpi-agent/releases/download/$GLPI_VERSION/glpi-agent-$GLPI_VERSION-x86_64.AppImage"
chmod +x "$INSTALLER"

# Instalar o GLPI Agent
echo "[INFO] Instalando GLPI Agent..."
sudo "$INSTALLER" --install --server "$GLPI_SERVER" --tag "$AGENT_TAG" --tasks inventory,network,software,hardware --service

echo "==============================================="
echo "INSTALAÇÃO CONCLUÍDA COM SUCESSO!"
echo "Verifique o log em: $LOG_FILE"
echo "==============================================="

# Verificar status do serviço
sudo systemctl enable glpi-agent --no-pager
sudo systemctl restart gllpi-agent --no-pager
sudo systemctl status glpi-agent --no-pager
sudo glpi-agent --force
echo "[INFO] Removendo arquivo AppImage temporário..."
sudo rm -f "$INSTALLER"
