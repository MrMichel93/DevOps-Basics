# Use official Python runtime as base image
# alpine variant is smaller and more secure
FROM python:3.11-slim

# Set working directory in container
WORKDIR /app

# Copy requirements file first (for layer caching)
# If requirements don't change, this layer is cached
COPY requirements.txt .

# Install dependencies
# --no-cache-dir reduces image size
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port the app runs on
EXPOSE 5000

# Set environment variables
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

# Run the application
# Use CMD (not RUN) - CMD executes when container starts
CMD ["flask", "run"]
