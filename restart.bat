@echo off
taskkill /f /im FXServer.exe
timeout /t 2 >nul
start "" "./artifacts/FXServer.exe" +exec server.cfg
