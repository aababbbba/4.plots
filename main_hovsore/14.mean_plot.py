#Carga de paquetes
import numpy as np
import matplotlib.pyplot as plt
import glob
from matplotlib.backends.backend_pdf import PdfPages
pdf_pages = PdfPages('mean_data.pdf')
#Leer datos
datos = np.loadtxt("main/data_mean/data_mean.txt")

delta = 750

lww = 2.0

plt.rcParams.update({'font.size': 16})

fig, ax = plt.subplots(figsize=(5,7))
ax.grid(b=True,which='both',axis='y')
ax.grid(b=True,which='major',axis='x')
ax.set_xlabel(r'$k_{sgs}/u_*^2$ $[-]$')
ax.set_ylabel(r'$z/\delta$ [-]')
ax.set_ylim(0,1)
ax.minorticks_on()
ax.plot(datos[:,9],datos[:,0]/delta,"-",lw=lww,color="green")

fig.tight_layout()
pdf_pages.savefig(fig)

fig2, ax2 = plt.subplots(figsize=(5,7))
ax2.grid(b=True,which='both',axis='y')
ax2.grid(b=True,which='major',axis='x')
ax2.set_xlabel(r'$\Phi_{M}$ $[-]$')
ax2.set_ylabel(r'$z/\delta$ [-]')
ax2.set_ylim(0,1)
ax2.minorticks_on()
ax2.plot(datos[:19,8],datos[:19,7]/delta,"-",lw=lww,color="green")

fig2.tight_layout()
pdf_pages.savefig(fig2)

fig3, ax3 = plt.subplots(figsize=(5,7))
ax3.grid(b=True,which='both',axis='y')
ax3.grid(b=True,which='major',axis='x')
ax3.set_xlabel(r'$\tau_{13}/u_*^2$ $[-]$')
ax3.set_ylabel(r'$z/\delta$ [-]')
ax3.set_ylim(0,1)
ax3.minorticks_on()
ax3.plot(-1.0*datos[:,10],datos[:,0]/delta,"-",lw=lww,color="green")

fig3.tight_layout()
pdf_pages.savefig(fig3)

pdf_pages.close()