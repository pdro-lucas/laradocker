<h1 align="center">Laradocker</h1>
<p align="center">
  <img src="./assets/logo.png" alt="Laravel Logo" width="200">
</p>

This project is aimed at simplifying the setup of a Laravel development environment by leveraging Docker. The goal is to streamline the process for developers to create, test, and deploy Laravel applications efficiently.

## Getting Started

To get started, clone the repository and navigate to the project directory:

```bash
git clone https://github.com/pdro-lucas/laradocker.git && cd laradocker
```

Now, build the Docker containers:

```bash
docker-compose up -d --build app
```

## Installing Laravel

1. Set permissions to modify the `src/` folder:

```bash
chmod -R 777 src/
```

2. Install Laravel:

```bash
cd src/
docker-compose run --rm composer create-project laravel/laravel .
```

## Setting Up Development Environment

1. Install npm dependencies:

```bash
docker-compose run --rm npm install
```

2. Modify the `package.json` file:

```json
"dev": "vite --host 0.0.0.0",
```

3. Configure `vite.config.js`:

```javascript
import laravel from 'laravel-vite-plugin'
import { defineConfig } from 'vite'

export default defineConfig({
  server: {
    host: '0.0.0.0',
    port: 5173,
    hmr: {
      host: 'localhost',
    },
  },
  plugins: [
    laravel({
      input: ['resources/css/app.css', 'resources/js/app.js'],
      refresh: true,
    }),
  ],
})
```

4. Run npm dev:

```bash
docker-compose run --rm --service-ports npm run dev
```

## Accessing the Application

Access the application at: [http://localhost:5173](http://localhost:5173)
