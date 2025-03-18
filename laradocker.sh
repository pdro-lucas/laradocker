#!/bin/bash

print_message() {
  local type=$1
  local message=$2

  case $type in
    "info")
      echo -e "\e[1;34m[INFO]\e[0m $message"
      ;;
    "success")
      echo -e "\e[1;32m[SUCCESS]\e[0m $message"
      ;;
    "error")
      echo -e "\e[1;31m[ERROR]\e[0m $message"
      ;;
    "header")
      echo ""
      echo -e "\e[1;36m$message\e[0m"
      echo -e "\e[1;36m$(printf '=%.0s' $(seq 1 ${#message}))\e[0m"
      echo ""
      ;;
  esac
}

if ! command -v docker-compose &> /dev/null; then
  print_message "error" "Docker Compose não está instalado. Por favor, instale o Docker Compose primeiro."
  exit 1
fi

export UID=$(id -u)
export GID=$(id -g)

case "$1" in
  "artisan")
    shift
    docker-compose run --rm -u $(id -u):$(id -g) artisan "$@"
    ;;

  "composer")
    shift
    docker-compose run --rm -u $(id -u):$(id -g) composer "$@"
    ;;

  "npm")
    shift
    docker-compose run --rm -u $(id -u):$(id -g) npm "$@"
    ;;

  "shell")
    docker-compose exec -u $(id -u):$(id -g) php sh
    ;;

  "start")
    print_message "info" "Iniciando containers Docker..."
    docker-compose up -d
    print_message "success" "Containers iniciados!"
    echo "Acesse a aplicação em: http://localhost"
    ;;

  "stop")
    print_message "info" "Parando containers Docker..."
    docker-compose down
    print_message "success" "Containers parados!"
    ;;

  "restart")
    print_message "info" "Reiniciando containers Docker..."
    docker-compose down && docker-compose up -d
    print_message "success" "Containers reiniciados!"
    echo "Acesse a aplicação em: http://localhost"
    ;;

  "migrate")
    docker-compose run --rm -u $(id -u):$(id -g) artisan migrate
    ;;

  "help")
    echo ""
    echo "Laradocker - Ambiente de desenvolvimento Laravel com Docker"
    echo ""
    echo "Uso: ./laradocker.sh [comando] [opções]"
    echo ""
    echo "Comandos disponíveis:"
    echo "  artisan [comando]   - Executa comandos Artisan"
    echo "  composer [comando]  - Executa comandos Composer"
    echo "  npm [comando]       - Executa comandos NPM"
    echo "  shell               - Acessa o shell do PHP"
    echo "  start               - Inicia os containers"
    echo "  stop                - Para os containers"
    echo "  restart             - Reinicia os containers"
    echo "  migrate             - Executa as migrações"
    echo "  help                - Exibe esta ajuda"
    echo ""
    ;;

  *)
    echo "Comando desconhecido: $1"
    echo "Use './laradocker.sh help' para ver a lista de comandos disponíveis"
    exit 1
    ;;
esac
