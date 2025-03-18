<p align="center">
  <img src="./assets/logo.png" alt="Laravel Logo" width="200">
</p>
<h1 align="center">Laradocker</h1>

Lightweight and optimized Laravel development environment using Docker.

## Features

- Support for Laravel 12
- Optimized Docker containers
- Command-line script for common tasks
- No unnecessary dependencies

## Requirements

- Docker
- Docker Compose

## Installation

1. Clone the repository:

```bash
git clone https://github.com/pdro-lucas/laradocker.git && cd laradocker
```

2. Run the installation script:

```bash
chmod +x install.sh && ./install.sh
```

The script will:

- Check for required dependencies
- Set up Docker containers
- Install the latest Laravel version
- Offer the option to initialize a new Git repository
- Install basic NPM dependencies

## Usage

Once installed, you can manage your Laravel environment using the included script:

```bash
./laradocker.sh [command]
```

### Available Commands:

- `start` - Starts the containers
- `stop` - Stops the containers
- `restart` - Restarts the containers
- `artisan [command]` - Runs Artisan commands (e.g., `./laradocker.sh artisan migrate`)
- `composer [command]` - Runs Composer commands (e.g., `./laradocker.sh composer require guzzlehttp/guzzle`)
- `npm [command]` - Runs NPM commands (e.g., `./laradocker.sh npm run dev`)
- `shell` - Accesses the PHP container shell
- `migrate` - Runs database migrations
- `help` - Displays the list of available commands

## Accessing the Application

After starting the containers, you can access your application at:

- Web: [http://localhost](http://localhost)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
