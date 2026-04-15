@echo off
echo ========================================
echo Starting LibreChat Frontend
echo ========================================
echo.
echo Make sure the backend is already running!
echo.
echo The frontend will be available at:
echo http://localhost:3090
echo.
pause

cd client
npm run dev
