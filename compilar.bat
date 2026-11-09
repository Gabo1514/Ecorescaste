@echo off
rem Compila Operacion EcoRescate y genera EcoRescate.jar (requiere un JDK instalado)
setlocal
cd /d "%~dp0"
if exist bin rmdir /s /q bin
mkdir bin
dir /s /b src\*.java > fuentes.txt

set "JAVAC=javac"
where javac >nul 2>nul
if errorlevel 1 (
    if defined JAVA_HOME if exist "%JAVA_HOME%\bin\javac.exe" set "JAVAC=%JAVA_HOME%\bin\javac.exe"
)
if "%JAVAC%"=="javac" (
    where javac >nul 2>nul
    if errorlevel 1 (
        for %%P in ("%ProgramFiles%" "%ProgramFiles(x86)%") do (
            for /d %%d in ("%%~P\Java\jdk*" "%%~P\Eclipse Adoptium\jdk*" "%%~P\Microsoft\jdk*" "%%~P\BellSoft\*" "%%~P\Zulu\*") do (
                if exist "%%~d\bin\javac.exe" set "JAVAC=%%~d\bin\javac.exe"
            )
        )
    )
)

rem --release 8 hace que el .jar funcione tambien en PCs con Java 8
"%JAVAC%" -encoding UTF-8 --release 8 -Xlint:-options -d bin @fuentes.txt 2>nul || "%JAVAC%" -encoding UTF-8 -d bin @fuentes.txt
if errorlevel 1 (
    del fuentes.txt
    echo.
    echo Hubo errores al compilar. Verifica que tengas un JDK instalado.
    pause
    exit /b 1
)
del fuentes.txt

rem Buscar la herramienta jar (a veces no esta en el PATH)
set "JAR=jar"
where jar >nul 2>nul
if errorlevel 1 (
    if defined JAVA_HOME if exist "%JAVA_HOME%\bin\jar.exe" set "JAR=%JAVA_HOME%\bin\jar.exe"
)
if "%JAR%"=="jar" (
    where jar >nul 2>nul
    if errorlevel 1 (
        for %%P in ("%ProgramFiles%" "%ProgramFiles(x86)%") do (
            for /d %%d in ("%%~P\Java\jdk*" "%%~P\Eclipse Adoptium\jdk*" "%%~P\Microsoft\jdk*" "%%~P\BellSoft\*" "%%~P\Zulu\*") do (
                if exist "%%~d\bin\jar.exe" set "JAR=%%~d\bin\jar.exe"
            )
        )
    )
)

echo Main-Class: ecorescate.Main> manifest.txt
"%JAR%" cfm EcoRescate.jar manifest.txt -C bin .
if errorlevel 1 (
    del manifest.txt
    echo.
    echo No se encontro la herramienta "jar". Las clases compiladas quedaron en la carpeta bin.
    pause
    exit /b 1
)
del manifest.txt
rmdir /s /q bin
echo.
echo Listo: EcoRescate.jar
pause
