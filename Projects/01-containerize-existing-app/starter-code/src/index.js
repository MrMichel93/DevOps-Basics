require('dotenv').config();
const express = require('express');
const path = require('path');
const db = require('./db');
const taskRoutes = require('./routes/tasks');
const healthRoutes = require('./routes/health');
const logger = require('./middleware/logger');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());
app.use(logger);

// Static files
app.use(express.static(path.join(__dirname, '../public')));

// Routes
app.use('/health', healthRoutes);
app.use('/api/tasks', taskRoutes);

// Initialize database and start server
const startServer = async () => {
  try {
    // Initialize database
    await db.initialize();
    
    app.listen(PORT, '0.0.0.0', () => {
      console.log(`Server running on port ${PORT}`);
      console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
      console.log(`Health check: http://localhost:${PORT}/health`);
    });
  } catch (error) {
    console.error('Failed to start server:', error);
    process.exit(1);
  }
};

// Graceful shutdown
process.on('SIGTERM', async () => {
  console.log('SIGTERM received, shutting down gracefully...');
  await db.close();
  process.exit(0);
});

process.on('SIGINT', async () => {
  console.log('SIGINT received, shutting down gracefully...');
  await db.close();
  process.exit(0);
});

startServer();
