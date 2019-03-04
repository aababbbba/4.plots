#Carga de paquetes
import numpy as np

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

ff1 = u0 + 0.5*np.sin(np.pi*x2) + 0.5*np.sin(2*np.pi*y2) + 2*np.sin(4*np.pi*(x2+y2))

data = open("testdata","w")
for j in range(ny2):
	for i in range(nx2):
		data.write("%f " %ff1[i,j])
	data.write("\n")
data.close()