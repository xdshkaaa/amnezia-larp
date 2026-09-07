# LarpmneziaVPN для macOS

Универсальная тестовая сборка (arm64 + x86_64) на базе AmneziaVPN.
Нужны macOS, Command Line Tools, Python 3.12+, CMake и Ninja.

Из корня репозитория:

```sh
python3.12 -m venv .tools/conan
.tools/conan/bin/pip install conan aqtinstall
.tools/conan/bin/aqt install-qt mac desktop 6.10.1 clang_64 -O .tools/Qt -m qt5compat qtremoteobjects qtshadertools
.tools/conan/bin/conan profile detect
git submodule update --init client/3rd/SortFilterProxyModel client/3rd/qtkeychain
cmake --preset larp-macos
cmake --build --preset larp-macos
QT_QPA_PLATFORM=offscreen .tools/Qt/6.10.1/macos/bin/qmltestrunner -input tests/qml -o -,txt
bash deploy/larp/package.sh
```

Результат: `dist/LarpmneziaVPN-test.dmg` и SHA-256 рядом с ним.
DMG содержит PKG, устанавливающий клиент и отдельную launchd-службу.
Пакет использует ad-hoc подпись; Developer ID и нотарификация не настроены.

Если локальный Clang не находит `type_traits`, а файл есть в SDK:

```sh
cmake --preset larp-macos -DCMAKE_CXX_FLAGS="-isystem $(xcrun --show-sdk-path)/usr/include/c++/v1"
```

Тестовая сборка использует собственные QSettings, Keychain service,
bundle identifier и IPC endpoint. Существующие профили AmneziaVPN
автоматически не импортируются. Для сетевого теста импортируйте свой профиль.
Самостоятельно настроенные серверы и импорт конфигураций используют
исходный VPN backend. Закрытые ключи доступа к Amnezia Gateway не включены.

Для изменения подписи: Настройки → Приложение → Имя пользователя.
Пустая строка возвращает «вконтакте.ком», длина ограничена 64 символами.
