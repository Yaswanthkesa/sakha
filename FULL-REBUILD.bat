@echo off
echo ========================================
echo Full Rebuild (Slowest but Most Complete)
echo ========================================
echo.
echo Use this when:
echo - Changed backend code (API/server)
echo - Changed dependencies (package.json)
echo - Changed Dockerfile or docker-compose.yml
echo - Something is broken and needs clean rebuild
echo - Takes: ~5-10 minutes
echo.
pause

echo Step 1: Building frontend...
call npm run frontend
if %errorlevel% neq 0 (
    echo ERROR: Frontend build failed!
    pause
    exit /b %errorlevel%
)

echo.
echo Step 2: Stopping containers...
docker compose down

echo.
echo Step 3: Rebuilding Docker image...
docker compose build api --no-cache

echo.
echo Step 4: Starting everything...
docker compose up -d

echo.
echo ✅ Done! Full rebuild complete!
echo Open: http://localhost:3080
echo.
pause
