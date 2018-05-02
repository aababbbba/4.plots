from scipy import signal
from matplotlib.backends.backend_pdf import PdfPages
import matplotlib.pyplot as plt
import numpy as np

pdf_pages = PdfPages('spectra.pdf')
for ll in range(15):
	print('Trabajando en nivel %s...'%(ll+1))
	nivel = ll+1

	u= []
	v= []
	t= []
	uu= []

	f = open('../loc1.d06.UU', 'r')
	for i in range(364501):
		dummy = f.readline()
	for line in f:
	    line = line.strip()
	    columns = line.split()
	    u.append(float(columns[nivel]))
	    t.append(float(columns[0]))
	f.close()

	g = open('../loc1.d06.VV', 'r')
	for i in range(364501):
		dummy = g.readline()
	for line in g:
	    line = line.strip()
	    columns = line.split()
	    v.append(float(columns[nivel]))
	g.close()

	for i in range(len(u)):
		uu.append(np.sqrt(u[i]**2.0+v[i]**2.0))

	fs = 243.0/12.0
	f, Pxx_den = signal.periodogram(uu, fs)

	x1=0.005
	x2=0.5
	y1=0.0001*x1**(-2.0/3.0)
	y2=0.0001*x2**(-2.0/3.0)
	x=[x1,x2]
	y=[y1,y2]

	plot=plt.figure()
	plt.rc('text', usetex=True)
	plt.rc('font', family='serif')
	plt.loglog(f, f*Pxx_den)
	plt.loglog(x,y)
	plt.grid(True,which="both",ls="-")
	plt.grid(True,which="majorminor",ls="-", color='0.35')
	plt.xlabel(r'f $[1/s]$')
	plt.ylabel(r'f$\cdot$ PSD $[m^2/s^{-2}]$')
	plt.ylim((1e-11,10))
	plt.title(r'Horizontal Velocity Spectra for $\eta_{l}=%s$'%(nivel),fontsize=16)
	#plot.savefig("spectra.pdf", bbox_inches='tight')
	pdf_pages.savefig(plot)
print('Fin')
pdf_pages.close()