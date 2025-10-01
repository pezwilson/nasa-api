import { FastifyPluginAsync } from 'fastify';
import { parseNasaData, NASANeoResponse } from '../plugins/nasa-parser';

const nasaRoutes: FastifyPluginAsync = async (fastify) => {
  fastify.get(
    '/api/nasa',
    {
      schema: {
        querystring: {
          type: 'object',
          required: ['start_date', 'end_date'],
          properties: {
            start_date: { type: 'string', pattern: '^\\d{4}-\\d{2}-\\d{2}$' },
            end_date: { type: 'string', pattern: '^\\d{4}-\\d{2}-\\d{2}$' },
          },
        },
      },
    },
    async (request) => {
      const { start_date, end_date } = request.query as {
        start_date: string;
        end_date: string;
      };

      const NASA_API_KEY = process.env.NASA_API_KEY || 'DEMO_KEY';
      const url = `https://api.nasa.gov/neo/rest/v1/feed?start_date=${start_date}&end_date=${end_date}&api_key=${NASA_API_KEY}`;

      const response = await fetch(url);
      const nasaData = await response.json() as NASANeoResponse;

      const asteroids = parseNasaData(nasaData);

      return { asteroids };
    }
  );
};

export default nasaRoutes;