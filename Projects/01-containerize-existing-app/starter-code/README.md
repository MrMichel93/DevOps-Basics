# Starter Code - Simple Express App

## 📋 Overview

This is a basic Node.js/Express application that you'll containerize. The app includes:
- RESTful API endpoints
- PostgreSQL database connection
- Basic CRUD operations
- Health check endpoint
- Static file serving

## 🚀 Quick Start (Without Docker)

### Prerequisites
- Node.js 18 or higher
- PostgreSQL 14 or higher
- npm or yarn

### Setup

1. Install dependencies:
```bash
npm install
```

2. Set up environment variables:
```bash
cp .env.example .env
# Edit .env with your database credentials
```

3. Create database:
```bash
createdb taskapp
```

4. Run the application:
```bash
npm start
```

5. Test it works:
```bash
curl http://localhost:3000/health
```

## 📁 Project Structure

```
starter-code/
├── src/
│   ├── index.js          # Application entry point
│   ├── db.js             # Database connection
│   ├── routes/
│   │   ├── tasks.js      # Task CRUD endpoints
│   │   └── health.js     # Health check endpoint
│   └── middleware/
│       └── logger.js     # Request logging
├── public/
│   └── index.html        # Simple frontend
├── package.json          # Dependencies
├── .env.example          # Environment template
└── README.md            # This file
```

## 🎯 Your Task

Containerize this application by:

1. Creating a `Dockerfile`
2. Creating a `docker-compose.yml`
3. Adding appropriate configuration files
4. Following the project requirements in the main README

## 📚 API Endpoints

- `GET /health` - Health check
- `GET /api/tasks` - List all tasks
- `POST /api/tasks` - Create a new task
- `GET /api/tasks/:id` - Get a specific task
- `PUT /api/tasks/:id` - Update a task
- `DELETE /api/tasks/:id` - Delete a task

## 🔧 Environment Variables

See `.env.example` for all required variables:

- `PORT` - Application port (default: 3000)
- `NODE_ENV` - Environment (development/production)
- `DATABASE_URL` - PostgreSQL connection string

## 💡 Tips

- The app is already configured to work in containers
- Database connection uses environment variables
- Health check endpoint is already implemented
- Application follows 12-factor app principles

## 📝 Next Steps

1. Review the code to understand the application
2. Follow the main project instructions
3. Use checkpoints.md for guided implementation
4. Refer to rubric.md for grading criteria

Good luck! 🚀
