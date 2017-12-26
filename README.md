APPIUM DRIVER
-------------

### Что это?
Гем, упрощающий запуск (в том числе параллельный) тестового окружения для АТ Android и iOS, в частности
запускает Appium сервер и AVD(Android Virtual Device)/iOS Simulator, с указанными параметрами.

### Что нужно для работы appium_driver. Не для Windows юзеров :(
- **Android SDK** (*для запуска AVD*)
  - Загружаем [SDK](https://developer.android.com/studio/releases/sdk-tools.html)
  - Распаковываем
  - Установка переменной окружения $ANDROID_HOME:
    - откроем .bash_profile: `nano ~/.bash_profile `
    - В файл добавьте следующие строки с указанием пути до распакованного SDK:
       ```
       export ANDROID_HOME=/YOUR_PATH_TO/android-sdk
       export PATH=$ANDROID_HOME/platform-tools:$PATH
       export PATH=$ANDROID_HOME/tools:$PATH
       ```
    - Применим изменения: `source ~/.bash_profile`
    - Проверим. Выполните команду: `echo $ANDROID_HOME`
    Должен вывести путь до SDK
- **Xcode** (*Только OS X. Для запуска iOS Simulator*)
  - Установить из AppStore'a актуальную версию
  - Произвести первый запуск (с автонастройкой)
- **Appium Server**
  - Установка gem appium_lib
    - Установите Ruby, если еще нет: `\curl -sSL https://get.rvm.io | bash -s stable --ruby`
    - Ставим необходимые гемы:
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
  - Cтавим brew: `ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"`
  - Ставим Nodejs, ant и maven:
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
      - ! Так как мы работаем с XCUITest, следующие строкивыполнять не нужно:
         ```
         npm install -g authorize-ios
         sudo authorize-ios
         ```
         
### Как использовать
- Подключение гема: `require 'appium_driver'`
- Запуск сессии: `driver = Driver.new(caps)`
  - Желательные параметры:
    - iOS `caps = { platform_name: 'iOS', platform_version: '11.2', device_name: 'iPhone 5s' }`
    - Android `caps = { platform_name: 'Android', platform_version: '7.1', device_name: '9' }`
- Завершение сессии: `driver.stop`
- Убийцы процессов:
  - Убить все потоки и **эмуляторы** (TODO: убийство всех запущенных симуляторов): `kill_all`
  - Убить все Appium сервера: `kill_all_appium_servers`
  - Убить все эмуляторы: `kill_all_emulators`
  
