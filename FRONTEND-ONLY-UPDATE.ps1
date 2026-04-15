Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Frontend-Only Update (Faster)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Use this when:" -ForegroundColor Yellow
Write-Host "- You changed ONLY frontend code (React/TypeScript)"
Write-Host "- No backend/API changes"
Write-Host "- Takes: ~3-5 minutes"
Write-Host ""
Read-Host "Press Enter to continue"

Write-Host "Building frontend..." -ForegroundColor Green
npm run frontend
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Frontend build failed!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit $LASTEXITCODE
}

Write-Host ""
Write-Host "Restarting containers..." -ForegroundColor Green
docker compose restart api

Write-Host ""
Write-Host "✅ Done! Frontend updated!" -ForegroundColor Green
Write-Host "Open: http://localhost:3080" -ForegroundColor Cyan
Write-Host "Press Ctrl+Shift+R in browser to hard refresh" -ForegroundColor Yellow
Write-Host ""
Read-Host "Press Enter to exit"
