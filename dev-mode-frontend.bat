@echo off
echo ========================================
echo Starting LibreChat Frontend (Dev Mode)
echo ========================================
echo.
echo Make sure the backend is already running in another window!
echo.
echo The frontend will be available at: http://localhost:3090
echo.
echo Press any key to start...
pause > nul

cd client
call npm run dev
