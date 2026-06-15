#!/bin/bash

# Uso:
#   ./06_processos.sh listar
#   ./06_processos.sh buscar apache
#   ./06_processos.sh matar 1234


source "$(dirname "$0")/lib_comum.sh"

listar_processos() {
  msg_info "Processos ativos no ambiente da ${PROJETO}:"
  ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | head -n 20
}

buscar_processo() {
  local nome="$1"
  if [ -z "${nome}" ]; then
    msg_erro "Informe o nome do processo. Ex.: ./06_processos.sh buscar apache"
    return 1
  fi

  msg_info "Buscando processos contendo '${nome}'..."
  local resultado
  resultado="$(ps -eo pid,user,comm,args | grep -i "${nome}" | grep -v grep)"

  if [ -n "${resultado}" ]; then
    echo "${resultado}"
    msg_ok "Busca concluída."
  else
    msg_alerta "Nenhum processo encontrado para '${nome}'."
  fi
}

matar_processo() {
  local pid="$1"

  if [ -z "${pid}" ]; then
    msg_erro "SEGURANÇA: nenhum PID informado. Encerramento cancelado."
    msg_info "Uso correto: ./06_processos.sh matar <PID>"
    return 1
  fi

  if ! [[ "${pid}" =~ ^[0-9]+$ ]]; then
    msg_erro "SEGURANÇA: PID inválido ('${pid}'). Informe apenas números."
    return 1
  fi

  if ! kill -0 "${pid}" 2>/dev/null; then
    msg_alerta "Não existe processo com PID ${pid} (ou sem permissão)."
    return 1
  fi

  msg_info "Encerrando o processo PID ${pid}..."
  if kill "${pid}" 2>/dev/null; then
    msg_ok "Processo ${pid} encerrado."
  else
    msg_erro "Falha ao encerrar o processo ${pid}."
    return 1
  fi
}

cabecalho "Gerenciamento de Processos"

ACAO="$1"
case "${ACAO}" in
  listar) listar_processos ;;
  buscar) buscar_processo "$2" ;;
  matar)  matar_processo "$2" ;;
  *)
    msg_info "Uso: $0 {listar | buscar <nome> | matar <PID>}"
    ;;
esac