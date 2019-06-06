#Carga de paquetes
import numpy as np
import matplotlib.pyplot as plt
import glob
from scipy.stats.stats import pearsonr
from matplotlib.backends.backend_pdf import PdfPages
pdf_pages = PdfPages('correlation.pdf')

data_simu = np.loadtxt("main/data_simu.txt")
data_real = np.loadtxt("main/data_med.txt")

lww = 10.0
opa = 0.8
plt.rcParams.update({'font.size': 18})
colors = plt.cm.viridis(np.linspace(1,0,3))

minn = 0.0
maxx = 15.0
#M1
fig, ax = plt.subplots(figsize=(7.6,7))
ax.grid(b=True,which='both',axis='y')
ax.grid(b=True,which='both',axis='x')
ax.set_xlabel(r'$V_{med}$ $[m/s]$')
ax.set_ylabel(r'$V_{sim}$ $[m/s]$')
ax.set_ylim(minn,maxx)
ax.set_xlim(minn,maxx)
ax.set_title("M1")

print(pearsonr(data_real[:,1], data_simu[:,1]))
print(pearsonr(data_real[:,2], data_simu[:,2]))
print(pearsonr(data_real[:,3], data_simu[:,3]))
print()

ax.plot(data_real[:,1],data_simu[:,1],"o",markersize=lww,alpha=opa,label=r"$z=9.0$ [m] $r=-0.173$",color=colors[0])
ax.plot(data_real[:,2],data_simu[:,2],"o",markersize=lww,alpha=opa,label=r"$z=5.0$ [m] $r=-0.317$",color=colors[1])
ax.plot(data_real[:,3],data_simu[:,3],"o",markersize=lww,alpha=opa,label=r"$z=2.0$ [m] $r=-0.410$",color=colors[2])
ax.legend(ncol=1,fontsize='small',markerscale=1)
fig.tight_layout()
pdf_pages.savefig(fig)

#M2
fig, ax = plt.subplots(figsize=(7.6,7))
ax.grid(b=True,which='both',axis='y')
ax.grid(b=True,which='both',axis='x')
ax.set_xlabel(r'$V_{med}$ $[m/s]$')
ax.set_ylabel(r'$V_{sim}$ $[m/s]$')
ax.set_ylim(minn,maxx)
ax.set_xlim(minn,maxx)
ax.set_title("M2")

print(pearsonr(data_real[:,7], data_simu[:,7]))
print(pearsonr(data_real[:,8], data_simu[:,8]))
print(pearsonr(data_real[:,9], data_simu[:,9]))
print()

ax.plot(data_real[:,7],data_simu[:,7],"o",markersize=lww,alpha=opa,label=r"$z=9.0$ [m] $r=0.047$",color=colors[0])
ax.plot(data_real[:,8],data_simu[:,8],"o",markersize=lww,alpha=opa,label=r"$z=5.0$ [m] $r=0.050$",color=colors[1])
ax.plot(data_real[:,9],data_simu[:,9],"o",markersize=lww,alpha=opa,label=r"$z=2.0$ [m] $r=0.104$",color=colors[2])
ax.legend(ncol=1,fontsize='small',markerscale=1)
fig.tight_layout()
pdf_pages.savefig(fig)

#M3
fig, ax = plt.subplots(figsize=(7.6,7))
ax.grid(b=True,which='both',axis='y')
ax.grid(b=True,which='both',axis='x')
ax.set_xlabel(r'$V_{med}$ $[m/s]$')
ax.set_ylabel(r'$V_{sim}$ $[m/s]$')
ax.set_ylim(minn,maxx)
ax.set_xlim(minn,maxx)
ax.set_title("M3")

print(pearsonr(data_real[:,12], data_simu[:,12]))
print(pearsonr(data_real[:,13], data_simu[:,13]))
print(pearsonr(data_real[:,14], data_simu[:,14]))
print()

ax.plot(data_real[:,12],data_simu[:,12],"o",markersize=lww,alpha=opa,label=r"$z=9.0$ [m] $r=-0.034$",color=colors[0])
ax.plot(data_real[:,13],data_simu[:,13],"o",markersize=lww,alpha=opa,label=r"$z=5.0$ [m] $r=-0.056$",color=colors[1])
ax.plot(data_real[:,14],data_simu[:,14],"o",markersize=lww,alpha=opa,label=r"$z=2.0$ [m] $r=-0.109$",color=colors[2])
ax.legend(ncol=1,fontsize='small',markerscale=1)
fig.tight_layout()
pdf_pages.savefig(fig)

#M4
fig, ax = plt.subplots(figsize=(7.6,7))
ax.grid(b=True,which='both',axis='y')
ax.grid(b=True,which='both',axis='x')
ax.set_xlabel(r'$V_{med}$ $[m/s]$')
ax.set_ylabel(r'$V_{sim}$ $[m/s]$')
ax.set_ylim(minn,maxx)
ax.set_xlim(minn,maxx)
ax.set_title("M4")

print(pearsonr(data_real[:,17], data_simu[:,17]))
print(pearsonr(data_real[:,18], data_simu[:,18]))
print(pearsonr(data_real[:,19], data_simu[:,19]))
print()

ax.plot(data_real[:,17],data_simu[:,17],"o",markersize=lww,alpha=opa,label=r"$z=9.0$ [m] $r=$    $0.241$",color=colors[0])
ax.plot(data_real[:,18],data_simu[:,18],"o",markersize=lww,alpha=opa,label=r"$z=5.0$ [m] $r=-0.243$",color=colors[1])
ax.plot(data_real[:,19],data_simu[:,19],"o",markersize=lww,alpha=opa,label=r"$z=2.0$ [m] $r=-0.123$",color=colors[2])
ax.legend(ncol=1,fontsize='small',markerscale=1)
fig.tight_layout()
pdf_pages.savefig(fig)

#M5
fig, ax = plt.subplots(figsize=(7.6,7))
ax.grid(b=True,which='both',axis='y')
ax.grid(b=True,which='both',axis='x')
ax.set_xlabel(r'$V_{med}$ $[m/s]$')
ax.set_ylabel(r'$V_{sim}$ $[m/s]$')
ax.set_ylim(minn,maxx)
ax.set_xlim(minn,maxx)
ax.set_title("M5")

print(pearsonr(data_real[:,23], data_simu[:,23]))
print(pearsonr(data_real[:,24], data_simu[:,24]))
print()

ax.plot(data_real[:,23],data_simu[:,23],"o",markersize=lww,alpha=opa,label=r"$z=5.0$ [m] $r=0.058$",color=colors[1])
ax.plot(data_real[:,24],data_simu[:,24],"o",markersize=lww,alpha=opa,label=r"$z=2.0$ [m] $r=0.064$",color=colors[2])
ax.legend(ncol=1,fontsize='small',markerscale=1)
fig.tight_layout()
pdf_pages.savefig(fig)

#M6
fig, ax = plt.subplots(figsize=(7.6,7))
ax.grid(b=True,which='both',axis='y')
ax.grid(b=True,which='both',axis='x')
ax.set_xlabel(r'$V_{med}$ $[m/s]$')
ax.set_ylabel(r'$V_{sim}$ $[m/s]$')
ax.set_ylim(minn,maxx)
ax.set_xlim(minn,maxx)
ax.set_title("M6")

print(pearsonr(data_real[:,27], data_simu[:,27]))
print(pearsonr(data_real[:,28], data_simu[:,28]))
print(pearsonr(data_real[:,29], data_simu[:,29]))
print()

ax.plot(data_real[:,27],data_simu[:,27],"o",markersize=lww,alpha=opa,label=r"$z=9.0$ [m] $r=$    $0.009$",color=colors[0])
ax.plot(data_real[:,28],data_simu[:,28],"o",markersize=lww,alpha=opa,label=r"$z=5.0$ [m] $r=-0.003$",color=colors[1])
ax.plot(data_real[:,29],data_simu[:,29],"o",markersize=lww,alpha=opa,label=r"$z=2.0$ [m] $r=-0.611$",color=colors[2])
ax.legend(ncol=1,fontsize='small',markerscale=1)
fig.tight_layout()
pdf_pages.savefig(fig)

#M7
fig, ax = plt.subplots(figsize=(7.6,7))
ax.grid(b=True,which='both',axis='y')
ax.grid(b=True,which='both',axis='x')
ax.set_xlabel(r'$V_{med}$ $[m/s]$')
ax.set_ylabel(r'$V_{sim}$ $[m/s]$')
ax.set_ylim(minn,maxx)
ax.set_xlim(minn,maxx)
ax.set_title("M7")

print(pearsonr(data_real[:,32], data_simu[:,32]))
print(pearsonr(data_real[:,33], data_simu[:,33]))
print()

ax.plot(data_real[:,32],data_simu[:,32],"o",markersize=lww,alpha=opa,label=r"$z=5.0$ [m] $r=-0.264$",color=colors[1])
ax.plot(data_real[:,33],data_simu[:,33],"o",markersize=lww,alpha=opa,label=r"$z=2.0$ [m] $r=-0.189$",color=colors[2])
ax.legend(ncol=1,fontsize='small',markerscale=1)
fig.tight_layout()
pdf_pages.savefig(fig)

#M8
fig, ax = plt.subplots(figsize=(7.6,7))
ax.grid(b=True,which='both',axis='y')
ax.grid(b=True,which='both',axis='x')
ax.set_xlabel(r'$V_{med}$ $[m/s]$')
ax.set_ylabel(r'$V_{sim}$ $[m/s]$')
ax.set_ylim(minn,maxx)
ax.set_xlim(minn,maxx)
ax.set_title("M8")

print(pearsonr(data_real[:,36], data_simu[:,36]))
print(pearsonr(data_real[:,37], data_simu[:,37]))
print(pearsonr(data_real[:,38], data_simu[:,38]))
print()

ax.plot(data_real[:,36],data_simu[:,36],"o",markersize=lww,alpha=opa,label=r"$z=9.0$ [m] $r=-0.162$",color=colors[0])
ax.plot(data_real[:,37],data_simu[:,37],"o",markersize=lww,alpha=opa,label=r"$z=5.0$ [m] $r=-0.256$",color=colors[1])
ax.plot(data_real[:,38],data_simu[:,38],"o",markersize=lww,alpha=opa,label=r"$z=2.0$ [m] $r=-0.642$",color=colors[2])
ax.legend(ncol=1,fontsize='small',markerscale=1)
fig.tight_layout()
pdf_pages.savefig(fig)

pdf_pages.close()