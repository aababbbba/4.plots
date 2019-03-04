;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; Código hecho por Pablo Andrés Cárdenas Zamorano - UTFSM - 2018 ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Esta subrutina se encarga de graficar la orografía y el uso de suelo de todos lo dominios para los resultados del WRF
;Como anexo, también se pueden agregar la forma de las costas según la base de datos del NCL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Carga de paquetes
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
begin

;Información de la carpeta contenedora
DATADir                     = "../"
FILES                       = systemfunc (" ls -1 " + DATADir + "wrfinput*")
numFILES                    = dimsizes(FILES)
;Inicialización del gráfico 
type                        = "pdf"
wks                         = gsn_open_wks(type,"1.domain_in")
;Almacenamiento de los archivos a plotear 
a                           = addfiles(FILES,"r")

;Característica del gráfico de altura (hgt)
res                      = True
res@cnFillOn 		     = True
res@gsnSpreadColors      = True
res@gsnSpreadColorStart  = 0
res@gsnSpreadColorEnd    = -3
res@FieldTitle           = "z"
res@cnFillPalette        = "OceanLakeLandSnow"
res@cnLinesOn            = False
res@cnLineLabelsOn       = False
res@cnInfoLabelOn        = False
res@InitTime             = False
;res@cnMaxLevelCount      = 50
;res@cnLevelSelectionMode = "EqualSpacedLevels"
;Otras formas de crear la barra de color
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF  = 0.5
;res@lbLabelAlignment     = "BoxCenters"

;Características del wrfoverlays, para graficar hgt con formato de WRF
mpres                       = True
mpres@mpOutlineOn           = False
;mpres@mpDataBaseVersion     = "HighRes"
;mpres@mpDataResolution      = "finest"
;mpres@mpGeophysicalLineColor = "black"
;mpres@mpGeophysicalLineThicknessF = 0.5

;Características del gráfico de LU
res2                        = True
res2@cnFillOn               = True
res2@cnRasterModeOn         = True
res2@FieldTitle             = "Categoria de uso de suelo USGS 24 (-)"
res2@cnFillPalette          = "hlu_default"
res2@gsnSpreadColorStart    = 0
res2@gsnSpreadColorEnd      = 24
res2@InitTime               = False
res2@cnLevelSelectionMode   = "ManualLevels"
res2@cnMinLevelValF         = 2.
res2@cnMaxLevelValF         = 24.
res2@cnLevelSpacingF        = 1.
;res2@lbLabelAlignment     = "BoxCenters"

;Características del plot global
auxres          = True
auxres@NoTitles = True

;Ciclo que crea los gráficos
;print("1. Graficando dominios y uso de suelo...")
do it = 0,numFILES-1,1
    ;Creación del gráfico de altura
    ;;Extraccion de altura del terreno
    hgt = wrf_user_getvar(a[it], "HGT",0)
    ;Adaptación de la barra de color
    res@cnMaxLevelValF  = max(hgt)
    res@cnLevelSpacingF = (max(hgt)-3.)/40.
    ;Comando para graficar
    cplot = wrf_contour(a[it],wks,hgt,res)
    plot = wrf_map_overlays(a[it],wks,(/cplot/),auxres,mpres)
    ;Creación del gráfico de LU
    if(isfilevar(a[it],"LU_INDEX"))
        ;;Extraccion de uso de suelo del terreno
        land = wrf_user_getvar(a[it],"LU_INDEX",0)
        contour = wrf_contour(a[it],wks,land,res2)
        plot = wrf_map_overlays(a[it],wks,(/contour/),auxres,mpres)
    end if
    delete(hgt)
    delete(land)
end do
end