#Carga de paquetes
import numpy as np
import matplotlib.pyplot as plt
import glob

#Leer datos
datos = np.loadtxt("main/theta_data/m8.txt")
fig, ax = plt.subplots(figsize=(4,7))

ax.grid(b=True,which='both',axis='y')
ax.grid(b=True,which='major',axis='x')
ax.set_xlabel(r'$\theta$ [K]')
ax.set_ylabel(r'$z/\delta$ [-]')
ax.set_ylim(0,1)
ax.set_xlim(275,285)
#ax.set_title(r"Perfil de Temperatura Potencial $\theta$")
ax.minorticks_on()

maxval = 22
rem = 0
nn = 109 - rem #max 85
rem2 = 0 #datos removidos del final
colors = plt.cm.viridis(np.linspace(1,0,nn-rem2))

delta = 750.
zd = datos[:maxval,0]/delta

for i in range(0,nn-rem2,4):
	ax.plot(datos[:maxval,rem+i+1],zd,"-",color=colors[i],lw=1.5)


fig.tight_layout()
fig.savefig("main/theta_data/m8_profile.pdf")