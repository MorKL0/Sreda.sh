#!/bin/bash

# Убедитесь, что вы запускаете этот скрипт с правами суперпользователя
if [[ $EUID -ne 0 ]]; then
   echo "Этот скрипт должен быть запущен с правами суперпользователя"
   exit 1
fi

# Путь к скачиваемому файлу (замените на актуальный URL)
MESSENGER_URL="https://dl.armgs.team/downloads/linux/x64/latest/sreda.tar.xz"
MESSENGER_FILE="/tmp/sreda.tar.xz"
MESSENDER_DIR="/opt/sreda"

# Скачивание установочного файла мессенджера
echo "Скачивание мессенджера Среда..."
wget -O $MESSENGER_FILE $MESSENGER_URL
if [[ $? -ne 0 ]]; then
    echo "Ошибка при скачивании файла $MESSENGER_URL"
    exit 1
fi
echo "Файл $MESSENGER_URL скачен успешно."

# Установка пакета мессенджера
echo "Установка мессенджера Среда..."

# Создание каталога для программы
if [[ ! -d "$MESSENDER_DIR" ]]; then
    mkdir $MESSENDER_DIR
    if [[ $? -ne 0 ]]; then
        echo "Ошибка при создании каталога $MESSENDER_DIR"
        rm -f $MESSENGER_FILE
        exit 1
    fi
fi
echo "Каталога $MESSENDER_DIR создан успешно."

# Распаковка архива в созданный каталог
tar xvf $MESSENGER_FILE -C $MESSENDER_DIR
if [[ $? -ne 0 ]]; then
    echo "Ошибка при распаковке $MESSENGER_FILE в каталог $MESSENDER_DIR"
    rm -f $MESSENGER_FILE
    exit 1
fi
echo "Архив $MESSENGER_FILE успешно распакован в каталог $MESSENDER_DIR"

# Создание desktop файла для интеграции с меню приложений
cat << EOF > /usr/share/applications/sredadesktop.desktop
[Desktop Entry]
Version=1.0
Name=Среда
Comment=Official desktop application for the Среда messaging service
Exec=/opt/sreda/sreda -urlcommand %u
Terminal=false
Type=Application
StartupWMClass=sreda
Categories=Network;InstantMessaging;Qt;
MimeType=x-scheme-handler/vkteams;x-scheme-handler/myteam-messenger;
X-Desktop-File-Install-Version=0.26
EOF
if [[ $? -ne 0 ]]; then
    echo "Ошибка при создании desktop файла для интеграции с меню приложений"
fi
echo "Файла для интеграции с меню приложений успешно создан"

# Создание файла для автозапуска программы при входе в систему
cat << EOF > /etc/xdg/autostart/sredadesktop.desktop
[Desktop Entry]
Version=1.0
Name=Среда
Comment=Official desktop application for the Среда messaging service
Exec=/opt/sreda/sreda -urlcommand %u
Terminal=false
Type=Application
StartupWMClass=sreda
Categories=Network;InstantMessaging;Qt;
MimeType=x-scheme-handler/vkteams;x-scheme-handler/myteam-messenger;
X-Desktop-File-Install-Version=0.26
EOF
if [[ $? -ne 0 ]]; then
    echo "Ошибка при создании файла для автозапуска программы при входе в систему"
fi
echo "Файла для автозапуска программы при входе в систему успешно создан"

# Удаление скачанного файла мессенджера
rm -f $MESSENGER_FILE
if [[ $? -ne 0 ]]; then
    echo "Ошибка при удаление скачанного файла мессенджера $MESSENGER_FILE"
fi

# Завершение скрипта
echo "Мессенджер Среда успешно установлен."
