#!/usr/bin/env powershell

# Установить переменные окружения для Flutter
$env:FLUTTER_HOME = "D:\flutter"
$env:FLUTTER_ROOT = "D:\flutter"
$env:DART_SDK = "D:\flutter\bin\cache\dart-sdk"
$env:Path = "$env:DART_SDK\bin;$env:FLUTTER_HOME\bin;$env:Path"

# Очистить кэш, если нужно
if ($args -contains "--clean") {
    Write-Host "Очистка кэша..."
    Remove-Item -Recurse -Force ".dart_tool", ".flutter", "build", ".packages", "pubspec.lock" -ErrorAction SilentlyContinue
}

# Загрузить зависимости с помощью dart
Write-Host "Загрузка зависимостей..."
& "$env:DART_SDK\bin\dart.exe" pub get

if ($LASTEXITCODE -ne 0) {
    Write-Host "Ошибка при загрузке зависимостей" -ForegroundColor Red
    exit 1
}

# Запустить flutter
Write-Host "Запуск Flutter..."
& "$env:FLUTTER_HOME\bin\flutter.bat" run @args
