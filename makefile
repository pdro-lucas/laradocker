.PHONY: setup build set_permissions init_git

setup: build set_permissions init_git finish

build:
	@echo "Building docker containers"
	docker-compose up -d --build app

set_permissions:
	@echo "Setting permissions for src directory! This step requires sudo to run properly"
	sudo chmod -R 777 src/

init_git:
	@echo "\nDo you want to initialize a new Git repository? (Y/n)"
	@read answer; \
	if [ "$$answer" != "${answer#[Yy]}" ]; then \
		rm -rf .git/; \
		git init; \
		echo "Git repository initialized"; \
	else \
		echo "Skipping initialization of Git repository"; \
	fi

finish:
	@echo "Finished setting up project"
