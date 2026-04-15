@echo off
echo 🚀 Rebuilding LibreChat with Follow-Up Suggestions Feature...
echo.

echo 📦 Step 1: Installing dependencies...
call npm install

echo.
echo 🔨 Step 2: Building packages...
call npm run build:packages

echo.
echo 🎨 Step 3: Building frontend...
call npm run frontend

echo.
echo 🐳 Step 4: Rebuilding Docker image...
docker compose build api

echo.
echo 🔄 Step 5: Restarting containers...
docker compose down
docker compose up -d

echo.
echo ✅ Done! LibreChat is now running with the Follow-Up Suggestions feature.
echo 🌐 Access it at: http://localhost:3080
echo.
echo 💡 Tip: It may take 30-60 seconds for the service to fully start.
echo 📝 Check logs with: docker compose logs -f api
pause
