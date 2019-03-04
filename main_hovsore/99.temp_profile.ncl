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
FILES                       = systemfunc (" ls -1 " + DATADir + "wrfout_d07_*")
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
;Inicialización de matrices de temperatura
theta               = new((/dimZ,ntimes+1/),float)
theta  = 0.
;1. Selección del punto
;Ubicación del punto de control en las coordenadas del modelo (mass points)
loc         = wrf_user_ll_to_ij(a[0], 8.1509, 56.4406, True)
locX        = loc(0)
locY        = loc(1)
if ( locX .lt. 1 .or. locX .gt. dimX .or. locY .lt. 1 .or. locY .gt. dimY )
    print("Fuera de dominio")
else 
    locX      = locX - 1
    locY      = locY - 1
    ;Almacenamiento de la altura del terreno
    ter       = wrf_user_getvar(a[0],"HGT",0)
    hgt_point = ter(locX,locY)
    ;LOOP POR CADA GRÁFICO DEL PROMEDIO MOVIL
    ;2. Creación del arreglo
    do ii = 0,ntimes-1,1 ;Loop por por cada gráfico
        print("        Obteniendo datos para hora "+(ii+1)+":")
        theta_data  = wrf_user_getvar(a[ii],"T",0)
        theta(:,ii+1) = theta_data(:,locX,locY) + 300.
    end do
end if
z_data      = wrf_user_getvar(a[0],"z",0)
z           = z_data(:,locX,locY) - hgt_point
theta(:,0) = z
;3. Escritura en txt
opt   = True
opt@fout = "99.test.txt"
write_matrix(theta,ntimes + 1 + "f16.10",opt)
end