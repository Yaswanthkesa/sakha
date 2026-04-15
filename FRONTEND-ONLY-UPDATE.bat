@echo off
echo ========================================
echo Frontend-Only Update (Faster)
echo ========================================
echo.
echo Use this when:
echo - You changed ONLY frontend code (React/TypeScript)
echo - No backend/API changes
echo - Takes: ~3-5 minutes
echo.
pause

echo Building frontend...
call npm run frontend
if %errorlevel% neq 0 (
    echo ERROR: Frontend build failed!
    pause
    exit /b %errorlevel%
)

echo.
echo Restarting containers...
docker compose restart api

echo.
echo ✅ Done! Frontend updated!
echo Open: http://localhost:3080
echo Press Ctrl+Shift+R in browser to hard refresh
echo.
pause
