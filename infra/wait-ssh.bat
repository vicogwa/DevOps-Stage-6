@echo off
setlocal

set SERVER_IP=%1
set KEY_PATH=%2
set MAX_ATTEMPTS=60
set ATTEMPT=1

if "%SERVER_IP%"=="" goto usage
if "%KEY_PATH%"=="" goto usage

echo Waiting for SSH connection to %SERVER_IP%...

:loop
echo Attempt %ATTEMPT%/%MAX_ATTEMPTS%...

ssh -i "%KEY_PATH%" -o ConnectTimeout=10 -o StrictHostKeyChecking=no ubuntu@%SERVER_IP% "echo SSH connection successful" >nul 2>&1
if %errorlevel%==0 (
    echo SSH connection established successfully!
    exit /b 0
)

timeout /t 10 /nobreak >nul
set /a ATTEMPT+=1
if %ATTEMPT% leq %MAX_ATTEMPTS% goto loop

echo Failed to establish SSH connection after %MAX_ATTEMPTS% attempts
exit /b 1

:usage
echo Usage: %0 ^<server_ip^> ^<key_path^>
exit /b 1