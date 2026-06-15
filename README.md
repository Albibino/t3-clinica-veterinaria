# Trabalho 03 — Linux, Shell Script e Cloud Computing

Ambiente Linux containerizado com scripts Shell de automação operacional, aplicado ao tema
**Clínica Veterinária (VetClínica)**.

---

## 1. Aluno

**William Wollert** — Unidavi

## 2. Tema

**Clínica Veterinária** — sistema/infraestrutura de apoio a uma clínica que atende animais
(pacientes), gerencia consultas, funcionários, medicamentos e agendamentos.

## 3. Tecnologias Utilizadas

- Linux Ubuntu 22.04
- Docker
- Docker Compose
- Apache (apache2)
- Shell Script (Bash)
- GitHub
- DockerHub

## 4. Estrutura do Projeto

```
t3-clinica-veterinaria/
├── Dockerfile               # Imagem Ubuntu + ferramentas + scripts/site
├── docker-compose.yml       # Serviço trabalho03-linux, volume e porta 8080:80
├── README.md                # Este arquivo
├── Trabalho 03.txt          # Enunciado original (referência)
├── scripts/                 # Scripts de automação da clínica
│   ├── lib_comum.sh         # Biblioteca compartilhada (variáveis, log, cores)
│   ├── 01_update.sh         # Atualização do sistema
│   ├── 02_apache.sh         # Instalação e validação do Apache
│   ├── 03_estrutura.sh      # Estrutura de diretórios da clínica
│   ├── 04_backup.sh         # Backup automatizado (.tar.gz)
│   ├── 05_deploy.sh         # Deploy do site no Apache
│   ├── 06_processos.sh      # Gerenciamento de processos
│   ├── 07_monitoramento.sh  # Monitoramento de CPU/RAM/disco/Apache
│   ├── 08_usuarios_permissoes.sh  # Usuários, grupos e permissões
│   ├── 09_relatorio.sh      # Relatório operacional
│   └── menu.sh              # Menu principal (integração)
├── source/                  # Site estático da clínica (servido pelo Apache)
│   ├── index.html
│   ├── sobre.html
│   └── assets/css/
├── backups/                 # Backups gerados (bind do container)
├── logs/                    # Logs e relatório (bind do container)
└── evidencias/              # Prints/arquivos de evidência
```

Dentro do container, os dados da clínica ficam em `/app/clinica/`:

```
/app/clinica/
├── pacientes/      # Cadastro de animais
├── consultas/      # Consultas veterinárias
├── funcionarios/   # Equipe (veterinários e recepção)
├── medicamentos/   # Estoque de medicamentos
├── agendamentos/   # Agendamentos
├── relatorios/     # Relatórios
├── backups/        # Backups .tar.gz
└── logs/           # Logs e relatorio_execucao.txt
```

## 5. Explicação de Cada Script

| Script | Funções principais | Descrição |
|---|---|---|
| `lib_comum.sh` | `registrar_log`, `cabecalho`, `msg_ok/erro/alerta`, `checar_root` | Biblioteca carregada por todos os scripts; centraliza variáveis do tema, log e mensagens. |
| `01_update.sh` | `atualizar_sistema` | Executa `apt update && apt upgrade -y`, registra log e informa sucesso/falha. |
| `02_apache.sh` | `instalar_apache`, `verificar_apache`, `versao_apache` | Instala o Apache, inicia o serviço, valida a instalação e mostra a versão. |
| `03_estrutura.sh` | `criar_estrutura` | Remove estrutura antiga com segurança e cria os diretórios temáticos da clínica + arquivos iniciais. |
| `04_backup.sh` | `gerar_backup` | Gera `.tar.gz` com data/hora dos dados da clínica e valida o arquivo criado. |
| `05_deploy.sh` | `publicar_site` | Limpa `/var/www/html`, publica o site de `source/`, lista os arquivos e valida o `index.html`. |
| `06_processos.sh` | `listar_processos`, `buscar_processo`, `matar_processo` | Lista, busca e encerra processos; bloqueia encerramento sem PID. |
| `07_monitoramento.sh` | `uso_cpu`, `monitorar` | Mostra CPU, memória, disco e status do Apache; emite `[ALERTA]` acima dos limites. |
| `08_usuarios_permissoes.sh` | `criar_grupo`, `criar_usuario`, `aplicar_permissoes`, `configurar_acesso` | Cria grupo `clinica_ops` e usuários `vet_user`/`recepcao_user`; aplica `chown`/`chmod` (sem 777). |
| `09_relatorio.sh` | `gerar_relatorio` | Consolida disco, diretórios, Apache, backups, logs, publicação e usuários em `logs/relatorio_execucao.txt`. |
| `menu.sh` | `menu_principal` | Menu interativo que executa todas as rotinas acima. |

## 6. Como Executar o Projeto

```sh
docker compose up -d --build
docker ps
docker exec -it trabalho03-linux bash
```

## 7. Como Acessar o Apache no Navegador

Após rodar os scripts de instalação do Apache (2) e deploy (5), acesse:

```
http://localhost:8080
```

## 8. Como Executar Cada Script

Dentro do container, na pasta dos scripts:

```sh
cd /app/scripts
chmod +x *.sh

./01_update.sh
./02_apache.sh
./03_estrutura.sh
./04_backup.sh
./05_deploy.sh
./06_processos.sh listar
./06_processos.sh buscar apache
./06_processos.sh matar <PID>
./07_monitoramento.sh
./08_usuarios_permissoes.sh
./09_relatorio.sh
```

> Ordem recomendada na primeira execução: **1 → 2 → 3 → 5 → 4 → 7 → 8 → 9**.

## 9. Como Executar o Menu Principal

```sh
cd /app/scripts
./menu.sh
```

## 10. Evidências de Funcionamento

As evidências estão na pasta [`evidencias/`]

## 11. DockerHub

Imagem publicada em:

```
https://hub.docker.com/r/williamwollert/trabalho03-clinica
```

## 12. Uso de Inteligência Artificial

Para a organização do projeto e revisão dos scripts utilizei IA como apoio.
A IA ajudou a estruturar a biblioteca comum (`lib_comum.sh`), padronizar as mensagens de log e
revisar a documentação. **Todos os scripts foram revisados e adaptados manualmente** ao tema da
clínica veterinária — nomes de diretórios, grupos (`clinica_ops`), usuários (`vet_user`,
`recepcao_user`), conteúdo do site e mensagens.