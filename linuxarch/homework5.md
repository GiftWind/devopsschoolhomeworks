### Linux Architecture Homework 5

Нашел подсказку в мане по команде ping:

> If ping does not receive any reply packets at all it will exit with code 1. If a packet count and deadline are both specified, and fewer than count packets are received by the time the deadline has arrived, it will also exit with code 1. On other error it exits with code 2. Otherwise it exits with code 0. This makes it possible to use the exit code to see if a host is alive or not.

Дальше просто написал простой скрипт для сравнения с нулем кода возврата команды:

```
#!/usr/bin/bash
ping -c 1 "$1" >& /dev/null
if [ $? -eq 0 ]
then
        echo "$1 is alive"
else
        echo "$1 is not alive"
fi
```
Отправляю один запрос и жду ответа 2 секунды.
stdout и stderr направляю в /dev/null, чтобы получить чистый вывод.
Результат:

```
giftwind@markuslab01:~/devops/devopsschoolhomeworks/linuxarch/hw5$ ./ping.sh google.com
google.com is alive
giftwind@markuslab01:~/devops/devopsschoolhomeworks/linuxarch/hw5$ ./ping.sh eeeerrr.fff.rrr
eeeerrr.fff.rrr is not alive
```

Основной недостаток - отправка только одного пакета. При высоких потерях в сети запрос может не дойти до удаленного хоста, т.е. скрипт может давать неправильный ответ. Правильнее было бы отправить несколько пакетов, но при заданном количестве запросов и времени ожидания ответа код возврата при потере хотя бы одного пакета уже будет 1. Если так правильнее, то лучше вытащить количество полученных ответов из предпоследней строки команды ping и сравнить с нулем. Вернусь к этой задаче после выполнения третьего ДЗ. Альтернатива - удалить из скрипта опции с количеством пакетов и временем ожидания ответа и вручную прерывать выполнение скрипта.