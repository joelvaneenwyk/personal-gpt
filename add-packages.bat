@echo off
goto:$Main

:Add
setlocal EnableDelayedExpansion
    cd /d "%~dp0"
    git add .
    rye add "%~1"
    rye sync
    if errorlevel 1 goto:$AddError
    goto:$AddDone

    :$AddError
    echo Failed to add package: "%~1"
    rye remove "%~1"
    rye sync
    git add .
    exit /b 99

    :$AddDone
endlocal & exit /b %ERRORLEVEL%

:$Main
setlocal EnableDelayedExpansion
    cd /d "%~dp0"
    call :Add "fastapi[all]"
    if errorlevel 1 goto:$MainError
    call :Add "boto3"
    if errorlevel 1 goto:$MainError
    call :Add "injector"
    if errorlevel 1 goto:$MainError
    call :Add "pyyaml"
    if errorlevel 1 goto:$MainError
    call :Add "python-multipart"
    if errorlevel 1 goto:$MainError
    call :Add "pypdf"
    if errorlevel 1 goto:$MainError
    call :Add "llama-index"
    if errorlevel 1 goto:$MainError
    call :Add "watchdog"
    if errorlevel 1 goto:$MainError
    call :Add "qdrant-client"
    if errorlevel 1 goto:$MainError
    call :Add "chromadb"
    if errorlevel 1 goto:$MainError
    call :Add "asyncpg"
    if errorlevel 1 goto:$MainError
    call :Add "pgvector"
    if errorlevel 1 goto:$MainError
    call :Add "psycopg2-binary"
    if errorlevel 1 goto:$MainError
    call :Add "sqlalchemy"
    if errorlevel 1 goto:$MainError
    call :Add "huggingface_hub"
    if errorlevel 1 goto:$MainError
    call :Add "pydantic"
    if errorlevel 1 goto:$MainError
    call :Add "transformers"
    if errorlevel 1 goto:$MainError
    call :Add "ruff"
    if errorlevel 1 goto:$MainError

    goto:$MainDone

    :$MainError
    echo Failed to add packages.
    exit /b 99

    :$MainDone
endlocal & exit /b %ERRORLEVEL%
