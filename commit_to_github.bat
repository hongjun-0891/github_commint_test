@echo off
setlocal

call :header
call :load_env
:: adaasdf
if "%GITHUB_TOKEN%"=="" (
    echo GITHUB_TOKEN is not set. Please check the env file.
    pause
    exit /b 1
)

:: dfaasda
if "%GITHUB_REPO%"=="" (
    echo GITHUB_REPO is not set. Please check the env file.
    pause
    exit /b 1
)

if "%REPO_PATH%"=="" (
    echo REPO_PATH is not set. Please check the env file.
    pause
    exit /b 1
)

echo Enter the file name to commit (including extension)
set /p file_name="> "

if not exist "%REPO_PATH%\%file_name%" (
    echo.
    echo Error: File does not exist in the repository.
    pause
    goto :eof
)

echo Enter the commit message
set /p commit_message="> "

cd /d "%REPO_PATH%"
if errorlevel 1 (
    echo.
    echo Error: Incorrect repository path.
    pause
    goto :eof
)

git add "%file_name%"
if errorlevel 1 (
    echo.
    echo Error: Unable to add the file. Please check the file name and try again.
    pause
    goto :eof
)

git commit -m "%commit_message%"
if errorlevel 1 (
    echo.
    echo Error: Unable to commit the file. Please check Git settings and try again.
    pause
    goto :eof
)

set remote_url=https://%GITHUB_TOKEN%@github.com/%GITHUB_REPO%.git
git remote set-url origin %remote_url%

git push origin main
if errorlevel 1 (
    echo.
    echo Error: Unable to push to GitHub. Please check network connection and remote repository settings.
    pause
    goto :eof
)

echo.
echo ========================================
echo          Commit and Push Successful
echo ========================================
pause
goto :eof

:header
cls
echo ========================================
echo         GitHub Commit Automation
echo ========================================
echo.
goto :eof

:load_env
if exist .env (
    for /f "tokens=1,* delims==" %%a in (.env) do (
        if "%%a" == "GITHUB_TOKEN" set "GITHUB_TOKEN=%%b"
        if "%%a" == "GITHUB_REPO" set "GITHUB_REPO=%%b"
        if "%%a" == "REPO_PATH" set "REPO_PATH=%%b"
    )
) else (
    echo Cannot find the env file.
    pause
    exit /b 1
)
goto :eof
