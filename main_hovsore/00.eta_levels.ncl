;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; Código hecho por Pablo Andrés Cárdenas Zamorano - UTFSM - 2018 ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Subrutina encargada de graficar el campo de velocidad medio durante el periodo de simulación para cada nivel
;Tambien grafica la distribución de niveles verticales promedios según altura
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Carga de paquetes
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
begin

;Ubicación de Archivos
DATADir                     = "../"
FILES                       = systemfunc (" ls -1 " + DATADir + "wrfout_d07_*")

;Obtención de datos
a                           = addfiles(FILES,"r")

;Dimensiones del dominio
mdims                       = getfilevardimsizes(a[0],"P")
nd                          = dimsizes(mdims)
dimZ                        = mdims(nd-3)
dimX                        = mdims(nd-1)
dimY                        = mdims(nd-2)

ter                         = wrf_user_getvar(a[0],"HGT",0)
;Inicialización para promedios de altura
promx                       = new(dimY,float)
promy                       = new(1,float)
promtot                     = new(dimZ,float)
promx                       = 0.0
promy                       = 0.0
promtot                     = 0.0
zz                          = wrf_user_getvar(a[0],"z",0)
levels                      = new(dimZ,float)
;Loop por los niveles
do ii = 0,dimZ-1,1
    levels(ii)       = ii + 1
    auxzz                   = zz(ii,:,:) - ter(:,:)
    do j = 0,dimX-1,1
        promx               = promx + auxzz(j,:)
    end do
    do k = 0,dimY-1,1
        promy               = promy + promx(k)
    end do
    promtot(ii)             = promy/(dimX*dimY)
    ;Reinicio de Promedios
    promx(:)                = 0.0
    promy                   = 0.0
end do

print(promtot)

do ii=0,dimZ-1,1
    if (ii .eq. 0)
        print(promtot(ii))
    else 
        print(promtot(ii)-promtot(ii-1))
    end if
end do
;Gráfico de eta levels para referencia
; system("printf '        Graficando distribución media de niveles verticales en dominio...'")
; wks2 = gsn_open_wks("pdf","mean_levels")
; gsn_define_colormap(wks2,"MPL_viridis")
; resxy                     = True
; resxy@gsnMaximize         = True
; resxy@xyMarkLineModes     = "Markers"                
; resxy@xyMarkers           =  16
; resxy@vpWidthF            = 0.6  
; resxy@vpHeightF           = 0.5                                          
; resxy@xyMarkerSizeF       = 0.01
; resxy@tmYMajorGrid        = True
; resxy@tmYMinorGrid        = True
; resxy@tmXMajorGrid        = True
; ;resxy@tmYRBorderOn        = False
; ;resxy@tmXTBorderOn        = False
; resxy@tmYROn              = False
; resxy@tmYUseLeft          = False
; resxy@tmXTOn              = False
; resxy@tmXUseBottom        = False
; resxy@trYMinF                    = 1.
; resxy@tmXBMajorOutwardLengthF    = 0.0
; resxy@tmXBMinorOutwardLengthF    = 0.0
; resxy@tmYLMajorOutwardLengthF    = 0.0
; resxy@tmYLMinorOutwardLengthF    = 0.0
; resxy@tmYMajorGridLineColor      = "Gray"
; resxy@tmYMinorGridLineColor      = "Gray"
; resxy@tmXMajorGridLineColor      = "Gray"  
; resxy@tiXAxisFontHeightF         = 0.018
; resxy@tiYAxisFontHeightF         = 0.018
; resxy@tmXBLabelFontHeightF       = 0.014
; resxy@tmYLLabelFontHeightF       = 0.014
; resxy@xyYStyle            = "Log"
; resxy@tiXAxisString       = "n~B~i~N~"
; resxy@tiYAxisString       = "z (m)"
; resxy@xyMarkerColor       = 128

; plot    = gsn_csm_xy(wks2, levels, promtot, resxy)
end