#!/bin/bash

# NASA API Installation Script
# Node.js v20.16.0

set -e

echo "🚀 Setting up NASA API with TypeScript, ESLint, Prettier, and OpenAPI..."

# Create project directory structure
echo "📁 Creating project structure..."
mkdir -p src

# Initialize package.json
echo "📦 Initializing package.json..."
npm init -y

# Update package name
node << 'NAMESCRIPT'
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
pkg.name = 'nasa-api';
pkg.version = '1.0.0';
pkg.description = 'NASA API built with Fastify';
fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
NAMESCRIPT

# Install Fastify and core dependencies
echo "⬇️  Installing Fastify dependencies..."
npm install fastify @fastify/swagger @fastify/swagger-ui

# Install TypeScript and type definitions
echo "⬇️  Installing TypeScript..."
npm install -D typescript @types/node tsx

# Install ESLint and plugins
echo "⬇️  Installing ESLint..."
npm install -D eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin
npm install -D eslint-config-prettier eslint-plugin-prettier

# Install Prettier
echo "⬇️  Installing Prettier..."
npm install -D prettier

# Create tsconfig.json
echo "⚙️  Creating tsconfig.json..."
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ES2022",
    "lib": ["ES2022"],
    "moduleResolution": "bundler",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "removeComments": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF

# Create ESLint configuration
echo "⚙️  Creating .eslintrc.json..."
cat > .eslintrc.json << 'EOF'
{
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "ecmaVersion": 2022,
    "sourceType": "module",
    "project": "./tsconfig.json"
  },
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:prettier/recommended"
  ],
  "plugins": ["@typescript-eslint", "prettier"],
  "rules": {
    "prettier/prettier": "error",
    "@typescript-eslint/no-explicit-any": "warn",
    "@typescript-eslint/no-unused-vars": ["error", { "argsIgnorePattern": "^_" }]
  },
  "env": {
    "node": true,
    "es2022": true
  }
}
EOF

# Create Prettier configuration
echo "⚙️  Creating .prettierrc..."
cat > .prettierrc << 'EOF'
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false
}
EOF

# Create .prettierignore
cat > .prettierignore << 'EOF'
node_modules
dist
coverage
*.md
EOF

# Create main application file
echo "📝 Creating src/server.ts..."
cat > src/server.ts << 'EOF'
import Fastify from 'fastify';
import swagger from '@fastify/swagger';
import swaggerUi from '@fastify/swagger-ui';

const app = Fastify({
  logger: {
    level: process.env.LOG_LEVEL || 'info',
  },
});

// Register Swagger
await app.register(swagger, {
  openapi: {
    info: {
      title: 'NASA API',
      description: 'NASA API documentation',
      version: '1.0.0',
    },
    servers: [
      {
        url: 'http://localhost:3000',
        description: 'Development server',
      },
    ],
  },
});

await app.register(swaggerUi, {
  routePrefix: '/documentation',
  uiConfig: {
    docExpansion: 'list',
    deepLinking: false,
  },
});

// NASA data endpoint
app.get(
  '/api/nasa',
  {
    schema: {
      description: 'Get NASA data for a date range',
      querystring: {
        type: 'object',
        required: ['start_date', 'end_date'],
        properties: {
          start_date: {
            type: 'string',
            description: 'Start date (YYYY-MM-DD)',
            pattern: '^\\d{4}-\\d{2}-\\d{2}$',
          },
          end_date: {
            type: 'string',
            description: 'End date (YYYY-MM-DD)',
            pattern: '^\\d{4}-\\d{2}-\\d{2}$',
          },
        },
      },
      response: {
        200: {
          type: 'object',
          properties: {
            start_date: { type: 'string' },
            end_date: { type: 'string' },
            data: { type: 'array' },
          },
        },
      },
    },
  },
  async (request) => {
    const { start_date, end_date } = request.query as {
      start_date: string;
      end_date: string;
    };

    // TODO: Add your NASA API logic here
    return {
      start_date,
      end_date,
      data: [],
    };
  }
);

// Start server
const start = async () => {
  try {
    const port = Number(process.env.PORT) || 3000;
    const host = process.env.HOST || '0.0.0.0';

    await app.listen({ port, host });

    console.log(`🚀 Server listening on http://${host}:${port}`);
    console.log(`📚 Documentation at http://${host}:${port}/documentation`);
  } catch (err) {
    app.log.error(err);
    process.exit(1);
  }
};

start();
EOF

# Create .env.example
echo "📝 Creating .env.example..."
cat > .env.example << 'EOF'
PORT=3000
HOST=0.0.0.0
LOG_LEVEL=info
NODE_ENV=development
EOF

# Create .gitignore
echo "📝 Creating .gitignore..."
cat > .gitignore << 'EOF'
node_modules
dist
.env
*.log
coverage
.DS_Store
EOF

# Update package.json scripts
echo "⚙️  Updating package.json scripts..."
node << 'SCRIPT'
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));

pkg.type = 'module';
pkg.scripts = {
  "dev": "tsx src/server.ts",
  "build": "tsc",
  "start": "node dist/server.js",
  "lint": "eslint src/**/*.ts",
  "lint:fix": "eslint src/**/*.ts --fix",
  "format": "prettier --write \"src/**/*.ts\"",
  "format:check": "prettier --check \"src/**/*.ts\"",
  "type-check": "tsc --noEmit"
};

pkg.engines = {
  "node": ">=20.0.0"
};

fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
SCRIPT

echo ""
echo "✅ Setup complete!"
echo ""
echo "📋 Next steps:"
echo "   1. Run 'npm run dev' to start the development server"
echo "   2. Visit http://localhost:3000/documentation for API docs"
echo "   3. Test: curl 'http://localhost:3000/api/nasa?start_date=2024-01-01&end_date=2024-01-31'"
echo ""
echo "📚 Available commands:"
echo "   npm run dev          - Start development server"
echo "   npm run build        - Build for production"
echo "   npm start            - Start production server"
echo "   npm run lint         - Lint code"
echo "   npm run lint:fix     - Fix linting issues"
echo "   npm run format       - Format code with Prettier"
echo ""