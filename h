#!/bin/bash
MINIENTREGA_FECHALIMITE="2017-20-21"
if [ $MINIENTREGA_FECHALIMITE:4:1 -ne "-" ] || [ $MINIENTREGA_FECHALIMITE:7:1 -ne "-" ];then
	echo "minientrega.sh+ fecha incorrecta \"$MINIENTREGA_FECHALIMITE\"" >&2
	exit 65
else
	echo "SFDASD"
fi
