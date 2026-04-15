@echo off
echo ========================================
echo Starting LibreChat in Development Mode
echo ========================================
echo.
echo This will let you see the Follow-Up Suggestions feature immediately!
echo.

echo Step 1: Stopping Docker containers...
docker compose down

echo.
echo Step 2: Starting database services only...
docker compose up -d mongodb meilisearch vectordb rag_api

echo.
echo Step 3: Installing dependencies (this may take a few minutes)...
call npm install

echo.
echo Step 4: Building packages...
call npm run build:packages

echo.
echo Step 5: Starting backend...
echo.
echo ⚠️  IMPORTANT: Keep this window open!
echo.
echo After the backend starts, open a NEW PowerShell window and run:
echo    cd sakha-client
echo    npm run frontend:dev
echo.
echo Then open your browser to: http://localhost:3090
echo.
echo Press any key to start the backend...
pause > nul

call npm run backend:dev
