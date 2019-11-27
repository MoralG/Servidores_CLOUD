# Tarea 6. Servidor DNS

#### Vamos a instalar un servidor dns que nos permita gestionar la resolución directa e inversa de nuestros nombres. Cada alumno va a poseer un servidor dns con autoridad sobre un subdominio de nuestro dominio principal gonzalonazareno.org, que se llamará tu_nombre.gonzalonazareno.org.

#### El servidor DNS se va a instalar en el servidor1 (croqueta). Y en un primer momento se configurará de la siguiente manera

* El servidor DNS se llama croqueta.tu_nombre.gonzalonazareno.org y va a ser el servidor con autoridad para la zona tu_nombre.gonzalonazareno.org.
* El servidor debe resolver el nombre de los tres servidores.
* El servidor debe resolver los distintos servicios (virtualhost y servidor de base de datos).
* Debes determinar si la resolución directa se hace con dirección ip fijas o flotantes del cloud depediendo del servicio que se este prestando.
* Debes considerar la posibilidad de hacer dos zonas de resolución inversa para resolver ip fijas o flotantes del cloud.

> **IP privada: 10.0.0.6**
> 
> **IP flotante: 172.22.200.125**

#### *Configuración del Servidor:*

###### Instalamos el paquete de *bind9*

~~~
sudo apt install bind9
~~~

###### Añadimos la siguiente linea al dichero */etc/bind/named.conf.options*

~~~
allow-query{172.22.0.0/16; 192.168.202.0/24;};
~~~

##### *Realizamos la resolución directa*

###### Modificamos el fichero */etc/bind/named.conf.local*

~~~
zone "amorales.gonzalonazareno.org"
{
  file "db.amorales.gonzalonazareno.org";
  type master;
};
~~~

###### Copiamos un fichero de configuración ya creado para la resolución directa

~~~
sudo cp /etc/bind/db.local /var/cache/bind/db.amorales.gonzalonazareno.org
~~~

###### Modificamos el fichero */var/cache/bind/db.amorales.gonzalonazareno.org*

~~~
$TTL    86400
@       IN      SOA     croqueta.amorales.gonzalonazareno.org.                  ale95mogra.amorales.gonzalonazareno.org. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                          86400 )       ; Negative Cache TTL

@               IN      NS      croqueta.amorales.gonzalonazareno.org.

$ORIGIN amorales.gonzalonazareno.org.
croqueta-int    IN      A       10.0.0.6
croqueta        IN      A       172.22.200.125
tortilla-int    IN      A       10.0.0.9
tortilla        IN      A       172.22.200.126
salmorejo-int   IN      A       10.0.0.19
salmorejo       IN      A       172.22.200.127

www             IN      CNAME   salmorejo
cloud           IN      CNAME   salmorejo
mysql           IN      CNAME   tortilla-int
~~~

##### *Realizamos la resolución inversa*

###### Copiamos un fichero de configuración ya creado para la resolución inversa interna y la inversa de la ip flotante

~~~
sudo cp /etc/bind/db.empty /var/cache/bind/db.0.0.10
sudo cp /etc/bind/db.empty /var/cache/bind/db.200.22.172
~~~

###### Añadimos en el fichero */etc/bind/named.conf.local*

~~~
zone "0.0.10.in-addr.arpa"
{
  file "db.0.0.10";
  type master;
};

zone "200.22.172.in-addr.arpa"
{
  file "db.22.172";
  type master;
};
~~~

###### Modificamos el fichero */var/cache/bind/db.0.0.10*

~~~
$TTL    86400
@       IN      SOA     croqueta.amorales.gonzalonazareno.org.                  ale95mogra.amorales.gonzalonazareno.org. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                          86400 )       ; Negative Cache TTL
;
@               IN      NS      amorales.gonzalonazareno.org.

$ORIGIN 0.0.10.in-addr.arpa.
6       IN      PTR     croqueta.amorales.gonzalonazareno.org.
9       IN      PTR     tortilla.amorales.gonzalonazareno.org.
19      IN      PTR     salmorejo.amorales.gonzalonazareno.org.
~~~

###### Modificamos el fichero */var/cache/bind/db.22.172*

~~~
$TTL    86400
@       IN      SOA     croqueta.amorales.gonzalonazareno.org.                  ale95mogra.amorales.gonzalonazareno.org. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                          86400 )       ; Negative Cache TTL
;
@               IN      NS      amorales.gonzalonazareno.org.

$ORIGIN 200.22.172.in-addr.arpa.
200.125       IN      PTR     croqueta.amorales.gonzalonazareno.org.
200.126       IN      PTR     tortilla.amorales.gonzalonazareno.org.
200.127       IN      PTR     salmorejo.amorales.gonzalonazareno.org.
~~~

###### Tenemos que reiniciar el bind

~~~
sudo rndc reload
~~~

###### Para que nos muestre los errores

~~~
sudo named-checkconf

sudo named-checkzone amorales.gonzalonazareno.org /var/cache/bind/db.amorales.gonzalonazareno.org
   zone amorales.gonzalonazareno.org/IN: loaded serial 1
   OK


sudo named-checkzone 0.0.10.in-addr.arpa /var/cache/bind/db.0.0.10
   zone 0.0.10.in-addr.arpa/IN: loaded serial 1
   OK


sudo named-checkzone 200.22.172.in-addr.arpa /var/cache/bind/db.22.172
   zone 22.172.in-addr.arpa/IN: loaded serial 1
   OK
~~~

#### Entrega el resultado de las siguientes consultas a los servidores de nuestra red

* El servidor DNS con autoridad sobre la zona del dominio tu_nombre.gonzalonazareno.org

~~~
dig ns amorales.gonzalonazareno.org

   ; <<>> DiG 9.11.5-P4-5.1-Debian <<>> ns amorales.gonzalonazareno.org
   ;; global options: +cmd
   ;; Got answer:
   ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 41577
   ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

   ;; OPT PSEUDOSECTION:
   ; EDNS: version: 0, flags:; udp: 4096
   ; COOKIE: 325bfa1977b543fa97f65f135ddb9913cba9aa87e01526d7 (good)
   ;; QUESTION SECTION:
   ;amorales.gonzalonazareno.org.	IN	NS

   ;; ANSWER SECTION:
   amorales.gonzalonazareno.org. 86346 IN	NS	croqueta.amorales.gonzalonazareno.org.
   
   ;; Query time: 1 msec
   ;; SERVER: 192.168.202.2#53(192.168.202.2)
   ;; WHEN: lun nov 25 10:04:19 CET 2019
   ;; MSG SIZE  rcvd: 108
~~~

* La dirección IP de algún servidor

~~~
dig tortilla.amorales.gonzalonazareno.org

   ; <<>> DiG 9.11.5-P4-5.1-Debian <<>> tortilla.amorales.gonzalonazareno.org
   ;; global options: +cmd
   ;; Got answer:
   ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 45917
   ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 1
   
   ;; OPT PSEUDOSECTION:
   ; EDNS: version: 0, flags:; udp: 4096
   ; COOKIE: 0640e311ad1e21b0ca5125d75ddb9a14446261eadf2a4aba (good)
   ;; QUESTION SECTION:
   ;tortilla.amorales.gonzalonazareno.org. IN A
   
   ;; ANSWER SECTION:
   tortilla.amorales.gonzalonazareno.org. 86400 IN	A 172.22.200.126
   
   ;; AUTHORITY SECTION:
   amorales.gonzalonazareno.org. 86089 IN	NS	croqueta.amorales.gonzalonazareno.org.
   
   ;; Query time: 5 msec
   ;; SERVER: 192.168.202.2#53(192.168.202.2)
   ;; WHEN: lun nov 25 10:08:36 CET 2019
   ;; MSG SIZE  rcvd: 133
~~~

* Una resolución de un nombre de un servicio

~~~
dig www.amorales.gonzalonazareno.org

   ; <<>> DiG 9.11.5-P4-5.1-Debian <<>> www.amorales.gonzalonazareno.org
   ;; global options: +cmd
   ;; Got answer:
   ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 2367
   ;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 1, ADDITIONAL: 1
   
   ;; OPT PSEUDOSECTION:
   ; EDNS: version: 0, flags:; udp: 4096
   ; COOKIE: 430b6e6cb4bfd147dad5467c5ddb99cc813dcc7b374cf420 (good)
   ;; QUESTION SECTION:
   ;www.amorales.gonzalonazareno.org. IN	A
   
   ;; ANSWER SECTION:
   www.amorales.gonzalonazareno.org. 86400	IN CNAME    salmorejo.amorales.gonzalonazareno.org.
   salmorejo.amorales.gonzalonazareno.org.	86400 IN A 172.22.200.127
   
   ;; AUTHORITY SECTION:
   amorales.gonzalonazareno.org. 86161 IN	NS	croqueta.amorales.gonzalonazareno.org.
   
   ;; Query time: 8 msec
   ;; SERVER: 192.168.202.2#53(192.168.202.2)
   ;; WHEN: lun nov 25 10:07:24 CET 2019
   ;; MSG SIZE  rcvd: 152
~~~

* Un resolución inversa de IP fija, y otra resolución inversa de IP flotante. (Esta consulta la debes hacer directamente preguntando a tu servidor)

~~~
dig @croqueta -x 172.22.200.126

   ; <<>> DiG 9.11.5-P4-5.1-Debian <<>> @croqueta -x 172.22.200.126
   ; (1 server found)
   ;; global options: +cmd
   ;; Got answer:
   ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 34381
   ;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2
   ;; WARNING: recursion requested but not available
   
   ;; OPT PSEUDOSECTION:
   ; EDNS: version: 0, flags:; udp: 4096
   ; COOKIE: 2945f45cc2d701f0cbea09795ddb9a4181fb38616ce851a0 (good)
   ;; QUESTION SECTION:
   ;126.200.22.172.in-addr.arpa.	IN	PTR
   
   ;; ANSWER SECTION:
   126.200.22.172.in-addr.arpa. 86400 IN	PTR	tortilla.amorales.gonzalonazareno.org.
   
   ;; AUTHORITY SECTION:
   200.22.172.in-addr.arpa. 86400	IN	NS	croqueta.amorales.gonzalonazareno.org.
   
   ;; ADDITIONAL SECTION:
   croqueta.amorales.gonzalonazareno.org. 86400 IN	A 172.22.200.125
   
   ;; Query time: 2 msec
   ;; SERVER: 172.22.200.125#53(172.22.200.125)
   ;; WHEN: lun nov 25 10:09:21 CET 2019
   ;; MSG SIZE  rcvd: 174
~~~

~~~
dig @croqueta -x 10.0.0.9

   ; <<>> DiG 9.11.5-P4-5.1-Debian <<>> @croqueta -x 10.0.0.9
   ; (1 server found)
   ;; global options: +cmd
   ;; Got answer:
   ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 10196
   ;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2
   ;; WARNING: recursion requested but not available
   
   ;; OPT PSEUDOSECTION:
   ; EDNS: version: 0, flags:; udp: 4096
   ; COOKIE: 5eb5eb0971fc3973fcdef1e65ddb9a3b6a9f6be6a123f10a (good)
   ;; QUESTION SECTION:
   ;9.0.0.10.in-addr.arpa.		IN	PTR
   
   ;; ANSWER SECTION:
   9.0.0.10.in-addr.arpa.	86400	IN	PTR	tortilla.amorales.gonzalonazareno.org.
   
   ;; AUTHORITY SECTION:
   0.0.10.in-addr.arpa.	86400	IN	NS	croqueta.amorales.gonzalonazareno.org.
   
   ;; ADDITIONAL SECTION:
   croqueta.amorales.gonzalonazareno.org. 86400 IN	A 172.22.200.125
   
   ;; Query time: 18 msec
   ;; SERVER: 172.22.200.125#53(172.22.200.125)
   ;; WHEN: lun nov 25 10:09:15 CET 2019
   ;; MSG SIZE  rcvd: 168
~~~