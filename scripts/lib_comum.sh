#!/bin/bash

export PROJETO="VetClínica"
export TEMA="Clínica Veterinária"
export ALUNO="William Wollert"
export INSTITUICAO="Unidavi"

: "${BASE_DIR:=/app/clinica}"          # raiz dos dados da clínica
: "${LOG_DIR:=${BASE_DIR}/logs}"       # logs operacionais
: "${BACKUP_DIR:=${BASE_DIR}/backups}" # backups .tar.gz
export BASE_DIR LOG_DIR BACKUP_DIR
: "${WEB_DIR:=/var/www/html}"          # publicação do Apache
export WEB_DIR

export PROJETO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export SOURCE_DIR="${PROJETO_DIR}/source"

export LOG_FILE="${LOG_DIR}/clinica_operacoes.log"

export C_VERDE='\033[0;32m'
export C_VERMELHO='\033[0;31m'
export C_AMARELO='\033[1;33m'
export C_AZUL='\033[0;36m'
export C_NEGRITO='\033[1m'
export C_RESET='\033[0m'

garantir_dirs_log() {
  mkdir -p "${LOG_DIR}" "${BACKUP_DIR}" 2>/dev/null
}

registrar_log() {
  local mensagem="$1"
  garantir_dirs_log
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] ${mensagem}" >> "${LOG_FILE}"
}

msg_ok()      { echo -e "${C_VERDE}[OK]${C_RESET} $1";      registrar_log "[OK] $1"; }
msg_erro()    { echo -e "${C_VERMELHO}[ERRO]${C_RESET} $1"; registrar_log "[ERRO] $1"; }
msg_alerta()  { echo -e "${C_AMARELO}[ALERTA]${C_RESET} $1"; registrar_log "[ALERTA] $1"; }
msg_info()    { echo -e "${C_AZUL}[INFO]${C_RESET} $1";     registrar_log "[INFO] $1"; }

cabecalho() {
  local titulo="$1"
  echo -e "${C_NEGRITO}${C_VERDE}"
  echo "============================================================"
  echo "  🐾 ${PROJETO} — ${titulo}"
  echo "  Tema: ${TEMA} | ${INSTITUICAO}"
  echo "============================================================"
  echo -e "${C_RESET}"
}

checar_root() {
  if [ "$(id -u)" -ne 0 ]; then
    msg_alerta "Esta operação requer privilégios de root (use sudo ou rode no container)."
    return 1
  fi
  return 0
}