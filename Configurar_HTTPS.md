# Tarea 4) HTTPS

#### El siguiente paso de nuestro proyecto es configurar de forma adecuada el protocolo HTTPS en nuestro servidor nginx para nuestras dos aplicaciones web. Para ello vamos a emitir un certificado wildcard en la AC certbot Gonzalo Nazareno utilizando para la petición la utilidad "gestiona".

* Debes hacer una redirección para forzar el protocolo https

###### Los certificados SSL Wildcard protegen la dirección URL de tu sitio web, así como también un número ilimitado de sus subdominios.

##### Creacion del certificado

###### Para crear un certificado de Wildcard vamos a utilizar *openssl*

###### Instalamos el paquete *openssl*

~~~
sudo dnf install openssl
sudo dnf install mod_ssl
~~~

###### Creamos la clave privada con el siguiente comando

~~~
sudo openssl genrsa -out amorales.gonzalonazareno.org.key 4096
   Generating RSA private key, 4096 bit long modulus (2 primes)
   ...............................................................................++++
   ............................................++++
   e is 65537 (0x010001)
~~~

###### Creamos un fichero de configuración, amorales.gonzalonazareno.org.conf, y le añadimos lo siguiente

~~~
[ req ]
default_bits       = 4096
default_keyfile    = amorales.gonzalonazareno.org.key
distinguished_name = req_distinguished_name

[ req_distinguished_name ]
countryName                 = Country Name (2 letter code)
countryName_default         = SP
stateOrProvinceName         = State or Province Name (full name)
stateOrProvinceName_default = Seville
localityName                = Locality Name (eg, city)
localityName_default        = Dos Hermanas
organizationName            = Organization Name (eg, company)
organizationName_default    = amorales
commonName                  = Common Name (e.g. server FQDN or YOUR name)
commonName_max              = 64
commonName_default          = *.amorales.gonzalonazareno.org
~~~

###### Creamos el certificado para nuestras páginas

~~~
sudo openssl req -new -nodes -sha256 -config amorales.gonzalonazareno.org.conf -out amorales.gonzalonazareno.org.csr
   Generating a RSA private key
   .......................................................................................   ............++++
   .......................................................................................   ........................................++++
   writing new private key to 'amorales.gonzalonazareno.org.key'
   -----
   You are about to be asked to enter information that will be incorporated
   into your certificate request.
   What you are about to enter is what is called a Distinguished Name or a DN.
   There are quite a few fields but you can leave some blank
   For some fields there will be a default value,
   If you enter '.', the field will be left blank.
   -----
   Country Name (2 letter code) [SP]:
   State or Province Name (full name) [Seville]:
   Locality Name (eg, city) [Dos Hermanas]:
   Organization Name (eg, company) [amorales]:
   Common Name (e.g. server FQDN or YOUR name) [*.amorales.gonzalonazareno.org]:
~~~

###### Comprobamos que se a generado bien

~~~
openssl req -in amorales.gonzalonazareno.org.csr -noout -text
   Certificate Request:
    Data:
        Version: 1 (0x0)
        Subject: C = SP, ST = Seville, L = Dos Hermanas, O = amorales, CN = *.amorales.gonzalonazareno.org
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (4096 bit)
                Modulus:
                    00:cc:f5:f5:ca:14:fd:ef:bf:33:43:18:78:16:47:
                    cf:8a:5e:ed:85:b1:e6:0d:2a:fd:9b:5a:b8:01:c4:
                    5d:30:02:c2:4e:56:8d:f8:c6:af:55:a5:24:51:ab:
                    45:d9:83:5d:f8:01:f4:bf:c7:0c:d7:8b:9c:3b:3b:
                    53:ad:7a:8d:f1:e9:56:6b:cf:31:a4:7c:e1:77:9a:
                    20:c9:56:16:e2:81:7c:39:d7:9f:9e:c7:a8:9c:35:
                    b4:db:8b:e5:d7:38:7a:39:8c:3e:72:67:6c:16:8d:
                    11:f0:60:e8:61:07:be:a6:7e:df:bd:09:58:02:10:
                    0b:b9:60:ba:b7:40:26:50:09:7f:5d:df:99:d2:f3:
                    3f:98:c2:05:eb:4c:3e:a8:0c:ed:af:42:8a:ce:38:
                    c4:7d:3e:4a:7d:77:01:ed:0f:8b:f6:8d:e6:a6:7b:
                    8b:e5:6a:92:fa:4e:b2:97:ce:7a:bb:9c:dc:2a:10:
                    fa:e8:84:5d:a9:89:82:b5:8e:0c:98:31:5a:54:20:
                    66:79:f9:ef:6a:1d:bc:d4:79:7d:a7:08:7c:db:8b:
                    cd:f4:8b:7d:ac:3e:3c:d0:d1:fa:12:9c:a3:0d:2c:
                    21:e1:c8:d3:eb:2d:df:66:91:05:2f:a9:04:d6:cb:
                    90:12:df:df:52:cd:34:b1:2f:ef:bd:36:d1:ce:09:
                    d4:74:48:e7:d6:10:7d:c5:7d:ae:c9:50:88:2b:48:
                    87:41:84:e0:a1:ab:91:de:63:5b:cf:a7:52:fe:54:
                    18:e7:5f:81:fe:54:e3:d9:eb:60:79:c4:ea:74:3f:
                    b9:5a:82:a1:07:df:1c:1f:e1:9a:84:aa:fa:61:9e:
                    fa:54:bf:c3:4a:f4:83:cc:fd:57:42:2f:4c:c5:e0:
                    fb:6a:07:a5:3a:f1:5c:59:41:2d:dd:ce:ae:d2:5a:
                    21:b5:81:e8:e5:84:7f:48:2d:ba:de:01:47:62:76:
                    c7:2a:3f:95:19:fa:83:a3:a6:16:39:98:57:b0:68:
                    e6:9b:5f:7f:85:c2:21:12:ae:97:6f:a3:a9:4e:a5:
                    51:38:4c:de:1d:aa:d2:55:4d:55:1d:27:25:58:a4:
                    51:63:c9:56:ef:99:c1:92:1e:5c:e1:75:7e:a1:23:
                    4b:57:39:ba:d2:b2:27:c2:b3:32:02:2b:f2:a9:fb:
                    62:3b:cc:e2:a0:e0:cd:26:1f:7c:cb:9a:f0:bb:e9:
                    75:7f:5b:16:4b:82:75:03:5e:a7:7b:28:ec:b0:61:
                    8a:1b:e7:2b:13:7e:25:aa:7b:0e:cb:75:e9:b4:32:
                    9f:e2:9f:6d:db:b8:f1:e9:d1:5d:40:cc:dc:97:22:
                    dc:4b:f5:6a:21:35:ec:6a:2a:0f:d9:4a:00:26:9e:
                    0b:10:b7
                Exponent: 65537 (0x10001)
        Attributes:
            a0:00
    Signature Algorithm: sha256WithRSAEncryption
         b6:b2:ee:6a:69:03:e1:e1:95:51:2e:fd:24:ce:68:bd:86:c8:
         dc:8b:33:9c:7c:b2:4b:a6:59:50:23:c5:1d:dc:1c:33:a6:17:
         60:12:fb:33:49:cc:dc:e1:fb:42:e3:62:12:c6:7e:b2:f8:6e:
         70:9d:77:bc:76:96:04:3a:63:38:19:7b:3e:da:1b:e1:0b:f2:
         1b:cf:f4:78:15:2f:ce:1c:54:48:8c:a8:6e:d7:84:42:fe:2b:
         5e:80:97:da:47:be:0c:25:3a:b5:27:67:0e:e6:a5:d9:43:0f:
         cf:73:f3:84:4e:ae:0e:db:a9:04:6c:f5:a6:19:08:14:8d:b4:
         bd:d4:05:52:a2:dc:c7:8f:a5:2b:1c:33:28:03:71:13:cc:9b:
         c0:06:52:44:2d:d6:55:e1:64:58:66:5e:4e:e6:87:02:dc:3d:
         ab:12:f1:9d:bc:dd:53:c2:3f:a4:7e:94:30:f9:0e:bc:25:17:
         e6:11:77:75:c4:79:84:52:fa:48:b0:71:de:04:bc:32:c5:2e:
         6c:ca:07:d2:a3:aa:c6:ee:ec:f6:8a:22:f4:4b:91:a8:3f:1d:
         1e:30:a8:a7:92:c4:5d:c1:7c:53:98:f3:93:68:ee:5c:c0:8c:
         68:41:43:1c:ff:f6:ed:2a:2b:ac:71:28:bb:19:f7:b3:6d:c8:
         8c:42:d6:8c:b3:b6:a0:d5:c9:c5:70:a2:8f:31:ad:5b:f1:34:
         b7:2f:35:71:f5:db:6b:e9:f0:e8:31:e7:0e:e1:f3:f8:db:7a:
         04:f4:58:65:59:db:27:54:e1:64:49:b1:9e:f1:84:43:75:e1:
         aa:74:f2:b4:32:f6:58:9a:74:ae:e1:bb:71:0f:9b:ad:60:95:
         da:3b:2c:98:e4:b7:bd:49:13:92:72:ec:35:c2:83:44:f4:ac:
         0d:dc:b4:72:ec:16:3d:77:93:ee:88:e8:b1:5d:92:cb:a3:7c:
         76:94:26:0c:77:1a:44:c4:69:cf:5a:78:b1:82:4a:11:b8:59:
         8d:56:f9:70:8b:a6:11:4c:d1:11:92:8c:ce:5d:79:4f:bc:d3:
         38:6c:dd:30:af:14:0e:f4:2f:c1:16:6d:bd:bb:da:57:25:fc:
         07:ac:7d:57:47:37:2f:c1:ea:b6:10:56:98:d9:62:ec:14:88:
         f0:05:d4:e6:f3:11:f8:7b:a6:84:86:55:e7:d7:4c:ff:1a:59:
         6c:73:8b:55:5a:29:94:7f:d4:ef:15:98:9b:9f:32:3b:d5:79:
         84:c6:75:e1:7a:85:a1:c9:f8:9c:7c:69:b2:91:52:a2:23:4d:
         25:29:50:a6:01:68:f5:2a:87:a9:57:a3:a3:fb:17:27:f6:e5:
         26:31:2e:35:d9:2c:08:11
~~~

###### Ahora tenemos que enviar el certificado a la autoridad certificadora de Gonzalonazareno para que nos la firme.

