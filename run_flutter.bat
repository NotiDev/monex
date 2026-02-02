@echo off
setlocal

REM Установить FLUTTER_ROOT в начало скрипта
set FLUTTER_ROOT=D:\flutter
set Path=%FLUTTER_ROOT%\bin;%Path%

REM Проверить версию flutter
echo Проверка Flutter...
call %FLUTTER_ROOT%\bin\flutter.bat --version

REM Перейти в директорию проекта
cd /d "%~dp0"

REM Выполнить pub get
echo.
echo Загрузка зависимостей...
call %FLUTTER_ROOT%\bin\flutter.bat pub get

REM Выполнить flutter run
echo.
echo Запуск приложения...
call %FLUTTER_ROOT%\bin\flutter.bat run %*

endlocal
