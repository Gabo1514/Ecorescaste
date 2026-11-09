@echo off
setlocal
cd /d "%~dp0"

if not exist "EcoRescate.jar" (
    echo.
    echo  [!] No se encontro "EcoRescate.jar" en esta carpeta.
    echo      IMPORTANTE: Primero debes descomprimir "EcoRescate.zip"
    echo      ^(Clic derecho sobre EcoRescate.zip ^> "Extraer todo..."^).
    echo.
    pause
    exit /b 1
)

rem Buscar javaw en el PATH o en las rutas habituales de instalacion de Windows
set "JAVAW="
where javaw >nul 2>nul
if not errorlevel 1 set "JAVAW=javaw"

if not defined JAVAW if defined JAVA_HOME if exist "%JAVA_HOME%\bin\javaw.exe" set "JAVAW=%JAVA_HOME%\bin\javaw.exe"

if not defined JAVAW (
    for %%P in ("%ProgramFiles%" "%ProgramFiles(x86)%" "%LocalAppData%\Programs") do (
        for /d %%V in ("%%~P\Java\*" "%%~P\Eclipse Adoptium\*" "%%~P\AdoptOpenJDK\*" "%%~P\Microsoft\jdk*" "%%~P\BellSoft\*" "%%~P\Zulu\*") do (
            if not defined JAVAW if exist "%%~V\bin\javaw.exe" set "JAVAW=%%~V\bin\javaw.exe"
        )
    )
)

if not defined JAVAW (
    echo.
    echo  No se encontro Java instalado en esta computadora.
    echo.
    echo  Instala Java ^(gratis^) desde:  https://www.java.com/es/download/
    echo  y luego vuelve a hacer doble clic en ejecutar.bat
    echo.
    pause
    exit /b 1
)

start "" "%JAVAW%" -Xms64m -Xmx512m -Dsun.java2d.uiScale.enabled=true -jar "EcoRescate.jar"
