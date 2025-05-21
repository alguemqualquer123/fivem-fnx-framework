@echo off
echo [coreNova] Inicializando instalação...

REM Passo 1: Iniciar servidor
echo [coreNova] Iniciando servidor FX...

start "" "./artifacts/FXServer.exe" +exec server.cfg
