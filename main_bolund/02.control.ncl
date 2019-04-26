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
DATADir                     = "../"
FILES                       = systemfunc (" ls -1 " + DATADir + "wrfinput_d08")
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
res@cnMinLevelValF  = .5

;Propiedades del wrfplot
mpres                               = True
mpres@mpGeophysicalLineThicknessF   = 0.5
mpres@mpOutlineOn                   = False

;Propiedades de los puntos en el mapa
polyres                   = True
polyres@gsMarkerIndex     = 2
polyres@gsMarkerSizeF     = 12.
polyres@gsMarkerColor     = "Black"

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
dum1    = gsn_add_polymarker(wks,plot,12.09840,55.70360,polyres)
;Incorporación de las turbinas eólicas
polyres@gsMarkerIndex     = 16
polyres@gsMarkerSizeF     = 10.
polyres@gsMarkerColor     = "Black"
m1    = gsn_add_polymarker(wks,plot,12.09760,55.70332,polyres)
m2    = gsn_add_polymarker(wks,plot,12.09787,55.70340,polyres) 
m4    = gsn_add_polymarker(wks,plot,12.09927,55.70386,polyres) 
m5    = gsn_add_polymarker(wks,plot,12.09848,55.70315,polyres)  
m7    = gsn_add_polymarker(wks,plot,12.09735,55.70360,polyres) 
m6    = gsn_add_polymarker(wks,plot,12.09770,55.70360,polyres) 
m3   = gsn_add_polymarker(wks,plot,12.09850,55.70360,polyres) 
m8   = gsn_add_polymarker(wks,plot,12.09992,55.70360,polyres)

maa   = gsn_add_polymarker(wks,plot,12.09700,55.70313,polyres) 
mbb   = gsn_add_polymarker(wks,plot,12.10100,55.70442,polyres) 

polyres@gsLineColor = "Black"
polyres@gsLineThicknessF = 2.0
line = gsn_add_polyline(wks, plot, (/12.09700, 12.10100/), (/55.70313,55.70442/), polyres)

polyres@gsMarkerIndex     = 16
polyres@gsMarkerSizeF     = 8.
polyres@gsMarkerColor     = "Magenta"
mm1    = gsn_add_polymarker(wks,plot,12.09760,55.70332,polyres)
mm2    = gsn_add_polymarker(wks,plot,12.09787,55.70340,polyres) 
mm4    = gsn_add_polymarker(wks,plot,12.09927,55.70386,polyres) 
mm5    = gsn_add_polymarker(wks,plot,12.09848,55.70315,polyres) 
mm7    = gsn_add_polymarker(wks,plot,12.09735,55.70360,polyres) 
mm6    = gsn_add_polymarker(wks,plot,12.09770,55.70360,polyres) 
mm3   = gsn_add_polymarker(wks,plot,12.09850,55.70360,polyres) 
mm8   = gsn_add_polymarker(wks,plot,12.09992,55.70360,polyres)

;Comando que muestra el plot
draw(plot)
txres               = True                     ; text mods desired
txres@txFontHeightF = 0.01                  ; font smaller. default big

gsn_text_ndc(wks,"M1",0.355,0.570,txres) 
gsn_text_ndc(wks,"M2",0.40,0.590,txres) 
gsn_text_ndc(wks,"M3",0.48,0.640,txres)
gsn_text_ndc(wks,"M4",0.59,0.700,txres) 
gsn_text_ndc(wks,"M5",0.48,0.530,txres)
gsn_text_ndc(wks,"M6",0.37,0.642,txres)
gsn_text_ndc(wks,"M7",0.32,0.642,txres)
gsn_text_ndc(wks,"M8",0.68,0.642,txres)
frame(wks)
end