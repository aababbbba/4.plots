;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; Código hecho por Pablo Andrés Cárdenas Zamorano - UTFSM - 2018 ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Esta subrutina se encarga de graficar la rapidez instantea del viento para cada archivo de salida según la teoria de MO similaridad
;Al finalizar realiza una animación de este
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Carga de paquetes
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
begin

;Información de la carpeta contenedora
DATADir                     = "../"
FILES                       = systemfunc (" ls -1 " + DATADir + "wrfout_d07_*")
numFILES                    = dimsizes(FILES)
;Inicialización del gráfico
type                        = "pdf"
wks_u                         = gsn_open_wks(type,"eta1/u/eta1_u")
wks_v                         = gsn_open_wks(type,"eta1/v/eta1_v")
wks_V                         = gsn_open_wks(type,"eta1/V/eta1_V")
;Almacenamiento de los archivos a plotear 
a                           = addfiles(FILES,"r")
;Obtención de pasos de tiempo para los archivos
times                       = wrf_user_getvar(a, "times", -1)
ntimes                      = dimsizes(times)
;Dimensiones del dominio
mdims                       = getfilevardimsizes(a[0],"P")
nd                          = dimsizes(mdims)
dimZ                        = mdims(nd-3)
dimY                        = mdims(nd-2)
dimX                        = mdims(nd-1)

;Características del gráfico
res                                 = True
res@cnLineColor                     = "Black"
res@gsnDraw                         = False
res@gsnFrame                        = False
res@gsnMaximize                     = True
res@cnFillOn                        = True
res@gsnSpreadColors                 = True
res@cnLinesOn                       = True
res@gsnContourNegLineDashPattern    = 0
;res@cnLineThicknessF = 1.5
res@cnLineThicknessF = 0.001
res@gsnSpreadColorStart             = 1
res@gsnSpreadColorEnd               = -3
res@Footer                          = False
res@cnInfoLabelOn                   = False
res@lbAutoManage                    = False
res@lbLabelStride                   = 4.
res@lbLabelFontHeightF              = .015
;Carácterísticas del wrfoverlay 
mpres                       = True
mpres@mpOutlineOn           = True
;Características del plot global
auxres  = True
auxres@NoTitles = True

nn_modif = 25 ;numero de elementos a borrar de los bordes 

;grafico de u
print("Grafico de u")
res@cnLevelSelectionMode            = "ManualLevels"
res@MainTitle                       = "Compontente u del viento en el primer nivel"
res@cnFillPalette                   = "MPL_plasma"
res@FieldTitle                      = "u"
res@cnLevelSpacingF                 = 0.075
;res@cnMinLevelValF                  = -10.0
;res@cnMaxLevelValF                  = -2.0
;Inicio del ciclo que recorre todos los pasos de tiempo
do it = 0,ntimes-1,1
; it = 1
    ;Comienzo de creación de gráficos
    ;obtencion de datos
    res@TimeLabel           = times(it)
    uvm                     = wrf_user_getvar(a[it],"uvmet",0)
    u                       = uvm(0,0,:,:) 
    print("     Graficando en tiempo: " + times(it) + "        max = " + sprintf("%6.3f", max(u))+ "        min = " + sprintf("%6.3f", min(u)))
    contour_mag             = wrf_contour(a[it],wks_u,u(nn_modif:dimX-1-nn_modif,nn_modif:dimX-1-nn_modif),res)
    plot                    = wrf_map_overlays(a[it],wks_u,(/contour_mag/),auxres,mpres)
end do

;grafico de v
print("Grafico de v")
res@cnLevelSelectionMode            = "ManualLevels"
res@MainTitle                       = "Compontente v del viento en el primer nivel"
res@cnFillPalette                   = "MPL_magma"
res@FieldTitle                      = "v"
res@cnLevelSpacingF                 = 0.075
; res@cnMinLevelValF                  = 0.0
; res@cnMaxLevelValF                  = 3.0
;Inicio del ciclo que recorre todos los pasos de tiempo
do it = 0,ntimes-1,1
    ;Comienzo de creación de gráficos
    ;obtencion de datos
    res@TimeLabel           = times(it)
    uvm                     = wrf_user_getvar(a[it],"uvmet",0)
    v                       = uvm(1,0,:,:)
    print("     Graficando en tiempo: " + times(it) + "        max = " + sprintf("%6.3f", max(v))+ "        min = " + sprintf("%6.3f", min(v)))
    contour_mag             = wrf_contour(a[it],wks_v,v(nn_modif:dimX-1-nn_modif,nn_modif:dimX-1-nn_modif),res)
    plot                    = wrf_map_overlays(a[it],wks_v,(/contour_mag/),auxres,mpres)
end do

;grafico de V
print("Grafico de V")
res@cnLevelSelectionMode            = "ManualLevels"
res@MainTitle                       = "Magnitud del viento en el primer nivel"
res@cnFillPalette                   = "MPL_viridis"
res@FieldTitle                      = "V (m s-1)"
res@cnLevelSpacingF                 = 0.075
; res@cnMinLevelValF                  = 5.
; res@cnMaxLevelValF                  = 11.
;Inicio del ciclo que recorre todos los pasos de tiempo
do it = 0,ntimes-1,1
    ;Comienzo de creación de gráficos
    ;obtencion de datos
    res@TimeLabel           = times(it)
    uvm                     = wrf_user_getvar(a[it],"uvmet",0)
    u                       = uvm(0,0,:,:) 
    v                       = uvm(1,0,:,:)
    mag                     = sqrt(u^2 + v^2)
    print("     Graficando en tiempo: " + times(it) + "        max = " + sprintf("%6.3f", max(mag))+ "        min = " + sprintf("%6.3f", min(mag)))
    contour_mag             = wrf_contour(a[it],wks_V,mag(nn_modif:dimX-1-nn_modif,nn_modif:dimX-1-nn_modif),res)
    plot                    = wrf_map_overlays(a[it],wks_V,(/contour_mag/),auxres,mpres)
end do

;Edición(corte) de las fotos

; FILES2 = systemfunc (" ls -1 10m/u/*.png 10m/v/*.png 10m/V/*.png")
; numFILES2 = dimsizes(FILES2)
; print("        Editando gráficos...")
; ;Ciclo que recorre las fotos
; do ii=0,numFILES2-1
;     system("convert "+FILES2(ii)+" -crop 780x850+130+0 +repage "+FILES2(ii))
; end do

end