#!/bin/bash

source "$(dirname "$0")/lib_comum.sh"

LIMITE_CPU=80
LIMITE_MEM=80
LIMITE_DISCO=80

uso_cpu() {
  read -r _ a b c d _ < /proc/stat
  local idle1=$d total1=$((a+b+c+d))
  sleep 1
  read -r _ a b c d _ < /proc/stat
  local idle2=$d total2=$((a+b+c+d))
  local dtotal=$((total2-total1)) didle=$((idle2-idle1))
  if [ "${dtotal}" -gt 0 ]; then
    echo $(( (100 * (dtotal - didle)) / dtotal ))
  else
    echo 0
  fi
}

monitorar() {
  cabecalho "Monitoramento do Sistema"
  msg_info "Coleta realizada em: $(date '+%Y-%m-%d %H:%M:%S')"
  echo

  local cpu
  cpu=$(uso_cpu)
  echo "🖥️  Uso de CPU:    ${cpu}%"
  if [ "${cpu}" -ge "${LIMITE_CPU}" ]; then
    msg_alerta "Uso de CPU acima de ${LIMITE_CPU}% (${cpu}%)"
  else
    msg_ok "CPU em nível normal (${cpu}%)"
  fi

  local mem_total mem_disp mem_uso
  mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  mem_disp=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
  mem_uso=$(( (100 * (mem_total - mem_disp)) / mem_total ))
  echo "🧠 Uso de memória: ${mem_uso}%"
  if [ "${mem_uso}" -ge "${LIMITE_MEM}" ]; then
    msg_alerta "Uso de memória acima de ${LIMITE_MEM}% (${mem_uso}%)"
  else
    msg_ok "Memória em nível normal (${mem_uso}%)"
  fi

  local disco
  disco=$(df / | awk 'END{gsub("%","",$5); print $5}')
  echo "💾 Uso de disco:   ${disco}%"
  if [ "${disco}" -ge "${LIMITE_DISCO}" ]; then
    msg_alerta "Uso de disco acima de ${LIMITE_DISCO}% (${disco}%)"
  else
    msg_ok "Disco em nível normal (${disco}%)"
  fi

  echo
  if pgrep -x apache2 >/dev/null 2>&1; then
    msg_ok "Apache em execução"
  else
    msg_alerta "Apache NÃO está em execução"
  fi
}

monitorar