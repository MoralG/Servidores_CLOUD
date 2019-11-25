# Servidores en el cloud

#### Práctica de ASIR, para la creación de un entorno real de trabajo en el cloud (Openstack) con distintos servicios y servidores.

### Tarea 1) Instalación de los servidores
#### Crear tres máquinas en el cloud con los siguientes nombres y sistemas operativos:

* Croqueta (Debian 10)
* Tortilla (Ubunut 18.04)
* Salmorejo (CentOs 7)

1. Croqueta y Tortilla usan un volumen como unidad de disco principal.
2. Se creará un usuario "profesor" con el que podrán acceder los profesores usando claves RSA.

### Tarea 2) Instalación de un servidor Web (SERVICIOS)
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

### Tarea 3) Instalación aplicaciones web (APLICACIONES WEB)

#### Vamos a instalar dos aplicaciones web php en nuestros servidores:

* En www.tunombre.gonzalonazareno.org vamos a instalar WordPress. En WordPress debemos configurar de forma correcta las URL limpias.
* En cloud.tunombre.gonzalonazareno.org vamos a instalar NextCloud.

#### Modifica las aplicaciones web y personalizalas para que se demuestre que son tus aplicaciones. Entrega una breve descripción de los pasos dados para conseguir la instalación de las aplicaciones web. Usando resolución estática entrega algunas capturas donde se demuestre que las aplicaciones están funcionando.

### Tarea 4) HTTPS (Seguridad)

#### El siguiente paso de nuestro proyecto es configurar de forma adecuada el protocolo HTTPS en nuestro servidor nginx para nuestras dos aplicaciones web. Para ello vamos a emitir un certificado wildcard en la AC Gonzalo Nazareno utilizando para la petición la utilidad "gestiona".

* Debes hacer una redirección para forzar el protocolo https.

### Tarea 6) Servidor DNS (SERVICIOS)

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

