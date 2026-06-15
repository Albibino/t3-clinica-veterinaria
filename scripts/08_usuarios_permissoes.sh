#!/bin/bash

source "$(dirname "$0")/lib_comum.sh"

GRUPO="clinica_ops"           # grupo operacional da clínica
USUARIO_VET="vet_user"        # usuário dos veterinários
USUARIO_REC="recepcao_user"   # usuário da recepção

criar_grupo() {
  if getent group "${GRUPO}" >/dev/null; then
    msg_alerta "Grupo '${GRUPO}' já existe."
  else
    groupadd "${GRUPO}" && msg_ok "Grupo '${GRUPO}' criado."
  fi
}

criar_usuario() {
  local usuario="$1"
  if id "${usuario}" >/dev/null 2>&1; then
    msg_alerta "Usuário '${usuario}' já existe."
  else
    useradd --system -g "${GRUPO}" -s /usr/sbin/nologin "${usuario}" \
      && msg_ok "Usuário de sistema '${usuario}' criado no grupo '${GRUPO}'."
  fi
}

aplicar_permissoes() {
  if [ ! -d "${BASE_DIR}" ]; then
    msg_erro "Estrutura ${BASE_DIR} não existe. Rode 03_estrutura.sh antes."
    return 1
  fi

  msg_info "Aplicando dono '${USUARIO_VET}:${GRUPO}' em ${BASE_DIR}..."
  chown -R "${USUARIO_VET}:${GRUPO}" "${BASE_DIR}"

  msg_info "Aplicando permissões 770 (dono+grupo) — dados sensíveis da clínica..."
  chmod -R 770 "${BASE_DIR}"

  chmod 750 "${BASE_DIR}/pacientes"
  msg_ok "Permissões aplicadas."

  echo
  msg_info "Permissões atuais em ${BASE_DIR}:"
  ls -ld "${BASE_DIR}" "${BASE_DIR}"/*
}

configurar_acesso() {
  cabecalho "Usuários, Grupos e Permissões"

  if ! checar_root; then
    msg_erro "Gerenciar usuários/grupos requer privilégios de root."
    return 1
  fi

  criar_grupo
  criar_usuario "${USUARIO_VET}"
  criar_usuario "${USUARIO_REC}"
  aplicar_permissoes
}

configurar_acesso