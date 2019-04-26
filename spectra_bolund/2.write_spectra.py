#Carga de paquetes
import numpy as np
import glob

#Definición del dominio numérico
nx = 105
ny = 90
dx = 2.74348
dy = 2.74348

#Leer datos
carpetas = glob.glob("data/raw/*")
print(carpetas)
for m in range(len(carpetas)):
	archivos = glob.glob(carpetas[m]+"/*.txt")
	for n in range(len(archivos)):
		print(archivos[n])
		ff1 = np.loadtxt(archivos[n])
		#Frecuencias en x
		#f_frec=np.fft.fftfreq(nx,dx)
		fft_ff1 = np.zeros((ny,nx),dtype=complex)
		for i in range(ny):
		    fft_ff1[i,:] =np.fft.fft(ff1[i,:],nx)
		print("    fft_x ok!")
		#print(fft_ff1.shape)
		#Frecuencias en y
		#f_frec=np.fft.fftfreq(ny,dy)
		fft_ff2 = np.zeros((ny,nx),dtype=complex)
		#print(fft_ff2.shape)
		for i in range(nx):
		    fft_ff2[:,i] =np.fft.fft(fft_ff1[:,i],ny)
		print("    fft_y ok!")
		#almacenamiento de valores de la transformada
		frec_x=np.fft.fftfreq(nx,dx)
		frec_y=np.fft.fftfreq(ny,dy)

		k_vec     = np.zeros(nx*ny)
		abs_fft_u = np.zeros_like(k_vec)

		#print(frec_x.shape)
		#print(frec_y.shape)
		for i in range(nx):
		    for j in range(ny):
		        k_vec[ny*i+j]     = np.sqrt(frec_x[i]**2+frec_y[j]**2)
		        abs_fft_u[ny*i+j] = np.abs(fft_ff2[j,i])
		print("    wave_number ok!")
		# Ordenar el vector
		result = np.zeros((2,nx*ny))
		result[0,:]=k_vec
		result[1,:]=abs_fft_u
		idx = np.argsort(result[0])
		result2 = result[:,idx]

		print(archivos[n][8:])

		#escritura de datos
		data = open("data/fft"+archivos[n][8:],"w")
		for j in range(nx*ny):
			for i in range(2):
				data.write("%f " %result2[i,j])
			data.write("\n")
		data.close()