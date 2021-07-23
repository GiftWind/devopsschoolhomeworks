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
1. Скрипт принимает на вход имя пользователя
2. Если пользователь с таким именем уже существует - exit 1
3. Скрипт создает пользователя с домашним каталогом
4. Скрипт генерирует пароль, назначает его пользователю и выводит на экран.
    4.1. Скрипт делает пароль expired, чтобы пользователь поменял его при своем первом логине.
    chage -d 0 $username
5. Скрипт создает каталог /var/ftp/username
6. Скрипт назначает нового пользователя владельцем каталога и устанавливает права доступа. На каталоге /var/ftp уже установлен SGID, поэтому группу-владельца можно не указывать.
7. Сразу присваиваю первый параметр переменной username для лучшей читаемости кода.
8. else не использую сознательно - в случае early return в нем нет необходимости. Если это противоречит code conventions, то перепишу.

##### Демонстрация работы

До добавления нового пользователя:
```
giftwind@markuslab01:~/devops/devopsschoolhomeworks/linuxadm/hw3$ tail -5 /etc/passwd
rachel:x:1005:1005:rachel green:/home/rachel:/bin/bash
phoebe:x:1006:1006:phoebe buffay:/home/phoebe:/bin/bash
chandler:x:1007:1007:chandler bing:/home/chandler:/bin/bash
ftp-admin:x:1008:1008:ftp admin:/home/ftp-admin:/bin/bash
stranger:x:1009:1009:user with nologin shell:/home/stranger:/sbin/nologin
giftwind@markuslab01:~/devops/devopsschoolhomeworks/linuxadm/hw3$ ll /home
total 48
drwxr-xr-x 12 root      root      4096 Jul 23 10:35 ./
drwxr-xr-x 20 root      root      4096 Jun  4 21:11 ../
drwxr-xr-x  2 chandler  chandler  4096 Jul 12 23:10 chandler/
drwxr-xr-x  4 ftp-admin ftp-admin 4096 Jul 14 18:13 ftp-admin/
drwxr-xr-x 13 giftwind  giftwind  4096 Jul 23 10:33 giftwind/
drwxr-xr-x  2 joey      joey      4096 Jul 12 23:10 joey/
drwxr-xr-x  2 markus    markus    4096 Jun  8 19:33 markus/
drwxr-xr-x  3 monica    monica    4096 Jul 14 19:35 monica/
drwxr-xr-x  3 phoebe    phoebe    4096 Jul 14 16:06 phoebe/
drwxr-xr-x  3 rachel    rachel    4096 Jul 19 20:45 rachel/
drwxr-xr-x  4 ross      ross      4096 Jul 14 16:06 ross/
drwxr-xr-x  2 stranger  stranger  4096 Jul 15 20:12 stranger/
giftwind@markuslab01:~/devops/devopsschoolhomeworks/linuxadm/hw3$ ll /var/ftp/
total 32
drwxrwsr-x  8 ftp-admin ftp-admin 4096 Jul 23 10:35 ./
drwxr-xr-x 14 root      root      4096 Jul 14 16:02 ../
drwxrwsr-x  2 chandler  ftp-admin 4096 Jul 14 16:08 chandler/
drwxrwsr-x  2 joey      ftp-admin 4096 Jul 14 16:07 joey/
drwxrwsr-x  4 monica    ftp-admin 4096 Jul 14 18:45 monica/
drwxrwsr-x  3 phoebe    ftp-admin 4096 Jul 14 18:45 phoebe/
drwxrwsr-x  2 rachel    ftp-admin 4096 Jul 14 17:37 rachel/
drwxrwsr-x  2 ross      ftp-admin 4096 Jul 14 16:30 ross/
```


