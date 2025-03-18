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
  print_message "header" "Checking dependencies"

  if ! command -v docker &> /dev/null; then
    print_message "error" "Docker is not installed. Please install Docker first."
    exit 1
  fi

  if ! command -v docker-compose &> /dev/null; then
    print_message "error" "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
  fi

  print_message "success" "All dependencies are installed."
}

setup_directories() {
  print_message "header" "Setting up directories"

  mkdir -p src

  export UID=$(id -u)
  export GID=$(id -g)

  print_message "success" "Directories configured."
}

start_containers() {
  print_message "header" "Starting Docker containers"

  docker-compose up -d

  print_message "success" "Containers started."
}

install_laravel() {
  print_message "header" "Installing Laravel"

  docker-compose run --rm -u $(id -u):$(id -g) composer create-project laravel/laravel .

  find ./src -type d -exec chmod 755 {} \;
  find ./src -type f -exec chmod 644 {} \;

  print_message "success" "Laravel installed."
}

setup_npm() {
  print_message "header" "Configuring NPM"

  docker-compose run --rm -u $(id -u):$(id -g) npm install

  print_message "success" "NPM configured"
}

setup_git() {
  print_message "header" "Configuring Git"

  read -p "Do you want to initialize a new Git repository? (y/n): " init_git

  if [ "$init_git" = "s" ] || [ "$init_git" = "S" ]; then
    (cd src && git init && git add . && git commit -m "First commit with laradocker")
    print_message "success" "Git repository initialized"
  else
    print_message "info" "Skipping Git initialization"
  fi
}

finalize_installation() {
  print_message "header" "Finalizing installation"

  docker-compose run --rm artisan key:generate

  echo ""
  print_message "success" "Installation successfully completed!"
  echo ""
  echo "⚡ To start the Laravel server, run:"
  echo "   ./laradocker start"
  echo ""
  echo "🌐 Access the application at: http://localhost"
  echo ""
  echo "📚 Useful commands:"
  echo "   ./laradocker.sh help               - See all available commands"
  echo "   ./laradocker.sh artisan [comando]  - Runs Artisan commands"
  echo "   ./laradocker.sh composer [comando] - Runs Composer commands"
  echo "   ./laradocker.sh npm [comando]      - Runs NPM commands"
  echo "   ./laradocker.sh shell              - Accesses the PHP shell"
  echo "   ./laradocker.sh start              - Starts the containers"
  echo "   ./laradocker.sh stop               - Stops the containers"
  echo ""
}

main() {
  print_message "header" "Laradocker - Installation"

  check_dependencies
  setup_directories
  start_containers
  install_laravel
  setup_npm
  setup_git
  finalize_installation
}

main
