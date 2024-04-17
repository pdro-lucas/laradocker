.PHONY: setup build-laravel install-npm-packages modify-vite-config

setup: build-laravel install-npm-packages modify-vite-config
	@echo ""
	@echo "*********************"
	@echo "*                   *"
	@echo "*    Laradocker     *"
	@echo "*                   *"
	@echo "*********************"
	@echo ""
	@echo "Setup completed successfully!"
	@echo "To start the development server, run:"
	@echo "docker-compose run --rm --service-ports npm run dev"
	@echo "Then access the application at:"
	@echo "http://localhost:5173"

build-laravel:
	@echo "Building Docker containers and setting permissions for src directory"
	docker-compose up -d --build app
	sudo chmod -R 777 src/
	@echo "Installing Laravel..."
	cd src
	docker-compose run --rm composer create-project laravel/laravel .
	@echo "Initializing new git repository"
	rm -rf .git/

install-npm-packages:
	@echo "Installing npm packages"
	docker-compose run --rm npm install

modify-vite-config:
	@echo "Modifying dev script in package.json"
	sed -i 's/"dev": "vite"/"dev": "vite --host 0.0.0.0"/' src/package.json
