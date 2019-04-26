;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; Código hecho por Pablo Andrés Cárdenas Zamorano - UTFSM - 2018 ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 1. Selecciona un punto del dominio de WRF
; 2. Extrae los perfiles de temperatura y los almacena en un arreglo 
; 3. Guarda los arreglos en un .txt para luego ser graficados en Python 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Carga de paquetes
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
begin
;Ubicación de Archivos
DATADir                     = "../"
FILES                       = systemfunc (" ls -1 " + DATADir + "wrfout_d08_*")
numFILES                    = dimsizes(FILES)
;Almacenamiento de archivos
a                           = addfiles(FILES,"r")
times                       = wrf_user_getvar(a, "times", -1)
ntimes                      = dimsizes(times)
;Dimensiones del dominio
mdims                       = getfilevardimsizes(a[0],"P")
nd                          = dimsizes(mdims)
dimZ                        = mdims(nd-3)
dimY                        = mdims(nd-2)
dimX                        = mdims(nd-1)
ter                         = wrf_user_getvar(a[0],"HGT",0)
z_data                      = wrf_user_getvar(a[0],"z",0)
;Inicialización de matrices de temperatura
theta  = new((/dimZ,ntimes+1/),float)
theta  = 0.
;1. Selección del punto
;Ubicación del punto de control en las coordenadas del modelo (mass points)
print("Sacando datos para M1...")
dataLON     = 12.09760
dataLAT     = 55.70332
loc         = wrf_user_ll_to_ij(a[0], dataLON, dataLAT, True)
locX        = loc(0)
locY        = loc(1)
locX        = locX - 1
locY        = locY - 1
hgt_point = ter(locX,locY)
;2. Creación del arreglo
do ii = 0,ntimes-1,1 ;Loop por por cada tiempo
    print("        Obteniendo datos para hora "+(ii+1)+":")
    theta_data  = wrf_user_getvar(a[ii],"T",0)
    theta(:,ii+1) = theta_data(:,locX,locY) + 300.
end do
z           = z_data(:,locX,locY) - hgt_point
theta(:,0)  = z
;3. Escritura en txt
opt   = True
opt@fout = "main/theta_data/m1.txt"
write_matrix(theta,ntimes + 1 + "f16.10",opt)


print("Sacando datos para M2...")
dataLON     = 12.09787
dataLAT     = 55.70340
loc         = wrf_user_ll_to_ij(a[0], dataLON, dataLAT, True)
locX        = loc(0)
locY        = loc(1)
locX        = locX - 1
locY        = locY - 1
hgt_point = ter(locX,locY)
;2. Creación del arreglo
do ii = 0,ntimes-1,1 ;Loop por por cada tiempo
    print("        Obteniendo datos para hora "+(ii+1)+":")
    theta_data  = wrf_user_getvar(a[ii],"T",0)
    theta(:,ii+1) = theta_data(:,locX,locY) + 300.
end do
z           = z_data(:,locX,locY) - hgt_point
theta(:,0)  = z
;3. Escritura en txt
opt   = True
opt@fout = "main/theta_data/m2.txt"
write_matrix(theta,ntimes + 1 + "f16.10",opt)


print("Sacando datos para M3...")
dataLON     = 12.09850
dataLAT     = 55.70360
loc         = wrf_user_ll_to_ij(a[0], dataLON, dataLAT, True)
locX        = loc(0)
locY        = loc(1)
locX        = locX - 1
locY        = locY - 1
hgt_point = ter(locX,locY)
;2. Creación del arreglo
do ii = 0,ntimes-1,1 ;Loop por por cada tiempo
    print("        Obteniendo datos para hora "+(ii+1)+":")
    theta_data  = wrf_user_getvar(a[ii],"T",0)
    theta(:,ii+1) = theta_data(:,locX,locY) + 300.
end do
z           = z_data(:,locX,locY) - hgt_point
theta(:,0)  = z
;3. Escritura en txt
opt   = True
opt@fout = "main/theta_data/m3.txt"
write_matrix(theta,ntimes + 1 + "f16.10",opt)


print("Sacando datos para M4...")
dataLON     = 12.09927
dataLAT     = 55.70386
loc         = wrf_user_ll_to_ij(a[0], dataLON, dataLAT, True)
locX        = loc(0)
locY        = loc(1)
locX        = locX - 1
locY        = locY - 1
hgt_point = ter(locX,locY)
;2. Creación del arreglo
do ii = 0,ntimes-1,1 ;Loop por por cada tiempo
    print("        Obteniendo datos para hora "+(ii+1)+":")
    theta_data  = wrf_user_getvar(a[ii],"T",0)
    theta(:,ii+1) = theta_data(:,locX,locY) + 300.
end do
z           = z_data(:,locX,locY) - hgt_point
theta(:,0)  = z
;3. Escritura en txt
opt   = True
opt@fout = "main/theta_data/m4.txt"
write_matrix(theta,ntimes + 1 + "f16.10",opt)


print("Sacando datos para M5...")
dataLON     = 12.09848
dataLAT     = 55.70315
loc         = wrf_user_ll_to_ij(a[0], dataLON, dataLAT, True)
locX        = loc(0)
locY        = loc(1)
locX        = locX - 1
locY        = locY - 1
hgt_point = ter(locX,locY)
;2. Creación del arreglo
do ii = 0,ntimes-1,1 ;Loop por por cada tiempo
    print("        Obteniendo datos para hora "+(ii+1)+":")
    theta_data  = wrf_user_getvar(a[ii],"T",0)
    theta(:,ii+1) = theta_data(:,locX,locY) + 300.
end do
z           = z_data(:,locX,locY) - hgt_point
theta(:,0)  = z
;3. Escritura en txt
opt   = True
opt@fout = "main/theta_data/m5.txt"
write_matrix(theta,ntimes + 1 + "f16.10",opt)


print("Sacando datos para M6...")
dataLON     = 12.09770
dataLAT     = 55.70360
loc         = wrf_user_ll_to_ij(a[0], dataLON, dataLAT, True)
locX        = loc(0)
locY        = loc(1)
locX        = locX - 1
locY        = locY - 1
hgt_point = ter(locX,locY)
;2. Creación del arreglo
do ii = 0,ntimes-1,1 ;Loop por por cada tiempo
    print("        Obteniendo datos para hora "+(ii+1)+":")
    theta_data  = wrf_user_getvar(a[ii],"T",0)
    theta(:,ii+1) = theta_data(:,locX,locY) + 300.
end do
z           = z_data(:,locX,locY) - hgt_point
theta(:,0)  = z
;3. Escritura en txt
opt   = True
opt@fout = "main/theta_data/m6.txt"
write_matrix(theta,ntimes + 1 + "f16.10",opt)


print("Sacando datos para M7...")
dataLON     = 12.09735
dataLAT     = 55.70360
loc         = wrf_user_ll_to_ij(a[0], dataLON, dataLAT, True)
locX        = loc(0)
locY        = loc(1)
locX        = locX - 1
locY        = locY - 1
hgt_point = ter(locX,locY)
;2. Creación del arreglo
do ii = 0,ntimes-1,1 ;Loop por por cada tiempo
    print("        Obteniendo datos para hora "+(ii+1)+":")
    theta_data  = wrf_user_getvar(a[ii],"T",0)
    theta(:,ii+1) = theta_data(:,locX,locY) + 300.
end do
z           = z_data(:,locX,locY) - hgt_point
theta(:,0)  = z
;3. Escritura en txt
opt   = True
opt@fout = "main/theta_data/m7.txt"
write_matrix(theta,ntimes + 1 + "f16.10",opt)


print("Sacando datos para M8...")
dataLON     = 12.09992
dataLAT     = 55.70360
loc         = wrf_user_ll_to_ij(a[0], dataLON, dataLAT, True)
locX        = loc(0)
locY        = loc(1)
locX        = locX - 1
locY        = locY - 1
hgt_point = ter(locX,locY)
;2. Creación del arreglo
do ii = 0,ntimes-1,1 ;Loop por por cada tiempo
    print("        Obteniendo datos para hora "+(ii+1)+":")
    theta_data  = wrf_user_getvar(a[ii],"T",0)
    theta(:,ii+1) = theta_data(:,locX,locY) + 300.
end do
z           = z_data(:,locX,locY) - hgt_point
theta(:,0)  = z
;3. Escritura en txt
opt   = True
opt@fout = "main/theta_data/m8.txt"
write_matrix(theta,ntimes + 1 + "f16.10",opt)

end