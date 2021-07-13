### Linux Architecture Homework 2

#### Задание 1:
> Используя bash и программы из пакетов util-linux и core-utils, составить pipeline, который считает количество файлов в полном имени (включая путь) которых есть подстрока “root”, но нет подстроки “proc”.

find и grep не входят в состав util-linux и core-utils, но первый вариант решения я сделал с ними.

```
#!/bin/bash
find / -type f 2>/dev/null | grep root | grep -v proc | wc -l 
```

Демонстрация работы в Ubuntu Server 20.04:

```
giftwind@markuslab01:~$ ./findroot.sh
103
giftwind@markuslab01:~$ sudo ./findroot.sh
186
giftwind@markuslab01:~$ touch rootfile rootrootroot rootandproc
giftwind@markuslab01:~$ sudo ./findroot.sh
188
giftwind@markuslab01:~$ mkdir rootdir
giftwind@markuslab01:~$ sudo ./findroot.sh
188
giftwind@markuslab01:~$ touch rootdir/justafile rootdir/procfile
giftwind@markuslab01:~$ sudo ./findroot.sh
189
giftwind@markuslab01:~$
```

Stderr перенаправляется в /dev/null, поэтому ошибки доступа не выводятся. При запуске с привилегиями root результат, разумеется, выше. При создании пустой директории с root в названии результат подсчета не меняется, при добавлении в нее файла без root в названии результат увеличивается.
 В Centos 7 результат подсчета отличается:

```
[mokulov@markus-lab-centos hw2]$ ./findroot.sh
69
[mokulov@markus-lab-centos hw2]$ sudo !!
sudo ./findroot.sh
246
```

#### Задание 2:
> Используя bash и программы из пакетов util-linux и core-utils, составить pipeline, который выводит значящие (не закомментированные и не пустые) строки файла конфигурации сервиса. Например из файла /etc/ssh/sshd_config.

Дважды использовал grep по регулярному выражению. Насколько я понимаю, можно сделать и одним, но пока не разобрался. И в этом случае код будет хуже читаться.

```
#!/bin/bash
cat $1 | grep -v '^$' | grep -v '^\s\#'
```

Скрипт принимает в качестве аргумента полное имя файла. Разумеется, необходимо следить за правами доступа.
 Результат вызова в Ubuntu:

```
giftwind@markuslab01:~$ ./nonempty.sh /etc/ssh/sshd_config
Include /etc/ssh/sshd_config.d/*.conf
ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding yes
PrintMotd no
AcceptEnv LANG LC_*
Subsystem sftp  /usr/lib/openssh/sftp-server
PasswordAuthentication yes
```

Результат вызова в Centos отличается. Видимо, sshd по-разному сконфигурирован по умолчанию.

```
[mokulov@markus-lab-centos hw2]$ sudo ./nonempty.sh /etc/ssh/sshd_config
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key
SyslogFacility AUTHPRIV
AuthorizedKeysFile      .ssh/authorized_keys
PasswordAuthentication yes
ChallengeResponseAuthentication no
GSSAPIAuthentication yes
GSSAPICleanupCredentials no
UsePAM yes
X11Forwarding yes
AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE
AcceptEnv XMODIFIERS
Subsystem       sftp    /usr/libexec/openssh/sftp-server
```

#### Задание 4
> Выбрать все уникальные оболочки из файла /etc/passwd и сравнить со списком оболочек из файла /etc/shells.

Я использовал утилиту comm и process substitution, поскольку нашел только один альтернативный способ - создание временных файлов с отсортированным содержимым каждого из файлов. 
```
#!/usr/bin/bash
comm <(cut -d: -f7 /etc/passwd | sort | uniq) <(tail -n+2 /etc/shells | sort)
```
в Ubuntu первая строка содержит комментарий
```
# /etc/shells: valid login shells
```
поэтому я использовал tail начиная со второй строки.

Результат работы в Ubuntu:

```
giftwind@markuslab01:~/devops/devopsschoolhomeworks/linuxarch/hw2$ ./workingcomm.sh
                /bin/bash
        /bin/dash
/bin/false
        /bin/rbash
                /bin/sh
/bin/sync
        /usr/bin/bash
        /usr/bin/dash
        /usr/bin/rbash
        /usr/bin/screen
        /usr/bin/tmux
/usr/sbin/nologin
```

Результат работы в Centos:

```
[mokulov@markus-lab-centos hw2]$ ./workingcomm.sh
                /bin/bash
/bin/sync
/sbin/halt
/sbin/nologin
/sbin/shutdown
        /usr/bin/bash
        /usr/bin/sh
```
Отсутствие /bin/sh в выводе для Centos удивило. Выяснил, что комментария как в Ubuntu в Centos нет. Переписал скрипт.

```
#!/usr/bin/bash
comm <(cut -d: -f7 /etc/passwd | sort | uniq) <(grep -v '\#' /etc/shells | sort)
```
Результат работы в Ubuntu не изменился, в Centos:
```
                /bin/bash
        /bin/sh
/bin/sync
/sbin/halt
/sbin/nologin
/sbin/shutdown
        /usr/bin/bash
        /usr/bin/sh
```