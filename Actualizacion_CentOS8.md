# Actualización de Centos 7 a Centos 8

#### **Tenga en cuenta que esta no es una actualización oficial, por lo que no es adecuada para un entorno de producción.

### Configuramos el sistema para prepararse para la actualización
----------------------------------------------------------------

###### Nos aseguramos y eliminamos el repositorio actual de EPEL si lo tenemos
~~~
sudo dnf remove epel-release
~~~

###### Descargamos e instalamos el repositorio EPEL:
~~~
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
~~~

###### Instalamos el paquete *yum-utils*
~~~
sudo yum -y install rpmconf yum-utils
~~~

###### Resolvemos los paquetes rmp (IMPORTANTE, pulsamos a todo *INTRO* para dejarlo por defecto):
~~~
sudo rpmconf -a
~~~

###### Limpiamos algunos paquetes que no necesitamos:
~~~
sudo package-cleanup --leaves
sudo package-cleanup --orphans
~~~

###### Instalamos el paquete de *dnf*, que va a sustituir a *yum*:
~~~
sudo yum -y install dnf
~~~

###### Eliminamos el administrador de paquetes *yum*:
~~~
sudo dnf -y remove yum yum-metadata-parser
sudo rm -Rf /etc/yum
~~~

###### Actualizamos el sistema utilizando el binario *dnf* para ver si funciona de forma correcta:
~~~
sudo sudo dnf -y upgrade
~~~

### Comenzamos la actualización hacia Centos 8
----------------------------------------------------------------


###### Instalamos la nueva version de centos:
~~~
sudo dnf -y upgrade http://mirror.bytemark.co.uk/centos/8/BaseOS/x86_64/os/Packages/centos-release-8.0-0.1905.0.9.el8.x86_64.rpm
~~~

###### Actualizamos el repositorio de EPEL:
~~~
sudo dnf -y upgrade https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
~~~

###### Eliminamos los ficheros temporales:
~~~
sudo dnf clean all
~~~

###### Eliminar los kernel anteriores
~~~
sudo rpm -e `rpm -q kernel`
~~~

###### Ejecutamos el siguiente comando para eliminar los conflictos:
~~~
sudo rpm -e --nodeps sysvinit-tools
~~~

###### Ahora vamos a realizar la actualización:
~~~
sudo dnf -y --releasever=8 --allowerasing --setopt=deltarpm=false distro-sync
~~~


### Importante. Antes de avanzar tenemos que solucionar los errores y conflictos que nos devuelve la actualización
----------------------------------------------------------------

###### Los errores siguientes pueden ser distintos en cada servidor, yo voy a mostrar los que me salieron a mi

###### Errores tras el upgrade
~~~
Total                                                                     16 MB/s | 219 MB     00:13
Ejecutando verificación de operación
Verificación de operación exitosa.
Ejecutando prueba de operaciones
Los paquetes descargados se han guardado en caché para la próxima transacción.
Puede borrar los paquetes de la caché ejecutando 'dnf clean packages'.
Error: Error en la verificación de operación:
  el archivo /usr/lib64/libgdbm_compat.so.4.0.0 de la instalación de gdbm-libs-1:1.18-1.el8.x86_64 entra en conflicto con el archivo del paquete gdbm-1.10-8.el7.x86_64
  el archivo /usr/lib64/libzip.so.5.0 de la instalación de libzip-1.5.1-1.module_el8.0.0+56+d1ca79aa.x86_64 entra en conflicto con el archivo del paquete libzip5-1.5.2-1.el7.remi.x86_64

Resumen de errores
~~~

###### Para solucionar el problema del error de la librería _libzip_ tenemos que borrarla y volver a actualizar
~~~
sudo dnf remove libzip
sudo dnf update
~~~

###### Para solucionar el problema del error de la librería _libgdbm_ tenemos que borrarla y volver a actualizar
~~~
sudo rpm --nodeps -e gdbm
sudo dnf -y upgrade --best --allowerasing
sudo dnf update
~~~

### Seguimos con la Actualización. Instalamos el nuevo kernel y confirmaciones
----------------------------------------------------------------

###### Realizamos la nueva configuración (igual que antes, todo *INTRO*)
~~~
sudo rpmconf -a
~~~

###### Instalamos el nuevo kernel:
~~~
sudo rpm -e kernel-core
sudo dnf -y install kernel-core
~~~

###### Confirmamos que el grup esta instalado:
~~~
ROOTDEV=`ls /dev/*da|head -1`;
sudo echo "Detected root as $ROOTDEV..."
sudo grub2-install $ROOTDEV
~~~

###### Instalamos el paquete *Minimal*
~~~
sudo dnf -y groupupdate "Core" "Minimal Install"
~~~

###### Podemos ver que version de Kernel tenemos:
~~~
cat /etc/centos-release
~~~


### Una vez finalizada la actualización, voy a mostrar los errores que he corregido para que todos los servicios del servidor funcionen correctamente
----------------------------------------------------------------
###### Instalamos el nuevo kernel si ha habido errores


###### Añadir en los fichero de virtualhost de *nextcloud.conf* y *wordpress.conf* la nueva ruta del socket

~~~
fastcgi_pass unix:/var/run/php-fpm/www.sock;
~~~

###### Si por algun error estan desinstalados los paquetes de nginx y php, tendremos que instalarlos de nuevo

###### Ahora modificamos algunas lineas del fichero /etc/php-fpm.d/www.conf (descomentamos las que esten comentadas)

~~~
listen = /var/run/php-fpm/php-fpm.sock
listen.owner = nginx
listen.group = nginx
user = nginx
group = nginx
~~~

###### reiniciamos los servicios y todo debería de funcionar

~~~
sudo systemctl restart nginx
sudo systemctl restart php-fpm
~~~