@echo off
echo ========================================
echo Applying Follow-Up Suggestions Fix
echo ========================================
echo.
echo This will rebuild the frontend with the React error fix
echo Takes: ~3-5 minutes
echo.
pause

cd sakha-client

echo Building frontend with fix...
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
echo ========================================
echo ✅ Fix Applied Successfully!
echo ========================================
echo.
echo What was fixed:
echo - React error #310 (too many re-renders) - FIXED
echo - React error #300 (hook ordering) - FIXED
echo - Send button blocking after response - FIXED
echo - Suggestions now clickable and functional - FIXED
echo.
echo Open: http://localhost:3080
echo Press Ctrl+Shift+R to hard refresh
echo.
echo Test it:
echo 1. Ask a question
echo 2. Wait for AI response
echo 3. Click any follow-up suggestion
echo 4. Suggestion should fill the input box
echo 5. Send button should work normally
echo.
pause
