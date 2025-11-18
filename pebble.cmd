@echo off

SET IMAGE=clustermeerkat/pebble-dev-windows:1.1

rem Maximum inactivity time in minutes
SET STOP_AFTER=30

rem Generate container name based on current directory full path
setlocal enabledelayedexpansion
set "CONTAINER_NAME=!CD!"
rem Replace spaces and invalid characters with hyphens
set "CONTAINER_NAME=!CONTAINER_NAME: =-!"
set "CONTAINER_NAME=!CONTAINER_NAME:/=-!"
set "CONTAINER_NAME=!CONTAINER_NAME:\=-!"
set "CONTAINER_NAME=!CONTAINER_NAME::=-!"
set "CONTAINER_NAME=!CONTAINER_NAME:?=-!"
set "CONTAINER_NAME=!CONTAINER_NAME:|=-!"
set "CONTAINER_NAME=!CONTAINER_NAME:"=-!"
set "CONTAINER_NAME=!CONTAINER_NAME:<=-!"
set "CONTAINER_NAME=!CONTAINER_NAME:>=-!"
rem If name is empty, use default value
if "!CONTAINER_NAME!"=="" set "CONTAINER_NAME=pebble"
endlocal & set "CONTAINER_NAME=%CONTAINER_NAME%"

rem echo Container name: %CONTAINER_NAME%

if "%1"=="docker-stop" (
    echo Stopping container %CONTAINER_NAME%
    docker stop %CONTAINER_NAME%
    exit /b
) else if "%1"=="docker-rm" (
    echo Removing container %CONTAINER_NAME%
    docker rm %CONTAINER_NAME%
    exit /b
)

rem Check if container exists
docker inspect %CONTAINER_NAME% >nul 2>&1
if errorlevel 1 (
    rem Container doesn't exist, create it
    echo Creating container %CONTAINER_NAME%
    docker run -d --name=%CONTAINER_NAME% --restart=no -v ./:/app -v /run/desktop/mnt/host/wslg/.X11-unix:/tmp/.X11-unix -e STOP_AFTER=%STOP_AFTER% %IMAGE%
) else (
    rem Container exists, check if it's running
    set "CONTAINER_RUNNING="
    for /f %%i in ('docker ps -q --filter "name=^%CONTAINER_NAME%$" 2^>nul') do set "CONTAINER_RUNNING=%%i"
    if not defined CONTAINER_RUNNING (
        rem Container is stopped, start it
        echo Starting container %CONTAINER_NAME%
        docker start %CONTAINER_NAME% >nul
    )
)
rem Check if first parameter is "gdb" to add -t flag
if "%1"=="gdb" (
    docker exec -it %CONTAINER_NAME% pebble %*
) else (
    docker exec -i %CONTAINER_NAME% pebble %*
)
