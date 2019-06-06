#Carga de paquetes
import numpy as np
import matplotlib.pyplot as plt
import glob
from matplotlib.backends.backend_pdf import PdfPages
pdf_pages = PdfPages('second_order_mean.pdf')

#Leer datos
data_m1 = np.loadtxt("main/secondorder_mean/m1.txt")
data_m2 = np.loadtxt("main/secondorder_mean/m2.txt")
data_m3 = np.loadtxt("main/secondorder_mean/m3.txt")
data_m4 = np.loadtxt("main/secondorder_mean/m4.txt")

delta 	= 300
lww 	= 2.0

plt.rcParams.update({'font.size': 16})

fig, ax = plt.subplots(figsize=(5,7))
ax.grid(b=True,which='both',axis='y')
ax.grid(b=True,which='both',axis='x')
ax.set_xlabel(r'$k_{sgs}/u_*^2$ [-]')
ax.set_ylabel(r'$z/\delta$ [-]')
ax.set_ylim(0,1)
ax.minorticks_on()
ax.plot(data_m1[:,9],data_m1[:,0]/delta,"-",lw=lww,label=r"M1 ; $u_*=0.234$ [m/s]")
ax.plot(data_m2[:,9],data_m2[:,0]/delta,"-",lw=lww,label=r"M2 ; $u_*=0.604$ [m/s]")
ax.plot(data_m3[:,9],data_m3[:,0]/delta,"-",lw=lww,label=r"M3 ; $u_*=0.530$ [m/s]")
ax.plot(data_m4[:,9],data_m4[:,0]/delta,"-",lw=lww,label=r"M4 ; $u_*=0.106$ [m/s]")
ax.legend(ncol=1,fontsize=12,markerscale=1)

fig.tight_layout()
pdf_pages.savefig(fig)

fig2, ax2 = plt.subplots(figsize=(5,7))
ax2.grid(b=True,which='both',axis='y')
ax2.grid(b=True,which='both',axis='x')
ax2.set_xlabel(r'$\Phi_{M}$ [-]')
ax2.set_ylabel(r'$z/\delta$ [-]')
ax2.set_ylim(0,1)
ax2.minorticks_on()
#ax2.plot(datos[:19,8],datos[:19,7]/delta,"-",lw=lww,color="green")
ax2.plot(data_m1[:19,8],data_m1[:19,7]/delta,"-",lw=lww,label="M1")
ax2.plot(data_m2[:19,8],data_m2[:19,7]/delta,"-",lw=lww,label="M2")
ax2.plot(data_m3[:19,8],data_m3[:19,7]/delta,"-",lw=lww,label="M3")
ax2.plot(data_m4[:19,8],data_m4[:19,7]/delta,"-",lw=lww,label="M4")
#ax2.legend(loc=1,ncol=1,fontsize=10,markerscale=1)

fig2.tight_layout()
pdf_pages.savefig(fig2)

fig3, ax3 = plt.subplots(figsize=(5,7))
ax3.grid(b=True,which='both',axis='y')
ax3.grid(b=True,which='both',axis='x')
ax3.set_xlabel(r'$\tau_{13}/u_*^2$ [-]')
ax3.set_ylabel(r'$z/\delta$ [-]')
ax3.set_ylim(0,1)
ax3.minorticks_on()
#ax3.plot(datos[:,10],datos[:,0]/delta,"-",lw=lww,color="green")
ax3.plot(data_m1[:,10],data_m1[:,0]/delta,"-",lw=lww,label="M1")
ax3.plot(data_m2[:,10],data_m2[:,0]/delta,"-",lw=lww,label="M2")
ax3.plot(data_m3[:,10],data_m3[:,0]/delta,"-",lw=lww,label="M3")
ax3.plot(data_m4[:,10],data_m4[:,0]/delta,"-",lw=lww,label="M4")
#ax3.legend(loc=1,ncol=1,fontsize=10,markerscale=1)

fig3.tight_layout()
pdf_pages.savefig(fig3)

pdf_pages.close()