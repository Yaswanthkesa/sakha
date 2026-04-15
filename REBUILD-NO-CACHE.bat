@echo off
echo ========================================
echo Rebuilding Docker WITHOUT Cache
echo ========================================
echo.
echo This will force a complete rebuild with your local code
echo including the Follow-Up Suggestions feature.
echo.
echo This takes about 10-15 minutes...
echo.
pause

echo Stopping containers...
docker compose down

echo.
echo Building frontend...
call npm run frontend
if %errorlevel% neq 0 (
    echo ERROR: Frontend build failed!
    pause
    exit /b %errorlevel%
)

echo.
echo Rebuilding Docker image (no cache)...
docker compose build --no-cache api

echo.
echo Starting everything...
docker compose up -d

echo.
echo ========================================
echo ✅ Done! Open http://localhost:3080
echo ========================================
echo.
pause
