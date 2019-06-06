#Carga de paquetes
import numpy as np
import matplotlib.pyplot as plt
import glob
from scipy.stats.stats import pearsonr
from matplotlib.backends.backend_pdf import PdfPages
pdf_pages = PdfPages('correlation.pdf')

#Leer datos
#data_simu = readAsciiTable("main/data_interpol_simu.txt", 7, "float", 37)
#data_real = readAsciiTable("main/data_interpol_med.txt", 7, "float", 37)

data_simu = np.loadtxt("main/data_interpol_simu.txt")
data_real = np.loadtxt("main/data_interpol_med.txt")

lww = 8.0
opa = 0.8

plt.rcParams.update({'font.size': 18})
fig, ax = plt.subplots(figsize=(7.6,7))
ax.grid(b=True,which='both',axis='y')
ax.grid(b=True,which='both',axis='x')
ax.set_xlabel(r'$V_{med}$ $[m/s]$')
ax.set_ylabel(r'$V_{sim}$ $[m/s]$')
ax.set_ylim(6,20)
ax.set_xlim(6,20)
#ax.minorticks_on()
colors = plt.cm.viridis(np.linspace(1,0,6))

print(pearsonr(data_real[37:,1], data_simu[37:,1]))
print(pearsonr(data_real[37:,2], data_simu[37:,2]))
print(pearsonr(data_real[37:,3], data_simu[37:,3]))
print(pearsonr(data_real[37:,4], data_simu[37:,4]))
print(pearsonr(data_real[37:,5], data_simu[37:,5]))
print(pearsonr(data_real[37:,6], data_simu[37:,6]))

#print(data_real[37:,0])
ax.plot(data_real[37:,1],data_simu[37:,1],"o",markersize=lww,alpha=opa,label=r"$z=116.5$ [m] $r=-0.061$"		,color=colors[0])
ax.plot(data_real[37:,2],data_simu[37:,2],"o",markersize=lww,alpha=opa,label=r"$z=100.0$ [m] $r=-0.006$"		,color=colors[1])
ax.plot(data_real[37:,3],data_simu[37:,3],"o",markersize=lww,alpha=opa,label=r"$z=$  $80.0$ [m] $r=$    $0.042$",color=colors[2])
ax.plot(data_real[37:,4],data_simu[37:,4],"o",markersize=lww,alpha=opa,label=r"$z=$  $60.0$ [m] $r=$    $0.093$",color=colors[3])
ax.plot(data_real[37:,5],data_simu[37:,5],"o",markersize=lww,alpha=opa,label=r"$z=$  $40.0$ [m] $r=$    $0.204$",color=colors[4])
ax.plot(data_real[37:,6],data_simu[37:,6],"o",markersize=lww,alpha=opa,label=r"$z=$  $10.0$ [m] $r=$    $0.282$",color=colors[5])
ax.legend(ncol=1,fontsize='small',markerscale=1)

fig.tight_layout()
pdf_pages.savefig(fig)
pdf_pages.close()