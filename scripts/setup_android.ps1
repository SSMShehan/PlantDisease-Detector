# Android SDK Setup Script - Run this as PowerShell Administrator
# This script installs Android SDK 36 and accepts all licenses

$sdkm = "C:\flutter\android\cmdline-tools\latest\bin\sdkmanager.bat"

Write-Host "=== Android SDK Setup ===" -ForegroundColor Cyan
Write-Host "Installing Android SDK 36..." -ForegroundColor Yellow

# Install required platforms
"y" | & $sdkm "platforms;android-36"
Write-Host "Android SDK 36 installed!" -ForegroundColor Green

Write-Host "Installing Build Tools 28.0.3..." -ForegroundColor Yellow
"y" | & $sdkm "build-tools;28.0.3"
Write-Host "Build Tools installed!" -ForegroundColor Green

Write-Host "Updating Platform Tools..." -ForegroundColor Yellow
"y" | & $sdkm "platform-tools"
Write-Host "Platform Tools updated!" -ForegroundColor Green

Write-Host "Accepting all Android licenses..." -ForegroundColor Yellow
"y`ny`ny`ny`ny`ny`ny`ny`ny`ny`ny" | & $sdkm --licenses
Write-Host "Licenses accepted!" -ForegroundColor Green

Write-Host "=== Running flutter doctor ===" -ForegroundColor Cyan
flutter doctor -v
