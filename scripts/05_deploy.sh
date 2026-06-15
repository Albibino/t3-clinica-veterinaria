#!/bin/bash

source "$(dirname "$0")/lib_comum.sh"

publicar_site() {
  cabecalho "Deploy do Site Estático"

  if [ ! -d "${SOURCE_DIR}" ]; then
    msg_erro "Pasta de origem do site não encontrada: ${SOURCE_DIR}"
    return 1
  fi

  if [ ! -f "${SOURCE_DIR}/index.html" ]; then
    msg_erro "index.html não encontrado em ${SOURCE_DIR}. Deploy abortado."
    return 1
  fi

  if ! checar_root; then
    msg_alerta "Pode ser necessário root para escrever em ${WEB_DIR}."
  fi

  mkdir -p "${WEB_DIR}"

  msg_info "Limpando o diretório de destino ${WEB_DIR}..."
  rm -rf "${WEB_DIR:?}"/*

  msg_info "Publicando o site da ${PROJETO}..."
  if cp -r "${SOURCE_DIR}"/* "${WEB_DIR}/"; then
    msg_ok "Arquivos copiados para ${WEB_DIR}."
  else
    msg_erro "Falha ao copiar os arquivos do site."
    return 1
  fi

  if [ -f "${WEB_DIR}/index.html" ]; then
    msg_ok "Validação OK: index.html publicado em ${WEB_DIR}."
  else
    msg_erro "index.html não encontrado no destino após o deploy."
    return 1
  fi

  echo
  msg_info "Arquivos publicados:"
  ls -lh "${WEB_DIR}"
  echo
  msg_info "Acesse o site da clínica em: http://localhost:8080"
}

publicar_site