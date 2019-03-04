;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; Código hecho por Pablo Andrés Cárdenas Zamorano - UTFSM - 2018 ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Carga de paquetes
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
begin

;Inicialización del entorno
wks = gsn_open_wks("png","ts/ts_med")
;Obtención de datos para la velocidad
print("        Cargando datos...")
data = readAsciiTable("main/data_hovsore.txt", 10, "float", 1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;Gráfico de velocidad;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Caracteríticas de gráfico de velocidad
res                        = True
res@gsnMaximize            = True      
res@xyLineThicknesses      = 1
res@vpWidthF               = 0.8  
res@vpHeightF              = 0.3
res@tiXAxisString          = "t (h)"
res@tiXAxisFontHeightF     = 0.0115
res@tiYAxisString          = "V (m s-1)"
res@tiYAxisFontHeightF     = 0.0115
res@gsnDraw                = False
res@gsnFrame               = False
res@tmXBLabelFontHeightF   = 0.01
res@tmYLLabelFontHeightF   = 0.01
res@tmXBMajorOutwardLengthF= 0.0
res@tmXBMinorOutwardLengthF= 0.0
res@tmYLMajorOutwardLengthF= 0.0
res@tmYLMinorOutwardLengthF= 0.0
res@tmXMajorGrid           = True
res@tmYMajorGrid           = True
res@tmYMajorGridLineColor  = "Gray"
res@tmXMajorGridLineColor  = "Gray"

; ;Cálculo de máximos y mínimos
; print("        Calculando máximos y mínimos...")
; max_uv = 0.
; min_uv = 99999.
; do i = 1,6
;     aux_max_uv = max(data(:,i))
;     if (aux_max_uv .gt. max_uv) then
;         max_uv = aux_max_uv
;     end if
;     aux_min_uv = min(data(:,i))
;     if (aux_min_uv .lt. min_uv) then
;         min_uv = aux_min_uv
;     end if
; end do
; res@trYMaxF           = max_uv
; res@trYMinF           = 0;min_uv

res@trYMaxF           = 20.0
res@trYMinF           = 0
res@trXMaxF           = 20.0
res@trXMinF           = 6.0

auxz = new(6,float)
auxz = (/10,40,60,80,100,116.5/)

;Definición de la paleta de colores
gsn_define_colormap(wks,"MPL_viridis")
nn = 0.0 ;Factor de corrección horaria
;Creación de gráficos por los 10 primeros niveles
res@xyMonoLineThickness = True
res@xyLineThicknessF = 4.0
res@xyLineColor       = (254/6)*6  
plot1  = gsn_csm_xy(wks,data(:,0),data(:,1),res)

res@xyLineColor       = (254/6)*5 
plot2  = gsn_csm_xy(wks,data(:,0),data(:,2),res)
overlay(plot1,plot2) 

res@xyLineColor       = (254/6)*4 
plot3  = gsn_csm_xy(wks,data(:,0),data(:,3),res)
overlay(plot1,plot3)

res@xyLineColor       = (254/6)*3 
plot4  = gsn_csm_xy(wks,data(:,0),data(:,4),res)
overlay(plot1,plot4) 

res@xyLineColor       = (254/6)*2 
plot5  = gsn_csm_xy(wks,data(:,0),data(:,5),res) 
overlay(plot1,plot5)

res@xyLineColor       = (254/6)*1 
plot6  = gsn_csm_xy(wks,data(:,0),data(:,6),res)
overlay(plot1,plot6) 

;Creación de la Legenda
;Caracteristicas Generales
gres                            = True
lineres                         = True
textres                         = True
lineres@lgLineThicknesses       = 5.0
lineres@LineLengthPercent       = 2.
gres@ItemSpacePercent           = 5.
gres@LineLabelWhiteSpacePercent = 1
textres@lgLabelFontHeights      = 0.0115
;Primera columna
gres@YPosPercent     = 22.5
gres@XPosPercent     = 4.0
textres@lgLabels     = (/"z = "+sprintf("%6.1f",auxz(0))+" m","z = "+sprintf("%6.1f",auxz(1))+" m","z = "+sprintf("%6.1f",auxz(2))+" m"/)
lineres@lgLineColors = (/(254/6)*1,(254/6)*2,(254/6)*3/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)
;Segunda Columna
gres@YPosPercent     = 22.5
gres@XPosPercent     = 18.0
textres@lgLabels     = (/"z = "+sprintf("%6.1f",auxz(3))+" m","z = "+sprintf("%6.1f",auxz(4))+" m","z = "+sprintf("%6.1f",auxz(5))+" m"/)
lineres@lgLineColors = (/(254/6)*4,(254/6)*5,(254/6)*6/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)

print("        Graficando serie de tiempo para velocidades...")
draw(plot1)
frame(wks)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Gráfico de Ángulo;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Caracteríticas de gráfico de ángulo
res2                            = True
res2@gsnMaximize                = True
res2@vpWidthF                   = 0.8  
res2@vpHeightF                  = 0.3
res2@tiXAxisFontHeightF         = 0.0115
res2@tiYAxisFontHeightF         = 0.0115
res2@gsnDraw                    = False
res2@gsnFrame                   = False
res2@tmXBLabelFontHeightF       = 0.01
res2@tmYLLabelFontHeightF       = 0.01
res2@tmXBMajorOutwardLengthF    = 0.0
res2@tmXBMinorOutwardLengthF    = 0.0
res2@tmYLMajorOutwardLengthF    = 0.0
res2@tmYLMinorOutwardLengthF    = 0.0
res2@tmXMajorGrid               = True
res2@tmYMajorGrid               = True
res2@tmYMajorGridLineColor      = "Gray"
res2@tmXMajorGridLineColor      = "Gray"    
res2@xyLineThicknesses          = 1  
res2@tiXAxisString              = "t (h)" 
res2@tiYAxisString              = "~F33~q~F~ (~F34~0~F~)"
res2@trYMaxF                    = 180.
res2@trYMinF                    = 0.
res2@trXMaxF           = 20.0
res2@trXMinF           = 6.0

;Definición de la paleta de colores
gsn_define_colormap(wks,"MPL_plasma")
;Selección de colores para el gráfico de ángulos
colorlow  = 2
colorhigh = (240-2);*3/4
h         = (colorhigh - colorlow)/2
color     = new(10,integer)
color(0)  = colorlow
;Ciclo que define el numero de color en la paleta
do i = 1,2
    color(i) = color(i-1)+h
end do

;Creación de gráficos por los 10 primeros niveles
res2@xyMonoLineThickness = True
res2@xyLineThicknessF = 4.0
res2@xyLineColor       = color(2)
plot1  = gsn_csm_xy(wks,data(:,0),data(:,7),res2)

res2@xyLineColor       = color(1)
plot2  = gsn_csm_xy(wks,data(:,0),data(:,8),res2)
overlay(plot1,plot2) 

res2@xyLineColor       = color(0)
plot3  = gsn_csm_xy(wks,data(:,0),data(:,9),res2)
overlay(plot1,plot3)
;Creación de la Legenda
;Caracteristicas Generales
gres                            = True
lineres                         = True
textres                         = True
lineres@lgLineThicknesses       = 5.0
lineres@LineLengthPercent       = 2.
gres@ItemSpacePercent           = 5.
gres@LineLabelWhiteSpacePercent = 1
textres@lgLabelFontHeights      = 0.0115
;Primera columna
gres@YPosPercent     = 92.5
gres@XPosPercent     = 4.0
textres@lgLabels     = (/"z = "+sprintf("%6.1f",10.0)+" m","z = "+sprintf("%6.1f",40.0)+" m","z = "+sprintf("%6.1f",60.0)+" m"/)
lineres@lgLineColors = (/color(0),color(1),color(2)/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)

print("        Graficando serie de tiempo para angulos...")
draw(plot1)
frame(wks)
end