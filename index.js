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

app.get('/api/users/:id', (req, res) => {
  logger.error('Database connection failed', {
    error: 'ECONNREFUSED',
    endpoint: '/api/users/:id',
    userId: req.params.id,
    message: 'Could not connect to PostgreSQL database',
    code: 'DB_CONNECTION_ERROR',
    host: 'localhost:5432'
  });
  return res.status(503).json({
    success: false,
    error: 'Service temporarily unavailable - database connection failed',
    timestamp: new Date().toISOString()
  });
});

app.post('/api/checkout', (req, res) => {
  logger.error('Payment gateway timeout', {
    error: 'ETIMEDOUT',
    endpoint: '/api/checkout',
    gateway: 'stripe-api',
    message: 'Payment processing timed out after 30 seconds',
    code: 'PAYMENT_TIMEOUT',
    orderId: `ORD-${Date.now()}`
  });
  return res.status(504).json({
    success: false,
    error: 'Payment processing timeout',
    timestamp: new Date().toISOString()
  });
});

app.get('/api/orders', (req, res) => {
  logger.error('Authentication failed', {
    error: 'UNAUTHORIZED',
    endpoint: '/api/orders',
    message: 'Invalid or expired JWT token',
    code: 'AUTH_FAILED',
    ip: req.ip
  });
  return res.status(401).json({
    success: false,
    error: 'Authentication required',
    timestamp: new Date().toISOString()
  });
});

app.get('/error', (req, res) => {
  logger.error('Test error endpoint hit', {
    timestamp: new Date().toISOString(),
    ip: req.ip,
    userAgent: req.get('user-agent')
  });
  return res.status(500).json({
    success: false,
    error: 'Test error for monitoring',
    timestamp: new Date().toISOString()
  });
});

app.listen(port, () => {
  logger.info(`Server is running on port ${port}`, {
    port,
    env: process.env.NODE_ENV || 'development'
  });
});