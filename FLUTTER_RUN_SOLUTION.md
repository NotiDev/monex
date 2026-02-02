# Решение проблемы flutter run

## Диагностика проблемы

### Ошибка
```
Building flutter tool... 
Системе не удается найти указанный путь.
The system cannot find the specified path.
```

### Причина
Flutter SDK имеет проблему с инициализацией инструментов. Возможные причины:
1. Dart SDK был частично скачан или поврежден
2. Путь в flutter.bat указывает на несуществующее расположение
3. Flutter SDK требует переинсталляции

## Быстрые решения

### ✅ Решение 1: Использование VS Code Flutter Extension (РЕКОМЕНДУЕТСЯ)
1. Откройте VS Code
2. Установите расширение "Flutter" от Dart Code
3. Нажмите F5 или перейдите в Run → Start Debugging
4. Выберите конфигурацию "Flutter" или "Flutter Web"
5. Flutter автоматически загрузит зависимости и запустит приложение

### ✅ Решение 2: Чистая переинсталляция Flutter SDK

**Шаг 1: Скачайте Flutter**
```powershell
# Удалите текущий Flutter
Remove-Item -Recurse "D:\flutter"

# Скачайте последнюю версию с https://flutter.dev/docs/get-started/install
# Выберите Windows и скачайте ZIP файл
```

**Шаг 2: Распакуйте в новое место**
```powershell
# Распакуйте в D:\flutter-new
# Переименуйте или скопируйте в место без специальных символов
```

**Шаг 3: Добавьте в PATH**
```powershell
# В PowerShell с администратором:
$newPath = "D:\flutter\bin;$([Environment]::GetEnvironmentVariable('Path','Machine'))"
[Environment]::SetEnvironmentVariable('Path', $newPath, 'Machine')

# Перезагрузите компьютер
```

**Шаг 4: Проверьте установку**
```powershell
flutter doctor -v
flutter pub get
flutter run
```

### ✅ Решение 3: Запуск в веб-браузере (временно)
```powershell
$env:FLUTTER_ROOT = "D:\flutter"
D:\flutter\bin\flutter.bat run -d chrome --web-port=8080
```

### ✅ Решение 4: Использование Docker (продвинутый вариант)
Создайте Dockerfile:
```dockerfile
FROM google/dart:latest
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get
COPY . .
RUN dart compile exe bin/main.dart -o app
CMD ["./app"]
```

Запустите:
```bash
docker build -t monex-flutter .
docker run -p 8080:8080 monex-flutter
```

## Диагностика в VS Code

1. Откройте VS Code в папке проекта
2. Откройте терминал (Ctrl+`)
3. Выполните:
   ```powershell
   # Проверка наличия Flutter
   Get-Command flutter
   
   # Проверка версии Dart
   dart --version
   
   # Проверка статуса Flutter
   flutter doctor -v
   
   # Попытка загрузить зависимости
   flutter pub get
   
   # Попытка запустить на веб
   flutter run -d web
   ```

## Если ничего не помогает

1. **Переинсталлируйте Flutter:**
   - Скачайте с https://flutter.dev
   - Установите в `C:\flutter` (без диакритики)
   - Добавьте в системные переменные окружения

2. **Используйте Android Studio / IntelliJ IDEA:**
   - Установите Android Studio
   - Перейдите в Tools → SDK Manager
   - Установите Flutter plugin
   - Flutter будет автоматически настроен

3. **Контактируйте с поддержкой Flutter:**
   - GitHub Issues: https://github.com/flutter/flutter/issues
   - Stack Overflow: tag:flutter

## Примечание к проекту

Проект был успешно дополнен функциональностью аутентификации:
- ✅ Экран входа
- ✅ Экран регистрации  
- ✅ AuthService с хэшированием паролей
- ✅ Локальное хранилище (SharedPreferences)

Все исходные файлы находятся в папке `lib/`, проблема только в запуске Flutter.

