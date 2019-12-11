0º Intalar y configurar le proftpd
   Instalar y configurar el phpmyadmin
   Crear paginas con los nombre ftp y sql

1º Crear el usuario
        En sistema o LDAP

2º Crear un virtualhosts en el servidor web
        Hacemos concidir el DocumentRoot con el DefaultRoot del FTP

3º Añadir el CNAME en el Servidor DNS con el nombre del virtualhosts

4º Crear el usuario de la Base de Datos y la Base de Datos

5º MEJORA 1. 
        Utilizar usuarios en LDAP
        Configurarlo en el fichero proladapd.conf

6º MEJORA 2.
        Añadir: añadir usuario en la base de datos, añadir base de datos, añadir CNAME en DNS, crear nuevo virtualhosting, crear usuario en LDAP, 

7º Te tiene que dar el usuario y contraseña del usuario ftp y el del mysql en el script.


# Hosting, FTP y Automatización

#### Queremos que diferentes usuarios, puedan gestionar una página web en vuestro servidor que esté gestionada por medio de un FTP. También se creará una base de datos para cada usuario.

###### Antes de empezar tendremos que instalar y configurar el servidor de FTP en la máquina salmorejo con Centos 8

###### Tenemos que tenerel repositorio de EPEL 7 para poder instalar todas las dependencias correctamente. Aquí dejo como instalarlo en el caso de no tenerlo:

~~~
sudp wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
ls * .rpm
sudo dnf install epel-release-latest-7.noarch.rpm -y
~~~

###### Ahora vamos a descargar los paquetes necesarios para proftpd

~~~
wget http://mirror.centos.org/centos/7/os/x86_64/Packages/GeoIP-1.5.0-14.el7.x86_64.rpm
sudo dnf install GeoIP-1.5.0-14.el7.x86_64.rpm
~~~

###### Instalar el paquete 'tcp_wrappers-libs' que es necesario

~~~
wget http://mirror.centos.org/centos/7/os/x86_64/Packages/tcp_wrappers-7.6-77.el7.x86_64.rpm
sudo dnf install tcp_wrappers-7.6-77.el7.x86_64.rpm
~~~

###### Ahora ya podemos instalar proftpd:

~~~
sudo dnf install proftpd -y
~~~

###### Vamos a habilitar los puertos de FTP en el firewall

~~~
sudo firewall-cmd --add-service=ftp --permanent --zone=public
sudo firewall-cmd --reload
~~~

###### Tenemos que iniciar y activar en el arranque proftpd

~~~
sudo systemctl start proftpd
sudo systemctl enable proftpd
~~~

#### Por ejemplo, el usuario josedom quiere hacer una página cuyo nombre será servicios:

* La página que vamos a crear será accesible en https://servicios.tunombre.gonzalonazareno.org.

##### Creación del virtualhosts:

###### Vamos a crear una web con el nombre 'https://dir.amorales.gonzalonazareno.org'

###### Para esto tenemos que crear un virtualhosting 'dir-amorales.conf' nuevo y añadimos las siguientes lineas:

~~~
server {
    listen 80;
    server_name  dir.amorales.gonzalonazareno.org;
    rewrite ^ https://$server_name$request_uri permanent;
}

server {
    listen 443 ssl;
    server_name  dir.amorales.gonzalonazareno.org;
    ssl on;
    ssl_certificate /etc/pki/tls/certs/amorales.gonzalonazareno.org.crt;
    ssl_certificate_key /etc/pki/tls/private/gonzalonazareno.pem;

    # note that these lines are originally from the "location /" block
    root   /usr/share/nginx/html/user_amorales;
    index index.php index.html index.htm info.php;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_pass unix:/var/run/php-fpm/www.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
~~~

###### Creamos ahora el directorio en la direción '/usr/share/nginx/html/amorales' y añadimos un fichero 'info.php' para comprobar que todo funciona correctamente

~~~
sudo mkdir /usr/share/nginx/html/user_amorales
sudo chown -R nginx:nginx /usr/share/nginx/html/user_amorales/
sudo find /usr/share/nginx/html/user_amorales -type f -exec chmod 0644 {} \;
sudo find /usr/share/nginx/html/user_amorales -type d -exec chmod 0755 {} \;
sudo chcon -t httpd_sys_content_t /usr/share/nginx/html/user_amorales -R
~~~

###### Reiniciamos los servicios de nginx y php-fpm

~~~
sudo systemctl restart nginx
sudo systemctl restart php-fpm
~~~

* Se creará un usuario user_josedom, que tendrá una contraseña, para que accediendo a ftp.tunombre.gonzalonazareno.org, pueda gestionar los ficheros de su página web.

##### Creación del usuario:

###### Vamos a crear el usuario 'user_amorales', con la contraseña 'SUHGuh234' para que pueda gestionar los ficheros de su web

~~~
sudo useradd user_amorales
sudo passwd user_amorales
~~~

##### Configuraciṕon del servidor de FTP:

###### Ahora vamos a configurar proftpd en el fichero '/etc/proftpd.conf'

###### Modificamos la linea del 'DefaultRoot'

~~~
DefaultRoot                     /usr/share/nginx/html/%u
~~~

###### Reiniciamos el servicio de proftpd:

~~~
sudo systemctl restart proftpd
~~~

##### Comprobación de conexión:


~~~

~~~

* Se creará un usuario en la base de datos llamado myjosedom. Este usuario tendrá una contraseña distinta a la del usuario del servidor FTP.
* Se creará una bases de datos para el usuario anteriormente creado. Para que los usuarios gestionen su base de datos se puede instalar la aplicación phpmyadmin a la que se accederá con la URL https://sql.tunombre.gonzalonmazareno.org.

#### Tarea: Configura manualmente los distintos servicios para crear un nuevo usuario que gestione su propia página web y tenga una base de datos a su disposición. Instala un CMS.

#### Mejora 1: Modifica la configuración del sistema para que se usen usuarios virtuales para el acceso por FTP, cuya información este guardada en vuestro directorio ldap.

#### Mejora 2: Realiza un script que automatice la creación/borrado de nuevos usuarios en el hosting.