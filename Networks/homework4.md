### Homework 4
#### Задание 1: Отправить GET запрос удаленному серверу.
Для отправки запроса выбран сервер neverssl.com, поскольку он не поддерживает ssl, и запросы к нему можно делать с помощью telnet, а не openssl.
```
giftwind@markuslab01:~/devops/devopsschoolhomeworks/Networks/http$ telnet neverssl.com 80
Trying 65.9.47.189...
Connected to neverssl.com.
Escape character is '^]'.
GET / HTTP/1.1
Host: neverssl.com

HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 2536
Connection: keep-alive
Last-Modified: Thu, 19 Nov 2020 22:29:21 GMT
Accept-Ranges: bytes
Server: AmazonS3
Date: Fri, 09 Jul 2021 22:36:39 GMT
ETag: "e8bb9152091d61caa9d69fed8c4aebc6"
Vary: Accept-Encoding
X-Cache: Hit from cloudfront
Via: 1.1 2fe761c42f710dbc97bfbe41f450bf42.cloudfront.net (CloudFront)
X-Amz-Cf-Pop: ARN54-C1
X-Amz-Cf-Id: Zn-SQ49DzXELFgf_ZCbBlb4wEXr0fNlPp1gTcOU-7Juir5b24upzkQ==
Age: 66387

<html>
    <head>
        <title>NeverSSL - helping you get online</title>

        <style>
        body {
             font-family: Montserrat, helvetica, arial, sans-serif;
             font-size: 16x;
             color: #444444;
             margin: 0;
        }
        h2 {
            font-weight: 700;
            font-size: 1.6em;
            margin-top: 30px;
        }
        p {
            line-height: 1.6em;
        }
        .container {
            max-width: 650px;
            margin: 20px auto 20px auto;
            padding-left: 15px;
            padding-right: 15px
        }
        .header {
            background-color: #42C0FD;
            color: #FFFFFF;
            padding: 10px 0 10px 0;
            font-size: 2.2em;
        }
        <!-- CSS from Mark Webster https://gist.github.com/markcwebster/9bdf30655cdd5279bad13993ac87c85d -->
        </style>
    </head>
    <body>

    <div class="header">
        <div class="container">
        <h1>NeverSSL</h1>
        </div>
    </div>

    <div class="content">
    <div class="container">

    <h2>What?</h2>
    <p>This website is for when you try to open Facebook, Google, Amazon, etc
    on a wifi network, and nothing happens. Type "http://neverssl.com"
    into your browser's url bar, and you'll be able to log on.</p>

    <h2>How?</h2>
    <p>neverssl.com will never use SSL (also known as TLS). No
    encryption, no strong authentication, no <a
    href="https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security">HSTS</a>,
    no HTTP/2.0, just plain old unencrypted HTTP and forever stuck in the dark
    ages of internet security.</p>

    <h2>Why?</h2>
    <p>Normally, that's a bad idea. You should always use SSL and secure
    encryption when possible. In fact, it's such a bad idea that most websites
    are now using https by default.</p>

    <p>And that's great, but it also means that if you're relying on
    poorly-behaved wifi networks, it can be hard to get online.  Secure
    browsers and websites using https make it impossible for those wifi
    networks to send you to a login or payment page. Basically, those networks
    can't tap into your connection just like attackers can't. Modern browsers
    are so good that they can remember when a website supports encryption and
    even if you type in the website name, they'll use https.</p>

    <p>And if the network never redirects you to this page, well as you can
    see, you're not missing much.</p>

    </div>
    </div>

    </body>
</html>
```
#### Задание 2: Отправить POST запрос удаленному серверу.
Для отправки запроса выбран сервер http://ptsv2.com, созданный специально для тестирования POST запросов. SSL не поддерживает, поэтому можно использовать обычный Telnet. Тело запроса - JSON вида ```{"test": true}```

```
giftwind@Mark:/mnt/c/Users/Mark$ telnet ptsv2.com 80
Trying 216.239.38.21...
Connected to ptsv2.com.
Escape character is '^]'.
POST /t/gxnyo-1625866690/post HTTP/1.1
Host: ptsv2.com
Connection: close
Content-type: application/json
Content-length: 14

{"test": true}
HTTP/1.1 200 OK
Content-Type: text/plain; charset=utf-8
Vary: Accept-Encoding
Access-Control-Allow-Origin: *
X-Cloud-Trace-Context: e556a1df704fe923a73ba861ab725080
Date: Fri, 09 Jul 2021 22:08:59 GMT
Server: Google Frontend
Content-Length: 54
Connection: close

Thank you for this dump. I hope you have a lovely day!Connection closed by foreign host.
```

