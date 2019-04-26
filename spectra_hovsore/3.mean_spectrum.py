#Esté código promedia los bins de numero de onda y promedia horariamente los espectros.
#Carga de paquetes
import numpy as np
import glob
nx = 105 #Largo del dominio
ny = 105
aux_largo = 1108 #este valor depende de la cantidad de numeros de onda, hay que modificarlo
#Leer datos
carpetas = glob.glob("data/fft/*") # lista con los distintas carpetas (niveles) de los archivos
print(carpetas)
for m in range(len(carpetas)): #Entra a cada carpeta y empieza a operar (loop por niveles)
	#Promedio de u
	archivos = glob.glob(carpetas[m]+"/u*.txt") #selecciona los archivos de u
	mean_aux = np.zeros((nx*ny,2),dtype=float) #aca se almacenaran los valores para promediar
	write_aux = np.zeros((aux_largo,2),dtype=float) #se usa para imprimir los archivos finales
	for n in range(len(archivos)): #recorre y promedia los archivos 
		print(archivos[n])
		mean_aux = mean_aux+np.loadtxt(archivos[n])
	mean_aux = mean_aux/len(archivos) #promedia
	cont = 0 #cuenta cuantos valores se repiten en cada numero de onda
	aux_suma = 0 # para promediar los valores que pertenecen a un mismo numero de onda
	index_aux = 0 # indice para almacenar en el arreglo final
	for i in range(len(mean_aux[:,0])+1): #loop por cada numero de onda
		if (i==0):
			pass
		elif(i==len(mean_aux[:,0])):
			write_aux[index_aux,0] = mean_aux[i-1,0]
			write_aux[index_aux,1] = (aux_suma+mean_aux[i-1,1])/(cont+1)
			print(mean_aux[i-1,:])
		elif (mean_aux[i,0]==mean_aux[i-1,0]):
			cont = cont +1
			aux_suma = aux_suma + mean_aux[i-1,1]
		else:
			write_aux[index_aux,0] = mean_aux[i-1,0]
			write_aux[index_aux,1] = (aux_suma+mean_aux[i-1,1])/(cont+1)
			index_aux = index_aux+1
			aux_suma = 0
			cont = 0
	data = open("data/mean"+archivos[1][8:16]+".txt","w")
	print("data/mean"+archivos[1][8:16]+".txt")
	for j in range(aux_largo):
		for i in range(2):
			data.write("%f " %write_aux[j,i])
		data.write("\n")
	data.close()
	#
	#
	#Promedio de v
	archivos = glob.glob(carpetas[m]+"/v*.txt") #selecciona los archivos de v
	mean_aux = np.zeros((nx*ny,2),dtype=float) #aca se almacenaran los valores para promediar
	write_aux = np.zeros((aux_largo,2),dtype=float) #se usa para imprimir los archivos finales
	for n in range(len(archivos)): #recorre y promedia los archivos 
		print(archivos[n])
		mean_aux = mean_aux+np.loadtxt(archivos[n])
	mean_aux = mean_aux/len(archivos) #promedia
	cont = 0 #cuenta cuantos valores se repiten en cada numero de onda
	aux_suma = 0 # para promediar los valores que pertenecen a un mismo numero de onda
	index_aux = 0 # indice para almacenar en el arreglo final
	for i in range(len(mean_aux[:,0])+1): #loop por cada numero de onda
		if (i==0):
			pass
		elif(i==len(mean_aux[:,0])):
			write_aux[index_aux,0] = mean_aux[i-1,0]
			write_aux[index_aux,1] = (aux_suma+mean_aux[i-1,1])/(cont+1)
		elif (mean_aux[i,0]==mean_aux[i-1,0]):
			cont = cont +1
			aux_suma = aux_suma + mean_aux[i-1,1]
		else:
			write_aux[index_aux,0] = mean_aux[i-1,0]
			write_aux[index_aux,1] = (aux_suma+mean_aux[i-1,1])/(cont+1)
			index_aux = index_aux+1
			aux_suma = 0
			cont = 0
	data = open("data/mean"+archivos[1][8:16]+".txt","w")
	print("data/mean"+archivos[1][8:16]+".txt")
	for j in range(aux_largo):
		for i in range(2):
			data.write("%f " %write_aux[j,i])
		data.write("\n")
	data.close()
	#
	#
	#Promedio de V
	archivos = glob.glob(carpetas[m]+"/V*.txt") #selecciona los archivos de V
	mean_aux = np.zeros((nx*ny,2),dtype=float) #aca se almacenaran los valores para promediar
	write_aux = np.zeros((aux_largo,2),dtype=float) #se usa para imprimir los archivos finales
	for n in range(len(archivos)): #recorre y promedia los archivos 
		print(archivos[n])
		mean_aux = mean_aux+np.loadtxt(archivos[n])
	mean_aux = mean_aux/len(archivos) #promedia
	cont = 0 #cuenta cuantos valores se repiten en cada numero de onda
	aux_suma = 0 # para promediar los valores que pertenecen a un mismo numero de onda
	index_aux = 0 # indice para almacenar en el arreglo final
	for i in range(len(mean_aux[:,0])+1): #loop por cada numero de onda
		if (i==0):
			pass
		elif(i==len(mean_aux[:,0])):
			write_aux[index_aux,0] = mean_aux[i-1,0]
			write_aux[index_aux,1] = (aux_suma+mean_aux[i-1,1])/(cont+1)
		elif (mean_aux[i,0]==mean_aux[i-1,0]):
			cont = cont +1
			aux_suma = aux_suma + mean_aux[i-1,1]
		else:
			write_aux[index_aux,0] = mean_aux[i-1,0]
			write_aux[index_aux,1] = (aux_suma+mean_aux[i-1,1])/(cont+1)
			index_aux = index_aux+1
			aux_suma = 0
			cont = 0
	data = open("data/mean"+archivos[1][8:16]+".txt","w")
	print("data/mean"+archivos[1][8:16]+".txt")
	for j in range(aux_largo):
		for i in range(2):
			data.write("%f " %write_aux[j,i])
		data.write("\n")
	data.close()