### Linux Adm Homework 1
Собрать git из исходников
* проверим текущую версию git:

![git version before](https://github.com/GiftWind/devopsschoolhomeworks/blob/master/linuxadm/hw1/before.jpg)

* воспользуемся [инструкцией](https://git-scm.com/book/ru/v2/%D0%92%D0%B2%D0%B5%D0%B4%D0%B5%D0%BD%D0%B8%D0%B5-%D0%A3%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-Git)

Я не стал устанавливать пакеты для сборки документации в различных форматах - слишком много зависимостей.

Общая последовательность действий:
1. Получаем архив с исходниками
```
giftwind@markuslab01:~/gitsource$ wget https://github.com/git/git/archive/refs/tags/v2.32.0.tar.gz
```
2. Распаковываем
```
giftwind@markuslab01:~/gitsource$ tar -zxf v2.32.0.tar.gz
giftwind@markuslab01:~/gitsource$ ll
total 10128
drwxrwxr-x  3 giftwind giftwind     4096 Jul 16 11:55 ./
drwxr-xr-x  9 giftwind giftwind     4096 Jul 16 11:53 ../
drwxrwxr-x 26 giftwind giftwind    20480 Jun  6 06:40 git-2.32.0/
-rw-rw-r--  1 giftwind giftwind 10342296 Jul 16 11:53 v2.32.0.tar.gz
```
3. Устанавливаем необходимые пакеты
```
giftwind@markuslab01:~/gitsource$ sudo apt-get install dh-autoreconf libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev
```
4. Генерируем конфиг с указанием префикса директории инсталляции
```
giftwind@markuslab01:~/gitsource/git-2.32.0$ make configure
GIT_VERSION = 2.32.0
    GEN configure
giftwind@markuslab01:~/gitsource/git-2.32.0$ ./configure --prefix=/usr/local
```
5. Компилируем
```
giftwind@markuslab01:~/gitsource/git-2.32.0$ make
```
6. Инсталлируем
```
giftwind@markuslab01:~/gitsource/git-2.32.0$ sudo make install
```
7. Очищаем каталог от временных файлов
```
giftwind@markuslab01:~/gitsource/git-2.32.0$ sudo make clean
```

Результат:

![after new version of git installation](https://github.com/GiftWind/devopsschoolhomeworks/blob/master/linuxadm/hw1/result.jpg)

Установленная в /usr/bin версия git 2.25.1 осталась. Можно удалить, можно оставить.
После очистки хэша от старого пути (hash -d git, hash -r или ребут) при вызове git --version получена новая версия, т.к. в PATH /usr/local/bin стоит раньше /usr/bin:

![git version after reboot](https://github.com/GiftWind/devopsschoolhomeworks/blob/master/linuxadm/hw1/afterreboot.jpg)

Проверка работы:

![new git init](https://github.com/GiftWind/devopsschoolhomeworks/blob/master/linuxadm/hw1/gitinit.jpg)