#Carga de paquetes
import numpy as np
import matplotlib.pyplot as plt
import glob

#Leer datos

datos = np.loadtxt("99.test.txt")

#print(datos[:,0])

fig, ax = plt.subplots(figsize=(4,7))

ax.grid(b=True,which='both',axis='y')
ax.grid(b=True,which='major',axis='x')
ax.set_xlabel(r'$\theta$ [K]')
ax.set_ylabel(r'$z/\delta$ [-]')
ax.set_ylim(0,1)
ax.set_xlim(286.5,289.5)
#ax.set_title(r"Perfil de Temperatura Potencial $\theta$")
ax.minorticks_on()

maxval = 17
rem = 24
nn = 85 - rem #max 85
rem2 = 0 #datos removidos del final
colors = plt.cm.viridis(np.linspace(1,0,nn-rem2))

delta = 750.
zd = datos[:maxval,0]/delta

for i in range(0,nn-rem2,2):
	ax.plot(datos[:maxval,rem+i+1],zd,"-",color=colors[i],lw=2.0)


fig.tight_layout()
fig.savefig("temp_profile.pdf")