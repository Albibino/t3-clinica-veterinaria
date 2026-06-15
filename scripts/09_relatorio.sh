#!/bin/bash

source "$(dirname "$0")/lib_comum.sh"

RELATORIO="${LOG_DIR}/relatorio_execucao.txt"

gerar_relatorio() {
  cabecalho "Relatório Operacional"

  mkdir -p "$(dirname "${RELATORIO}")"

  secao() { echo "" ; echo "----- $1 -----" ; }

  {
    echo "============================================================"
    echo "  RELATÓRIO OPERACIONAL — ${PROJETO}"
    echo "============================================================"
    echo "Projeto : ${PROJETO}"
    echo "Tema    : ${TEMA}"
    echo "Aluno   : ${ALUNO} (${INSTITUICAO})"
    echo "Data    : $(date '+%Y-%m-%d %H:%M:%S')"
    echo "Host    : $(hostname)"

    secao "ESPAÇO EM DISCO"
    df -h /

    secao "USO DOS DIRETÓRIOS DA CLÍNICA"
    if [ -d "${BASE_DIR}" ]; then
      du -sh "${BASE_DIR}"/* 2>/dev/null
    else
      echo "(estrutura ${BASE_DIR} ainda não criada)"
    fi

    secao "STATUS DO APACHE"
    if command -v apache2 >/dev/null 2>&1; then
      apache2 -v | head -n1
      if pgrep -x apache2 >/dev/null 2>&1; then
        echo "Status: EM EXECUÇÃO"
      else
        echo "Status: PARADO"
      fi
    else
      echo "Apache não instalado."
    fi

    secao "ÚLTIMOS BACKUPS"
    ls -lht "${BACKUP_DIR}"/backup_clinica_*.tar.gz 2>/dev/null | head -n 5 \
      || echo "(nenhum backup encontrado)"

    secao "ÚLTIMOS LOGS"
    ls -lht "${LOG_DIR}"/*.log 2>/dev/null | head -n 5 \
      || echo "(nenhum log encontrado)"

    secao "ARQUIVOS PUBLICADOS (APACHE)"
    ls -lh "${WEB_DIR}" 2>/dev/null || echo "(nada publicado)"

    secao "USUÁRIOS E PERMISSÕES DA CLÍNICA"
    echo "Grupo clinica_ops:"
    getent group clinica_ops || echo "(grupo não criado)"
    echo "Permissões em ${BASE_DIR}:"
    ls -ld "${BASE_DIR}" 2>/dev/null || echo "(estrutura não criada)"

    echo ""
    echo "============================================================"
    echo "  Fim do relatório — ${PROJETO}"
    echo "============================================================"
  } > "${RELATORIO}"

  msg_ok "Relatório gerado em: ${RELATORIO}"
  echo
  msg_info "Prévia do relatório:"
  cat "${RELATORIO}"
}

gerar_relatorio