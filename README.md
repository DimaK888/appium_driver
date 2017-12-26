APPIUM DRIVER
-------------

### Что это?
Гем, упрощающий запуск (в том числе параллельный) тестового окружения для АТ Android и iOS, в частности
запускает Appium сервер и AVD(Android Virtual Device)/iOS Simulator, с указанными параметрами.

### Что нужно для работы appium_driver. Не для Windows юзеров :(
- **Android SDK** (*для запуска AVD*)
  - Загрузить [SDK](https://developer.android.com/studio/releases/sdk-tools.html)
  - Распаковать
  - Установить переменную окружения $ANDROID_HOME:
    - открыть .bash_profile: `nano ~/.bash_profile `
    - В файл добавить следующие строки с указанием пути до распакованного SDK:
       ```
       export ANDROID_HOME=/YOUR_PATH_TO/android-sdk
       export PATH=$ANDROID_HOME/platform-tools:$PATH
       export PATH=$ANDROID_HOME/tools:$PATH
       ```
    - Применить изменения: `source ~/.bash_profile`
    - Проверить, выполнив команду: `echo $ANDROID_HOME`
    Должен вывести путь до SDK
- **Xcode** (*Только OS X. Для запуска iOS Simulator*)
  - Установить из AppStore'a актуальную версию
  - Произвести первый запуск (с автонастройкой)
- **Appium Server**
  - Установить Ruby, если еще нет: `\curl -sSL https://get.rvm.io | bash -s stable --ruby`
  - Установить gem appium_lib
    - Поставить необходимые гемы:
        ```
        gem update --system ;\
        gem install --no-rdoc --no-ri bundler ;\
        gem update ;\
        gem cleanup ;\
        gem uninstall -aIx appium_lib ;\
        gem uninstall -aIx appium_console ;\
        gem install --no-rdoc --no-ri appium_console ;\
        gem uninstall -aIx flaky ;\
        gem install --no-rdoc --no-ri flaky
        ```
  - Поставить brew: `ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"`
  - Поставить Nodejs, ant и maven:
      ```
      brew update ;\
      brew upgrade node ;\
      brew install node ;\
      brew install ant ;\
      brew install maven
      ```
  - Appium из source(подробнее в [инструкции](https://github.com/appium/appium/blob/master/docs/en/contributing-to-appium/appium-from-source.md#setting-up-appium-from-source)):
      ```
      git clone https://github.com/appium/appium.git
      cd appium
      npm install -g mocha
      npm install -g gulp
      npm install -g gulp-cli
      npm install -g appium-doctor
      npm install
      gulp transpile
      node .
      ```
      - ! Так как работаем с XCUITest, следующие строки выполнять не нужно:
         ```
         npm install -g authorize-ios
         sudo authorize-ios
         ```
  - Установить переменную окружения $APPIUM_HOME:
     - открыть .bash_profile: `nano ~/.bash_profile `
     - В файл добавить следующие строки с указанием пути до папки appium:
        ```
        export APPIUM_HOME=/YOUR_PATH_TO/appium
        ```
     - Применить изменения: `source ~/.bash_profile`
     - Проверить, выполнив команду: `echo $APPIUM_HOME`
     Должен вывести путь до папки appium        
### Как использовать
- Подключение гема: `require 'appium_driver'`
- Запуск сессии: `driver = Driver.new(caps)`
  - Что происходит: *Создание эмулятора/симулятора устройста, его запуск и запуск appium ноды*
  - Желательные параметры:
    - iOS `caps = { platform_name: 'iOS', platform_version: '11.2', device_name: 'iPhone 5s' }`
    - Android `caps = { platform_name: 'Android', platform_version: '7.1', device_name: '9' }`
- Остановка работы: `driver.stop`
  - Что происходит: *Завершение работы симулятора/эмулятора и ноды appium'a*
- Повторный запуск эмулятора/симулятора и ноды appium'a: `driver.start`
- Завершение сессии: `driver.exit`
  - Что происходит: *Завершение работы и удаление эмулятора/симулятора, закрытие сессии appium ноды*
- Убийцы процессов:
  - Убить все потоки и эмуляторы/симуляторы: `kill_all`
  - Убить все запущенные сессии Appium сервера: `kill_all_appium_servers`
  - Убить все запущенные симуляторы: `kill_all_booted_simulators`
  - Убить все запущенные эмуляторы: `kill_all_booted_emulators`
- Завершение работы эмулятора/симулятора:
  - iOS: `IOS::SimCtl.shutdown_vd(UDID)`
  - Android: `Android::AVDManager.shutdown_vd(port)`, где port - это порт, на котором запущен эмулятор
- Удаление эмулятора/симулятора:
  - iOS: `IOS::SimCtl.delete_vd(UDID)`
  - Android: `Android::AVDManager.delete_vd(avd)`, где avd - это имя avd
