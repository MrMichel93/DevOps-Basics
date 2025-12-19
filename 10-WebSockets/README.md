# Module 10: WebSockets

## 🎯 Learning Objectives

- ✅ Understand real-time communication
- ✅ Know when to use WebSockets
- ✅ Implement basic WebSocket connections
- ✅ Understand WebSocket vs HTTP differences

**Time Required**: 2-3 hours

## 🔌 What are WebSockets?

WebSockets provide **full-duplex** (two-way) communication between client and server over a single TCP connection.

### HTTP vs WebSocket

**HTTP (Request-Response)**:
```
Client: "Hey server, any updates?"
Server: "Nope"
Client: "How about now?"
Server: "Nope"
Client: "Now?"
Server: "Yes, here's data"
```

**WebSocket (Persistent Connection)**:
```
Client: "Keep me updated"
Server: "OK, connected"
... time passes ...
Server: "Hey, here's an update!"
Client: "Thanks!"
```

## 🌐 How WebSockets Work

### Connection Upgrade

WebSocket starts as HTTP, then upgrades:

**1. Client sends upgrade request**:
```http
GET /chat HTTP/1.1
Host: example.com
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==
Sec-WebSocket-Version: 13
```

**2. Server accepts upgrade**:
```http
HTTP/1.1 101 Switching Protocols
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=
```

**3. Connection established** - Now both can send messages anytime!

## 📊 WebSocket vs HTTP

| Feature | HTTP | WebSocket |
|---------|------|-----------|
| Direction | One-way (client → server) | Two-way (bidirectional) |
| Connection | New per request | Persistent |
| Overhead | High (headers every time) | Low (after handshake) |
| Real-time | Polling required | Native push |
| Use Case | Request/response | Real-time updates |

## 🎯 When to Use WebSockets

### ✅ Good Use Cases

1. **Chat Applications**: Real-time messaging
2. **Live Feeds**: Social media updates, news
3. **Collaborative Tools**: Google Docs-style editing
4. **Gaming**: Multiplayer games
5. **Live Sports**: Scores, updates
6. **Stock Tickers**: Live price updates
7. **Notifications**: Instant alerts
8. **IoT Dashboards**: Sensor data streaming

### ❌ When NOT to Use WebSockets

1. **Simple CRUD**: Regular API calls work fine
2. **Infrequent Updates**: Polling is simpler
3. **Cacheable Data**: HTTP caching is better
4. **RESTful Operations**: Use REST API
5. **Search/Browse**: Standard HTTP sufficient

## 💻 Simple WebSocket Example

### Client (JavaScript)

```javascript
// Connect to WebSocket server
const socket = new WebSocket('ws://localhost:8080');

// Connection opened
socket.addEventListener('open', (event) => {
    console.log('Connected to server');
    socket.send('Hello Server!');
});

// Listen for messages
socket.addEventListener('message', (event) => {
    console.log('Message from server:', event.data);
});

// Connection closed
socket.addEventListener('close', (event) => {
    console.log('Disconnected from server');
});

// Handle errors
socket.addEventListener('error', (error) => {
    console.error('WebSocket error:', error);
});

// Send message
function sendMessage(message) {
    if (socket.readyState === WebSocket.OPEN) {
        socket.send(message);
    }
}

// Close connection
function disconnect() {
    socket.close();
}
```

### Server (Python with Flask-SocketIO)

```python
from flask import Flask
from flask_socketio import SocketIO, emit

app = Flask(__name__)
socketio = SocketIO(app)

@socketio.on('connect')
def handle_connect():
    print('Client connected')
    emit('response', {'data': 'Connected to server'})

@socketio.on('message')
def handle_message(data):
    print(f'Received message: {data}')
    emit('response', {'data': f'Echo: {data}'})

@socketio.on('disconnect')
def handle_disconnect():
    print('Client disconnected')

if __name__ == '__main__':
    socketio.run(app, port=8080)
```

### Server (Node.js with Socket.io)

```javascript
const express = require('express');
const http = require('http');
const socketIo = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = socketIo(server);

io.on('connection', (socket) => {
    console.log('Client connected');
    
    socket.on('message', (data) => {
        console.log('Received:', data);
        socket.emit('response', `Echo: ${data}`);
    });
    
    socket.on('disconnect', () => {
        console.log('Client disconnected');
    });
});

server.listen(8080, () => {
    console.log('WebSocket server running on port 8080');
});
```

## 📡 WebSocket Protocols

### ws:// vs wss://

- **ws://**: Unencrypted WebSocket
- **wss://**: Encrypted WebSocket (like HTTPS)

**Always use wss:// in production!**

```javascript
// Development
const socket = new WebSocket('ws://localhost:8080');

// Production
const socket = new WebSocket('wss://api.example.com/ws');
```

## 🔄 Common Patterns

### Broadcasting

Send message to all connected clients:

```python
@socketio.on('message')
def handle_broadcast(data):
    # Send to everyone
    emit('broadcast', data, broadcast=True)
```

```javascript
io.emit('broadcast', data);  // Send to all clients
```

### Rooms/Channels

Group clients into rooms:

```python
from flask_socketio import join_room, leave_room

@socketio.on('join')
def on_join(data):
    room = data['room']
    join_room(room)
    emit('message', f'User joined {room}', room=room)

@socketio.on('room_message')
def handle_room_message(data):
    room = data['room']
    message = data['message']
    emit('message', message, room=room)
```

### Heartbeat/Ping-Pong

Keep connection alive:

```javascript
// Client
setInterval(() => {
    socket.send('ping');
}, 30000);  // Every 30 seconds

socket.addEventListener('message', (event) => {
    if (event.data === 'pong') {
        console.log('Connection alive');
    }
});

// Server
@socketio.on('ping')
def handle_ping():
    emit('pong')
```

## 🧪 Hands-On Exercise: Simple Chat

### HTML Client

```html
<!DOCTYPE html>
<html>
<head>
    <title>WebSocket Chat</title>
</head>
<body>
    <div id="messages"></div>
    <input type="text" id="messageInput" placeholder="Type message...">
    <button onclick="sendMessage()">Send</button>

    <script>
        const socket = new WebSocket('ws://localhost:8080');
        
        socket.onmessage = (event) => {
            const messages = document.getElementById('messages');
            messages.innerHTML += `<p>${event.data}</p>`;
        };
        
        function sendMessage() {
            const input = document.getElementById('messageInput');
            socket.send(input.value);
            input.value = '';
        }
    </script>
</body>
</html>
```

## 🔒 Security Considerations

### 1. Authentication

```javascript
// Send auth token
const socket = new WebSocket('wss://api.example.com/ws?token=abc123');

// Or after connection
socket.send(JSON.stringify({
    type: 'auth',
    token: 'abc123'
}));
```

### 2. Validate Messages

```python
@socketio.on('message')
def handle_message(data):
    # Validate
    if not isinstance(data, dict):
        return
    if 'type' not in data:
        return
    
    # Process based on type
    if data['type'] == 'chat':
        handle_chat(data)
```

### 3. Rate Limiting

```python
from flask_limiter import Limiter

limiter = Limiter(app)

@socketio.on('message')
@limiter.limit("10 per minute")
def handle_message(data):
    emit('response', data)
```

### 4. Input Sanitization

```python
from html import escape

@socketio.on('message')
def handle_message(data):
    # Sanitize
    clean_message = escape(data['message'])
    emit('broadcast', clean_message, broadcast=True)
```

## ⚠️ Common Pitfalls

1. **Not handling disconnections**: Always implement reconnection logic
2. **Sending too much data**: Use compression or pagination
3. **No authentication**: Secure your WebSocket endpoints
4. **Not validating messages**: Always validate incoming data
5. **Memory leaks**: Clean up event listeners

## 🎯 Best Practices

1. **Use wss:// in production**
2. **Implement reconnection logic**
3. **Add authentication**
4. **Validate all messages**
5. **Rate limit connections**
6. **Monitor connection count**
7. **Use rooms for scalability**
8. **Implement heartbeat**
9. **Handle errors gracefully**
10. **Consider fallbacks (long polling)**

## 🧪 Testing WebSockets

### Using websocat

```bash
# Install websocat
brew install websocat  # macOS
# or download from https://github.com/vi/websocat

# Connect to WebSocket
websocat ws://localhost:8080

# Send message (type and press enter)
Hello Server!
```

### Using Browser DevTools

1. Open DevTools (`F12`)
2. Go to **Network** tab
3. Filter by **WS** (WebSocket)
4. Click on connection to see messages

## 🎯 Key Takeaways

1. **WebSockets**: Full-duplex real-time communication
2. **When to Use**: Chat, live feeds, collaborative tools
3. **When NOT to Use**: Simple CRUD, infrequent updates
4. **Security**: Use wss://, authenticate, validate, rate limit
5. **Libraries**: Socket.io, Flask-SocketIO simplify development

## 📖 Next Steps

➡️ [Module 11: Other Protocols](../11-Other-Protocols/)

## 🔗 Resources

- [WebSocket MDN Documentation](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket)
- [Socket.io Documentation](https://socket.io/docs/)
- [Flask-SocketIO Documentation](https://flask-socketio.readthedocs.io/)
- [WebSocket Testing Tool](https://www.websocket.org/echo.html)
