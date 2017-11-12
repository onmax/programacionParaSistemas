# !/bin/bash

#Comprobamos que tiene solo un argumento
if [ $# -ne "1" ]; then
  echo "minientrega.sh: Error(EX_USAGE), uso incorrecto del mandato. \"Success\"" >&2
  echo "minientrega.sh: Debe ser invocado con un argumento que identifique la práctica." >&2
  exit 64
fi

#Mostrar ayuda
if [ $1 == "-h" ] || [ $1 == "--help" ]; then
  echo "minientrega.sh: Uso: minientrega.sh [-h | --help | ID_PRACTICA]"
  echo "minientrega.sh: realiza la entrega de la practica ID_PRACTICA"
  exit 0
fi


ERROR="minientrega.sh: Error, no se pudo realizar la entrega"

#Si no existe la variable donde se guarda el directorio entonces:
if test -z ${MINIENTREGA_CONF} ;then
  echo $ERROR 
  echo "minientrega.sh+ No es accesible el directorio \"${MINIENTREGA_CONF}\"" >&2
  exit 64
fi

#Si no es accesible el directorio:
if test ! -d ${MINIENTREGA_CONF} ;then
  echo $ERROR 
  echo "minientrega.sh+ No es accesible el directorio \"${MINIENTREGA_CONF}\"" >&2
  exit 64
else
  cd ${MINIENTREGA_CONF}
	#Si no existe el archivo en dicho directorio:
  if test ! -e $1; then
    echo $ERROR 
    echo "minientrega.sh+ No es accesible el fichero \"$1\"" >&2
    exit 66
  fi
fi

#Cargamos variables
source $1

#Comprobamos fecha
date -d $MINIENTREGA_FECHALIMITE>&/dev/null

if [ $? -ne "0" ] || [ $MINIENTREGA_FECHALIMITE -ge "21000101" ];then
	echo $ERROR
	echo "minientrega.sh+ fecha incorrecta \"$MINIENTREGA_FECHALIMITE\""
	exit 65
fi

#Comprobamos archivos
for file in ${MINIENTREGA_FICHEROS[@]}; do
	echo $file
	if (test ! -e $file) || (test -r $file); then
		echo $ERROR 
		echo "minientrega.sh+ No es accesible el fichero \"$file\"" >&2
		exit 66
	fi
done

#Comprobamos destino
if test ! -d ${MINIENTREGA_DESTINO} ;then
  echo $ERROR 
  echo "minientrega.sh+ No es accesible el directorio \"${MINIENTREGA_DESTINO}\"" >&2
  exit 73
fi
cd ${MINIENTREGA_DESTINO}
mkdir ${USER}
if [ $? -ne "0" ];then
	echo $ERROR
	echo "minientrega.sh+ no se pudo crear el subdirectorio de entrega en \"$MINIENTREGA_DESTINO\""
	exit 73
fi
exit 0

