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
  print_message "error" "Docker Compose is not installed. Please install Docker Compose first."
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
    print_message "info" "Starting Docker containers..."
    docker-compose up -d
    print_message "success" "Containers started!"
    echo "Access the application at: http://localhost"
    ;;

  "stop")
    print_message "info" "Stopping Docker containers..."
    docker-compose down
    print_message "success" "Containers stopped!"
    ;;

  "restart")
    print_message "info" "Restarting Docker containers..."
    docker-compose down && docker-compose up -d
    print_message "success" "Containers restarted!"
    echo "Access the application at: http://localhost"
    ;;

  "migrate")
    docker-compose run --rm -u $(id -u):$(id -g) artisan migrate
    ;;

  "help")
    echo ""
    echo "Laradocker - Laravel development environment with Docker"
    echo ""
    echo "Usage: ./laradocker.sh [command] [options]"
    echo ""
    echo "Available commands:"
    echo "  artisan [command]   - Run Artisan commands"
    echo "  composer [command]  - Run Composer commands"
    echo "  npm [command]       - Run NPM commands"
    echo "  shell               - Access PHP shell"
    echo "  start               - Start containers"
    echo "  stop                - Stop containers"
    echo "  restart             - Restart containers"
    echo "  migrate             - Run migrations"
    echo "  help                - Display this help"
    echo ""
    ;;

  *)
    echo "Unknown command: $1"
    echo "Use './laradocker.sh help' to see the list of available commands"
    exit 1
    ;;
esac
