# NASA API

A TypeScript-based API built with Fastify that retrieves Near Earth Object (NEO) data from NASA's API.

## Features

- Fetch asteroid data for specific date ranges
- Type-safe implementation with TypeScript
- OpenAPI documentation with Swagger UI
- Code quality enforcement with ESLint and Prettier
- Modular architecture with plugins and routes

## Prerequisites

- Node.js v20.16.0 or higher
- npm

## Installation

1. Clone the repository
2. Install dependencies:

```bash
npm install
```

3. Create a `.env` file based on `.env.example`:

```bash
cp .env.example .env
```

4. (Optional) Add your NASA API key to `.env`:

```
NASA_API_KEY=your_api_key_here
```

Get a free API key at [https://api.nasa.gov/](https://api.nasa.gov/)

## Usage

### Development

Start the development server with hot reload:

```bash
npm run dev
```

### Production

Build and run for production:

```bash
npm run build
npm start
```

### Available Scripts

- `npm run dev` - Start development server with hot reload
- `npm run build` - Build TypeScript to JavaScript
- `npm start` - Start production server
- `npm run lint` - Check code for linting errors
- `npm run lint:fix` - Fix linting errors automatically
- `npm run format` - Format code with Prettier
- `npm run format:check` - Check code formatting
- `npm run type-check` - Check TypeScript types without emitting files

## API Endpoints

### GET /api/nasa

Retrieve asteroid data for a specific date range.

**Query Parameters:**
- `start_date` (required) - Start date in YYYY-MM-DD format
- `end_date` (required) - End date in YYYY-MM-DD format

**Example Request:**

```bash
curl 'http://localhost:3000/api/nasa?start_date=2024-01-01&end_date=2024-01-07'
```

**Example Response:**

```json
{
  "asteroids": [
    {
      "name": "456051 (2006 AW)",
      "average_size": 0.746,
      "closeness_to_earth_km": 25524830.7,
      "relative_velocity_kmh": 49054.69
    }
  ]
}
```

## Documentation

Interactive API documentation is available at:

```
http://localhost:3000/documentation
```

## Project Structure

```
nasa-api/
├── src/
│   ├── server.ts              # Main server setup
│   ├── routes/
│   │   └── nasa.ts            # NASA API route handlers
│   └── plugins/
│       └── nasa-parser.ts     # Data parsing logic and types
├── dist/                      # Compiled JavaScript (generated)
├── package.json
├── tsconfig.json
├── .eslintrc.json
├── .prettierrc
└── README.md
```

## Technologies

- **Fastify** - Fast and low overhead web framework
- **TypeScript** - Type-safe JavaScript
- **@fastify/swagger** - OpenAPI specification generation
- **@fastify/swagger-ui** - Interactive API documentation
- **ESLint** - Code linting
- **Prettier** - Code formatting
- **tsx** - TypeScript execution for development

## License

MIT
