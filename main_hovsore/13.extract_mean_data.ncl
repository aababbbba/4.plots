;ust = 0.5272063
;Carga de paquetes
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
begin
print("        Cargando archivos...")
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

eta_max = 20
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
loc         = wrf_user_ll_to_ij(a[0], 8.1509, 56.4406, True)
locX        = loc(0)
locY        = loc(1)
if ( locX .lt. 1 .or. locX .gt. dimX .or. locY .lt. 1 .or. locY .gt. dimY )
    print("Fuera de dominio")
else 
    locX      = locX - 1
    locY      = locY - 1
end if
len         = 0
ter         = wrf_user_getvar(a[0],"HGT",0)
hgt_point   = ter(locX,locY)
;Variables a rescatar
z   = new((/eta_max/),float)
z   = 0
V   = z
tke = z 
ust = 0.0 
xkmv = z 
xkmh = z 
def13 = z 
def23 = z

data_min = 36
data_max = 48
print("promedio entre:"+times(data_min)+" y "+times(data_max))
;Calculo de promedio
do it = data_min,data_max,1
    print("     Datos en tiempo: " + times(it))
    len = len + 1
    z_data      = wrf_user_getvar(a[it],"z",0)
    tke_data    = wrf_user_getvar(a[it],"TKE",0)
    def11_data  = wrf_user_getvar(a[it],"DEFOR11",0)
    def12_data  = wrf_user_getvar(a[it],"DEFOR12",0)
    def22_data  = wrf_user_getvar(a[it],"DEFOR22",0)
    def23_aux   = wrf_user_getvar(a[it],"DEFOR23",0)
    def33_aux   = wrf_user_getvar(a[it],"DEFOR33",0)
    def13_aux   = wrf_user_getvar(a[it],"DEFOR13",0)
    def23_data  = wrf_user_unstagger(def23_aux, "Z")
    def33_data  = wrf_user_unstagger(def33_aux, "Z")
    def13_data  = wrf_user_unstagger(def13_aux, "Z")
    xkmv_data   = wrf_user_getvar(a[it],"XKMV",0)
    xkmh_data   = wrf_user_getvar(a[it],"XKMH",0)
    uvm         = wrf_user_getvar(a[it],"uvmet",0) ;Extrae las componente u,v rotadas a la cord de la tierra y en los mass point
    u_data      = uvm(0,:,:,:) 
    v_data      = uvm(1,:,:,:)
    ust_data    = wrf_user_getvar(a[it],"UST",0)
    ;loop por los niveles
    ust = ust + ust_data(locX,locY)
    do jj = 0,eta_max-1,1
        z(jj)       = z(jj)     + z_data(jj,locX,locY)
        def13(jj)   = def13(jj) + def13_data(jj,locX,locY)
        def23(jj)   = def23(jj) + def23_data(jj,locX,locY)
        tke(jj)     = tke(jj)   + tke_data(jj,locX,locY)
        xkmv(jj)    = xkmv(jj)  + xkmv_data(jj,locX,locY)
        xkmh(jj)    = xkmh(jj)  + xkmh_data(jj,locX,locY)
        V(jj)       = V(jj)     + sqrt(u_data(jj,locX,locY)^2.0 + v_data(jj,locX,locY)^2.0)
    end do  
end do
z       = z/len - hgt_point
def13   = def13/len
def23   = def23/len
tke     = tke/len
xkmv    = xkmv/len
xkmh    = xkmh/len
V       = V/len
ust     = ust/len 

print(ust)

aux_write = new((/eta_max,11/), float)
aux_write = 0
aux_write(:,0) = z
aux_write(:,1) = V
aux_write(:,2) = tke
aux_write(:,3) = xkmh
aux_write(:,4) = xkmv
aux_write(:,5) = def13
aux_write(:,6) = def23

phi     = new((/eta_max/),float)
phi     = 0.0
z_grad  = phi

;Cálculo de Phi
do jj=1,(eta_max-1)
    phi(jj-1) = (V(jj)-V(jj-1))/(z(jj)-z(jj-1))
    z_grad(jj-1) = (z(jj)+z(jj-1))*0.5
    phi(jj-1) = phi(jj-1)*z_grad(jj-1)*0.4/ust
end do

aux_write(:,7)  = z_grad
aux_write(:,8)  = phi
aux_write(:,9)  = tke/(ust^2.0)
calc_tau13      = (xkmv*def13)/(ust^2.0)
calc_tau23      = (xkmv*def23)/(ust^2.0)
aux_write(:,10) = -1.0*sqrt(calc_tau13^2.0 + calc_tau23^2.0)

opt      = True
opt@fout = "main/data_mean/data_mean.txt"
;write_matrix(z,dimX + "f28.21",opt)
write_matrix(aux_write,"11f18.12",opt)
;print(z)
end