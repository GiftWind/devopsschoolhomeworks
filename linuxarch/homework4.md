#### Linux Architecture Homework 4
```
$ sudo echo “Secret Password” > /root/password.txt
permission denied
```

* Почему такое использование sudo не срабатывает?
Не срабатывает, потому что перенаправлением вывода отвечает командная оболочка непривилегированного пользователя. С привилегиями root запущена только команда echo.
* Как можно обойти?
Обойти можно несколькими способами, например запустить пайп в оболочке привилегированного пользователя. Несколько примеров (я использую перенаправление >> вместо > для сохранения результатов работы предыдущих команд):

```
giftwind@markuslab01:~$ sudo touch secretfile.txt
giftwind@markuslab01:~$ sudo echo "Secret Password" > secretfile.txt
-bash: secretfile.txt: Permission denied
giftwind@markuslab01:~$ sudo sh -c "echo 'Secret Password' >> secretfile.txt"
giftwind@markuslab01:~$ sudo bash -c "echo 'Secret Password 2' >> secretfile.txt"
giftwind@markuslab01:~$ sudo -i
root@markuslab01:~# echo "Secret Password 3" >> /home/giftwind/secretfile.txt
root@markuslab01:~# logout
giftwind@markuslab01:~$ sudo -s
root@markuslab01:/home/giftwind# echo "Secret Password 4" >> secretfile.txt
root@markuslab01:/home/giftwind# logout
bash: logout: not login shell: use `exit'
root@markuslab01:/home/giftwind# exit
```

Можно добавить строку с помощью sed или awk:

```
giftwind@markuslab01:~$ sudo sed -i "\$ a Secret Password 5" secretfile.txt
giftwind@markuslab01:~$ sudo awk 'BEGIN{ printf "Secret Password 6\n" >> "secretfile.txt" }'
```

* Как правильно собрать такой pipeline с sudo?
Выше приведены именно способы обхода, а не аккуратное решение. Мне кажется более правильным и лаконичным использовать для перенаправления вывода команду tee:

```
giftwind@markuslab01:~$ echo "Secret Password 7" | sudo tee -a secretfile.txt
```

Результат работы всех команд:
![Result secretfile.txt]()
