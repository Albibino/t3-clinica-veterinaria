#!/bin/bash

source "$(dirname "$0")/lib_comum.sh"

atualizar_sistema() {
  cabecalho "Atualização do Sistema"

  if ! checar_root; then
    msg_erro "Não foi possível atualizar o sistema sem privilégios."
    return 1
  fi

  msg_info "Atualizando a lista de pacotes (apt update)..."
  if apt update; then
    msg_ok "Lista de pacotes atualizada."
  else
    msg_erro "Falha ao executar 'apt update'."
    return 1
  fi

  msg_info "Atualizando os pacotes instalados (apt upgrade)..."
  if DEBIAN_FRONTEND=noninteractive apt upgrade -y; then
    msg_ok "Sistema da ${PROJETO} atualizado com sucesso."
  else
    msg_erro "Falha ao executar 'apt upgrade'."
    return 1
  fi

  return 0
}

atualizar_sistema