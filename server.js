const express = require('express');
const app = express();
const port = 3000;

// crypto check endpoint for Kubernetes
app.get('/crypto', (req, res) => {
  res.status(200).send('Service is Crypto');
});

// Basic route
app.get('/', (req, res) => {
  res.send('Start from the Coinbase service !');
});

// Logging middleware
app.use((req, res, next) => {
  console.log(`${req.method} request for ${req.url}`);
  next();
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).send('Something went wrong!');
});

// Start the server
const server = app.listen(port, () => {
  console.log(`Service running on http://localhost:${port}`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('Received SIGTERM, shutting down gracefully...');
  server.close(() => {
    console.log('Server closed');
  });
});
