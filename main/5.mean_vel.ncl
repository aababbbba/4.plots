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
DATADir                     = "../1.wrfouts/"
FILES                       = systemfunc (" ls -1 " + DATADir + "wrfout_d07_*")
numFILES                    = dimsizes(FILES)
;Entorno
type                        = "pdf"
wks                         = gsn_open_wks(type,"5.mean_vel")
;Obtención de datos
a                           = addfiles(FILES,"r")
times                       = wrf_user_getvar(a, "times", -1)
ntimes                      = dimsizes(times)

;Dimensiones del dominio
mdims                       = getfilevardimsizes(a[0],"P")
nd                          = dimsizes(mdims)
dimZ                        = mdims(nd-3)
dimX                        = mdims(nd-1)
dimY                        = mdims(nd-2)

;Definición del gráfico de contorno para altura
ter                         = wrf_user_getvar(a[0],"HGT",0)
ter@long_name               = "Terrain Height (m)"
delete(ter@description)
delete(ter@units) 
delete(ter@long_name)
res                         = True
res@cnLineDashPattern       = 2
;res@cnLevelSpacingF         = 5. ;Ajustar según estética y terreno
res@cnLineColor             = "Black"
res@cnLineLabelsOn          = False
res@gsnDraw                 = False
res@gsnFrame                = False
res@gsnMaximize             = True

;Plot del gráfico de Altura
contour_hgt                 = gsn_contour(wks,ter,res)

;Definición gráfico de velocidad
res@cnFillOn                = True
res@cnFillPalette           = "MPL_viridis"
res@gsnSpreadColors         = True
res@gsnSpreadColorStart     = 1
res@gsnSpreadColorEnd       = -3
res@Footer                  = False
res@FieldTitle              = "V (ms-1)"
;res@cnLevelSelectionMode    = "EqualSpacedLevels"
;res@cnMaxLevelCount         = 40
res@cnLevelSelectionMode    = "ManualLevels"
res@cnMinLevelValF          = 2.
res@cnMaxLevelValF          = 14.
res@cnLevelSpacingF        = 0.25
res@InitTime                = False

;Propiedades del wrfoverlay
mpres                       = True
mpres@mpOutlineOn           = False
;mpres@mpDataBaseVersion     = "HighRes"
;mpres@mpDataResolution      = "finest"

;Características del plot global
auxres  = True
auxres@NoTitles = True

;Inicialización de los promedios de velocidad
rapid                       = new( (/ dimZ, dimX, dimY /), float)
rapid                       = 0.0

;Loop por los archivos
do it = 0,ntimes-1,1
    uvm                     = wrf_user_getvar(a[it],"uvmet",0)
    u                       = uvm(0,:,:,:) 
    v                       = uvm(1,:,:,:)
    mag                     = sqrt(u^2 + v^2)
    ;Loop por los niveles
    do kk = 0,dimZ-1,1
        rapid(kk,:,:)       = rapid(kk,:,:) + mag(kk,:,:)
    end do
end do

;Cálculo de promedios
rapid                       = rapid/(ntimes)

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
    res@MainTitle           = "Nivel eta "+(ii+1)+"    Altura media = "+promtot(ii)+" [m]"
    contour_rapid           = wrf_contour(a[0], wks, rapid(ii,:,:), res)
    plot                    = wrf_map_overlays(a[0],wks,(/contour_rapid,contour_hgt/),auxres,mpres)
    ;Mensaje en la consola
    if (ii .lt. 9) then
        print("        Graficando nivel "+(ii+1)+"         max = " + sprintf("%6.3f", max(rapid(ii,:,:)))+"        min = "+sprintf("%6.3f", min(rapid(ii,:,:)))+"        z = "+sprintf("%8.2f",promtot(ii)))
    else 
        print("        Graficando nivel "+(ii+1)+"        max = " + sprintf("%6.3f", max(rapid(ii,:,:)))+"        min = "+sprintf("%6.3f", min(rapid(ii,:,:)))+"        z = "+sprintf("%8.2f",promtot(ii)))
    end if
end do

;Gráfico de eta levels para referencia
system("printf '        Graficando distribución media de niveles verticales en dominio...'")
wks2 = gsn_open_wks("pdf","5.mean_levels")
gsn_define_colormap(wks2,"MPL_viridis")

resxy                     = True
resxy@gsnMaximize         = True
resxy@xyMarkLineModes     = "Markers"                
resxy@xyMarkers           =  16
resxy@vpWidthF            = 0.6  
resxy@vpHeightF           = 0.5                                          
resxy@xyMarkerSizeF       = 0.01
resxy@tmYMajorGrid        = True
resxy@tmYMinorGrid        = True
resxy@tmXMajorGrid        = True
;resxy@tmYRBorderOn        = False
;resxy@tmXTBorderOn        = False
resxy@tmYROn              = False
resxy@tmYUseLeft          = False
resxy@tmXTOn              = False
resxy@tmXUseBottom        = False
resxy@trYMinF                    = 1.
resxy@tmXBMajorOutwardLengthF    = 0.0
resxy@tmXBMinorOutwardLengthF    = 0.0
resxy@tmYLMajorOutwardLengthF    = 0.0
resxy@tmYLMinorOutwardLengthF    = 0.0
resxy@tmYMajorGridLineColor      = "Gray"
resxy@tmYMinorGridLineColor      = "Gray"
resxy@tmXMajorGridLineColor      = "Gray"  
resxy@tiXAxisFontHeightF         = 0.018
resxy@tiYAxisFontHeightF         = 0.018
resxy@tmXBLabelFontHeightF       = 0.014
resxy@tmYLLabelFontHeightF       = 0.014
resxy@xyYStyle            = "Log"
resxy@tiXAxisString       = "n~B~i~N~"
resxy@tiYAxisString       = "z (m)"
resxy@xyMarkerColor       = 128


plot    = gsn_csm_xy(wks2, levels, promtot, resxy)
end