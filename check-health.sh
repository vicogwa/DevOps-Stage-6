#!/bin/bash

echo "Checking health of all services..."
echo "=================================="

# Check if containers are running
echo "Container Status:"
docker compose ps

echo ""
echo "Service Health Checks:"
echo "====================="

# Check Traefik
echo -n "Traefik Dashboard: "
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 | grep -q "200"; then
    echo "✓ OK"
else
    echo "✗ FAILED"
fi

# Check Frontend
echo -n "Frontend: "
if curl -s -o /dev/null -w "%{http_code}" http://localhost | grep -q "200\|301\|302"; then
    echo "✓ OK"
else
    echo "✗ FAILED"
fi

# Check Auth API (should return 404 for root path)
echo -n "Auth API: "
if curl -s -o /dev/null -w "%{http_code}" http://localhost/api/auth | grep -q "404\|301\|302"; then
    echo "✓ OK (404 expected)"
else
    echo "✗ FAILED"
fi

# Check Todos API (should return 401 without token)
echo -n "Todos API: "
if curl -s -o /dev/null -w "%{http_code}" http://localhost/api/todos | grep -q "401\|301\|302"; then
    echo "✓ OK (401 expected)"
else
    echo "✗ FAILED"
fi

# Check Users API (should return 401 without token)
echo -n "Users API: "
if curl -s -o /dev/null -w "%{http_code}" http://localhost/api/users | grep -q "401\|301\|302"; then
    echo "✓ OK (401 expected)"
else
    echo "✗ FAILED"
fi

echo ""
echo "Network connectivity test:"
echo "========================="

# Test internal network connectivity
docker compose exec frontend ping -c 1 auth-api > /dev/null 2>&1 && echo "✓ Frontend -> Auth API" || echo "✗ Frontend -> Auth API"
docker compose exec auth-api ping -c 1 users-api > /dev/null 2>&1 && echo "✓ Auth API -> Users API" || echo "✗ Auth API -> Users API"
docker compose exec todos-api ping -c 1 redis-queue > /dev/null 2>&1 && echo "✓ Todos API -> Redis" || echo "✗ Todos API -> Redis"

echo ""
echo "Health check complete!"