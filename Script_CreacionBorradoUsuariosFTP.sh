#! /bin/bash

#---------------------------------------------------------------------------#
#------------------------------- Funciones ---------------------------------#
#---------------------------------------------------------------------------#

function f_Menu {
    echo ""
    echo ""
    echo ""
    echo "------------------ MENU -------------------"
    echo "   (1) Añadir usuario                      "
    echo "   (2) Borrar usuario                      "
    echo "   (0) Salir                               "
    echo "-------------------------------------------"
    echo ""
    echo "¿Que opción quiere?"
    read -p "--->  " OPCION

    while [ $OPCION -lt 0 -o $OPCION -gt 2 ]
    do
        clear
        echo ""
        echo ""
        echo ""
        echo "--------ERROR--------"
        echo "   Opción no valida  "
        echo "---------------------"
        echo ""
        echo ""
        echo ""
        echo "------------------ MENU -------------------"
        echo "   (1) Añadir usuario                      "
        echo "   (2) Borrar usuario                      "
        echo "   (0) Salir                               "
        echo "-------------------------------------------"
        echo ""
        echo "¿Que opción quiere?"
        read -p "--->  " OPCION
        echo ""
    done
    
    return $OPCION
}

#---------------------------------------------------------------------------#
# Función de confirmación para realizar la creación y el borrado de los datos
#---------------------------------------------------------------------------#

function f_Confirmacion {
    echo ""
    echo "¿Estas seguro que quieres continuar? (Y/N)"
    read -p "--->   " CONFIRMACION
    echo ""
    while [ "$CONFIRMACION" != "Y" -a "$CONFIRMACION" != "y" -a "$CONFIRMACION" != "n" -a "$CONFIRMACION" != "N" ]
    do
        echo ""
        echo "-----------ERROR-----------"
        echo "   Confirmacion no valida  "
        echo "      Pruebe de nuevo      "
        echo "---------------------------"
        echo ""
        echo "¿Estas seguro que quieres continuar? (Y/N)"
        read -p "--->   " CONFIRMACION
        echo ""
    done
    if [ "$CONFIRMACION" == "Y" -o "$CONFIRMACION" == "y" ]
    then 
        CONFIRMACION=1
    else
        clear
        CONFIRMACION=0
    fi
    return $CONFIRMACION
}

#---------------------------------------------------------------------------#
# Función que pregunta las variables por teclado dependiendo de la opción
#---------------------------------------------------------------------------#

function f_Preguntar {
    clear
    if [ $1 -eq 1 ]
    then
        echo "¿Como se llama el usuario que quieres crear?"
        read -p "--->  " USUARIO

        echo "¿Como se llama el sitio web que quieres crear?"
        read -p "--->  " SITIOWEB
    fi
    if [ $1 -eq 2 ]
    then
        echo "Usuario que puedes borrar"
        echo "-----------------------------------------------------------------"
        echo " "
        MOSTRAR_USUARIOS=$(cut -d: -f1 /etc/passwd | egrep "^user_" | cut -d "_" -f2)
        echo "$MOSTRAR_USUARIOS" 
        echo " "
        echo "-----------------------------------------------------------------"
        echo " "
        echo "¿Como se llama el usuario que quieres borrar?"
        read -p "--->  " USUARIO
        return
    fi
}

#---------------------------------------------------------------------------#
# Función para rellenar las variables comunes dependiendo de la opción
#---------------------------------------------------------------------------#

function f_RellenarVariables {
    if [ $1 -eq 2 ]
    then
        SITIOWEB=$(sed -n 3p /etc/nginx/conf.d/user_$USUARIO.conf | cut -d " " -f7 | cut -d "." -f1)
    fi
    USER_FTP="user_$USUARIO"
    PASS_FTP=$(openssl rand -base64 5)
    USER_MYSQL="my_$USUARIO"
    DB_MYSQL="db_$USUARIO"
    PASS_MYSQL=$(openssl rand -base64 5)
    WEB="$SITIOWEB.amorales.gonzalonazareno.org"
    return
}

#---------------------------------------------------------------------------#
# Función de comprobacion de usuarios
#---------------------------------------------------------------------------#

function f_ComprobarUsuario {
    PROBAR_USER=$(cut -d: -f1 /etc/passwd | grep "^user_$USUARIO$")
    return $PROBAR_USER
}

#---------------------------------------------------------------------------#
# Función que muestra los datos que se van a crear o borrar antes de confirmar
#---------------------------------------------------------------------------#

function f_ExponerVariables {
    clear
    if [ $1 -eq 1 ]
    then
        echo " "
        echo "----------------------------------"
        echo "Se creará lo siguiente:"
        echo "----------------------------------"
        echo " "
        echo "  Usuario FTP: $USER_FTP"
        echo "Usuario MySQL: $USER_MYSQL"
        echo "Base de datos: $DB_MYSQL"
        echo "    Sitio Web: $WEB"
        echo " "
    fi
    if [ $1 -eq 2 ]
    then
        echo " "
        echo "----------------------------------"
        echo "Se borrará lo siguiente:"
        echo "----------------------------------"
        echo " "
        echo "  Usuario FTP: $USER_FTP"
        echo "Usuario MySQL: $USER_MYSQL"
        echo "Base de datos: $DB_MYSQL"
        echo "    Sitio Web: $WEB"
        echo " "
    fi
}

#---------------------------------------------------------------------------#
# Función para mostrar los datos finales de cada opción
#---------------------------------------------------------------------------#

function f_MostrarDatos {
    clear
    if [ $1 -eq 1 ]
    then
        echo "--------------------------------------------------------"
        echo "	             INFORMACIÓN DEL USUARIO"
        echo "--------------------------------------------------------"
        echo "                Usuario FTP: $USER_FTP"
        echo "             Contraseña FTP: $PASS_FTP"
        echo "              Usuario MySQL: $USER_MYSQL"
        echo "           Contraseña MySQL: $PASS_MYSQL"
        echo " Nombre de la Base de Datos: $DB_MYSQL"
        echo "                 Página Web: $WEB"
        echo "--------------------------------------------------------"
    fi
    if [ $1 -eq 2 ]
    then
        echo "----------------------------------------------------------------"
        echo "             SCRIPT FINALIZÓ CORRECTAMENTE                      "
        echo "Se ha eliminado todo lo relacionado con el usuario $USER_FTP    "
        echo "----------------------------------------------------------------"
    fi
}

#---------------------------------------------------------------------------#
# Función para crear el fichero del VirtualHosting del usuario.
#---------------------------------------------------------------------------#

function f_CrearVirtualHosting {
    echo 'server {
    listen	 80;
    server_name  '$WEB';
    rewrite ^ https://$server_name$request_uri permanent;
}

server {
    listen       443;
    server_name  '$WEB';
    ssl_certificate /etc/pki/tls/certs/amorales.gonzalonazareno.org.crt;
    ssl_certificate_key /etc/pki/tls/private/gonzalonazareno.pem;

    root   /usr/share/nginx/html/'$USER_FTP';
    index index.php index.html index.htm info.php;

    location / {
        try_files $uri $uri/ /index.php?$args;
	autoindex on;
	disable_symlinks if_not_owner;
    }

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_pass unix:/var/run/php-fpm/www.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}' | sudo tee /etc/nginx/conf.d/$USER_FTP.conf &> /dev/null
}

#---------------------------------------------------------------------------#
#------------------------------- Programa ----------------------------------#
#---------------------------------------------------------------------------#

clear
f_Menu

while [ $OPCION -ne 0 ]
do
    if [ $OPCION -eq 1 ]
    then
        f_Preguntar $OPCION
        f_RellenarVariables $OPCION
        f_ComprobarUsuario 
        echo $PROBAR_USER
        echo $USER_FTP
        if [ -z $PROBAR_USER ]
        then
            f_ExponerVariables $OPCION
            f_Confirmacion
            if [ $CONFIRMACION -eq 1 ]
            then
#Creamos el usuario del sistema y le asignamos una contraseña aleatoria.
                sudo useradd -M $USER_FTP
                echo $PASS_FTP | sudo passwd --stdin $USER_FTP
#Creamos el DocumentRoot y le asignamos el propietario y la regla de SELinux.
                sudo mkdir /usr/share/nginx/html/$USER_FTP 
                sudo chown -R $USER_FTP:$USER_FTP /usr/share/nginx/html/$USER_FTP
                sudo chcon -t httpd_sys_content_t /usr/share/nginx/html/$USER_FTP -R            
#Creamos el fichero '.conf'.
                f_CrearVirtualHosting
#Reiniciamos los servicios.
                sudo systemctl restart nginx
                sudo systemctl restart php-fpm
#Creamos el comando para crear el usuario y la base de datos y lo mandamos por ssh.
                CREAR_USUARIO_MYSQL='sudo mysql -e "CREATE USER \"'$USER_MYSQL'\"@\"%\" IDENTIFIED BY \"'$PASS_MYSQL'\";"'
                ssh ubuntu@tortilla $CREAR_USUARIO_MYSQL
                CREAR_BD_MYSQL='sudo mysql -e "CREATE DATABASE '$DB_MYSQL';"'
                ssh ubuntu@tortilla $CREAR_BD_MYSQL
                ASIGNAR_PRIVILEGIO='sudo mysql -e "GRANT ALL PRIVILEGES ON '$DB_MYSQL'.* TO \"'$USER_MYSQL'\"@\"%\""'
                ssh ubuntu@tortilla $ASIGNAR_PRIVILEGIO
#Creamos el comando para añadir el registro al DNS y lo mandamos por ssh.
                INSERTAR_REGISTRO_DNS="sudo sed -i '\$a $SITIOWEB IN CNAME salmorejo' /var/cache/bind/db.amorales.gonzalonazareno.org"
                ssh debian@croqueta $INSERTAR_REGISTRO_DNS 
                ssh debian@croqueta 'sudo rndc reload' 
#Mostramos los datos finales.
                f_MostrarDatos $OPCION
            fi    
        fi
    fi

    if [ $OPCION -eq 2 ]
    then
        f_Preguntar $OPCION
        f_RellenarVariables $OPCION
        f_ComprobarUsuario
        if [ $USER_FTP = $PROBAR_USER ]
        then
            f_ExponerVariables $OPCION
            f_Confirmacion
            if [ $CONFIRMACION -eq 1 ]
            then
#Eliminamos el fichero '.conf' y el directorio DocumentRoot del usuario.
                sudo rm -rf /usr/share/nginx/html/$USER_FTP
                sudo rm -rf /etc/nginx/conf.d/$USER_FTP.conf
#Eliminamos el usuario del sistema.
                sudo userdel $USER_FTP
#Creamos el comando para eliminar el usuario y la base de datos y lo enviamos por ssh.
                BORRAR_USUARIO='sudo mysql -e "DROP USER '$USER_MYSQL';"'
                ssh ubuntu@tortilla $BORRAR_USUARIO
                BORRAR_BD='sudo mysql -e "DROP DATABASE '$DB_MYSQL';"'
                ssh ubuntu@tortilla $BORRAR_BD
#Creamos el comando para eliminar el registro del DNS y lo enviamos por ssh.
                BORRAR_REGISTRO_DNS="sudo sed -i '/$SITIOWEB IN CNAME salmorejo/d' /var/cache/bind/db.amorales.gonzalonazareno.org"
                ssh debian@croqueta $BORRAR_REGISTRO_DNS
                ssh debian@croqueta 'sudo rndc reload' 
#Mostramos los datos finales.
                f_MostrarDatos $OPCION
            fi
        else
            echo ""
            echo "-------------ERROR-------------"
            echo "   Usuario $USUARIO no valido  "
            echo "-------------------------------"
            echo ""
        fi
    fi
    f_Menu
done

if [ $OPCION -eq 0 ]
then
    echo ""
    echo ""
    echo ""
    echo "-----------------------------"
    echo " ADIOS, que pase un buen dia "
    echo "-----------------------------"
    echo ""
    echo ""
    echo ""
fi