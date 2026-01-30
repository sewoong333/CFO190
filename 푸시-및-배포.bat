@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo CFO190 푸시 및 배포 실행 중...
powershell -ExecutionPolicy Bypass -File "%~dp0push-and-deploy.ps1"
pause
