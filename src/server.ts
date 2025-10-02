import 'dotenv/config';
import Fastify from 'fastify';
import cors from '@fastify/cors';
import swagger from '@fastify/swagger';
import swaggerUi from '@fastify/swagger-ui';
import nasaRoutes from './routes/nasa';

const app = Fastify({
  logger: {
    level: process.env.LOG_LEVEL || 'info',
  },
});

await app.register(cors, {
  origin: 'http://localhost:5173', // Your frontend URL
  credentials: true,
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

// Register routes
await app.register(nasaRoutes);

// Start server
const start = async () => {
  try {
    const port = Number(process.env.PORT) || 3000;
    const host = process.env.HOST || 'localhost';

    await app.listen({ port, host });

    console.log(`Server listening on http://${host}:${port}`);
    console.log(`Documentation at http://${host}:${port}/documentation`);
  } catch (err) {
    app.log.error(err);
    process.exit(1);
  }
};

start();