# RightStep App

Express.js application with OpenTelemetry instrumentation for monitoring.

## Features

- Health check endpoint
- OpenTelemetry integration (logs, traces, metrics)
- Winston logging
- Sends telemetry to SigNoz

## Installation

```bash
npm install
cp .env.example .env
```

## Configuration

Edit `.env`:

```env
OTEL_SERVICE_NAME=rightstep-app
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4318
PORT=3000
```

## Usage

### Start the app:
```bash
npm start
```

### Test health endpoint:
```bash
curl http://localhost:3000/health
```

## Monitoring

This app sends telemetry to SigNoz:
- **Logs:** All Winston logs
- **Traces:** Request traces
- **Metrics:** Performance metrics

View in SigNoz UI: http://localhost:8080

## Dependencies

- `express` - Web framework
- `winston` - Logging
- `dotenv` - Environment configuration
- `@opentelemetry/*` - Instrumentation

## Port

Default: `3000` (configurable via PORT env var)

## Endpoints

- `GET /health` - Health check

## License

MIT
