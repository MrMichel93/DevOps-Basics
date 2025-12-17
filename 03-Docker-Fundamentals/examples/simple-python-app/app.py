#!/usr/bin/env python3
"""
Simple Flask web application demonstrating Docker containerization.
"""

from flask import Flask, jsonify, request
import os
import socket
from datetime import datetime

app = Flask(__name__)

# Track request count
request_count = 0


@app.route('/')
def home():
    """Homepage with container information."""
    global request_count
    request_count += 1
    
    return f"""
    <!DOCTYPE html>
    <html>
    <head>
        <title>Python Docker App</title>
        <style>
            body {{
                font-family: Arial, sans-serif;
                max-width: 800px;
                margin: 50px auto;
                padding: 20px;
                background: #f0f0f0;
            }}
            .container {{
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }}
            h1 {{ color: #2c3e50; }}
            .info {{ 
                background: #ecf0f1;
                padding: 15px;
                margin: 10px 0;
                border-radius: 5px;
            }}
            .success {{ color: #27ae60; }}
            code {{
                background: #34495e;
                color: #ecf0f1;
                padding: 2px 6px;
                border-radius: 3px;
            }}
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🐳 Python Flask Docker App</h1>
            <p class="success">✓ Container is running successfully!</p>
            
            <div class="info">
                <h2>Container Information</h2>
                <p><strong>Hostname:</strong> {socket.gethostname()}</p>
                <p><strong>Environment:</strong> {os.getenv('ENVIRONMENT', 'development')}</p>
                <p><strong>Request Count:</strong> {request_count}</p>
                <p><strong>Current Time:</strong> {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}</p>
            </div>
            
            <div class="info">
                <h2>Available Endpoints</h2>
                <ul>
                    <li><code>GET /</code> - This page</li>
                    <li><code>GET /health</code> - Health check</li>
                    <li><code>GET /info</code> - Container info (JSON)</li>
                    <li><code>POST /api/greet</code> - Greeting API</li>
                </ul>
            </div>
            
            <div class="info">
                <h2>Try the API</h2>
                <pre>curl http://localhost:5000/health</pre>
                <pre>curl http://localhost:5000/info</pre>
                <pre>curl -X POST -H "Content-Type: application/json" -d '{{"name":"DevOps"}}' http://localhost:5000/api/greet</pre>
            </div>
        </div>
    </body>
    </html>
    """


@app.route('/health')
def health():
    """Health check endpoint for monitoring."""
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.now().isoformat(),
        'hostname': socket.gethostname()
    })


@app.route('/info')
def info():
    """Return container and application information."""
    return jsonify({
        'hostname': socket.gethostname(),
        'environment': os.getenv('ENVIRONMENT', 'development'),
        'python_version': os.sys.version,
        'request_count': request_count,
        'timestamp': datetime.now().isoformat()
    })


@app.route('/api/greet', methods=['POST'])
def greet():
    """API endpoint that accepts JSON and returns greeting."""
    data = request.get_json()
    
    if not data or 'name' not in data:
        return jsonify({
            'error': 'Please provide a name in JSON body'
        }), 400
    
    name = data['name']
    return jsonify({
        'message': f'Hello, {name}! Welcome to the Dockerized Python app!',
        'hostname': socket.gethostname(),
        'timestamp': datetime.now().isoformat()
    })


@app.errorhandler(404)
def not_found(error):
    """Handle 404 errors."""
    return jsonify({
        'error': 'Endpoint not found',
        'available_endpoints': ['/', '/health', '/info', '/api/greet']
    }), 404


if __name__ == '__main__':
    print("🚀 Starting Flask application...")
    print("📍 Application will be available at http://localhost:5000")
    app.run(host='0.0.0.0', port=5000, debug=True)
