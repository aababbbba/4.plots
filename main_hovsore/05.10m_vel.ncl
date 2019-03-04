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
type                        = "png"
wks_u                         = gsn_open_wks(type,"10m/u/10m_u")
wks_v                         = gsn_open_wks(type,"10m/v/10m_v")
wks_V                         = gsn_open_wks(type,"10m/V/10m_V")
;Almacenamiento de los archivos a plotear 
a                           = addfiles(FILES,"r")
;Obtención de pasos de tiempo para los archivos
times                       = wrf_user_getvar(a, "times", -1)
ntimes                      = dimsizes(times)

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

;grafico de u
print("Grafico de u")
res@cnLevelSelectionMode            = "ManualLevels"
res@MainTitle                       = "Compontente u del viento a 10m"
res@cnFillPalette                   = "MPL_plasma"
res@FieldTitle                      = "u"
res@cnLevelSpacingF                 = 0.1
;res@cnMinLevelValF                  = -11.0
;res@cnMaxLevelValF                  = -4.5
;Inicio del ciclo que recorre todos los pasos de tiempo
do it = 0,ntimes-1,1
    ;Comienzo de creación de gráficos
    ;obtencion de datos
    res@TimeLabel           = times(it)
    u10                     = wrf_user_getvar(a[it],"U10",0)
    print("     Graficando en tiempo: " + times(it) + "        max = " + sprintf("%6.3f", max(u10))+ "        min = " + sprintf("%6.3f", min(u10)))
    contour_mag             = wrf_contour(a[it],wks_u,u10,res)
    plot                    = wrf_map_overlays(a[it],wks_u,(/contour_mag/),auxres,mpres)
end do

;grafico de v
print("Grafico de v")
res@cnLevelSelectionMode            = "ManualLevels"
res@MainTitle                       = "Compontente v del viento a 10m"
res@cnFillPalette                   = "MPL_magma"
res@FieldTitle                      = "v"
res@cnLevelSpacingF                 = 0.1
;res@cnMinLevelValF                  = 0.5
;res@cnMaxLevelValF                  = 3.
;Inicio del ciclo que recorre todos los pasos de tiempo
do it = 0,ntimes-1,1
    ;Comienzo de creación de gráficos
    ;obtencion de datos
    res@TimeLabel           = times(it)
    v10                     = wrf_user_getvar(a[it],"V10",0)
    print("     Graficando en tiempo: " + times(it) + "        max = " + sprintf("%6.3f", max(v10))+ "        min = " + sprintf("%6.3f", min(v10)))
    contour_mag             = wrf_contour(a[it],wks_v,v10,res)
    plot                    = wrf_map_overlays(a[it],wks_v,(/contour_mag/),auxres,mpres)
end do

;grafico de V
print("Grafico de V")
res@cnLevelSelectionMode            = "ManualLevels"
res@MainTitle                       = "Magnitud del viento a 10m"
res@cnFillPalette                   = "MPL_viridis"
res@FieldTitle                      = "V (m s-1)"
res@cnLevelSpacingF                 = 0.1
;res@cnMinLevelValF                  = 5.
;res@cnMaxLevelValF                  = 11.
;Inicio del ciclo que recorre todos los pasos de tiempo
do it = 0,ntimes-1,1
    ;Comienzo de creación de gráficos
    ;obtencion de datos
    res@TimeLabel           = times(it)
    u10                     = wrf_user_getvar(a[it],"U10",0)
    v10                     = wrf_user_getvar(a[it],"V10",0)
    mag                     = sqrt(u10^2 + v10^2)
    print("     Graficando en tiempo: " + times(it) + "        max = " + sprintf("%6.3f", max(mag))+ "        min = " + sprintf("%6.3f", min(mag)))
    contour_mag             = wrf_contour(a[it],wks_V,mag,res)
    plot                    = wrf_map_overlays(a[it],wks_V,(/contour_mag/),auxres,mpres)
end do

;Edición(corte) de las fotos
FILES2 = systemfunc (" ls -1 10m/u/*.png 10m/v/*.png 10m/V/*.png")
numFILES2 = dimsizes(FILES2)
print("        Editando gráficos...")
;Ciclo que recorre las fotos
do ii=0,numFILES2-1
    system("convert "+FILES2(ii)+" -crop 780x850+130+0 +repage "+FILES2(ii))
end do
;Creación del gif en base a las fotos cortadas
;system("printf '        Generando archivo gif...'")
;system("convert -delay 15 -loop 0 V_10m/frames/*.png 3.10m_vel.gif")
end