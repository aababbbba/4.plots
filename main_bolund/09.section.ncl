;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; Código hecho por Pablo Andrés Cárdenas Zamorano - UTFSM - 2019 ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Grafica la magnitud del viento en el corte transversal a 240° en la colina de bolund
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Carga de paquetes
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
begin

;Información de la carpeta contenedora
DATADir                     = "../"
FILES                       = systemfunc (" ls -1 " + DATADir + "wrfout_d08_*")
numFILES                    = dimsizes(FILES)
;Inicialización del gráfico
type                          = "svg"
wks                         = gsn_open_wks(type,"cross/svg/cross_section")
;Almacenamiento de los archivos a plotear 
a                           = addfiles(FILES,"r")
;Obtención de pasos de tiempo para los archivos
times                       = wrf_user_getvar(a, "times", -1)
ntimes                      = dimsizes(times)
;Dimensiones del corte
start_lat       = 55.70313
end_lat         = 55.70442
start_lon       = 12.09700
end_lon         = 12.10100
;Parámetros de los gráficos
opt                       = True
opt@latlon                = True
opt@linecoords            = True
auxz                      = fspan(0, 40, 6000)
opt@levels                = auxz
res                       = True
res@cnLineColor           = "Black"
res@cnLineThicknessF      = 1.0
res@cnLevelSelectionMode  = "ManualLevels"
res@gsnMaximize           = True
res@vpWidthF              = 0.6  
res@vpHeightF             = 0.15*0.533333
res@cnFillOn              = True
res@cnLinesOn             = True
res@cnLineLabelsOn        = False
res@lbAutoManage          = False
res@lbLabelStride         = 1.
res@gsnSpreadColorStart   = 1
res@gsnSpreadColorEnd     = -3
res@lbOrientation         = "Vertical"
res@lbLabelFontHeightF    = 0.008

res@cnLevelSpacingF       = 0.5
res@cnMinLevelValF        = 0.0
res@cnMaxLevelValF        = 12.0
res@lbOrientation         = "Horizontal"
;res@lbBoxLinesOn          = False
res@lbTitleFontHeightF    = 0.008
res@lbTitleString         = "V (m/s)"

res@tiMainString          = "Corte Transversal M1-M4"
res@tiMainFontHeightF     = 0.012
res@gsnStringFontHeightF  = 0.008
res@tmXBLabelFontHeightF  = 0.007
res@tmYLLabelFontHeightF  = 0.008
;res@tmXBLabelAngleF       = 45.
res@cnFillPalette         = "MPL_viridis"
ll_step                   = 15
res@tmXBMode              = "Explicit"

titulos = (/"06:00","06:05","06:10","06:15","06:20","06:25",\
            "06:30","06:35","06:40","06:45","06:50","06:55",\
            "07:00","07:05","07:10","07:15","07:20","07:25",\
            "07:30","07:35","07:40","07:45","07:50","07:55",\
            "08:00","08:05","08:10","08:15","08:20","08:25",\
            "08:30","08:35","08:40","08:45","08:50","08:55",\
            "09:00","09:05","09:10","09:15","09:20","09:25",\
            "09:30","09:35","09:40","09:45","09:50","09:55",\
            "10:00","10:05","10:10","10:15","10:20","10:25",\
            "10:30","10:35","10:40","10:45","10:50","10:55",\
            "11:00","11:05","11:10","11:15","11:20","11:25",\
            "11:30","11:35","11:40","11:45","11:50","11:55",\
            "12:00","12:05","12:10","12:15","12:20","12:25",\
            "12:30","12:35","12:40","12:45","12:50","12:55",\
            "13:00","13:05","13:10","13:15","13:20","13:25",\
            "13:30","13:35","13:40","13:45","13:50","13:55",\
            "14:00","14:05","14:10","14:15","14:20","14:25",\
            "14:30","14:35","14:40","14:45","14:50","14:55",\
            "15:00","15:05","15:10","15:15","15:20","15:25",\
            "15:30","15:35","15:40","15:45","15:50","15:55",\
            "16:00","16:05","16:10","16:15","16:20","16:25",\
            "16:30","16:35","16:40","16:45","16:50","16:55",\
            "17:00","17:05","17:10","17:15","17:20","17:25",\
            "17:30","17:35","17:40","17:45","17:50","17:55",\
            "18:00","18:05","18:10","18:15","18:20","18:25",\
            "18:30","18:35","18:40","18:45","18:50","18:55",\
            "19:00","19:05","19:10","19:15","19:20","19:25",\
            "19:30","19:35","19:40","19:45","19:50","19:55",\
            "20:00","20:05","20:10","20:15","20:20","20:25",\
            "20:30","20:35","20:40","20:45","20:50","20:55",\
            "21:00","21:05","21:10","21:15","21:20","21:25",\
            "21:30","21:35","21:40","21:45","21:50","21:55",\
            "22:00"/)
;ITERACION
do it = 0,ntimes-1,1
;it = ntimes-1
    ;Comienzo de creación de gráficos
    print("     Graficando en tiempo: " + times(it))
    z    = wrf_user_getvar(a[it], "z",0)
    lats = wrf_user_getvar(a[it], "lat",0)
    lons = wrf_user_getvar(a[it], "lon",0)
    uvm                     = wrf_user_getvar(a[it],"uvmet",0)
    u                       = uvm(0,:,:,:) 
    v                       = uvm(1,:,:,:)
    mag                     = sqrt(u^2 + v^2)
    opt@file_handle = a[it]
    res@tiMainString          = "Corte Transversal M1-M4 "+titulos(it)
    mag_latlon       = wrf_user_vert_cross(mag,z,(/start_lon,start_lat,end_lon,end_lat/),opt)
    xvalues = ispan(0,dimsizes(mag_latlon(0,:))-1,1)
    res@tmXBValues        = xvalues(::ll_step)
    res@tmXBLabels        = sprintf("%8.4f",mag_latlon@lats(::ll_step)) + "~S~o~N~N~C~" + sprintf("%8.4f",mag_latlon@lons(::ll_step)) + "~S~o~N~E"
    plot = gsn_csm_contour(wks,mag_latlon(:,:),res)
end do
end