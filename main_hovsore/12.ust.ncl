;Carga de paquetes
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
begin
print("        Cargando archivos...")
;Ubicación de Archivos
DATADir                     = "../"
FILES                       = systemfunc (" ls -1 " + DATADir + "wrfout_d07_*")
numFILES                    = dimsizes(FILES)
;Entornos
type                        = "pdf"
wks_ust                     = gsn_open_wks(type,"12.ust")
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Información para promediar archivos
N         = 1 ; Cantidad de archivos a promediar
X         = (ntimes - N + 1) ; Número de promedios moviles
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
res@cnLineThicknessF                = 0.001
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
mpres@ZoomIn = True        ; Tell wrf_map_resources we want to zoom in.
;Características del plot global
auxres  = True
auxres@NoTitles = True
;Corte del dominio
nn_modif        = 38               ;numero de elementos a borrar de los bordes 
mpres@Xstart    = nn_modif          ; Set these four special WRF resources
mpres@Xend      = dimX-1-nn_modif   ; required for zooming.
mpres@Ystart    = nn_modif
mpres@Yend      = dimX-1-nn_modif
;grafico de ust
print("Grafico de ust")
res@cnLevelSelectionMode            = "ManualLevels"
res@MainTitle                       = "Compontente u del viento en el primer nivel"
res@cnFillPalette                   = "MPL_plasma"
res@FieldTitle                      = "ust"
res@cnLevelSpacingF                 = 0.01
res@cnMinLevelValF                  = 0.4
res@cnMaxLevelValF                  = 0.6
;Inicio del ciclo que recorre todos los pasos de tiempo
len = 0
ust = wrf_user_getvar(a[0],"UST",0)
ust = 0.0
;Calculo de promedio
do it = 36,48,1
    len = len + 1
    print("tiempo: "+times(it))
    res@TimeLabel           = times(it)
    ust                     = ust + wrf_user_getvar(a[it],"UST",0)   
end do
;Creación de gráficos
ust = ust/len
print(ust(locX, locY))
contour_mag             = wrf_contour(a[0],wks_ust,ust(nn_modif:dimX-1-nn_modif,nn_modif:dimX-1-nn_modif),res)
plot                    = wrf_map_overlays(a[0],wks_ust,(/contour_mag/),auxres,mpres)
end