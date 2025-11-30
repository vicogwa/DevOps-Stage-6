#!/bin/bash

echo "Starting microservices TODO application..."
echo "Building and starting all services with Docker Compose..."

# Build and start all services
docker compose up -d --build

echo ""
echo "Application is starting up..."
echo "Please wait a few moments for all services to be ready."
echo ""
echo "Access the application at:"
echo "  - Frontend: https://localhost (or http://localhost)"
echo "  - Traefik Dashboard: http://localhost:8080"
echo ""
echo "API Endpoints:"
echo "  - Auth API: https://localhost/api/auth"
echo "  - Todos API: https://localhost/api/todos"
echo "  - Users API: https://localhost/api/users"
echo ""
echo "To stop the application, run: docker compose down"