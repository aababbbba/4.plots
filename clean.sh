#bin/bash/
##############################################################################################################
####################### Código hecho por Pablo Andrés Cárdenas Zamorano - UTFSM - 2018 #######################
##############################################################################################################
#Limpia los gráficos creados y vuelve a crear un entorno adecuado para el ploteo de los datos
##############################################################################################################
clear
echo "##############################################################################################################"
echo "####################### Código hecho por Pablo Andrés Cárdenas Zamorano - UTFSM - 2018 #######################"
echo "##############################################################################################################"
echo ""
printf "Eliminando datos..."
rm -r V_10m/ V_eta1/
rm *.pdf *.gif *.png
echo "    OK!"
printf "Creando carpetas..."
mkdir V_10m V_eta1
mkdir V_10m/frames V_10m/frames_spinup
mkdir V_eta1/frames V_eta1/frames_spinup
echo "    OK!"
echo ""
echo "Configuración exitosa del directorio de ploteo!"
echo ""