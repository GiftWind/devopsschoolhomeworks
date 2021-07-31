### GIT Homework

> Склонировать один и тот же репозиторий к себе на компьютер в две разные папки. Сделать одни и те же изменения в обеих копиях репозитория, закоммитить и сделать push, pull. Добиться одинаковых hash сумм для обоих коммитов за счет идентичности коммитов. Сделать push pull.

1. Создаю репозиторий samehash и добавляю в него файл content с текстом:

```
Delete the last symbol from this line: X
```

2. Клонирую в две разные директории.
```
giftwind@markuslab01:~/devops$ mkdir git{1,2}
giftwind@markuslab01:~/devops$ cd git1
giftwind@markuslab01:~/devops/git1$ git clone https://github.com/GiftWind/samehash.git
Cloning into 'samehash'...
remote: Enumerating objects: 6, done.
remote: Counting objects: 100% (6/6), done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 6 (delta 0), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (6/6), done.
giftwind@markuslab01:~/devops/git1$ cd ../git2
giftwind@markuslab01:~/devops/git2$ git clone https://github.com/GiftWind/samehash.git
Cloning into 'samehash'...
remote: Enumerating objects: 6, done.
remote: Counting objects: 100% (6/6), done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 6 (delta 0), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (6/6), done.
```


Причина разности хэшей - время возле полей Author и Committer.
Время возле author меняется опцией --date= при git commit.
Время возле committer можно задать переменной окружения  GIT_COMMITTER_DATE: 2021-07-28T22:36:00
```
$ export GIT_AUTHOR_DATE=2021-07-28T00:00:00
$ export GIT_COMMITTER_DATE=2021-07-28T00:00:00
$ git commit -m ...
```
Решение с помощью переменной окружения:
```
giftwind@markuslab01:~/devops$ cd git1/samehash/
giftwind@markuslab01:~/devops/git1/samehash$ vim
content    .git/      README.md
giftwind@markuslab01:~/devops/git1/samehash$ vim
content    .git/      README.md
giftwind@markuslab01:~/devops/git1/samehash$ vim content
giftwind@markuslab01:~/devops/git1/samehash$ export GIT_AUTHOR_DATE=2021-07-28T00:00:00
giftwind@markuslab01:~/devops/git1/samehash$ export GIT_COMMITTER_DATE=2021-07-28T00:00:00
giftwind@markuslab01:~/devops/git1/samehash$ git add .
giftwind@markuslab01:~/devops/git1/samehash$ export GIT_AUTHOR_DATE=2021-07-28T00:00:00
giftwind@markuslab01:~/devops/git1/samehash$ export GIT_COMMITTER_DATE=2021-07-28T00:00:00
giftwind@markuslab01:~/devops/git1/samehash$ git commit -m "delete the last symbol"
[main d527e18] delete the last symbol
 1 file changed, 1 insertion(+), 1 deletion(-)
giftwind@markuslab01:~/devops/git1$ cd ../../git2/samehash/
giftwind@markuslab01:~/devops/git2/samehash$ ll
total 20
drwxrwxr-x 3 giftwind giftwind 4096 Jul 28 20:38 ./
drwxrwxr-x 3 giftwind giftwind 4096 Jul 28 20:38 ../
-rw-rw-r-- 1 giftwind giftwind   41 Jul 28 20:38 content
drwxrwxr-x 8 giftwind giftwind 4096 Jul 28 20:38 .git/
-rw-rw-r-- 1 giftwind giftwind   58 Jul 28 20:38 README.md
giftwind@markuslab01:~/devops/git2/samehash$ vim content
giftwind@markuslab01:~/devops/git2/samehash$ git add .
giftwind@markuslab01:~/devops/git2/samehash$ export GIT_AUTHOR_DATE=2021-07-28T00:00:00
giftwind@markuslab01:~/devops/git2/samehash$ export GIT_COMMITTER_DATE=2021-07-28T00:00:00
giftwind@markuslab01:~/devops/git2/samehash$ git commit -m "delete the last symbol"
[main d527e18] delete the last symbol
 1 file changed, 1 insertion(+), 1 deletion(-)
giftwind@markuslab01:~/devops/git2/samehash$ git show HEAD
commit d527e1826d109c57572dca95a31f3269bea7314f (HEAD -> main)
Author: Mark Okulov <mvokulov@gmail.com>
Date:   Wed Jul 28 00:00:00 2021 +0000

    delete the last symbol

diff --git a/content b/content
index a50d562..a81e407 100644
--- a/content
+++ b/content
@@ -1 +1 @@
-Delete the last symbol from this line: X
+Delete the last symbol from this line:
giftwind@markuslab01:~/devops/git2/samehash$ cd ../../git1/samehash/
giftwind@markuslab01:~/devops/git1/samehash$ git show HEAD
commit d527e1826d109c57572dca95a31f3269bea7314f (HEAD -> main)
Author: Mark Okulov <mvokulov@gmail.com>
Date:   Wed Jul 28 00:00:00 2021 +0000

    delete the last symbol

diff --git a/content b/content
index a50d562..a81e407 100644
--- a/content
+++ b/content
@@ -1 +1 @@
-Delete the last symbol from this line: X
+Delete the last symbol from this line:

giftwind@markuslab01:~/devops/git1/samehash$ git cat-file -p d527
tree 3a0035783fc025f2bdc5fc77133433ec552517a6
parent 8c65f1e1c312b8fafade37f66b67814fd74b5e36
author Mark Okulov <mvokulov@gmail.com> 1627430400 +0000
committer Mark Okulov <mvokulov@gmail.com> 1627430400 +0000

delete the last symbol
giftwind@markuslab01:~/devops/git1/samehash$ cd ../../git2/samehash/
giftwind@markuslab01:~/devops/git2/samehash$ git cat-file -p d527
tree 3a0035783fc025f2bdc5fc77133433ec552517a6
parent 8c65f1e1c312b8fafade37f66b67814fd74b5e36
author Mark Okulov <mvokulov@gmail.com> 1627430400 +0000
committer Mark Okulov <mvokulov@gmail.com> 1627430400 +0000

delete the last symbol
giftwind@markuslab01:~/devops/git2/samehash$ git log
commit d527e1826d109c57572dca95a31f3269bea7314f (HEAD -> main)
Author: Mark Okulov <mvokulov@gmail.com>
Date:   Wed Jul 28 00:00:00 2021 +0000

    delete the last symbol

commit 8c65f1e1c312b8fafade37f66b67814fd74b5e36 (origin/main, origin/HEAD)
Author: GiftWind <mvokulov@gmail.com>
Date:   Wed Jul 28 23:34:28 2021 +0300

    create content file

commit a9c1bf84dddfdcda55ad4abf552731fc0c529d9d
Author: GiftWind <mvokulov@gmail.com>
Date:   Wed Jul 28 23:33:04 2021 +0300

    Initial commit
giftwind@markuslab01:~/devops/git2/samehash$ cd ../../git1/samehash/
giftwind@markuslab01:~/devops/git1/samehash$ git log
commit d527e1826d109c57572dca95a31f3269bea7314f (HEAD -> main)
Author: Mark Okulov <mvokulov@gmail.com>
Date:   Wed Jul 28 00:00:00 2021 +0000

    delete the last symbol

commit 8c65f1e1c312b8fafade37f66b67814fd74b5e36 (origin/main, origin/HEAD)
Author: GiftWind <mvokulov@gmail.com>
Date:   Wed Jul 28 23:34:28 2021 +0300

    create content file

commit a9c1bf84dddfdcda55ad4abf552731fc0c529d9d
Author: GiftWind <mvokulov@gmail.com>
Date:   Wed Jul 28 23:33:04 2021 +0300

    Initial commit
giftwind@markuslab01:~/devops/git1/samehash$ cd .git/objects/
```

После выполнения git push из второй папки ожидаемо получаем сообщение Everything up-to-date.

Второй вариант решения - не делать коммиты одинаковыми изначально. а исправить один из них:
1. Сделать коммит из первой директории.
2. Сделать коммит из второй директории.
3. Скопировать timestamp коммита из пункта 1.
4. Задать переменные окружения GIT_AUTHOR_DATE и GIT_COMMITTER_DATE.
5. Сделать git commit --amend во второй директории.

```
giftwind@markuslab01:~/devops/git1/samehash$ git commit -m "delete the last symbol again"
[main dd713e7] delete the last symbol again
 1 file changed, 1 insertion(+), 1 deletion(-)
giftwind@markuslab01:~/devops/git1/samehash$ cd ../../git2/samehash/
giftwind@markuslab01:~/devops/git2/samehash$ vim content
giftwind@markuslab01:~/devops/git2/samehash$ git add .
giftwind@markuslab01:~/devops/git2/samehash$ git commit -m "delete the last symbol again"
[main 38c7230] delete the last symbol again
 1 file changed, 1 insertion(+), 1 deletion(-)
giftwind@markuslab01:~/devops/git2/samehash$ git log
commit 38c7230fdc708536324549cc2d46eaac6b2f58b0 (HEAD -> main)
Author: Mark Okulov <mvokulov@gmail.com>
Date:   Sat Jul 31 21:51:14 2021 +0000

    delete the last symbol again

commit d527e1826d109c57572dca95a31f3269bea7314f (origin/main, origin/HEAD)
Author: Mark Okulov <mvokulov@gmail.com>
Date:   Wed Jul 28 00:00:00 2021 +0000

    delete the last symbol

commit 8c65f1e1c312b8fafade37f66b67814fd74b5e36
Author: GiftWind <mvokulov@gmail.com>
Date:   Wed Jul 28 23:34:28 2021 +0300

    create content file

commit a9c1bf84dddfdcda55ad4abf552731fc0c529d9d
Author: GiftWind <mvokulov@gmail.com>
Date:   Wed Jul 28 23:33:04 2021 +0300

    Initial commit
giftwind@markuslab01:~/devops/git2/samehash$ cd ../../git1/samehash/
giftwind@markuslab01:~/devops/git1/samehash$ git log
commit dd713e71dd78b29234acf52470f203159c6537e3 (HEAD -> main)
Author: Mark Okulov <mvokulov@gmail.com>
Date:   Sat Jul 31 21:50:44 2021 +0000

    delete the last symbol again

commit d527e1826d109c57572dca95a31f3269bea7314f (origin/main, origin/HEAD)
Author: Mark Okulov <mvokulov@gmail.com>
Date:   Wed Jul 28 00:00:00 2021 +0000

    delete the last symbol

commit 8c65f1e1c312b8fafade37f66b67814fd74b5e36
Author: GiftWind <mvokulov@gmail.com>
Date:   Wed Jul 28 23:34:28 2021 +0300

    create content file

commit a9c1bf84dddfdcda55ad4abf552731fc0c529d9d
Author: GiftWind <mvokulov@gmail.com>
Date:   Wed Jul 28 23:33:04 2021 +0300

    Initial commit
giftwind@markuslab01:~/devops/git1/samehash$ git cat-file -p dd713
tree 2d6ebd6f8c2d8912e67d888b1d9ef6a25aa40a47
parent d527e1826d109c57572dca95a31f3269bea7314f
author Mark Okulov <mvokulov@gmail.com> 1627768244 +0000
committer Mark Okulov <mvokulov@gmail.com> 1627768244 +0000


delete the last symbol again
delete the last symbol again
giftwind@markuslab01:~/devops/git1/samehash$ cd ../../git2/samehash/
giftwind@markuslab01:~/devops/git2/samehash$ git cat-file -p 38c7
tree 2d6ebd6f8c2d8912e67d888b1d9ef6a25aa40a47
parent d527e1826d109c57572dca95a31f3269bea7314f
author Mark Okulov <mvokulov@gmail.com> 1627768274 +0000
committer Mark Okulov <mvokulov@gmail.com> 1627768274 +0000

delete the last symbol again
giftwind@markuslab01:~/devops/git2/samehash$ export GIT_AUTHOR_DATE="1627768244 +0000"
giftwind@markuslab01:~/devops/git2/samehash$ export GIT_COMMITTER_DATE="1627768244 +0000"
giftwind@markuslab01:~/devops/git2/samehash$ git commit --amend
[main 17a8bf1] delete the last symbol again
 Date: Sat Jul 31 21:51:14 2021 +0000
 1 file changed, 1 insertion(+), 1 deletion(-)
giftwind@markuslab01:~/devops/git2/samehash$ git log
commit 17a8bf120eec2f3417129a879ce232d0a2d26760 (HEAD -> main)
Author: Mark Okulov <mvokulov@gmail.com>
Date:   Sat Jul 31 21:51:14 2021 +0000

    delete the last symbol again

commit d527e1826d109c57572dca95a31f3269bea7314f (origin/main, origin/HEAD)
Author: Mark Okulov <mvokulov@gmail.com>
Date:   Wed Jul 28 00:00:00 2021 +0000

    delete the last symbol

commit 8c65f1e1c312b8fafade37f66b67814fd74b5e36
Author: GiftWind <mvokulov@gmail.com>
:...skipping...
commit 17a8bf120eec2f3417129a879ce232d0a2d26760 (HEAD -> main)
Author: Mark Okulov <mvokulov@gmail.com>
Date:   Sat Jul 31 21:51:14 2021 +0000

    delete the last symbol again

commit d527e1826d109c57572dca95a31f3269bea7314f (origin/main, origin/HEAD)
Author: Mark Okulov <mvokulov@gmail.com>
Date:   Wed Jul 28 00:00:00 2021 +0000

    delete the last symbol

commit 8c65f1e1c312b8fafade37f66b67814fd74b5e36
Author: GiftWind <mvokulov@gmail.com>
Date:   Wed Jul 28 23:34:28 2021 +0300

    create content file

commit a9c1bf84dddfdcda55ad4abf552731fc0c529d9d
Author: GiftWind <mvokulov@gmail.com>
Date:   Wed Jul 28 23:33:04 2021 +0300

    Initial commit
giftwind@markuslab01:~/devops/git2/samehash$ git cat-file -p 17a8
tree 2d6ebd6f8c2d8912e67d888b1d9ef6a25aa40a47
parent d527e1826d109c57572dca95a31f3269bea7314f
author Mark Okulov <mvokulov@gmail.com> 1627768274 +0000
committer Mark Okulov <mvokulov@gmail.com> 1627768244 +0000

delete the last symbol again
```

Тут я узнал, что --amend оставляет неизменным author timestamp исправляемого коммита, игнорируя переменную окружения. Ничего страшного, у нас есть --date=
```
giftwind@markuslab01:~/devops/git2/samehash$ git commit --amend --date=="1627768244 +0000"
[main dd713e7] delete the last symbol again
 Date: Sat Jul 31 21:50:44 2021 +0000
 1 file changed, 1 insertion(+), 1 deletion(-)
giftwind@markuslab01:~/devops/git2/samehash$ git log
commit dd713e71dd78b29234acf52470f203159c6537e3 (HEAD -> main)
Author: Mark Okulov <mvokulov@gmail.com>
Date:   Sat Jul 31 21:50:44 2021 +0000

    delete the last symbol again

commit d527e1826d109c57572dca95a31f3269bea7314f (origin/main, origin/HEAD)
Author: Mark Okulov <mvokulov@gmail.com>
Date:   Wed Jul 28 00:00:00 2021 +0000

    delete the last symbol

commit 8c65f1e1c312b8fafade37f66b67814fd74b5e36
Author: GiftWind <mvokulov@gmail.com>
Date:   Wed Jul 28 23:34:28 2021 +0300

    create content file

commit a9c1bf84dddfdcda55ad4abf552731fc0c529d9d
Author: GiftWind <mvokulov@gmail.com>
Date:   Wed Jul 28 23:33:04 2021 +0300

    Initial commit
giftwind@markuslab01:~/devops/git2/samehash$ git push
Username for 'https://github.com': giftwind
Password for 'https://giftwind@github.com':
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 325 bytes | 162.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
To https://github.com/GiftWind/samehash.git
   d527e18..dd713e7  main -> main
giftwind@markuslab01:~/devops/git2/samehash$ git pull
Already up to date.
giftwind@markuslab01:~/devops/git2/samehash$ cd ../../git2/samehash/
giftwind@markuslab01:~/devops/git2/samehash$ git push
Username for 'https://github.com': giftwind
Password for 'https://giftwind@github.com':
Everything up-to-date
giftwind@markuslab01:~/devops/git2/samehash$
```

Этот вариант решения появился после двух дней попыток вручную исправить содержимое объекта коммита, переименовать его в соответствии с новым значением хэша, а затем внести исправления в .git/refs и HEAD. Не получилось, но теперь я понимаю git немного лучше.