# Servidores en el cloud

#### Práctica de ASIR, para la creación de un entorno real de trabajo en el cloud (Openstack) con distintos servicios y servidores.

## Tarea 1) [Instalación de los servidores]()
#### Crear tres máquinas en el cloud con los siguientes nombres y sistemas operativos:

* Croqueta (Debian 10)
* Tortilla (Ubunut 18.04)
* Salmorejo (CentOs 7)

1. Croqueta y Tortilla usan un volumen como unidad de disco principal.
2. Se creará un usuario "profesor" con el que podrán acceder los profesores usando claves RSA.

## Tarea 2) [Instalación de un servidor Web (SERVICIOS)](https://github.com/MoralG/Servidores_CLOUD/blob/master/Instalacion_Servidor_Web.md#tarea-2-instalaci%C3%B3n-de-un-servidor-web-servicios)
#### Ante de realizar la instalación del servidor web vamos a configurar el nombre de nuestras máquinas, para ello:

1. Piensa en un nombre de dominio, que sera un subdominio de gonzalonazareno.org, y que contenga tu nombre, por ejemplo: josedom.gonzalonazareno.org.
2. Siguiendo con el ejemplo, los nombres de mis máquinas serán:

* croqueta.josedom.gonzalonazareno.org
* tortilla.josedom.gonzalonazareno.org
* salmorejo.josedom.gonzalonazareno.org

#### Comprueba que los servidores tienen configurados el nuevo nombre de dominio de forma adecuada después de volver a reiniciar el servidor (o tomar una nueva configuración DHCP). Para que el servidor tenga el FQDN debes tener configurado de forma correcta el parámetro domain en el fichero /etc/resolv.conf, además debemos evitar que este fichero se sobreescriba con los datos que manda el servidor DHCP de OpenStack. Quizás sea buena idea mirar la configuración de cloud-init. Documenta la configuración que has tenido que modificar y muestra el contenido del fichero /etc/resolv.conf y la salida del comando hostname -f después de un reinicio.

#### *Servidor Web*

#### En salmorejo (CentOs 7) vamos a instalar un servidor web nginx. Configura el servidor para que sea capaz de ejecutar código php (para ello vamos a usar un servidor de aplicaciones php-fpm). Entrega una captura de pantalla accediendo a www.tunombre.gonzalonazareno.org/info.php donde se vea la salida del fichero info.php.

#### Servidor de base de datos

#### En tortilla (Ubuntu) vamos a instalar un servidor de base de datos mariadb. Entrega una prueba de funcionamiento donde se vea como se realiza una conexión a la base de datos desde los otros dos equipos.

## Tarea 3) [Instalación aplicaciones web (APLICACIONES WEB)]()

#### Vamos a instalar dos aplicaciones web php en nuestros servidores:

* En www.tunombre.gonzalonazareno.org vamos a instalar WordPress. En WordPress debemos configurar de forma correcta las URL limpias.
* En cloud.tunombre.gonzalonazareno.org vamos a instalar NextCloud.

#### Modifica las aplicaciones web y personalizalas para que se demuestre que son tus aplicaciones. Entrega una breve descripción de los pasos dados para conseguir la instalación de las aplicaciones web. Usando resolución estática entrega algunas capturas donde se demuestre que las aplicaciones están funcionando.

## Tarea 4) [HTTPS (Seguridad)](https://github.com/MoralG/Servidores_CLOUD/blob/master/Configurar_HTTPS.md#tarea-4-https)

#### El siguiente paso de nuestro proyecto es configurar de forma adecuada el protocolo HTTPS en nuestro servidor nginx para nuestras dos aplicaciones web. Para ello vamos a emitir un certificado wildcard en la AC Gonzalo Nazareno utilizando para la petición la utilidad "gestiona".

* Debes hacer una redirección para forzar el protocolo https.

## Tarea 5) [Actualización de CentOS 7 a CentOS 8](https://github.com/MoralG/Servidores_CLOUD/blob/master/Actualizacion_CentOS8.md#actualizaci%C3%B3n-de-centos-7-a-centos-8)

#### Para realizar la actualización correctamente tenemos que:

* Instalar el paquete _dnf_ y desinstalar _yum_
* Cambiar e instalar nuevos repositorios
* Actualizar el Kernel

## Tarea 6) [Servidor DNS (SERVICIOS)](https://github.com/MoralG/Servidores_CLOUD/blob/master/Servidor_DNS_CLOUD.md#tarea-6-servidor-dns) 

#### Vamos a instalar un servidor dns que nos permita gestionar la resolución directa e inversa de nuestros nombres. Cada alumno va a poseer un servidor dns con autoridad sobre un subdominio de nuestro dominio principal gonzalonazareno.org, que se llamará tu_nombre.gonzalonazareno.org.

#### El servidor DNS se va a instalar en el servidor1 (croqueta). Y en un primer momento se configurará de la siguiente manera:

* El servidor DNS se llama croqueta.tu_nombre.gonzalonazareno.org y va a ser el servidor con autoridad para la zona tu_nombre.gonzalonazareno.org.
* El servidor debe resolver el nombre de los tres servidores.
* El servidor debe resolver los distintos servicios (virtualhost y servidor de base de datos).
* Debes determinar si la resolución directa se hace con dirección ip fijas o flotantes del cloud depediendo del servicio que se este prestando.
* Debes considerar la posibilidad de hacer dos zonas de resolución inversa para resolver ip fijas o flotantes del cloud.

#### Entrega el resultado de las siguientes consultas a los servidores de nuestra red :

* El servidor DNS con autoridad sobre la zona del dominio tu_nombre.gonzalonazareno.org
* La dirección IP de algún servidor
* Una resolución de un nombre de un servicio
* Un resolución inversa de IP fija, y otra resolución inversa de IP flotante. (Esta consulta la debes hacer directamente preguntando a tu servidor).

## Tarea 7) [Hosting (SERVICIOS)](https://github.com/MoralG/Servidores_CLOUD/blob/master/Hosting_FTP_y_Automatizacion.md#hosting-ftp-y-automatizaci%C3%B3n)

#### Queremos que diferentes usuarios, puedan gestionar una página web en vuestro servidor que esté gestionada por medio de un FTP. También se creará una base de datos para cada usuario.

#### Por ejemplo, el usuario josedom quiere hacer una página cuyo nombre será servicios:

* La página que vamos a crear será accesible en https://servicios.tunombre.gonzalonazareno.org.
* Se creará un usuario user_josedom, que tendrá una contraseña, para que accediendo a ftp.tunombre.gonzalonazareno.org, pueda gestionar los ficheros de su página web.
* Se creará un usuario en la base de datos llamado myjosedom. Este usuario tendrá una contraseña distinta a la del usuario del servidor FTP.
* Se creará una bases de datos para el usuario anteriormente creado. Para que los usuarios gestionen su base de datos se puede instalar la aplicación phpmyadmin a la que se accederá con la URL https://sql.tunombre.gonzalonmazareno.org.

#### Tarea: Configura manualmente los distintos servicios para crear un nuevo usuario que gestione su propia página web y tenga una base de datos a su disposición. Instala un CMS.

#### Mejora 1: Modifica la configuración del sistema para que se usen usuarios virtuales para el acceso por FTP, cuya información este guardada en vuestro directorio ldap.

#### Mejora 2: Realiza un script que automatice la creación/borrado de nuevos usuarios en el hosting.

## Tarea 8) [Instalación de aplicación python (APLICACIONES WEBS)]()

#### En esta tarea vamos a desplegar un CMS python . Hemos elegido Mezzanine, pero puedes elegir otro CMS python basado en django.

* Instala el CMS en el entorno de desarrollo. Debes utilizar un entorno virtual.
* Personaliza la página y añade contenido (algún artículo con alguna imagen).
* Guarda los ficheros generados durante la instalación en un repositorio github. * Guarda también en ese repositorio la copia de seguridad de la bese de datos.
* Realiza el despliegue de la aplicación en tu entorno de producción (servidor web y servidor de base de datos en el cloud). Utiliza un entorno de producción. Como servidor de aplicación puedes usar gunicorn o uwsgi (crea una unidad systemd para gestionar este servicio). La aplicación será accesible en la url python.tunombre.gonzalonazareno.org.
