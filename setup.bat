@echo off
goto:$Main

:$Main
setlocal EnableDelayedExpansion
    set "PYTHONPATH=%~dp0"
    proto >nul 2>&1
    if errorlevel 1 set "PATH=%USERPROFILE%\.proto\bin;%PATH%%"
    set "proto=%USERPROFILE%\.proto\bin\proto.exe"
    cd /D "%~dp0"
    set "python="%proto%" run python -- "
    if not exist "%proto%" set "python=py -3"
    call "%proto%" upgrade
    call "%proto%" use
    call !python! -m pip install --upgrade pip
    call "%proto%" run python -- -m venv "%~dp0.venv"
    call "%~dp0.venv\Scripts\activate.bat"
    call python -m pip install --upgrade pip poetry
    call poetry install --with "ui,local"
    call python "%~dp0scripts\setup"
    call poetry run python -m personal_gpt
endlocal & exit /b %errorlevel%
