### Homework 3

Создал пользователей и необходимые поддиректории в /var/ftp.
Общие соображения:
* owner каталога - пользователь с таким же именем - имеет права rwx
* group owner каталога - ftp-admin с правами rwx
* остальным можно оставить r-x. Если пользователь захочет, то сам скроет, для chmod своего каталога ему sudo ек потребуется.
* ftp-admin внес в группу sudo, чтобы он мог чинить сломанные другими администраторами права. И на случай если пользователь сделает chmod 700 на каком-то из своих файлов.
 
Затем вручную случайным образом поменял владение и права доступа для некоторых файлов и каталогов.

```
ftp-admin@markuslab01:/var/ftp$ ll
total 32
drwxrwxrwx  8 ftp-admin ftp-admin 4096 Jul 14 17:37 ./
drwxr-xr-x 14 root      root      4096 Jul 14 16:02 ../
drwxrwxr-x  2 chandler  chandler  4096 Jul 14 16:08 chandler/
drwxrwxr-x  2 joey      ftp-admin 4096 Jul 14 16:07 joey/
drwxrwxrwx  3 ftp-admin ftp-admin 4096 Jul 14 17:08 monica/
drwxrwxr-x  2 phoebe    phoebe    4096 Jul 14 16:07 phoebe/
drwxr-----  2 rachel    ross      4096 Jul 14 17:37 rachel/
drwxrwxr-x  2 ross      ross      4096 Jul 14 16:30 ross/
```
Росс смог попасть в каталог Моники, создать там badfile и удалить нескоторые из ее файлов.

```
ross@markuslab01:/var/ftp/monica$ ll
total 12
drwxrwxrwx 3 ftp-admin ftp-admin 4096 Jul 14 17:48 ./
drwxrwxrwx 8 ftp-admin ftp-admin 4096 Jul 14 17:37 ../
drwxrwxr-x 2 monica    monica    4096 Jul 14 17:08 monicadir/
-rw-rw-r-- 1 monica    monica       0 Jul 14 17:42 monicafile1
-rw-rw-r-- 1 monica    monica       0 Jul 14 17:48 monicafile2
-rwx------ 1 monica    monica       0 Jul 14 17:45 monicafile3*
-rw-rw-r-- 1 monica    monica       0 Jul 14 17:46 monicafile4
-rw-rw-r-- 1 monica    monica       0 Jul 14 17:48 monicafile5
-rw-rw-r-- 1 monica    monica       0 Jul 14 17:48 monicafile6
ross@markuslab01:/var/ftp/monica$ touch badfile; rm -f monicafile2 monicafile4 monicafile5
ross@markuslab01:/var/ftp/monica$ ll
total 12
drwxrwxrwx 3 ftp-admin ftp-admin 4096 Jul 14 17:49 ./
drwxrwxrwx 8 ftp-admin ftp-admin 4096 Jul 14 17:37 ../
-rw-rw-r-- 1 ross      ross         0 Jul 14 17:49 badfile
drwxrwxr-x 2 monica    monica    4096 Jul 14 17:08 monicadir/
-rw-rw-r-- 1 monica    monica       0 Jul 14 17:42 monicafile1
-rwx------ 1 monica    monica       0 Jul 14 17:45 monicafile3*
-rw-rw-r-- 1 monica    monica       0 Jul 14 17:48 monicafile6
```

Из-за поломанных прав доступа ftp-admin не может удалить badfile из каталога Фиби:

```
ftp-admin@markuslab01:/var/ftp/phoebe$ ll
total 8
drwxrwxr-x 2 phoebe    phoebe    4096 Jul 14 17:52 ./
drwxrwxrwx 8 ftp-admin ftp-admin 4096 Jul 14 17:37 ../
-rw-rw-r-- 1 phoebe    phoebe       0 Jul 14 17:52 badfile
ftp-admin@markuslab01:/var/ftp/phoebe$ rm -r badfile
rm: remove write-protected regular empty file 'badfile'? y
rm: cannot remove 'badfile': Permission denied
```

Потом администратор случайно сделал chmod 770 на /var/ftp и теперь никто из пользователей не может попасть в свой каталог.
```
ross@markuslab01:~$ cd /var/ftp/ross
-bash: cd: /var/ftp/ross: Permission denied
```

Править вручную было бы долго. поэтому я написал скрипт. Запускается с sudo.

```
#!/usr/bin/bash
chown ftp-admin:ftp-admin /var/ftp
chmod 2775 /var/ftp
for d in /var/ftp/*/; do
        name=`echo $d | cut -d/ -f4`
        chown -R $name:ftp-admin /var/ftp/$name
        for element in `find /var/ftp/$name`; do
                if [ -d $element ]; then
                        chmod 2775 $element;
                else
                        chmod  664 $element;
                fi
        done
#       chmod 2770 -R /var/ftp/$name
done
```
Закомментированную строчку я оставил из первой попытки решения. Задача в принципе решалась, но все файлы становились исполняемыми, а каталоги доступными только для пользователя-владельца и ftp-admin. Вторая версия более разборчива.

Результат:
```
ftp-admin@markuslab01:/var/ftp$ ll
total 32
drwxrwsr-x  8 ftp-admin ftp-admin 4096 Jul 14 17:37 ./
drwxr-xr-x 14 root      root      4096 Jul 14 16:02 ../
drwxrwsr-x  2 chandler  ftp-admin 4096 Jul 14 16:08 chandler/
drwxrwsr-x  2 joey      ftp-admin 4096 Jul 14 16:07 joey/
drwxrwsr-x  3 monica    ftp-admin 4096 Jul 14 17:52 monica/
drwxrwsr-x  2 phoebe    ftp-admin 4096 Jul 14 17:52 phoebe/
drwxrwsr-x  2 rachel    ftp-admin 4096 Jul 14 17:37 rachel/
drwxrwsr-x  2 ross      ftp-admin 4096 Jul 14 16:30 ross/
ftp-admin@markuslab01:/var/ftp$ cd monica
ftp-admin@markuslab01:/var/ftp/monica$ ll
total 12
drwxrwsr-x 3 monica    ftp-admin 4096 Jul 14 18:08 ./
drwxrwsr-x 8 ftp-admin ftp-admin 4096 Jul 14 17:37 ../
drwxrwsr-x 2 monica    ftp-admin 4096 Jul 14 17:08 monicadir/
-rw-rw-r-- 1 monica    ftp-admin    0 Jul 14 17:42 monicafile1
-rw-rw-r-- 1 monica    ftp-admin    0 Jul 14 17:45 monicafile3
-rw-rw-r-- 1 monica    ftp-admin    0 Jul 14 17:48 monicafile6
ftp-admin@markuslab01:/var/ftp/monica$ cd monica dir
-bash: cd: too many arguments
ftp-admin@markuslab01:/var/ftp/monica$ ll monicadir
total 8
drwxrwsr-x 2 monica ftp-admin 4096 Jul 14 17:08 ./
drwxrwsr-x 3 monica ftp-admin 4096 Jul 14 18:08 ../
-rw-rw-r-- 1 monica ftp-admin    0 Jul 14 17:08 monicafile4
ftp-admin@markuslab01:/var/ftp/monica$ rm ../phoebe/badfile
ftp-admin@markuslab01:/var/ftp/monica$ ll ../phoebe/
total 8
drwxrwsr-x 2 phoebe    ftp-admin 4096 Jul 14 18:11 ./
drwxrwsr-x 8 ftp-admin ftp-admin 4096 Jul 14 17:37 ../
```

Наверное, скрипт можно переписать в более чистом виде (мне, в частности, не нравится вложенный цикл c if-else). Я думал как-то использовать umask, но не нашел удобного способа получить ее в восьмеричном виде.