'use strict';

const express = require('express');
const bodyParser = require("body-parser");
const jwt = require('express-jwt').default; // v7+ requires destructuring
const redis = require("redis");

// --- Zipkin setup ---
const ZIPKIN_URL = process.env.ZIPKIN_URL || 'http://127.0.0.1:9411/api/v2/spans';
const { Tracer, BatchRecorder, jsonEncoder: { JSON_V2 } } = require('zipkin');
const CLSContext = require('zipkin-context-cls');
const { HttpLogger } = require('zipkin-transport-http');
const zipkinMiddleware = require('zipkin-instrumentation-express').expressMiddleware;

const ctxImpl = new CLSContext('zipkin');
const recorder = new BatchRecorder({
  logger: new HttpLogger({
    endpoint: ZIPKIN_URL,
    jsonEncoder: JSON_V2
  })
});
const localServiceName = 'todos-api';
const tracer = new Tracer({ ctxImpl, recorder, localServiceName });

// --- Redis setup ---
const logChannel = process.env.REDIS_CHANNEL || 'log_channel';
const redisClient = redis.createClient({
  socket: {
    host: process.env.REDIS_HOST || 'localhost',
    port: process.env.REDIS_PORT || 6379
  },
  retry_strategy: function (options) {
    if (options.error && options.error.code === 'ECONNREFUSED') {
      return new Error('The server refused the connection');
    }
    if (options.total_retry_time > 1000 * 60 * 60) {
      return new Error('Retry time exhausted');
    }
    if (options.attempt > 10) {
      console.log('Reattempting to connect to redis, attempt #' + options.attempt);
      return undefined;
    }
    return Math.min(options.attempt * 100, 2000);
  }
});

redisClient.connect().catch(err => console.error('Redis connection error:', err));

// --- Express app setup ---
const app = express();
const port = process.env.TODO_API_PORT || 8082;
const jwtSecret = process.env.JWT_SECRET || "foo";

// --- Middleware ---
app.use(jwt({
  secret: jwtSecret,
  algorithms: ["HS256"] // Required in express-jwt v7+
}));

app.use(zipkinMiddleware({ tracer }));

// Handle JWT errors
app.use(function (err, req, res, next) {
  if (err.name === 'UnauthorizedError') {
    return res.status(401).send({ message: 'invalid token' });
  }
  next(err);
});

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// --- Routes ---
const routes = require('./routes');
routes(app, { tracer, redisClient, logChannel });

// --- Start server ---
app.listen(port, function () {
  console.log(`todo list RESTful API server started on: ${port}`);
});
