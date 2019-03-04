;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; Código hecho por Pablo Andrés Cárdenas Zamorano - UTFSM - 2018 ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Extrae a la velocidad del viento u y v y la escribe en un txt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Carga de paquetes
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
begin

;Información de la carpeta contenedora
DATADir     = "../1.wrfouts/"
FILES       = systemfunc (" ls -1 " + DATADir + "wrfout_d07_*")
numFILES    = dimsizes(FILES)
;Almacenamiento de los archivos
a           = addfiles(FILES,"r")
;Obtención de pasos de tiempo para los archivos
times       = wrf_user_getvar(a, "times", -1)
ntimes      = dimsizes(times)
mdims       = getfilevardimsizes(a[0],"P")
nd          = dimsizes(mdims)
dimX        = mdims(nd-1)
dimY        = mdims(nd-2)

optu   = True
optv   = True
optvv  = True
;Inicio del ciclo que recorre todos los pasos de tiempo
do it = 0,ntimes-1,1
    uvm                     = wrf_user_getvar(a[it],"uvmet",0)
    auxtime = "t"+sprinti("%0.3i",it)
    do eta = 0,19,1
        u = uvm(0,eta,:,:)
        v = uvm(1,eta,:,:)
        auxeta  = "eta"+sprinti("%0.2i",eta+1)
        optu@fout = "data/raw/"+auxeta+"/"+"u_"+auxeta+"_"+times(it)+".txt"
        optv@fout = "data/raw/"+auxeta+"/"+"v_"+auxeta+"_"+times(it)+".txt"
        optvv@fout = "data/raw/"+auxeta+"/"+"V_"+auxeta+"_"+times(it)+".txt"
        write_matrix(u,dimX + "f28.21",optu)
        write_matrix(v,dimX + "f28.21",optv)
        write_matrix(sqrt(u^2+v^2),dimX + "f28.21", optvv)
    end do
end do
end