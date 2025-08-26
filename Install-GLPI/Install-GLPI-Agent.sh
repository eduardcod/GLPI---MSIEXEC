# !/bin/bash
# Instalação do GLPI AGENT e configuração

# ------------------------------------
#    INSTALAÇÃO DO GLPI PARA LINUX
# ------------------------------------

set -e

GLPI_SERVER="http://10.123.87.5/marketplace/glpiinventory/"
AGENT_TAG="PDV"
INSTALL_URL="https://github.com/glpi-project/glpi-agent/releases/download/1.15/glpi-agent-1.15-linux-installer.pl"
LOG_FILE= "/var/log/glpi-agent-install.log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "========================================="
echo " INÍCIO DA INSTALAÇÃO DO GLPI AGENT 1.15 "
echo " Data/Hora: $(date)"
echo " Log: $LOG_FILE"
echo "========================================="

echo "Estamos começando a instalação do GLPI Agent 1.15..."

if command -v apt-get &> /dev/null; then
    echo "Ubuntu detectado"
    sudo apt-get install -y perl libwww-perl libjson-perl libxml-simple-perl wget

elif command -v yum &> /dev/null; then
    echo "CentOS Detectado"
    sudo yum install -y perl perl-libwww-perl perl-JSON perl-XML-Simple wget
else
    echo "GLPI não suporta essa Distribuição"
    exit 1
fi

# BAIXAR O GLPI PARA INSTALAÇÃO
echo "Baixando o Agent GLPI..."
    wget -o /tmp/glpi-agent-1.15-linux-installer.pl $INSTALL_URL
    chmod +x /tmp/glpi-agent-1.15-linux-installer.pl

# INSTALANDO O GLPI AGENT 
echo "Instalando GLPI Agent..."
sudo perl /tmp/glpi-agent-1.15-linux-installer.pl --type=all --install


AGENT_CONF_FILE="/etc/glpi-agent/glpi-agent.cfg"

# PARAMETROS DO AGENT GLPI
sudo sed -i "s|^server_url=.*|server_url = $GLPI_SERVER|" $AGENT_CONF_FILE 2>/dev/null || \
echo "tags = $AGENT_TAG" | sudo tee -a $AGENT_CONF_FILE

echo "Verificando e localizando o serviço do GLPI Agent..."
    sudo systemctl enable glpi-agent
    sudo systemctl restart glpi-agent

echo "Instalação e configuração concluidas!"
    sudo systemctl status glpi-agent --no-pager
    sudo glpi-agent --force
echo "========================================="
echo " INSTALAÇÃO E CONFIGURAÇÃO CONCLUÍDAS! "
echo " Data/Hora: $(date)"
echo " Consulte o log completo em: $LOG_FILE"
echo "========================================="
 

