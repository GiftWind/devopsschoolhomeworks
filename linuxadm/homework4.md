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

Пробовал создавать симлинк в rc3.d - telinit уровнем выше и назад к запуску не приводит. При перезапуске подхватывается systemd и дальше работает как юнит systemd.

```
giftwind@markuslab01:/etc/init.d$ sudo ./filesharer start
Starting filesharer service on port 8080 sharing content of /opt/share
giftwind@markuslab01:/etc/init.d$ sudo ./filesharer status
Filesharer service is running with PID 1298
Sharing content of /opt/share on port 8080
giftwind@markuslab01:/etc/init.d$ sudo ./filesharer restart
Stopping filesharer
Filesharer stopped
Starting filesharer service on port 8080 sharing content of /opt/share
giftwind@markuslab01:/etc/init.d$ sudo ./filesharer status
Filesharer service is running with PID 1319
Sharing content of /opt/share on port 8080
giftwind@markuslab01:/etc/init.d$ sudo ./filesharer start
Service is already working
giftwind@markuslab01:/etc/init.d$ sudo ./filesharer stop
Stopping filesharer
Filesharer stopped
giftwind@markuslab01:/etc/init.d$ sudo ./filesharer stop
Filesharer is not running
```

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
1. After=network.target - требует запуск основной сетевой службы.
2. ExecStop=/bin/kill -15 $MAINPID - предпочтительный способ остановки.
3. WantedBy=multi-user.target примерно соответствует run level 3.




