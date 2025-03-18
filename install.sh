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

check_dependencies() {
  print_message "header" "Verificando dependências"

  if ! command -v docker &> /dev/null; then
    print_message "error" "Docker não está instalado. Por favor, instale o Docker primeiro."
    exit 1
  fi

  if ! command -v docker-compose &> /dev/null; then
    print_message "error" "Docker Compose não está instalado. Por favor, instale o Docker Compose primeiro."
    exit 1
  fi

  print_message "success" "Todas as dependências estão instaladas"
}

setup_directories() {
  print_message "header" "Configurando diretórios"

  mkdir -p src

  export UID=$(id -u)
  export GID=$(id -g)

  print_message "success" "Diretórios configurados"
}

start_containers() {
  print_message "header" "Iniciando containers Docker"

  docker-compose up -d

  print_message "success" "Containers iniciados"
}

install_laravel() {
  print_message "header" "Instalando Laravel"

  docker-compose run --rm composer create-project laravel/laravel .

  print_message "success" "Laravel instalado"
}

setup_npm() {
  print_message "header" "Configurando NPM"

  docker-compose run --rm -u $(id -u):$(id -g) npm install

  print_message "success" "NPM configurado"
}

setup_git() {
  print_message "header" "Configurando Git"

  read -p "Deseja inicializar um novo repositório Git? (s/n): " init_git

  if [ "$init_git" = "s" ] || [ "$init_git" = "S" ]; then
    (cd src && git init && git add . && git commit -m "Projeto inicial com Laradocker")
    print_message "success" "Repositório Git inicializado"
  else
    print_message "info" "Pulando inicialização do Git"
  fi
}

finalize_installation() {
  print_message "header" "Finalizando instalação"

  # Gerar chave de aplicação
  docker-compose run --rm artisan key:generate

  echo ""
  print_message "success" "Instalação finalizada com sucesso!"
  echo ""
  echo "⚡ Para iniciar o servidor Laravel, execute:"
  echo "   docker-compose up -d"
  echo ""
  echo "🌐 Acesse a aplicação em: http://localhost"
  echo ""
  echo "📚 Comandos úteis:"
  echo "   ./laradocker.sh artisan [comando]  - Executa comandos Artisan"
  echo "   ./laradocker.sh composer [comando] - Executa comandos Composer"
  echo "   ./laradocker.sh npm [comando]      - Executa comandos NPM"
  echo "   ./laradocker.sh shell              - Acessa o shell do PHP"
  echo "   ./laradocker.sh start              - Inicia os containers"
  echo "   ./laradocker.sh stop               - Para os containers"
  echo ""
}

main() {
  print_message "header" "Laradocker - Instalação"

  check_dependencies
  setup_directories
  start_containers
  install_laravel
  setup_npm
  setup_git
  finalize_installation
}

main
