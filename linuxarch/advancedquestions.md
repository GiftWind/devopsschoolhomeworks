### Advanced questions

* Как запретить обычным пользователям исполнять свои программы?

Не могу придумать ничего кроме как перемонтировать раздел (или диск) с /home с опцией noexec.

* Как одной командой переключиться в контекст пользователя у которого $SHELL - /sbin/nologin или /bin/false?

Нужно запустить c правами root нормальную оболочку от имени данного пользователя. Например, так:

```
giftwind@markuslab01:~$ tail -1 /etc/passwd
stranger:x:1009:1009:user with nologin shell:/home/stranger:/sbin/nologin
giftwind@markuslab01:~$ sudo su -s /bin/bash stranger
stranger@markuslab01:/home/giftwind$ whoami
stranger
```

Или так:
```
giftwind@markuslab01:~$ sudo -u stranger -s /bin/bash -c /bin/bash
stranger@markuslab01:/home/giftwind$ whoami
stranger
```

Или так:
```
giftwind@markuslab01:~$ sudo runuser -s /bin/bash stranger
stranger@markuslab01:/home/giftwind$ whoami
stranger
```

* Администратор случайно исполнил команду: /bin/chmod -x /bin/chmod
Как теперь починить права на этот файл?

Есть множество способов, которые можно условно поделить на несколько групп. До первых двух я додумался сам, до остальных с подсказкой:
1. Самый очевидный - получить файл с корректными правами из внешнего источника или бэкапа.
2. Поскольку chmod это по сути просто способ обратиться к системному вызову, можно обратиться к нему каким-либо другим способом и поменять права на /bin/chmod. Например, из программы на C, Python или любом другом языке, предоставляющем такую возможность. Код копипастить не надо, наверное, а сам сейчас не напишу.
3. Воспользоваться тем, что при копировании файла права доступа на него также копируются (именно это мне и подсказали). Значит, можно скопировать какой-нибудь исполняемый файл, а затем скопировать в него сломанный chmod. Все копирования я выполняю с sudo для сохранения владельца и группы-владельца.
```
giftwind@markuslab01:/bin$ ll chmod
-rw-r--r-- 1 root root 63864 Jul 16 00:38 chmod
giftwind@markuslab01:/bin$ chmod +x chmod
-bash: /usr/bin/chmod: Permission denied
giftwind@markuslab01:/bin$ sudo cp chmod ~/chmodbak/brokenchmod
giftwind@markuslab01:/bin$ ll ~/chmodbak
total 136
drwxrwxr-x  2 giftwind giftwind  4096 Jul 16 16:09 ./
drwxr-xr-x 13 giftwind giftwind  4096 Jul 16 15:46 ../
-rw-r--r--  1 root     root     63864 Jul 16 16:09 brokenchmod
-rwxr-xr-x  1 giftwind giftwind 63864 Sep  5  2019 chmod*
giftwind@markuslab01:/bin$ sudo rm chmod
giftwind@markuslab01:/bin$ sudo cp cp chmod
giftwind@markuslab01:/bin$ ll chmod
-rwxr-xr-x 1 root root 153976 Jul 16 16:10 chmod*
giftwind@markuslab01:/bin$ cp ~/chmodbak/brokenchmod chmod
cp: cannot create regular file 'chmod': Permission denied
giftwind@markuslab01:/bin$ sudo !!
sudo cp ~/chmodbak/brokenchmod chmod
giftwind@markuslab01:/bin$ ll chmod
-rwxr-xr-x 1 root root 63864 Jul 16 16:10 chmod*
giftwind@markuslab01:/bin$ cd ~/chmodbak
giftwind@markuslab01:~/chmodbak$ ll
total 136
drwxrwxr-x  2 giftwind giftwind  4096 Jul 16 16:09 ./
drwxr-xr-x 13 giftwind giftwind  4096 Jul 16 15:46 ../
-rw-r--r--  1 root     root     63864 Jul 16 16:09 brokenchmod
-rwxr-xr-x  1 giftwind giftwind 63864 Sep  5  2019 chmod*
giftwind@markuslab01:~/chmodbak$ chmod +x brokenchmod
chmod: changing permissions of 'brokenchmod': Operation not permitted
giftwind@markuslab01:~/chmodbak$ sudo !!
sudo chmod +x brokenchmod
giftwind@markuslab01:~/chmodbak$ ll
total 136
drwxrwxr-x  2 giftwind giftwind  4096 Jul 16 16:09 ./
drwxr-xr-x 13 giftwind giftwind  4096 Jul 16 15:46 ../
-rwxr-xr-x  1 root     root     63864 Jul 16 16:09 brokenchmod*
-rwxr-xr-x  1 giftwind giftwind 63864 Sep  5  2019 chmod*
```

Вместо cp можно использовать mv, echo brokenchmod > chmod или dd if=brokenchmod of=chmod/