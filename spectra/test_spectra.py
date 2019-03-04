#Carga de paquetes
import numpy as np
import matplotlib.pyplot as plt

#Definición del dominio numérico
nx2   = 2**11
ny2   = 2**11
lim   = 200.0 #limite superior
x2    = np.linspace(0, lim, nx2)
y2    = np.linspace(0, lim, ny2)
x2,y2 = np.meshgrid(x2,y2)
u0    = 10.0

dx = lim/(nx2-1.0) #espaciamiento en x
dy = lim/(ny2-1.0) #espaciamiento en y

#Leer datos
#ff1 = u0 + 0.5*np.sin(np.pi*x2) + 0.5*np.sin(2*np.pi*y2) + 2*np.sin(4*np.pi*(x2+y2))

ff1 = np.loadtxt("testdata")

#Frecuencias en x
f_frec=np.fft.fftfreq(nx2,dx)
fft_ff1 = np.zeros((nx2,ny2),dtype=complex)
for i in range(len(y2)):
    fft_ff1[i,:] =np.fft.fft(ff1[i,:],nx2)
print("fft_x ok!")

#Frecuencias en y
f_frec=np.fft.fftfreq(ny2,dy)
fft_ff2 = np.zeros((nx2,ny2),dtype=complex)
for i in range(len(x2)):
    fft_ff2[:,i] =np.fft.fft(fft_ff1[:,i],nx2)
print("fft_y ok!")

#almacenamiento de valores de la transformada
frec_x=np.fft.fftfreq(nx2,dx)
frec_y=np.fft.fftfreq(ny2,dy)

k_vec     = np.zeros(nx2*ny2)
abs_fft_u = np.zeros_like(k_vec)
for i in range(nx2):
    for j in range(ny2):
        k_vec[nx2*i+j]     = np.sqrt(frec_x[i]**2+frec_y[j]**2)
        abs_fft_u[nx2*i+j] = np.abs(fft_ff2[i,j])
print("wave_number ok!")

# Ordenar el vector
result = np.zeros((2,nx2*ny2))
result[0,:]=k_vec
result[1,:]=abs_fft_u
idx = np.argsort(result[0])
result2 = result[:,idx]
#a[a[:,1].argsort()]
print("orden ok!")

print("ploting...")
# Gráfico del espectro para el número de onda
plt.figure(figsize=(15,7))
plt.grid()
plt.ylim(1e-6,2)
plt.loglog(result2[0,1:], 1/(nx2*ny2)*result2[1,1:])
plt.savefig("spectra_test.png")