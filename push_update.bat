@echo off
setlocal

echo ======================================================
echo Deploying ClickOnce publish to GitHub Pages
echo ======================================================

:: === Step 1: Find the .application file ===
for %%f in (*.application) do (
    set "APP_MANIFEST=%%f"
)

if not defined APP_MANIFEST (
    echo ERROR: No .application file found in this folder!
    pause
    exit /b 1
)

echo Found application manifest: "%APP_MANIFEST%"

:: === Step 2: Extract version number using PowerShell ===
for /f "usebackq delims=" %%v in (`powershell -NoProfile -Command "(Select-String -Path '%APP_MANIFEST%' -Pattern 'assemblyIdentity.*version=""([\d\.]+)""').Matches[0].Groups[1].Value"`) do set "VERSION=%%v"

if not defined VERSION (
    echo ERROR: Could not extract version number from "%APP_MANIFEST%"
    pause
    exit /b 1
)

echo Detected version: %VERSION%

:: === Step 3: Commit and push to GitHub ===
echo.
echo Deploying version %VERSION% to GitHub...
echo.

git add .
git commit -m "Auto-deploy version %VERSION%"
git push origin main

echo.
echo Deployment complete!
pause
