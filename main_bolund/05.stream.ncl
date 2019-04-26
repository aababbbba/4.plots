;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; Código hecho por Pablo Andrés Cárdenas Zamorano - UTFSM - 2018 ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Esta subrutina se encarga de graficar la rapidez instantea del viento con vectores
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Carga de paquetes
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
begin

;Información de la carpeta contenedora
DATADir                     = "../"
FILES                       = systemfunc (" ls -1 " + DATADir + "wrfout_d08_*")
FILES_ter                   = systemfunc (" ls -1 " + DATADir + "wrfinput*d08*")
numFILES                    = dimsizes(FILES)
;Inicialización del gráfico
type                        = "pdf"
wks                         = gsn_open_wks(type,"st/eta1")
;Almacenamiento de los archivos a plotear 
a                           = addfiles(FILES,"r")
b                           = addfiles(FILES_ter,"r")
;Obtención de pasos de tiempo para los archivos
times                       = wrf_user_getvar(a, "times", -1)
ntimes                      = dimsizes(times)
;Obtención de altura
ter                         = wrf_user_getvar(b[0],"HGT",0)
;Características del gráfico del terreno
res1                         = True
res1@cnLineThicknessF        = 3
res1@cnLineDashPattern       = 0
res1@cnLineColor             = "Black"
res1@cnLineLabelsOn          = False
res1@cnLevelSpacingF                 = 0.5
res1@cnInfoLabelOn        = False
res1@gsnDraw                 = False
res1@gsnFrame                = False
res1@gsnMaximize             = True
;Plot del terreno
contour_hgt                 = gsn_contour(wks,ter,res1)
;Carácterísticas del wrfoverlay 
mpres                       = True
mpres@mpOutlineOn           = False
;Características del plot global
auxres  = True
auxres@NoTitles = True


;Características del gráfico stream
res                            = True
res@gsnMaximize                = True
; res@vcLevelPalette             = "MPL_viridis"
; res@vcGlyphStyle               = "LineArrow"
; res@vcLineArrowThicknessF      = 5
; res@vcMinDistanceF             = 0.01
; res@vcRefLengthF               = 0.03
res@tmXBOn                     = False
res@tmYROn                     = False
res@tmXTOn                     = False
res@tmYLOn                     = False
res@gsnDraw                 = False
res@gsnFrame                = False
res@gsnSpreadColors                 = True
res@gsnSpreadColorStart             = 1
res@gsnSpreadColorEnd               = -3
; res@vcRefAnnoOn               = False

;---Change the streamline levels
;res@stLevelSpacingF       = 100.
res@stLevelPalette        = "MPL_viridis"
res@stLineThicknessF      = 2.0
res@stLevelSelectionMode  = "ManualLevels"
res@stLevelSpacingF                 = .1
res@stArrowStride      = 2
res@stStepSizeF        = 0.01
res@stMinDistanceF = 0.02
res@stLineStartStride = 2
res@stArrowLengthF = 0.0035
res@lbOrientation = "vertical"
res@lbLabelFontHeightF = 0.013
res@lbLabelStride                   = 5.
barra = fspan(0.0, 7.5, 76)
res@lbLabelStrings          = sprintf("%3.1f", barra )
res@stMinLevelValF          = 0.0
res@stMaxLevelValF          = 7.5
;grafico
print("Grafico de V")
;Inicio del ciclo que recorre todos los pasos de tiempo
do it = 0,ntimes-1,1
    ;Comienzo de creación de gráficos
    ;obtencion de datos
    auxres@TimeLabel        = times(it)
    ; u10                     = wrf_user_getvar(a[it],"U10",0)
    ; v10                     = wrf_user_getvar(a[it],"V10",0)
    ; mag                     = sqrt(u10^2 + v10^2)
    uvm                     = wrf_user_getvar(a[it],"uvmet",0)
    u                       = uvm(0,0,:,:) 
    v                       = uvm(1,0,:,:)
    mag                     = sqrt(u^2 + v^2)
    print("     Graficando en tiempo: " + times(it))
    ;contour_mag             = wrf_contour(a[it],wks_V,mag,res)
    ;plot                    = wrf_map_overlays(a[it],wks_V,(/contour_mag/),auxres,mpres)
    ;plot = gsn_csm_vector_scalar(wks,u10,v10,mag,res)
    stream = gsn_csm_streamline_scalar(wks,u,v,mag,res)
    plot          = wrf_map_overlays(a[0],wks,(/contour_hgt,stream/),auxres,mpres)
end do
end