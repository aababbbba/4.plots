#Carga de paquetes
import numpy as np
import matplotlib.pyplot as plt
import glob

#Definición del dominio numérico
nx = 105
ny = 105
dx = 24.6914
dy = 24.6914

x1=0.002
x2=0.03
y1=0.00001*x1**(-5.0/3.0)
y2=0.00001*x2**(-5.0/3.0)
x=[x1,x2]
y=[y1,y2]

#Leer datos
carpetas = glob.glob("data/raw/*")
print(carpetas)
for m in range(len(carpetas)):
	archivos = glob.glob(carpetas[m]+"/*10:00:00*.txt")
	for n in range(len(archivos)):
		print(archivos[n])
		ff1 = np.loadtxt(archivos[n])
		#Frecuencias en x
		f_frec=np.fft.fftfreq(nx,dx)
		fft_ff1 = np.zeros((nx,ny),dtype=complex)
		for i in range(ny):
		    fft_ff1[i,:] =np.fft.fft(ff1[i,:],nx)
		print("    fft_x ok!")
		#Frecuencias en y
		f_frec=np.fft.fftfreq(ny,dy)
		fft_ff2 = np.zeros((nx,ny),dtype=complex)
		for i in range(nx):
		    fft_ff2[:,i] =np.fft.fft(fft_ff1[:,i],nx)
		print("    fft_y ok!")
		#almacenamiento de valores de la transformada
		frec_x=np.fft.fftfreq(nx,dx)
		frec_y=np.fft.fftfreq(ny,dy)

		k_vec     = np.zeros(nx*ny)
		abs_fft_u = np.zeros_like(k_vec)
		for i in range(nx):
		    for j in range(ny):
		        k_vec[nx*i+j]     = np.sqrt(frec_x[i]**2+frec_y[j]**2)
		        abs_fft_u[nx*i+j] = np.abs(fft_ff2[i,j])
		print("    wave_number ok!")
		# Ordenar el vector
		result = np.zeros((2,nx*ny))
		result[0,:]=k_vec
		result[1,:]=abs_fft_u
		idx = np.argsort(result[0])
		result2 = result[:,idx]
		print("    ploting...")
		# Gráfico del espectro para el número de onda
		plt.figure(figsize=(8,4))
		plt.grid(which="both")
		#plt.ylim(1e-6,2)
		if "u" in archivos[n]:
			plt.loglog(result2[0,1:], result2[0,1:]**2.0*result2[1,1:]**2.0,color="b",lw=0.5)
			plt.loglog(x,y,ls="--",color="k")
			auxname = archivos[n].replace("data", "plots")
			auxname = auxname.replace("txt","png")
			plt.xlabel(r'k $[1/m]$')
			plt.ylabel(r'$k^{2}|\hat{u}(k)|^2$ $[m/s]$')
			plt.tight_layout()
			plt.savefig(auxname)
		if "v" in archivos[n]:
			plt.loglog(result2[0,1:], result2[0,1:]**2.0*result2[1,1:]**2.0,color="g",lw=0.5)
			plt.loglog(x,y,ls="--",color="k")
			auxname = archivos[n].replace("data", "plots")
			auxname = auxname.replace("txt","png")
			plt.xlabel(r'k $[1/m]$')
			plt.ylabel(r'$k^{2}|\hat{v}(k)|^2$ $[m/s]$')
			plt.tight_layout()
			plt.savefig(auxname)
		if "V" in archivos[n]:
			plt.loglog(result2[0,1:], result2[0,1:]**2.0*result2[1,1:]**2.0,color="r",lw=0.5)
			plt.loglog(x,y,ls="--",color="k")
			auxname = archivos[n].replace("data", "plots")
			auxname = auxname.replace("txt","png")
			plt.xlabel(r'k $[1/m]$')
			plt.ylabel(r'$k^{2}|\hat{V}(k)|^2$ $[m/s]$')
			plt.tight_layout()
			plt.savefig(auxname)