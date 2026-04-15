@echo off
echo ========================================
echo Starting LibreChat with Follow-Up Suggestions
echo ========================================
echo.

echo Step 1: Starting database services...
docker compose up -d mongodb meilisearch vectordb rag_api

echo.
echo Waiting for databases to be ready (10 seconds)...
timeout /t 10 /nobreak > nul

echo.
echo ========================================
echo Step 2: Starting Backend Server
echo ========================================
echo.
echo The backend will start now.
echo Wait for: "Server listening on all interfaces at port 3001"
echo.
echo After backend starts, open a NEW PowerShell window and run:
echo   cd "c:\Users\Yaswanth kesa\Desktop\New folder\sakha-client"
echo   cd client
echo   npm run dev
echo.
echo Then open: http://localhost:3090
echo.
pause

npm run backend:dev
