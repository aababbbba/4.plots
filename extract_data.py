mast = "etm"
main = ["m1.d08.UU","m1.d08.VV","m2.d08.UU","m2.d08.VV","m3.d08.UU","m3.d08.VV","m4.d08.UU","m4.d08.VV","m5.d08.UU","m5.d08.VV","m6.d08.UU","m6.d08.VV","m7.d08.UU","m7.d08.VV","m8.d08.UU","m8.d08.VV"]

for i in main:
	print(i)
	arch_leer1  = i
	arch_write  = i+"mod"

	b  = open(arch_write,"w")
	a  = open(arch_leer1,"r")

	f1 = a.readlines()
	j  = 0
	for x in f1:
		if (j%5000==0):
			b.write(x)
		if (j==1):
			b.write(x)
		j = j+1

	a.close()
	b.close()