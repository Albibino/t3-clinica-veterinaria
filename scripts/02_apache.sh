#!/bin/bash

source "$(dirname "$0")/lib_comum.sh"

instalar_apache() {
  msg_info "Instalando o servidor Apache (apache2)..."
  if DEBIAN_FRONTEND=noninteractive apt install -y apache2; then
    msg_ok "Apache instalado."
  else
    msg_erro "Falha ao instalar o Apache."
    return 1
  fi
}

iniciar_apache() {
  msg_info "Iniciando o serviço Apache..."
  if service apache2 start 2>/dev/null || apachectl start 2>/dev/null; then
    msg_ok "Serviço Apache iniciado."
  else
    msg_alerta "Não foi possível iniciar via service; tente 'apachectl start' manualmente."
  fi
}

verificar_apache() {
  if command -v apache2 >/dev/null 2>&1; then
    msg_ok "Apache está instalado no ambiente da ${PROJETO}."
    return 0
  else
    msg_erro "Apache NÃO está instalado."
    return 1
  fi
}

versao_apache() {
  if command -v apache2 >/dev/null 2>&1; then
    msg_info "Versão do Apache instalada:"
    apache2 -v
  else
    msg_alerta "Apache não encontrado para exibir a versão."
  fi
}

cabecalho "Instalação e Validação do Apache"

if ! checar_root; then
  msg_erro "Instalação do Apache requer privilégios de root."
  exit 1
fi

instalar_apache
iniciar_apache
verificar_apache
versao_apache