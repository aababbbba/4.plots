#Carga de paquetes
import numpy as np
import matplotlib.pyplot as plt
import glob

#Leer datos
data_m1 = np.loadtxt("main/theta_data/m1.txt")
data_m2 = np.loadtxt("main/theta_data/m2.txt")
data_m3 = np.loadtxt("main/theta_data/m3.txt")
data_m4 = np.loadtxt("main/theta_data/m4.txt")
data_m5 = np.loadtxt("main/theta_data/m5.txt")
data_m6 = np.loadtxt("main/theta_data/m6.txt")
data_m7 = np.loadtxt("main/theta_data/m7.txt")
data_m8 = np.loadtxt("main/theta_data/m8.txt")

datos = (data_m1+data_m2+data_m3+data_m4+data_m5+data_m6+data_m7+data_m8)/8.0
fig, ax = plt.subplots(figsize=(4,7))

ax.grid(b=True,which='both',axis='y')
ax.grid(b=True,which='major',axis='x')
ax.set_xlabel(r'$\theta$ [K]')
ax.set_ylabel(r'$z/\delta$ [-]')
ax.set_ylim(0,1)
ax.set_xlim(275,280)
#ax.set_title(r"Perfil de Temperatura Potencial $\theta$")
ax.minorticks_on()

maxval = 22
rem = 54
nn = 109 - rem #max 85
rem2 = 0 #datos removidos del final
colors = plt.cm.viridis(np.linspace(1,0,nn-rem2))

delta = 300.
zd = datos[:maxval,0]/delta

for i in range(0,nn-rem2,3):
	ax.plot(datos[:maxval,rem+i+1],zd,"-",color=colors[i],lw=2.0)


fig.tight_layout()
fig.savefig("main/theta_data/mean_profile.pdf")