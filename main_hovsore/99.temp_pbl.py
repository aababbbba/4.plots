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
ax.set_ylabel(r'$z$ [m]')
ax.set_ylim(0,2000)
ax.set_xlim(286,298)
#ax.set_title(r"Perfil de Temperatura Potencial $\theta$")
ax.minorticks_on()

maxval = 22 #nivel vertical maximo
rem = 12 #datos removidos del inicio, 1 valor cada 10 min
nn = 85 - rem #max 73
rem2 = 12 #datos removidos del final
colors = plt.cm.viridis(np.linspace(1,0,nn-rem2))

text = [
	'6:00','6:10','6:20','6:30','6:40','6:50',
	'7:00','7:10','7:20','7:30','7:40','7:50',
	'8:00','8:10','8:20','8:30','8:40','8:50',
	'9:00','9:10','9:20','9:30','9:40','9:50',
	'10:00','10:10','10:20','10:30','10:40','10:50',
	'11:00','11:10','11:20','11:30','11:40','11:50',
	'12:00','12:10','12:20','12:30','12:40','12:50',
	'13:00','13:10','13:20','13:30','13:40','13:50',
	'14:00','14:10','14:20','14:30','14:40','14:50',
	'15:00','15:10','15:20','15:30','15:40','15:50',
	'16:00','16:10','16:20','16:30','16:40','16:50',
	'17:00','17:10','17:20','17:30','17:40','17:50',
	'18:00','18:10','18:20','18:30','18:40','18:50',
	'19:00','19:10','19:20','19:30','19:40','19:50',
	'20:00','20:10','20:20','20:30','20:40','20:50',
	'21:00','21:10','21:20','21:30','21:40','21:50',
	'22:00'
	]

ff = 12 #factor de corrección horaria
for i in range(0,nn-rem2,2):
	ax.plot(datos[:maxval,rem+i+1],datos[:maxval,0],"-",color=colors[i],lw=1.0)

for i in range(0,nn-rem2,3):
	ax.plot(0,0,"-",color=colors[i],lw=1.7, label=text[ff+rem+i])

ax.legend(ncol=2,fontsize='small',markerscale=0)

fig.tight_layout()
fig.savefig("pbl.pdf")