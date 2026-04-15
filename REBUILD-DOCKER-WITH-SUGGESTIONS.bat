@echo off
echo ========================================
echo Rebuilding Docker with Follow-Up Suggestions
echo ========================================
echo.
echo This will:
echo 1. Build the frontend with your new code
echo 2. Rebuild the Docker image
echo 3. Start everything
echo.
echo This takes about 5-10 minutes...
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
echo Step 2: Stopping old containers...
docker compose down

echo.
echo Step 3: Rebuilding Docker image...
docker compose build api

echo.
echo Step 4: Starting everything...
docker compose up -d

echo.
echo ========================================
echo ✅ Done! LibreChat is running with suggestions!
echo ========================================
echo.
echo Open: http://localhost:3080
echo.
echo The follow-up suggestions will appear below AI responses!
echo.
pause
