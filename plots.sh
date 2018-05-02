#bin/bash/
##############################################################################################################
####################### Código hecho por Pablo Andrés Cárdenas Zamorano - UTFSM - 2018 #######################
##############################################################################################################
#Esta subrutina se encarga de automatizar la realización de todos los gráficos necesarios
#Según el número con el que uno ejecute el comando se hará el gráfico respectivo
#Ejemplo: ./plot.sh 0: grafica todo, ./plot.sh 2: grafica solo el gráfico 2
##############################################################################################################

#############  Parámetros a modificar para cada vez que se quiere ejecutar este programa  ####################
## Ordenar los outputs del wrf de la manera en la que están estructuradas las carpetas
## Separar manualmente el spinup del modelo, de la simulación según la serie de tiempo
## Ajustar factor de correción horaria para las series de tiempo
## Para 1.hgt modificar en la linea 15 de FILES la hora en donde se extraeran los datos para los dominios
## Para 2.control lo mismo que antes y además definir las coordenadas a plotear
## Para 4. ajustar lat y lon del punto de control. Cambiar nombre del archivo ts si es necesario
## Para 6. definir correctamente el valor N de numero de archivos dentro de una hora
## Considerar los max y min mostrados en consola para ajustar los límites de las paletas de colores
## Considerar ajustar el delay de los .gif para una reproducción mas suave
clear
echo "##############################################################################################################"
echo "####################### Código hecho por Pablo Andrés Cárdenas Zamorano - UTFSM - 2018 #######################"
echo "##############################################################################################################"
echo ""
echo "Comienzo de creación de gráficos:"
echo ""

#1. Gráficos de dominios y uso de suelo
if [ $1 -eq 0 ] || [ $1 -eq 1 ]; then
	printf "\033[0;31m"
	printf "    1. Graficando dominios y uso de suelo..."
	printf "\033[0m"
	ncl -Q -n main/1.hgt.ncl
	echo "    OK!"
fi

#2. Gráfico de puntos de interés en el dominio mas interior
if [ $1 -eq 0 ] || [ $1 -eq 2 ]; then
	printf "\033[0;31m"
	printf "    2. Graficando punto de interés..."
	printf "\033[0m"
	ncl -Q -n main/2.control.ncl
	echo "    OK!"
fi

#3. Gráfico de evoución del viento superficial y animación
if [ $1 -eq 0 ] || [ $1 -eq 3 ]; then
	printf "\033[0;31m"
	echo "    3. Graficando evolución del viento superficial..."
	printf "\033[0m"
	ncl -Q -n main/3.10m_vel.ncl
	echo "    OK!"
	printf "\033[0;31m"
	echo "    3. Graficando evolución del viento superficial (SPINUP)..."
	printf "\033[0m"
	ncl -Q -n main/3alt.10m_vel.ncl
	echo "    OK!"
fi

#4. Gráfico de series de tiempo para las ubicaciones en tslist
if [ $1 -eq 0 ] || [ $1 -eq 4 ]; then
	printf "\033[0;31m"
	echo "    4. Graficando series de tiempos..."
	printf "\033[0m"
	ncl -Q -n main/4.ts_plot.ncl
	echo "    OK!"
fi

#5. Velocidad media por nivel
if [ $1 -eq 0 ] || [ $1 -eq 5 ]; then
	printf "\033[0;31m"
	echo "    5. Graficando velocidad media por nivel..."
	printf "\033[0m"
	ncl -Q -n main/5.mean_vel.ncl
	echo "    OK!"
fi

#6. Niveles verticales del dominio
if [ $1 -eq 0 ] || [ $1 -eq 6 ]; then
	printf "\033[0;31m"
	echo "    6. Graficando perfil de velocidad medio..."
	printf "\033[0m"
	ncl -Q -n main/6.mean_hourly_profile.ncl
	echo "    OK!"
fi

#7. Evolución del campo de velocidades en el nivel mas bajo (eta1)
if [ $1 -eq 0 ] || [ $1 -eq 7 ]; then
	printf "\033[0;31m"
	echo "    7. Graficando evolución del viento superficial en eta = 1..."
	printf "\033[0m"
	ncl -Q -n main/7.eta1_vel.ncl
	echo "    OK!"
	printf "\033[0;31m"
	echo "    7. Graficando evolución del viento superficial en eta = 1 (SPINUP)..."
	printf "\033[0m"
	ncl -Q -n main/7alt.eta1_vel.ncl
	echo "    OK!"
fi

printf "\033[0m"
echo ""
echo "Realización exitosa de gráficos!"
echo ""