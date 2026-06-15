#!/bin/bash

source "$(dirname "$0")/lib_comum.sh"

SCRIPTS_DIR="$(dirname "$0")"

pausar() {
  echo
  read -rp "Pressione [Enter] para voltar ao menu..."
}

mostrar_menu() {
  clear
  echo -e "${C_NEGRITO}${C_VERDE}"
  echo "============================================================"
  echo "  🐾 ${PROJETO} — MENU DEVOPS CLOUD"
  echo "============================================================"
  echo -e "${C_RESET}"
  echo "  Criado por : ${ALUNO}"
  echo "  Instituição: ${INSTITUICAO}"
  echo "  Tema       : ${TEMA}"
  echo "------------------------------------------------------------"
  echo "  1 - Atualizar sistema"
  echo "  2 - Instalar Apache"
  echo "  3 - Criar estrutura do projeto"
  echo "  4 - Realizar backup"
  echo "  5 - Fazer deploy do site"
  echo "  6 - Ver processos"
  echo "  7 - Monitorar sistema"
  echo "  8 - Configurar usuários e permissões"
  echo "  9 - Gerar relatório"
  echo "  0 - Sair"
  echo "------------------------------------------------------------"
}

menu_principal() {
  local opcao
  while true; do
    mostrar_menu
    read -rp "Escolha uma opção: " opcao
    echo
    case "${opcao}" in
      1) bash "${SCRIPTS_DIR}/01_update.sh"; pausar ;;
      2) bash "${SCRIPTS_DIR}/02_apache.sh"; pausar ;;
      3) bash "${SCRIPTS_DIR}/03_estrutura.sh"; pausar ;;
      4) bash "${SCRIPTS_DIR}/04_backup.sh"; pausar ;;
      5) bash "${SCRIPTS_DIR}/05_deploy.sh"; pausar ;;
      6)
        read -rp "Ação (listar | buscar <nome> | matar <PID>): " acao args
        bash "${SCRIPTS_DIR}/06_processos.sh" ${acao} ${args}
        pausar ;;
      7) bash "${SCRIPTS_DIR}/07_monitoramento.sh"; pausar ;;
      8) bash "${SCRIPTS_DIR}/08_usuarios_permissoes.sh"; pausar ;;
      9) bash "${SCRIPTS_DIR}/09_relatorio.sh"; pausar ;;
      0) echo -e "${C_VERDE}Encerrando o menu da ${PROJETO}. Até logo! 🐾${C_RESET}"; exit 0 ;;
      *) msg_alerta "Opção inválida. Tente novamente."; pausar ;;
    esac
  done
}

menu_principal