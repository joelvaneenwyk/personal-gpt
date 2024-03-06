@echo off
goto:$Main

:$Main
setlocal EnableDelayedExpansion
    set "PYTHONPATH=%~dp0"
    set "proto=%USERPROFILE%\.proto\bin\proto.exe"
    cd /D "%~dp0"
    set "python="%proto%" run python -- "
    if not exist "%proto%" set "python=py -3"
    "%proto%" upgrade
    "%proto%" use
    call !python! -m pip install --upgrade pip
    call !python! -m pip install -r requirements.txt
    call !python! -m poetry run pip install -r requirements.txt
    call !python! -m poetry run python scripts/setup
endlocal & exit /b %errorlevel%
