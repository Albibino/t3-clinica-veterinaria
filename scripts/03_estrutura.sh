#!/bin/bash

source "$(dirname "$0")/lib_comum.sh"

SUBDIRS=("pacientes" "consultas" "funcionarios" "medicamentos" \
         "agendamentos" "relatorios" "backups" "logs")

criar_estrutura() {
  cabecalho "Estrutura de Diretórios"

  if [ -d "${BASE_DIR}" ]; then
    if [ -z "${BASE_DIR}" ] || [ "${BASE_DIR}" = "/" ] || [[ "${BASE_DIR}" != *clinica* ]]; then
      msg_erro "BASE_DIR inseguro (${BASE_DIR}). Abortando por segurança."
      return 1
    fi
    msg_alerta "Estrutura antiga encontrada em ${BASE_DIR}. Removendo com segurança..."
    rm -rf "${BASE_DIR}" && msg_ok "Estrutura antiga removida."
  fi

  msg_info "Criando estrutura da ${PROJETO} em ${BASE_DIR}..."
  for sub in "${SUBDIRS[@]}"; do
    if mkdir -p "${BASE_DIR}/${sub}"; then
      echo "   📁 ${BASE_DIR}/${sub}"
    else
      msg_erro "Falha ao criar ${BASE_DIR}/${sub}"
      return 1
    fi
  done

  echo "Cadastro de pacientes (animais) da clínica." > "${BASE_DIR}/pacientes/LEIA-ME.txt"
  echo "Registros de consultas veterinárias."        > "${BASE_DIR}/consultas/LEIA-ME.txt"
  echo "Equipe da clínica (veterinários e recepção)." > "${BASE_DIR}/funcionarios/LEIA-ME.txt"
  echo "Estoque e controle de medicamentos."          > "${BASE_DIR}/medicamentos/LEIA-ME.txt"

  msg_ok "Estrutura de diretórios da ${PROJETO} criada com sucesso."
  echo
  msg_info "Árvore criada:"
  ls -R "${BASE_DIR}"
}

criar_estrutura