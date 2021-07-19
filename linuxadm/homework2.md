### Linux Administration Homework 2

#### Задание 1
>Рассчитать вероятность потерять данные при использовании дисков в raid массиве, для разных raid level и разных количествах дисков. Считать вероятность выхода из строя одного диска - 1%.
Рассчитать насколько уменьшится суммарный объем памяти при использовании дисков в raid массиве, для разных raid level и разном количестве дисков, по сравнению с использованием дисков как независимых.


Поскольку вероятность выхода из строя RAID массива соответствует верятности выхода из строя некоторого количества дисков, решение задачи сводится к биномиальному распределению:
![binomial distribution](https://wikimedia.org/api/rest_v1/media/math/render/svg/68e9ce21009429f91ba16de3ca2fbe830b9f8733)
где 
![binomial coefficient](https://wikimedia.org/api/rest_v1/media/math/render/svg/1065e327d2ca75be3c4dd2e461f608864f9c6e24) 
 биномиальный коэффициент, 
 p - вероятность выхода из строя одного диска,
 q = (1 - p) - вероятность "невыхода из строя",
 n - общее количество дисков,
 k - количество вышедших из строя дисков.

Для получения полной вероятности следует суммировать вероятности для k от k_min до n, где k_min - количество дисков, при котором RAID выходит из строя. То есть RAID5 из четырех дисков выйдет из строя при падении 2, 3 или 4 дисков.

RAID0: эффективный объем не уменьшается, но для выхода массива из строя достаточно выхода из строя одного диска.
Кол-во дисков | 2 | 3 | 4 | 5 | 6 |
--------------|----|----|----|----|----|
Вероятность, %|1.99|2.97|3.94|4.9|5.85

RAID1: зеркалирование происходит на все диски, то есть эффективный объем равен объему одного диска. Работает пока работает хотя бы один диск.
Кол-во дисков | 2 | 3 | 4 | 5 | 6 |
--------------|----|----|----|----|----|
Вероятность, %|0.01|0.0001|10^-6|10^-8|10^-10
Уменьшение объема,%|50|66.7|75|80|83.3|

RAID5: эффективный объем уменьшается на объем одного диска. Выходит из строя при выходе из строя двух дисков.
Кол-во дисков |  3 | 4 | 5 | 6 |
--------------|----|----|----|----|
Вероятность, %|0.0298|0.0592|0.098|0.146|
Уменьшение объема,%|33.3|25|20|16.7|

RAID6: эффективный объем уменьшается на объем двух дисков. Выходит из строя при выходе из строя трех дисков.
Кол-во дисков |  4 | 5 | 6 | 7 | 8
--------------|----|----|----|----|---|
Вероятность, %|0.0004|0.001|0.00195|0.0034|0.0054
Уменьшение объема,%|50|40|33.3|28.6|25

Для комибинированных уровней RAID расчет аналогичен, но значение p меняется с 1% на вероятность выхода из строя вложенного RAID массива.

#### Задание 2.
> Собрать несколько lv поверх md (raid5). Смонтировать с разными опциями в дерево каталогов.

Создадим несколько виртуальных жестких дисков и подключим к VM:

![plug vhd to vm](https://github.com/GiftWind/devopsschoolhomeworks/blob/master/linuxadm/hw2/plugvhd.jpg)

Проверим список подключенных блочных устройств.
```
giftwind@markuslab01:/$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                       7:0    0 69.9M  1 loop /snap/lxd/19188
loop1                       7:1    0 55.5M  1 loop /snap/core18/2074
loop2                       7:2    0 31.1M  1 loop /snap/snapd/10707
loop3                       7:3    0 32.3M  1 loop /snap/snapd/12398
loop4                       7:4    0 67.6M  1 loop /snap/lxd/20326
loop5                       7:5    0 55.4M  1 loop /snap/core18/1944
sda                         8:0    0   10G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part /boot
└─sda3                      8:3    0    9G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0    9G  0 lvm  /
sdb                         8:16   0    1G  0 disk
sdc                         8:32   0    1G  0 disk
sdd                         8:48   0    1G  0 disk
sde                         8:64   0    1G  0 disk
sr0                        11:0    1 1024M  0 rom
```

С помощью fdisk создадим разделы одинакового размера на дисках sdb, sdc, sdd, sdf. Можно не создавать, но тогда при замене диска придется следить за тем, чтобы его объем был больше или равен объему предыдущих дисков. В случае виртуальной машины это проще, в реальности же диски от разных производителей могут иметь разный фактический объем. На примере /dev/sdc:

```
giftwind@markuslab01:/$ sudo fdisk /dev/sdc

Welcome to fdisk (util-linux 2.34).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x670ee528.

Command (m for help): o
Created a new DOS disklabel with disk identifier 0xba1cdce7.

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-2097151, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-2097151, default 2097151):

Created a new partition 1 of type 'Linux' and of size 1023 MiB.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

Можно было создать GPT таблицу разделов, указать другой тип раздела, указать размер раздела или создать несколько разделов. Я все оставил по умолчанию. Проверим таблицы разделов:

```
giftwind@markuslab01:/$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                       7:0    0 69.9M  1 loop /snap/lxd/19188
loop1                       7:1    0 55.5M  1 loop /snap/core18/2074
loop2                       7:2    0 31.1M  1 loop /snap/snapd/10707
loop3                       7:3    0 32.3M  1 loop /snap/snapd/12398
loop4                       7:4    0 67.6M  1 loop /snap/lxd/20326
loop5                       7:5    0 55.4M  1 loop /snap/core18/1944
sda                         8:0    0   10G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part /boot
└─sda3                      8:3    0    9G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0    9G  0 lvm  /
sdb                         8:16   0    1G  0 disk
└─sdb1                      8:17   0 1023M  0 part
sdc                         8:32   0    1G  0 disk
└─sdc1                      8:33   0 1023M  0 part
sdd                         8:48   0    1G  0 disk
└─sdd1                      8:49   0 1023M  0 part
sde                         8:64   0    1G  0 disk
└─sde1                      8:65   0 1023M  0 part
sr0                        11:0    1 1024M  0 rom
```

С помощью mdadm создадим RAID5 массив из четырех дисков:

```
giftwind@markuslab01:/$ sudo mdadm --create --verbose /dev/md0 --level=5 --raid-devices=4 /dev/sd{b,c,d,e}1
mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: chunk size defaults to 512K
mdadm: size set to 1045504K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
```
Проверим статус RAID массива:
```
giftwind@markuslab01:/$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] [raid1] [raid10]
md0 : active raid5 sde1[4] sdd1[2] sdc1[1] sdb1[0]
      3136512 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] [UUUU]

unused devices: <none>
giftwind@markuslab01:~$ sudo mdadm -D /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Mon Jul 19 13:49:19 2021
        Raid Level : raid5
        Array Size : 3136512 (2.99 GiB 3.21 GB)
     Used Dev Size : 1045504 (1021.00 MiB 1070.60 MB)
      Raid Devices : 4
     Total Devices : 4
       Persistence : Superblock is persistent

       Update Time : Mon Jul 19 13:49:44 2021
             State : clean
    Active Devices : 4
   Working Devices : 4
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : resync

              Name : markuslab01:0  (local to host markuslab01)
              UUID : 9dffbece:5bc82472:1cb42677:4a127f2a
            Events : 18

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1
       4       8       65        3      active sync   /dev/sde1
```

Просмотрим обновленную информацию по блочным устройствам:
```
giftwind@markuslab01:/$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 69.9M  1 loop  /snap/lxd/19188
loop1                       7:1    0 55.5M  1 loop  /snap/core18/2074
loop2                       7:2    0 31.1M  1 loop  /snap/snapd/10707
loop3                       7:3    0 32.3M  1 loop  /snap/snapd/12398
loop4                       7:4    0 67.6M  1 loop  /snap/lxd/20326
loop5                       7:5    0 55.4M  1 loop  /snap/core18/1944
sda                         8:0    0   10G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part  /boot
└─sda3                      8:3    0    9G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0    9G  0 lvm   /
sdb                         8:16   0    1G  0 disk
└─sdb1                      8:17   0 1023M  0 part
  └─md0                     9:0    0    3G  0 raid5
sdc                         8:32   0    1G  0 disk
└─sdc1                      8:33   0 1023M  0 part
  └─md0                     9:0    0    3G  0 raid5
sdd                         8:48   0    1G  0 disk
└─sdd1                      8:49   0 1023M  0 part
  └─md0                     9:0    0    3G  0 raid5
sde                         8:64   0    1G  0 disk
└─sde1                      8:65   0 1023M  0 part
  └─md0                     9:0    0    3G  0 raid5
sr0                        11:0    1 1024M  0 rom
```

Поверх разделов sdb1, sdc1, sdd1, sde1 появился md0 объемом 3Гб.
Запишем информацию о массиве в конфигурационный файл:

```
giftwind@markuslab01:~$ sudo mdadm --examine --scan | sudo tee -a /etc/mdadm/mdadm.conf
ARRAY /dev/md/0  metadata=1.2 UUID=9dffbece:5bc82472:1cb42677:4a127f2a name=markuslab01:0
```

По инструкции из /etc/mdadm/mdadm.conf обновим образ начальной загрузки. Иначе после перезагрузки наш RAID сменит имя с /dev/md0 на /dev/md127:

```
giftwind@markuslab01:~$ sudo update-initramfs -u
update-initramfs: Generating /boot/initrd.img-5.4.0-77-generic
```

Инициализируем md0 как физический том:
```
giftwind@markuslab01:~$ sudo pvcreate /dev/md0
  Physical volume "/dev/md0" successfully created.
```
Убедимся в появлении нового физического тома:
```
giftwind@markuslab01:~$ sudo pvdisplay
  --- Physical volume ---
  PV Name               /dev/sda3
  VG Name               ubuntu-vg
  PV Size               <9.00 GiB / not usable 0
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              2303
  Free PE               0
  Allocated PE          2303
  PV UUID               pV2EbD-x5XP-1vJH-Ufzf-W5ji-0BXd-Y405lz

  "/dev/md0" is a new physical volume of "2.99 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/md0
  VG Name
  PV Size               2.99 GiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               nhCc2X-So5f-Rrav-1eP7-SYz5-tPUb-sIj7Za
```
Создадим новую группу томов на md0 и убедимся в ее создании:
```
giftwind@markuslab01:~$ sudo vgcreate hw2-vg /dev/md0
  Volume group "hw2-vg" successfully created
giftwind@markuslab01:~$ sudo pvdisplay /dev/md0
  --- Physical volume ---
  PV Name               /dev/md0
  VG Name               hw2-vg
  PV Size               2.99 GiB / not usable 3.00 MiB
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              765
  Free PE               765
  Allocated PE          0
  PV UUID               nhCc2X-So5f-Rrav-1eP7-SYz5-tPUb-sIj7Za
```

Далее создадим три логических тома:
```
giftwind@markuslab01:~$ sudo lvcreate -L 800M hw2-vg -n hw2-lv0
  Logical volume "hw2-lv0" created.
giftwind@markuslab01:~$ sudo lvcreate -L 800M hw2-vg -n hw2-lv1
  Logical volume "hw2-lv1" created.
giftwind@markuslab01:~$ sudo lvcreate -L 800M hw2-vg -n hw2-lv2
  Logical volume "hw2-lv2" created.
giftwind@markuslab01:~$ sudo lvdisplay hw2-vg
  --- Logical volume ---
  LV Path                /dev/hw2-vg/hw2-lv0
  LV Name                hw2-lv0
  VG Name                hw2-vg
  LV UUID                n9nxAq-l2W0-5rcq-W2zn-NdQa-pxIq-evKLz6
  LV Write Access        read/write
  LV Creation host, time markuslab01, 2021-07-19 20:01:07 +0000
  LV Status              available
  # open                 0
  LV Size                800.00 MiB
  Current LE             200
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     6144
  Block device           253:1

  --- Logical volume ---
  LV Path                /dev/hw2-vg/hw2-lv1
  LV Name                hw2-lv1
  VG Name                hw2-vg
  LV UUID                zJ7F1K-ucRm-zmOt-L9YE-yQVS-4mmM-2bjyO3
  LV Write Access        read/write
  LV Creation host, time markuslab01, 2021-07-19 20:01:11 +0000
  LV Status              available
  # open                 0
  LV Size                800.00 MiB
  Current LE             200
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     6144
  Block device           253:2

  --- Logical volume ---
  LV Path                /dev/hw2-vg/hw2-lv2
  LV Name                hw2-lv2
  VG Name                hw2-vg
  LV UUID                cvs2mc-vKf0-90fe-BZMc-bfAD-FAaH-y5dDKB
  LV Write Access        read/write
  LV Creation host, time markuslab01, 2021-07-19 20:01:14 +0000
  LV Status              available
  # open                 0
  LV Size                800.00 MiB
  Current LE             200
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     6144
  Block device           253:3
```
Список блочных устройств обновился:
```
sdb                         8:16   0    1G  0 disk
└─sdb1                      8:17   0 1023M  0 part
  └─md0                     9:0    0    3G  0 raid5
    ├─hw2--vg-hw2--lv0    253:1    0  800M  0 lvm
    ├─hw2--vg-hw2--lv1    253:2    0  800M  0 lvm
    └─hw2--vg-hw2--lv2    253:3    0  800M  0 lvm
sdc                         8:32   0    1G  0 disk
└─sdc1                      8:33   0 1023M  0 part
  └─md0                     9:0    0    3G  0 raid5
    ├─hw2--vg-hw2--lv0    253:1    0  800M  0 lvm
    ├─hw2--vg-hw2--lv1    253:2    0  800M  0 lvm
    └─hw2--vg-hw2--lv2    253:3    0  800M  0 lvm
sdd                         8:48   0    1G  0 disk
└─sdd1                      8:49   0 1023M  0 part
  └─md0                     9:0    0    3G  0 raid5
    ├─hw2--vg-hw2--lv0    253:1    0  800M  0 lvm
    ├─hw2--vg-hw2--lv1    253:2    0  800M  0 lvm
    └─hw2--vg-hw2--lv2    253:3    0  800M  0 lvm
sde                         8:64   0    1G  0 disk
└─sde1                      8:65   0 1023M  0 part
  └─md0                     9:0    0    3G  0 raid5
    ├─hw2--vg-hw2--lv0    253:1    0  800M  0 lvm
    ├─hw2--vg-hw2--lv1    253:2    0  800M  0 lvm
    └─hw2--vg-hw2--lv2    253:3    0  800M  0 lvm
```
Остается отформатировать и смонтировать:
```
giftwind@markuslab01:~$ sudo mkfs.ext4 /dev/hw2-vg/hw2-lv0
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 204800 4k blocks and 51296 inodes
Filesystem UUID: 44d4a4bd-ae11-4c9b-a961-2b96e365b90a
Superblock backups stored on blocks:
        32768, 98304, 163840

Allocating group tables: done
Writing inode tables: done
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done
giftwind@markuslab01:~$ sudo mkfs.ext4 /dev/hw2-vg/hw2-lv1
...
giftwind@markuslab01:~$ sudo mkfs.ext4 /dev/hw2-vg/hw2-lv2
...
giftwind@markuslab01:~$ sudo mkdir /mnt/lv0 /mnt/lv1 /mnt/lv2
giftwind@markuslab01:~$ sudo mount -o noexec /dev/hw2-vg/hw2-lv0 /mnt/lv0
giftwind@markuslab01:~$ sudo mount -o ro /dev/hw2-vg/hw2-lv1 /mnt/lv1
giftwind@markuslab01:~$ sudo mount /dev/hw2-vg/hw2-lv2 /mnt/lv2
```
Проверим монтирование томов:
```
giftwind@markuslab01:/mnt/lv1$ mount | grep hw2
/dev/mapper/hw2--vg-hw2--lv0 on /mnt/lv0 type ext4 (rw,noexec,relatime,stripe=384)
/dev/mapper/hw2--vg-hw2--lv1 on /mnt/lv1 type ext4 (ro,relatime,stripe=384)
/dev/mapper/hw2--vg-hw2--lv2 on /mnt/lv2 type ext4 (rw,relatime,stripe=384)
```

lv0 смонтирован как noexec:
```
giftwind@markuslab01:/mnt/lv0$ ll
total 28
drwxr-xr-x 3 root root  4096 Jul 19 20:19 ./
drwxr-xr-x 7 root root  4096 Jul 19 20:11 ../
drwx------ 2 root root 16384 Jul 19 20:10 lost+found/
-rwxr-xr-x 1 root root    23 Jul 19 20:19 sayhi.sh*
giftwind@markuslab01:/mnt/lv0$ cat sayhi.sh
#!/bin/bash
echo "Hi!"
giftwind@markuslab01:/mnt/lv0$ sudo ./sayhi.sh
sudo: unable to execute ./sayhi.sh: Permission denied
```
lv1 как readonly:
```
giftwind@markuslab01:/mnt/lv1$ touch newfile
touch: cannot touch 'newfile': Read-only file system
giftwind@markuslab01:/mnt/lv1$ sudo touch newfile
touch: cannot touch 'newfile': Read-only file system
```
Для автоматичеcкого монтирования при запуске системы следует отредактировать файл /etc/fstab.
Сразу после перезагрузки:
```
giftwind@markuslab01:~$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] [raid1] [raid10]
md0 : active raid5 sde1[4] sdd1[2] sdb1[0] sdc1[1]
      3136512 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] [UUUU]

unused devices: <none>
giftwind@markuslab01:~$ mount | grep hw2
/dev/mapper/hw2--vg-hw2--lv0 on /mnt/lv0 type ext4 (rw,noexec,relatime,stripe=384)
/dev/mapper/hw2--vg-hw2--lv2 on /mnt/lv2 type ext4 (rw,relatime,stripe=384)
/dev/mapper/hw2--vg-hw2--lv1 on /mnt/lv1 type ext4 (ro,relatime,stripe=384)
```


