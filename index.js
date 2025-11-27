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

app.get('/api/login', (req, res) => {
  logger.error('Authentication failed', {
    error: 'INVALID_CREDENTIALS',
    endpoint: '/api/login',
    message: 'Invalid or expired JWT token',
    code: 'AUTH_TOKEN_INVALID',
    attemptedUser: 'user_' + Math.floor(Math.random() * 1000)
  });
  return res.status(401).json({
    success: false,
    error: 'Invalid credentials',
    timestamp: new Date().toISOString()
  });
});

app.get('/api/secure-endpoint', (req, res) => {
  logger.error('Permission denied', {
    error: 'FORBIDDEN',
    endpoint: '/api/secure-endpoint',
    message: 'User does not have required permissions',
    code: 'PERMISSION_DENIED',
    requiredRole: 'admin',
    userRole: 'user'
  });
  return res.status(403).json({
    success: false,
    error: 'Permission denied',
    timestamp: new Date().toISOString()
  });
});

app.get('/api/database/query-timeout', (req, res) => {
  logger.error('Database query timeout', {
    error: 'QUERY_TIMEOUT',
    endpoint: '/api/database/query-timeout',
    message: 'Query execution exceeded timeout limit',
    code: 'DB_QUERY_TIMEOUT',
    timeout: '30000ms',
    query: 'SELECT * FROM large_table'
  });
  return res.status(500).json({
    success: false,
    error: 'Database query timeout',
    timestamp: new Date().toISOString()
  });
});

app.get('/api/database/deadlock', (req, res) => {
  logger.error('Database deadlock detected', {
    error: 'DEADLOCK',
    endpoint: '/api/database/deadlock',
    message: 'Deadlock found when trying to get lock',
    code: 'DB_DEADLOCK',
    tables: ['orders', 'inventory']
  });
  return res.status(500).json({
    success: false,
    error: 'Database deadlock',
    timestamp: new Date().toISOString()
  });
});

app.get('/api/external/rate-limit', (req, res) => {
  logger.error('External API rate limit exceeded', {
    error: 'RATE_LIMIT',
    endpoint: '/api/external/rate-limit',
    message: 'Rate limit exceeded for third-party API',
    code: 'API_RATE_LIMIT',
    service: 'SendGrid',
    limit: '100 requests/hour'
  });
  return res.status(429).json({
    success: false,
    error: 'Rate limit exceeded',
    timestamp: new Date().toISOString()
  });
});

app.get('/api/external/unavailable', (req, res) => {
  logger.error('External API unavailable', {
    error: 'SERVICE_UNAVAILABLE',
    endpoint: '/api/external/unavailable',
    message: 'Third-party service is temporarily unavailable',
    code: 'EXTERNAL_API_DOWN',
    service: 'Twilio'
  });
  return res.status(503).json({
    success: false,
    error: 'External service unavailable',
    timestamp: new Date().toISOString()
  });
});

app.post('/api/validation/create', (req, res) => {
  logger.error('Input validation failed', {
    error: 'VALIDATION_ERROR',
    endpoint: '/api/validation/create',
    message: 'Invalid data format in request body',
    code: 'INVALID_INPUT',
    field: 'email',
    expected: 'valid email format'
  });
  return res.status(400).json({
    success: false,
    error: 'Validation error',
    timestamp: new Date().toISOString()
  });
});

app.get('/api/memory/heap-limit', (req, res) => {
  logger.error('Memory limit exceeded', {
    error: 'OUT_OF_MEMORY',
    endpoint: '/api/memory/heap-limit',
    message: 'JavaScript heap out of memory',
    code: 'HEAP_LIMIT',
    heapUsed: '1.8 GB',
    heapLimit: '2 GB'
  });
  return res.status(500).json({
    success: false,
    error: 'Out of memory',
    timestamp: new Date().toISOString()
  });
});

app.get('/api/cache/redis-down', (req, res) => {
  logger.error('Cache service unavailable', {
    error: 'CACHE_UNAVAILABLE',
    endpoint: '/api/cache/redis-down',
    message: 'Redis connection refused',
    code: 'REDIS_DOWN',
    host: 'redis.example.com',
    port: 6379
  });
  return res.status(500).json({
    success: false,
    error: 'Cache unavailable',
    timestamp: new Date().toISOString()
  });
});

app.get('/api/network/dns-failure', (req, res) => {
  logger.error('DNS resolution failed', {
    error: 'DNS_ERROR',
    endpoint: '/api/network/dns-failure',
    message: 'Could not resolve hostname',
    code: 'ENOTFOUND',
    hostname: 'api.partner.com'
  });
  return res.status(500).json({
    success: false,
    error: 'DNS failure',
    timestamp: new Date().toISOString()
  });
});

app.get('/api/security/brute-force', (req, res) => {
  logger.error('Brute force attack detected', {
    error: 'SECURITY_THREAT',
    endpoint: '/api/security/brute-force',
    message: 'Too many failed login attempts',
    code: 'BRUTE_FORCE',
    clientIp: req.ip,
    attempts: 10
  });
  return res.status(429).json({
    success: false,
    error: 'Too many attempts',
    timestamp: new Date().toISOString()
  });
});

app.get('/api/config/missing-env', (req, res) => {
  logger.error('Configuration error', {
    error: 'CONFIG_ERROR',
    endpoint: '/api/config/missing-env',
    message: 'Required environment variable not set',
    code: 'MISSING_ENV_VAR',
    missingVar: 'AWS_SECRET_KEY'
  });
  return res.status(500).json({
    success: false,
    error: 'Configuration error',
    timestamp: new Date().toISOString()
  });
});

app.get('/api/business/insufficient-inventory', (req, res) => {
  logger.error('Insufficient inventory', {
    error: 'BUSINESS_LOGIC_ERROR',
    endpoint: '/api/business/insufficient-inventory',
    message: 'Not enough items in stock',
    code: 'INSUFFICIENT_INVENTORY',
    productId: 'prod_123',
    requested: 100,
    available: 25
  });
  return res.status(409).json({
    success: false,
    error: 'Insufficient inventory',
    timestamp: new Date().toISOString()
  });
});

app.get('/api/files/not-found', (req, res) => {
  logger.error('File not found', {
    error: 'FILE_NOT_FOUND',
    endpoint: '/api/files/not-found',
    message: 'Required file does not exist',
    code: 'ENOENT',
    filePath: '/uploads/document_123.pdf'
  });
  return res.status(404).json({
    success: false,
    error: 'File not found',
    timestamp: new Date().toISOString()
  });
});

app.listen(port, () => {
  logger.info(`Server is running on port ${port}`, {
    port,
    env: process.env.NODE_ENV || 'development'
  });
  console.log(`\n🚀 RightWatch Test App running on http://localhost:${port}`);
  console.log(`\n📊 Available error endpoints (${19} total):`);
  console.log(`   /api/login - Auth token errors`);
  console.log(`   /api/secure-endpoint - Permission errors`);
  console.log(`   /api/users/:id - Database connection`);
  console.log(`   /api/checkout - Payment timeout`);
  console.log(`   /api/orders - Authentication`);
  console.log(`   /api/database/query-timeout - Query timeout`);
  console.log(`   /api/database/deadlock - Database deadlock`);
  console.log(`   /api/external/rate-limit - Rate limiting`);
  console.log(`   /api/external/unavailable - External API down`);
  console.log(`   /api/validation/create - Validation errors`);
  console.log(`   /api/memory/heap-limit - Memory errors`);
  console.log(`   /api/cache/redis-down - Cache errors`);
  console.log(`   /api/network/dns-failure - Network errors`);
  console.log(`   /api/security/brute-force - Security threats`);
  console.log(`   /api/config/missing-env - Config errors`);
  console.log(`   /api/business/insufficient-inventory - Business logic`);
  console.log(`   /api/files/not-found - File system errors`);
  console.log(`   /error - General test error`);
  console.log(`\n💡 Quick test: for i in {1..20}; do curl http://localhost:3000/api/login; sleep 2; done\n`);
});