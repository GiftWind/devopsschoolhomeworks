### Linux Administration Homework 4

>Написать systemV init script и systemd service unit для filesharing service. В качестве транспорта для передачи файлов использовать протокол http. Номер tcp порта и папку для раздачи файлов можно вынести в файл с параметрами, можно оставить в скрипте, на ваше усмотрение (предлагаю 8080 и /opt/share). В качестве web сервера предлагаю использовать python -m http.server (или python -m SimpleHTTPServer для python2).
Продемонстрировать работоспособность: start, stop, restart, status.

#### SystemV init script

Создаем скрипт в директории /etc/init.d:

```
#!/bin/bash

workingdir="/opt/share"
port=8080
pidfile="/var/run/filesharer.pid"

getpid() {
	cat "$pidfile"
}

isrunning() {
	[ -f "$pidfile" ] && ps -p `getpid` &> /dev/null
}

start() {
	if isrunning; then
		echo "Service is already working"
	else
		echo "Starting filesharer service on port $port sharing content of $workingdir"
		cd "$workingdir"
		python3 -m http.server $port &> /dev/null &
		echo $! > "$pidfile"
	fi		
}

stop() {

	if ! isrunning ; then
		echo "Filesharer is not running"
	else
		echo "Stopping filesharer"
		kill $(getpid)
		sleep 1
		if isrunning; then
			echo "Service was not terminated, sending SIGKILL"
			kill -9 $(getpid)
		fi
		echo "Filesharer stopped"
	fi
	if [ -f $pidfile ]; then
		rm $pidfile
	fi
}

status() {
	if isrunning; then
		echo "Filesharer service is running with PID $(getpid)"
		echo "Sharing content of $workingdir on port $port"
	else
		echo "Filesharer is not running"
	fi
}

case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  status)
        status
        ;;
  restart|reload|condrestart)
        stop
        start
        ;;
  *)
        echo $"Usage: $0 {start|stop|restart|reload|status}"
        exit 1
esac

exit 0
``` 

1. Сервер работает в бэкграунде, все сообщения отправляются в /dev/null. Правильнее, конечно, писать их в логи.
2. Перед start и stop проверяется состояние. Если сервер соответственно уже запущен или остановлен, то выводится соответствующее сообщение. При попытке restart остановленного сервиса сначала выводится сообщение о том, что сервис уже остановлен, потом он запускается.
3. Порт и рабочая директория вынесены в переменные, чтобы скрипт было проще переписать для работы с внешним конфигурационным файлом.
4. Перед отправкой SIGKILL производится попытка остановить сервис SIGTERM'ом с секундным ожиданием. Это не более чем заглушка для точки расширения на будущее (возможно, стоит дать пользователям докачать файлы перед остановкой сервера, пока не могу написать обработку таких ситуаций).

Демонстрация работы:

Запуск через sudo, поскольку сервис создает (и удаляет) PID file в директории /var/run, принадлежащей root с правами rwxr-xr-x. Нормальной работе systemv это не помешает - init-скрипты запускаются с правами root. Перед status sudo не нужно, в демонстрации присутствует только из-за того, что я не набирал команду с нуля, а правил последнюю.

Вызывать скрипт приходится через полное имя, потому что service работает с systemd не так, как с systemv.

Пробовал создавать симлинк в rc3.d - telinit уровнем выше и назад к запуску не приводит. После ребута подхватывается systemd и дальше работает как юнит systemd.

![init script demo](https://github.com/GiftWind/devopsschoolhomeworks/blob/master/linuxadm/hw4/initscriptdemo.jpg)

```
giftwind@markuslab01:~$ ll /opt/share
total 8
drwxr-xr-x 2 root root 4096 Jul 27 16:24 ./
drwxr-xr-x 3 root root 4096 Jul 26 13:47 ../
-rw-r--r-- 1 root root    0 Jul 27 16:24 file1
-rw-r--r-- 1 root root    0 Jul 27 16:24 file2
-rw-r--r-- 1 root root    0 Jul 27 16:24 file3
```
Браузер хостовой машины:
![file sharing demo](https://github.com/GiftWind/devopsschoolhomeworks/blob/master/linuxadm/hw4/sharingdemo.jpg)

#### Systemd unit

Создаем конфигурационный файл сервиса в директории /etc/systemd/system.

```
[Unit]
Description=Filesharing service
After=network.target

[Service]
Type=simple
WorkingDirectory=/opt/share
ExecStart=/usr/bin/python3 -m http.server 8080
ExecStop=/bin/kill -15 $MAINPID
Restart=Always

[Install]
WantedBy=multi-user.target
```
1. Type=simple - процесс не будет форкаться.
2. After=network.target - требует запуск основной сетевой службы.
3. ExecStop=/bin/kill -15 $MAINPID - предпочтительный способ остановки.
4. WantedBy=multi-user.target примерно соответствует run level 3.

Демонстрация работы:
![systemd unit demo](https://github.com/GiftWind/devopsschoolhomeworks/blob/master/linuxadm/hw4/sysdunitdemo.jpg)

```
giftwind@markuslab01:~$ ll /opt/share
total 8
drwxr-xr-x 2 root root 4096 Jul 27 18:18 ./
drwxr-xr-x 3 root root 4096 Jul 26 13:47 ../
-rw-r--r-- 1 root root    0 Jul 27 18:18 file4
-rw-r--r-- 1 root root    0 Jul 27 18:18 file5
-rw-r--r-- 1 root root    0 Jul 27 18:18 file6
```
![systemd unit sharing demo](https://github.com/GiftWind/devopsschoolhomeworks/blob/master/linuxadm/hw4/sharingdemo-systemd.jpg)

