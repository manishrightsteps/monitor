import 'dotenv/config';
import './otel.js';
import express from 'express';
import logger from './logger.js';

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

app.get('/health', (req, res) => {
  logger.info('Health check requested');
  return res.json({
    success: true,
    status: 'healthy',
    uptime: process.uptime(),
    timestamp: new Date().toISOString()
  });
});

app.listen(port, () => {
  logger.info(`Server is running on port ${port}`, {
    port,
    env: process.env.NODE_ENV || 'development',
    otelEndpoint: process.env.OTEL_EXPORTER_OTLP_ENDPOINT
  });
});