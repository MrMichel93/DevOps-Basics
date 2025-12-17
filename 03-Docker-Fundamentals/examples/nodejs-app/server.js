#!/usr/bin/env node

/**
 * Simple Express server demonstrating Docker containerization
 */

const express = require('express');
const os = require('os');

const app = express();
const PORT = process.env.PORT || 3000;
const ENVIRONMENT = process.env.NODE_ENV || 'development';

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Request counter
let requestCount = 0;

// Middleware to count requests
app.use((req, res, next) => {
    requestCount++;
    next();
});

// Routes
app.get('/', (req, res) => {
    res.send(`
        <!DOCTYPE html>
        <html>
        <head>
            <title>Node.js Docker App</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    max-width: 800px;
                    margin: 50px auto;
                    padding: 20px;
                    background: #f5f5f5;
                }
                .container {
                    background: white;
                    padding: 30px;
                    border-radius: 10px;
                    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                }
                h1 { color: #2c3e50; }
                .info {
                    background: #ecf0f1;
                    padding: 15px;
                    margin: 10px 0;
                    border-radius: 5px;
                }
                .success { color: #27ae60; }
                code {
                    background: #34495e;
                    color: #ecf0f1;
                    padding: 2px 6px;
                    border-radius: 3px;
                    font-size: 14px;
                }
                pre {
                    background: #34495e;
                    color: #ecf0f1;
                    padding: 15px;
                    border-radius: 5px;
                    overflow-x: auto;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>🚀 Node.js Express Docker App</h1>
                <p class="success">✓ Container is running successfully!</p>
                
                <div class="info">
                    <h2>Container Information</h2>
                    <p><strong>Hostname:</strong> ${os.hostname()}</p>
                    <p><strong>Platform:</strong> ${os.platform()}</p>
                    <p><strong>Node Version:</strong> ${process.version}</p>
                    <p><strong>Environment:</strong> ${ENVIRONMENT}</p>
                    <p><strong>Request Count:</strong> ${requestCount}</p>
                    <p><strong>Uptime:</strong> ${Math.floor(process.uptime())} seconds</p>
                </div>
                
                <div class="info">
                    <h2>Available Endpoints</h2>
                    <ul>
                        <li><code>GET /</code> - This page</li>
                        <li><code>GET /health</code> - Health check</li>
                        <li><code>GET /api/info</code> - Container info (JSON)</li>
                        <li><code>POST /api/echo</code> - Echo API</li>
                        <li><code>GET /api/users</code> - Sample data API</li>
                    </ul>
                </div>
                
                <div class="info">
                    <h2>Try the API</h2>
                    <pre>curl http://localhost:3000/health</pre>
                    <pre>curl http://localhost:3000/api/info</pre>
                    <pre>curl http://localhost:3000/api/users</pre>
                    <pre>curl -X POST -H "Content-Type: application/json" \\
  -d '{"message":"Hello Docker"}' \\
  http://localhost:3000/api/echo</pre>
                </div>
            </div>
        </body>
        </html>
    `);
});

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({
        status: 'healthy',
        timestamp: new Date().toISOString(),
        hostname: os.hostname(),
        uptime: process.uptime()
    });
});

// Info endpoint
app.get('/api/info', (req, res) => {
    res.json({
        hostname: os.hostname(),
        platform: os.platform(),
        nodeVersion: process.version,
        environment: ENVIRONMENT,
        requestCount: requestCount,
        uptime: process.uptime(),
        memory: process.memoryUsage(),
        timestamp: new Date().toISOString()
    });
});

// Echo endpoint
app.post('/api/echo', (req, res) => {
    const { message } = req.body;
    
    if (!message) {
        return res.status(400).json({
            error: 'Please provide a message in the request body'
        });
    }
    
    res.json({
        echo: message,
        receivedAt: new Date().toISOString(),
        hostname: os.hostname()
    });
});

// Sample data endpoint
app.get('/api/users', (req, res) => {
    const users = [
        { id: 1, name: 'Alice', role: 'DevOps Engineer' },
        { id: 2, name: 'Bob', role: 'Backend Developer' },
        { id: 3, name: 'Charlie', role: 'Frontend Developer' }
    ];
    
    res.json({
        users: users,
        count: users.length,
        hostname: os.hostname()
    });
});

// 404 handler
app.use((req, res) => {
    res.status(404).json({
        error: 'Endpoint not found',
        path: req.path,
        method: req.method
    });
});

// Error handler
app.use((err, req, res, next) => {
    console.error('Error:', err);
    res.status(500).json({
        error: 'Internal server error',
        message: err.message
    });
});

// Graceful shutdown
process.on('SIGTERM', () => {
    console.log('SIGTERM received, shutting down gracefully...');
    server.close(() => {
        console.log('Server closed');
        process.exit(0);
    });
});

// Start server
const server = app.listen(PORT, '0.0.0.0', () => {
    console.log('🚀 Server starting...');
    console.log(`📍 Server is running on http://localhost:${PORT}`);
    console.log(`🌍 Environment: ${ENVIRONMENT}`);
    console.log(`🖥️  Hostname: ${os.hostname()}`);
    console.log(`📦 Node version: ${process.version}`);
});

module.exports = app;
