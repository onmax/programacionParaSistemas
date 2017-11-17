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

RUTA=${MINIENTREGA_CONF}	
ERROR="minientrega.sh: Error, no se pudo realizar la entrega"

#Si no existe la variable donde se guarda el directorio entonces:
if test -z ${MINIENTREGA_CONF} || test -o ${MINIENTREGA_CONF};then
  echo $ERROR >&2
  echo "minientrega.sh+ No es accesible el directorio \"${MINIENTREGA_CONF}\"" >&2
  exit 64
fi

#Si no es accesible el directorio:
if test ! -d ${MINIENTREGA_CONF} ;then
  echo $ERROR >&2
  echo "minientrega.sh+ No es accesible el directorio \"${MINIENTREGA_CONF}\"" >&2
  exit 64
else
  
	#Si no existe el archivo en dicho directorio:
  if test ! -f $RUTA/$1; then
    echo $ERROR >&2 
    echo "minientrega.sh+ No es accesible el fichero \"$1\"" >&2
    exit 66
  fi
fi

#Cargamos variables
source $RUTA/$1

#Comprobamos fecha
FECHAACTUAL=`date +"%Y%m%d"`	
FECHALIMITE=$MINIENTREGA_FECHALIMITE
date -d $MINIENTREGA_FECHALIMITE &> /dev/null
if [ $? -ne "0" ];then
	echo $ERROR >&2
	echo "minientrega.sh+ fecha incorrecasdfasdfta \"$MINIENTREGA_FECHALIMITE\"" >&2
	exit 65
fi

if [[ ${MINIENTREGA_FECHALIMITE} =~ ^[0-9]{4}-[0-9]{2}-[0,9]{2}$ ]];then
	echo $ERROR >&2
	echo "minientrega.sh+ fecha incorrecta \"$MINIENTREGA_FECHALIMITE\"" >&2
	exit 65
fi


FECHA=`date --date=$MINIENTREGA_FECHALIMITE +"%Y%m%d"`

if [ ${FECHA} -ge "21000101" ] || [ ${FECHA} -le ${FECHAACTUAL} ];then	
	echo $ERROR >&2
	echo "minientrega.sh+ fecha incorrecta \"$MINIENTREGA_FECHALIMITE\"" >&2
	exit 65
fi

#Comprobamos archivos
for file in ${MINIENTREGA_FICHEROS[@]}; do
	if test ! -r $file; then
		echo $ERROR >&2
		echo "minientrega.sh+ No es accesible el fichero \"$file\"" >&2
		exit 66
	fi
done

#Comprobamos destino
if test ! -d ${MINIENTREGA_DESTINO} ;then
  echo $ERROR >&2
  echo "minientrega.sh+ No se puede crear el subdirectorio de entrega en \"${MINIENTREGA_DESTINO}\"" >&2
  exit 73
else
	if test ! -w $MINIENTREGA_DESTINO;then
	  echo $ERROR >&2
	  echo "minientrega.sh+ No se tienen los permisos para crear el archivo en \"${MINIENTREGA_DESTINO}\"" >&2
	  exit 73
	else
		mkdir ${MINIENTREGA_DESTINO}/${USER}
		cp ${MINIENTREGA_FICHEROS} ${MINIENTREGA_DESTINO}/${USER}
	fi
fi


exit 0

