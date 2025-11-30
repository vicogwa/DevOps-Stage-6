@echo off

echo Checking health of all services...
echo ==================================

REM Check if containers are running
echo Container Status:
docker compose ps

echo.
echo Service Health Checks:
echo =====================

REM Check Traefik
echo|set /p="Traefik Dashboard: "
curl -s -o nul -w "%%{http_code}" http://localhost:8080 | findstr "200" >nul && echo ✓ OK || echo ✗ FAILED

REM Check Frontend
echo|set /p="Frontend: "
curl -s -o nul -w "%%{http_code}" http://localhost | findstr "200 301 302" >nul && echo ✓ OK || echo ✗ FAILED

REM Check Auth API
echo|set /p="Auth API: "
curl -s -o nul -w "%%{http_code}" http://localhost/api/auth | findstr "404 301 302" >nul && echo ✓ OK (404 expected) || echo ✗ FAILED

REM Check Todos API
echo|set /p="Todos API: "
curl -s -o nul -w "%%{http_code}" http://localhost/api/todos | findstr "401 301 302" >nul && echo ✓ OK (401 expected) || echo ✗ FAILED

REM Check Users API
echo|set /p="Users API: "
curl -s -o nul -w "%%{http_code}" http://localhost/api/users | findstr "401 301 302" >nul && echo ✓ OK (401 expected) || echo ✗ FAILED

echo.
echo Health check complete!