namesu = ["0600","0610","0620","0630","0640","0650",\
          "0700","0710","0720","0730","0740","0750",\
          "0800","0810","0820","0830","0840","0850",\
          "0900","0910","0920","0930","0940","0950",\
          "1000","1010","1020","1030","1040","1050",\
          "1100","1110","1120","1130","1140","1150",\
          "1200"]
#para UU
arch_write  = "../metm.d07.UUmod"
b  = open(arch_write,"w")
for i in namesu:
	print(i)
	arch_leer1  = "../resultados/tslist"+i+"/metm.d07.UU"
	a  = open(arch_leer1,"r")
	f1 = a.readlines()
	j  = 0
	for x in f1:
		if (i!="0600" and j!=0):
			aux = float(x[5:13])+n_final
			aux2 = f"{aux:.6f}"
			x = "".join((x[:5],aux2,x[13:]))
		else:
			pass
		if (j==0 and i=="0600"):
			print("true")
			b.write(x)
		elif (j==0):
			pass
		else:
			if (j%10==0 or j==1):
				b.write(x)
		if (j==len(f1)-1):
			n_final = float(x[5:13])
		j = j+1
	a.close()
b.close()

#para VV
arch_write  = "../metm.d07.VVmod"
b  = open(arch_write,"w")
for i in namesu:
	print(i)
	arch_leer1  = "../resultados/tslist"+i+"/metm.d07.VV"
	a  = open(arch_leer1,"r")
	f1 = a.readlines()
	j  = 0
	for x in f1:
		if (i!="0600" and j!=0):
			aux = float(x[5:13])+n_final
			aux2 = f"{aux:.6f}"
			x = "".join((x[:5],aux2,x[13:]))
		else:
			pass
		if (j==0 and i=="0600"):
			print("true")
			b.write(x)
		elif (j==0):
			pass
		else:
			if (j%10==0 or j==1):
				b.write(x)
		if (j==len(f1)-1):
			n_final = float(x[5:13])
		j = j+1
	a.close()
b.close()