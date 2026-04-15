@echo off
echo ========================================
echo Building All Packages
echo ========================================
echo.
echo This will take 2-3 minutes...
echo.

echo Step 1/4: Building data-provider...
call npm run build:data-provider
if %errorlevel% neq 0 (
    echo ERROR: data-provider build failed!
    pause
    exit /b %errorlevel%
)

echo.
echo Step 2/4: Building data-schemas...
call npm run build:data-schemas
if %errorlevel% neq 0 (
    echo ERROR: data-schemas build failed!
    pause
    exit /b %errorlevel%
)

echo.
echo Step 3/4: Building API...
call npm run build:api
if %errorlevel% neq 0 (
    echo ERROR: API build failed!
    pause
    exit /b %errorlevel%
)

echo.
echo Step 4/4: Building client package...
call npm run build:client-package
if %errorlevel% neq 0 (
    echo ERROR: client-package build failed!
    pause
    exit /b %errorlevel%
)

echo.
echo ========================================
echo ✅ All packages built successfully!
echo ========================================
echo.
echo Next steps:
echo 1. Run: npm run backend:dev
echo 2. In a NEW window, run: cd client ^&^& npm run dev
echo 3. Open: http://localhost:3090
echo.
pause
