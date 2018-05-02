;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; Código hecho por Pablo Andrés Cárdenas Zamorano - UTFSM - 2018 ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Esta subrutina se encarga de graficar la orografía del dominio a seleccionar para los resultados del WRF
;Además se identifican en el mapa los punto de interés a seleccionar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Carga de paquetes
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
begin

;Información de la carpeta contenedora
DATADir                     = "../1.wrfouts/spinup/"
FILES                       = systemfunc (" ls -1 " + DATADir + "wrfout_d07_2010-06-09_06:00:00")
numFILES                    = dimsizes(FILES)
;Inicialización del gráfico
type                        = "pdf"
wks                         = gsn_open_wks(type,"2.control_point")
;Almacenamiento del archivo a plotear 
a                           = addfiles(FILES,"r")
;Propiedades del gráfico
res                      = True
res@cnFillOn             = True
res@cnFillPalette        = "OceanLakeLandSnow"
res@FieldTitle           = "z"
res@cnLinesOn            = False
res@cnLineLabelsOn       = False
res@cnInfoLabelOn        = False
res@InitTime             = False
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF  = 3.

;Propiedades del wrfplot
mpres                               = True
mpres@mpGeophysicalLineThicknessF   = 0.5
mpres@mpOutlineOn                   = False

;Propiedades de los puntos en el mapa
polyres                   = True
polyres@gsMarkerIndex     = 16
polyres@gsMarkerSizeF     = 15.
polyres@gsMarkerColor     = "Red"

;Características del plot global
auxres          = True
auxres@NoTitles = True

;Comienzo del plot
;Extraccion de altura del terreno
hgt     = wrf_user_getvar(a[numFILES-1], "HGT",0)
res@cnMaxLevelValF  = max(hgt)
res@cnLevelSpacingF = (max(hgt)-3.)/40.
;ContourPlot de la orografía (hgt)
cplot   = wrf_contour(a[numFILES-1],wks,hgt,res)
;Activa PanelPlot para que se grafiquen encima los puntos de control
auxres@PanelPlot = True
;Creación del gráfico con los puntos
plot    = wrf_map_overlays(a[numFILES-1],wks,cplot,auxres,mpres)
dum1    = gsn_add_polymarker(wks,plot,8.150896,56.440582,polyres)
;Incorporación de las turbinas eólicas
polyres@gsMarkerIndex     = 15
polyres@gsMarkerSizeF     = 10.
polyres@gsMarkerColor     = "Black"
dum2    = gsn_add_polymarker(wks,plot,8.152103,56.453264,polyres)
dum3    = gsn_add_polymarker(wks,plot,8.151751,56.450657,polyres) 
dum4    = gsn_add_polymarker(wks,plot,8.151527,56.448111,polyres) 
dum5    = gsn_add_polymarker(wks,plot,8.151325,56.445123,polyres) 
dum6    = gsn_add_polymarker(wks,plot,8.151215,56.442437,polyres) 
;Comando que muestra el plot
draw(plot)
frame(wks)
end