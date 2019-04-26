;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; Código hecho por Pablo Andrés Cárdenas Zamorano - UTFSM - 2019 ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 1. Extrae la serie de tiempo para la magnitud de la velocidad en los puntos de interpolación
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Carga de paquetes
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
begin
;Obtención de datos
print("        Cargando datos...")
datau = readAsciiTable("../metm.d07.UUmod", 21, "float", 1)
datav = readAsciiTable("../metm.d07.VVmod", 21, "float", 1)
;Obteción de datos para la alura de cada nivel
DATADir     = "../"
FILES       = systemfunc (" ls -1 " + DATADir + "wrfout_d07_*")
a           = addfiles(FILES,"r")
mdims       = getfilevardimsizes(a[0],"P")
nd          = dimsizes(mdims)
dimX        = mdims(nd-1)
dimY        = mdims(nd-2)
;Obtención de altura para cada nivel
dataLON     =  8.150896
dataLAT     = 56.440582
loc         = wrf_user_ll_to_ij(a[0], dataLON, dataLAT, True)
locX        = loc(0)
locY        = loc(1)
hgt         = wrf_user_getvar(a[0], "HGT",0)
if ( locX .lt. 1 .or. locX .gt. dimX .or. locY .lt. 1 .or. locY .gt. dimY )
    print("Punto fuera de dominio")
else 
    locX    = locX - 1
    locY    = locY - 1
end if
z           = wrf_user_getvar(a[0],"z",0)
auxz        = z(:,locX,locY) - hgt(locX,locY)
print(auxz)
;Alturas a interpolar
magu_n1 = sqrt(datau(:,1)^2.0 + datav(:,1)^2.0)
magu_n4 = sqrt(datau(:,4)^2.0 + datav(:,4)^2.0)
magu_n6 = sqrt(datau(:,6)^2.0 + datav(:,6)^2.0)
magu_n7 = sqrt(datau(:,7)^2.0 + datav(:,7)^2.0)
magu_n8 = sqrt(datau(:,8)^2.0 + datav(:,8)^2.0)
magu_n9 = sqrt(datau(:,9)^2.0 + datav(:,9)^2.0)
;Constantes
z0 = 15./1000. ;Lo debería entregar el modelo
;interpolación10m
zr = auxz(0)
print(zr)
magu_10m = magu_n1*(log(10.0/z0)/log(zr/z0))
; ;interpolación40m
zr = auxz(3)
print(zr)
magu_40m = magu_n4*(log(40.0/z0)/log(zr/z0))
; ;interpolación60m
zr = auxz(5)
print(zr)
magu_60m = magu_n6*(log(60.0/z0)/log(zr/z0))
; ;interpolación80m
zr = auxz(6)
print(zr)
magu_80m = magu_n7*(log(80.0/z0)/log(zr/z0))
; ;interpolación100m
zr = auxz(7)
print(zr)
magu_100m = magu_n8*(log(100.0/z0)/log(zr/z0))
; ;interpolación116.5m
zr = auxz(8)
;print(zr)
magu_116m = magu_n9*(log(116.5/z0)/log(zr/z0))

aux=dimsizes(datau(:,0))
;Inicialización de matriz de almacenamiento
matrix  = new((/aux,7/),float)
matrix  = 0.
;print(matrix)
matrix(:,0)=datau(:,0)+6.0
matrix(:,1)=magu_116m
matrix(:,2)=magu_100m
matrix(:,3)=magu_80m
matrix(:,4)=magu_60m
matrix(:,5)=magu_40m
matrix(:,6)=magu_10m
;Escritura en una matriz
opt         = True
opt@fout    = "main/data_interpol_raw.txt"
write_matrix(matrix,7 + "f16.10",opt)
end