#!/bin/bash

source "$(dirname "$0")/lib_comum.sh"

ORIGEM="${BASE_DIR}"                 # dados da clínica a serem salvos
DESTINO="${BACKUP_DIR}"             # onde os backups ficam guardados

gerar_backup() {
  cabecalho "Backup Automatizado"

  if [ ! -d "${ORIGEM}" ]; then
    msg_erro "Diretório de origem ${ORIGEM} não existe. Rode 03_estrutura.sh antes."
    return 1
  fi

  garantir_dirs_log
  mkdir -p "${DESTINO}"

  local data_hora
  data_hora="$(date '+%Y-%m-%d_%H-%M')"
  local arquivo="${DESTINO}/backup_clinica_${data_hora}.tar.gz"

  msg_info "Gerando backup de ${ORIGEM}..."
  if tar --exclude="${DESTINO}" -czf "${arquivo}" -C "$(dirname "${ORIGEM}")" "$(basename "${ORIGEM}")"; then
    if [ -s "${arquivo}" ]; then
      local tamanho
      tamanho="$(du -h "${arquivo}" | cut -f1)"
      msg_ok "Backup criado: ${arquivo} (${tamanho})"
    else
      msg_erro "Backup gerado, mas o arquivo está vazio."
      return 1
    fi
  else
    msg_erro "Falha ao gerar o backup."
    return 1
  fi

  echo
  msg_info "Backups disponíveis em ${DESTINO}:"
  ls -lh "${DESTINO}"/backup_clinica_*.tar.gz 2>/dev/null
}

gerar_backup