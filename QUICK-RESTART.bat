@echo off
echo ========================================
echo Quick Restart (No Rebuild)
echo ========================================
echo.
echo Use this when:
echo - Just restarting the containers
echo - No code changes were made
echo - Takes: ~30 seconds
echo.

docker compose restart api

echo.
echo ✅ Done! LibreChat restarted!
echo Open: http://localhost:3080
echo.
pause
