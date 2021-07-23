### Linux Administration Homework 3

> Написать скрипт для добавления новых пользователей ftp-сервера в систему. Скрипт должен генерировать пароль, добавлять пользователя в систему, настраивать права пользователя, создавать домашний каталог.

Генерация пароля с помощью /dev/urandom:
`cat /dev/urandom | base64 | head -c 8`
Можно использовать pwgen, но его нужно устанавливать. Обойдемся имеющимися средствами.

```
#!/bin/bash
if [ $USER != "root" ];then
        echo "You must be root to execute this script"
        exit 1
fi
username=$1
grep $username /etc/passwd > /dev/null
if [ $? -eq 0 ];then
        echo "User $username already exists"
        exit 1
fi
        useradd -m -s /bin/bash $username
        password=$(cat /dev/urandom | base64 | head -c 8)
        echo $username:$password | chpasswd
        passwd -e $username > /dev/null
        mkdir /var/ftp/$username
        chown $username /var/ftp/$username
        chmod 775 /var/ftp/$username
        echo "User $username was created with password $password"
```

0. Скрипт запускается с правилегиями root. При запуске от имени обычного пользователя - exit 1.
1. Скрипт принимает на вход имя пользователя.
2. Сразу присваиваю первый параметр переменной username для лучшей читаемости кода.
3. Если пользователь с таким именем уже существует - exit 1
4. Скрипт создает пользователя с домашним каталогом.
5. Скрипт генерирует пароль и назначает его пользователю.

    5.1. Скрипт делает пароль expired, чтобы пользователь поменял его при своем первом логине.

6. Скрипт создает каталог /var/ftp/username.
7. Скрипт назначает нового пользователя владельцем каталога и устанавливает права доступа. На каталоге /var/ftp уже установлен SGID, поэтому группу-владельца можно не указывать.
8. Сразу присваиваю первый параметр переменной username для лучшей читаемости кода.
9. else не использую сознательно - в случае early return в нем нет необходимости. Если это противоречит code conventions, то перепишу.

##### Демонстрация работы

До добавления нового пользователя:
![before new user addition](https://github.com/GiftWind/devopsschoolhomeworks/blob/master/linuxadm/hw3/00-before.jpg)

Добавляем пользователя vasya:
```
giftwind@markuslab01:~/devops/devopsschoolhomeworks/linuxadm/hw3$ ./addftpuser.sh vasya
You must be root to execute this script
giftwind@markuslab01:~/devops/devopsschoolhomeworks/linuxadm/hw3$ sudo !!
sudo ./addftpuser.sh vasya
User vasya was created with password dpe3s/cp
```
После добавления пользователя vasya:
![after new user addition](https://github.com/GiftWind/devopsschoolhomeworks/blob/master/linuxadm/hw3/01-after.jpg)

Попробуем залогиниться как vasya:
![vasya login](https://github.com/GiftWind/devopsschoolhomeworks/blob/master/linuxadm/hw3/02-vasyalogin.jpg)

Система сразу же требует сменить пароль.
Добавить еще одного пользователя с именем vasya нельзя.


