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
wks = gsn_open_wks("png","ts/08ts")
;Obtención de datos para la velocidad
print("        Cargando datos...")
data = readAsciiTable("main/bolund_data.txt", 41, "float", 1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;M1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
res@tiMainString           = "M1 Mean Velocity Time Series"
res@tiMainFontHeightF      = 0.015
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
res@trYMaxF                = 18.
res@trYMinF                = 0.
res@trXMaxF           = 24.0
res@trXMinF           = 0.0
;Definición de la paleta de colores
gsn_define_colormap(wks,"MPL_viridis")
;Factor de corrección horaria
nn = 0.0
;Creación de gráficos por los niveles
res@xyMonoLineThickness = True
res@xyLineThicknessF    = 4.0
;Gráficos
res@xyLineColor = (254/2)*2 
plot1           = gsn_csm_xy(wks,data(:,0)+nn,data(:,1),res)
res@xyLineColor = (254/2)*1 
plot2           = gsn_csm_xy(wks,data(:,0)+nn,data(:,2),res)
overlay(plot1,plot2) 
res@xyLineColor = 2 
plot3           = gsn_csm_xy(wks,data(:,0)+nn,data(:,3),res)
overlay(plot1,plot3)
;Caracterísitcas de la Legenda
gres                            = True
lineres                         = True
textres                         = True
lineres@lgLineThicknesses       = 5.0
lineres@LineLengthPercent       = 2.
gres@ItemSpacePercent           = 5.
gres@LineLabelWhiteSpacePercent = 1
textres@lgLabelFontHeights      = 0.0115
;Creación de la Legenda
gres@YPosPercent     = 22.5
gres@XPosPercent     = 4.0
textres@lgLabels     = (/"z = "+sprintf("%6.1f",9.0)+" m","z = "+sprintf("%6.1f",5.0)+" m","z = "+sprintf("%6.1f",2.0)+" m"/)
lineres@lgLineColors = (/ (254/2)*2 , (254/2)*1 ,2/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)
;Cración del gráfico
draw(plot1)
frame(wks)
;Gráfico de angulo
res2                            = True
res2@gsnMaximize                = True
res2@vpWidthF                   = 0.8  
res2@vpHeightF                  = 0.3
res2@tiMainString               = "M1 Mean Dir Time Series"
res2@tiMainFontHeightF          = 0.015
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
res2@trYMaxF                    = 360.
res2@trYMinF                    = 0.
res@trXMaxF                     = 24.0
res@trXMinF                     = 0.0
;Definición de la paleta de colores
gsn_define_colormap(wks,"MPL_plasma")
;Creación de gráficos por los niveles
res2@xyMonoLineThickness = True
res2@xyLineThicknessF    = 4.0
;Gráfico
res2@xyLineColor       = (254/4)*3
plot1                  = gsn_csm_xy(wks,data(:,0),data(:,4),res2)
res2@xyLineColor       = (254/4)*2
plot2                  = gsn_csm_xy(wks,data(:,0),data(:,5),res2)
overlay(plot1,plot2) 
res2@xyLineColor       = (254/4)*1
plot3                  = gsn_csm_xy(wks,data(:,0),data(:,6),res2)
overlay(plot1,plot3)
;Caracteristicas Generales
gres                            = True
lineres                         = True
textres                         = True
lineres@lgLineThicknesses       = 5.0
lineres@LineLengthPercent       = 2.
gres@ItemSpacePercent           = 5.
gres@LineLabelWhiteSpacePercent = 1
textres@lgLabelFontHeights      = 0.0115
;Creación de la Legenda
gres@YPosPercent     = 92.5
gres@XPosPercent     = 4.0
textres@lgLabels     = (/"z = "+sprintf("%6.1f",9.0)+" m","z = "+sprintf("%6.1f",5.0)+" m","z = "+sprintf("%6.1f",2.0)+" m"/)
lineres@lgLineColors = (/(254/4)*3,(254/4)*2,(254/4)*1/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)
;Cración del gráfico
draw(plot1)
frame(wks)









;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;M2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
res@tiMainString           = "M2 Mean Velocity Time Series"
res@tiMainFontHeightF      = 0.015
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
res@trYMaxF                = 18.
res@trYMinF                = 0.
;Definición de la paleta de colores
gsn_define_colormap(wks,"MPL_viridis")
;Factor de corrección horaria
nn = 0.0
;Creación de gráficos por los niveles
res@xyMonoLineThickness = True
res@xyLineThicknessF    = 4.0
;Gráficos
res@xyLineColor = (254/2)*2  
plot1           = gsn_csm_xy(wks,data(:,0)+nn,data(:,7),res)
res@xyLineColor = (254/2)*1 
plot2           = gsn_csm_xy(wks,data(:,0)+nn,data(:,8),res)
overlay(plot1,plot2) 
res@xyLineColor = 2 
plot3           = gsn_csm_xy(wks,data(:,0)+nn,data(:,9),res)
overlay(plot1,plot3)
;Caracterísitcas de la Legenda
delete(textres)
delete(lineres)
gres                            = True
lineres                         = True
textres                         = True
lineres@lgLineThicknesses       = 5.0
lineres@LineLengthPercent       = 2.
gres@ItemSpacePercent           = 5.
gres@LineLabelWhiteSpacePercent = 1
textres@lgLabelFontHeights      = 0.0115
;Creación de la Legenda
gres@YPosPercent     = 22.5
gres@XPosPercent     = 4.0
textres@lgLabels     = (/"z = "+sprintf("%6.1f",9.0)+" m","z = "+sprintf("%6.1f",5.0)+" m","z = "+sprintf("%6.1f",2.0)+" m"/)
lineres@lgLineColors = (/(254/2)*2,(254/2)*1,2/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)
;Cración del gráfico
draw(plot1)
frame(wks)
;Gráfico de angulo
res2                            = True
res2@gsnMaximize                = True
res2@vpWidthF                   = 0.8  
res2@vpHeightF                  = 0.3
res2@tiMainString               = "M2 Mean Dir Time Series"
res2@tiMainFontHeightF          = 0.015
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
res2@trYMaxF                    = 360.
res2@trYMinF                    = 0.
;Definición de la paleta de colores
gsn_define_colormap(wks,"MPL_plasma")
;Creación de gráficos por los niveles
res2@xyMonoLineThickness = True
res2@xyLineThicknessF    = 4.0
;Gráfico
res2@xyLineColor       = (254/4)*2
plot1                  = gsn_csm_xy(wks,data(:,0),data(:,10),res2)
res2@xyLineColor       = (254/4)*1
plot2                  = gsn_csm_xy(wks,data(:,0),data(:,11),res2)
overlay(plot1,plot2) 
;Caracteristicas Generales
delete(textres)
delete(lineres)
gres                            = True
lineres                         = True
textres                         = True
lineres@lgLineThicknesses       = 5.0
lineres@LineLengthPercent       = 2.
gres@ItemSpacePercent           = 5.
gres@LineLabelWhiteSpacePercent = 1
textres@lgLabelFontHeights      = 0.0115
;Creación de la Legenda
gres@YPosPercent     = 92.5
gres@XPosPercent     = 4.0
textres@lgLabels     = (/"z = "+sprintf("%6.1f",5.0)+" m","z = "+sprintf("%6.1f",2.0)+" m"/)
lineres@lgLineColors = (/(254/4)*2,(254/4)*1/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)
;Cración del gráfico
draw(plot1)
frame(wks)









;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;M3;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
res@tiMainString           = "M3 Mean Velocity Time Series"
res@tiMainFontHeightF      = 0.015
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
res@trYMaxF                = 18.
res@trYMinF                = 0.
;Definición de la paleta de colores
gsn_define_colormap(wks,"MPL_viridis")
;Factor de corrección horaria
nn = 0.0
;Creación de gráficos por los niveles
res@xyMonoLineThickness = True
res@xyLineThicknessF    = 4.0
;Gráficos
res@xyLineColor = (254/2)*2
plot1           = gsn_csm_xy(wks,data(:,0)+nn,data(:,12),res)
res@xyLineColor = (254/2)*1 
plot2           = gsn_csm_xy(wks,data(:,0)+nn,data(:,13),res)
overlay(plot1,plot2) 
res@xyLineColor = 2 
plot3           = gsn_csm_xy(wks,data(:,0)+nn,data(:,14),res)
overlay(plot1,plot3)
;Caracterísitcas de la Legenda
delete(textres)
delete(lineres)
gres                            = True
lineres                         = True
textres                         = True
lineres@lgLineThicknesses       = 5.0
lineres@LineLengthPercent       = 2.
gres@ItemSpacePercent           = 5.
gres@LineLabelWhiteSpacePercent = 1
textres@lgLabelFontHeights      = 0.0115
;Creación de la Legenda
gres@YPosPercent     = 22.5
gres@XPosPercent     = 4.0
textres@lgLabels     = (/"z = "+sprintf("%6.1f",9.0)+" m","z = "+sprintf("%6.1f",5.0)+" m","z = "+sprintf("%6.1f",2.0)+" m"/)
lineres@lgLineColors = (/(254/2)*2,(254/2)*1,2/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)
;Cración del gráfico
draw(plot1)
frame(wks)
;Gráfico de angulo
res2                            = True
res2@gsnMaximize                = True
res2@vpWidthF                   = 0.8  
res2@vpHeightF                  = 0.3
res2@tiMainString               = "M3 Mean Dir Time Series"
res2@tiMainFontHeightF          = 0.015
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
res2@trYMaxF                    = 360.
res2@trYMinF                    = 0.
;Definición de la paleta de colores
gsn_define_colormap(wks,"MPL_plasma")
;Creación de gráficos por los niveles
res2@xyMonoLineThickness = True
res2@xyLineThicknessF    = 4.0
;Gráfico
res2@xyLineColor       = (254/4)*2
plot1                  = gsn_csm_xy(wks,data(:,0),data(:,15),res2)
res2@xyLineColor       = (254/4)*1
plot2                  = gsn_csm_xy(wks,data(:,0),data(:,16),res2)
overlay(plot1,plot2) 
;Caracteristicas Generales
delete(textres)
delete(lineres)
gres                            = True
lineres                         = True
textres                         = True
lineres@lgLineThicknesses       = 5.0
lineres@LineLengthPercent       = 2.
gres@ItemSpacePercent           = 5.
gres@LineLabelWhiteSpacePercent = 1
textres@lgLabelFontHeights      = 0.0115
;Creación de la Legenda
gres@YPosPercent     = 92.5
gres@XPosPercent     = 4.0
textres@lgLabels     = (/"z = "+sprintf("%6.1f",5.0)+" m","z = "+sprintf("%6.1f",2.0)+" m"/)
lineres@lgLineColors = (/(254/4)*2,(254/4)*1/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)
;Cración del gráfico
draw(plot1)
frame(wks)









;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;M4;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
res@tiMainString           = "M4 Mean Velocity Time Series"
res@tiMainFontHeightF      = 0.015
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
res@trYMaxF                = 18.
res@trYMinF                = 0.
;Definición de la paleta de colores
gsn_define_colormap(wks,"MPL_viridis")
;Factor de corrección horaria
nn = 0.0
;Creación de gráficos por los niveles
res@xyMonoLineThickness = True
res@xyLineThicknessF    = 4.0
;Gráficos
res@xyLineColor = (254/2)*2  
plot1           = gsn_csm_xy(wks,data(:,0)+nn,data(:,17),res)
res@xyLineColor = (254/2)*1 
plot2           = gsn_csm_xy(wks,data(:,0)+nn,data(:,18),res)
overlay(plot1,plot2) 
res@xyLineColor = 2 
plot3           = gsn_csm_xy(wks,data(:,0)+nn,data(:,19),res)
overlay(plot1,plot3)
;Caracterísitcas de la Legenda
delete(textres)
delete(lineres)
gres                            = True
lineres                         = True
textres                         = True
lineres@lgLineThicknesses       = 5.0
lineres@LineLengthPercent       = 2.
gres@ItemSpacePercent           = 5.
gres@LineLabelWhiteSpacePercent = 1
textres@lgLabelFontHeights      = 0.0115
;Creación de la Legenda
gres@YPosPercent     = 22.5
gres@XPosPercent     = 4.0
textres@lgLabels     = (/"z = "+sprintf("%6.1f",9.0)+" m","z = "+sprintf("%6.1f",5.0)+" m","z = "+sprintf("%6.1f",2.0)+" m"/)
lineres@lgLineColors = (/(254/2)*2,(254/2)*1,2/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)
;Cración del gráfico
draw(plot1)
frame(wks)
;Gráfico de angulo
res2                            = True
res2@gsnMaximize                = True
res2@vpWidthF                   = 0.8  
res2@vpHeightF                  = 0.3
res2@tiMainString               = "M4 Mean Dir Time Series"
res2@tiMainFontHeightF          = 0.015
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
res2@trYMaxF                    = 360.
res2@trYMinF                    = 0.
;Definición de la paleta de colores
gsn_define_colormap(wks,"MPL_plasma")
;Creación de gráficos por los niveles
res2@xyMonoLineThickness = True
res2@xyLineThicknessF    = 4.0
;Gráfico
res2@xyLineColor       = (254/4)*3
plot1                  = gsn_csm_xy(wks,data(:,0),data(:,20),res2)
res2@xyLineColor       = (254/4)*2
plot2                  = gsn_csm_xy(wks,data(:,0),data(:,21),res2)
overlay(plot1,plot2)
res2@xyLineColor       = (254/4)*1
plot3                  = gsn_csm_xy(wks,data(:,0),data(:,22),res2)
overlay(plot1,plot3)
;Caracteristicas Generales
delete(textres)
delete(lineres)
gres                            = True
lineres                         = True
textres                         = True
lineres@lgLineThicknesses       = 5.0
lineres@LineLengthPercent       = 2.
gres@ItemSpacePercent           = 5.
gres@LineLabelWhiteSpacePercent = 1
textres@lgLabelFontHeights      = 0.0115
;Creación de la Legenda
gres@YPosPercent     = 92.5
gres@XPosPercent     = 4.0
textres@lgLabels     = (/"z = "+sprintf("%6.1f",9.0)+" m","z = "+sprintf("%6.1f",5.0)+" m","z = "+sprintf("%6.1f",2.0)+" m"/)
lineres@lgLineColors = (/(254/4)*3,(254/4)*2,(254/4)*1/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)
;Cración del gráfico
draw(plot1)
frame(wks)









;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;M5;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
res@tiMainString           = "M5 Mean Velocity Time Series"
res@tiMainFontHeightF      = 0.015
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
res@trYMaxF                = 18.
res@trYMinF                = 0.
;Definición de la paleta de colores
gsn_define_colormap(wks,"MPL_viridis")
;Factor de corrección horaria
nn = 0.0
;Creación de gráficos por los niveles
res@xyMonoLineThickness = True
res@xyLineThicknessF    = 4.0
;Gráficos
res@xyLineColor = (254/2)*1  
plot1           = gsn_csm_xy(wks,data(:,0)+nn,data(:,23),res)
res@xyLineColor = 2 
plot2           = gsn_csm_xy(wks,data(:,0)+nn,data(:,24),res)
overlay(plot1,plot2) 
;Caracterísitcas de la Legenda
delete(textres)
delete(lineres)
gres                            = True
lineres                         = True
textres                         = True
lineres@lgLineThicknesses       = 5.0
lineres@LineLengthPercent       = 2.
gres@ItemSpacePercent           = 5.
gres@LineLabelWhiteSpacePercent = 1
textres@lgLabelFontHeights      = 0.0115
;Creación de la Legenda
gres@YPosPercent     = 22.5
gres@XPosPercent     = 4.0
textres@lgLabels     = (/"z = "+sprintf("%6.1f",5.0)+" m","z = "+sprintf("%6.1f",2.0)+" m"/)
lineres@lgLineColors = (/(254/2)*1,2/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)
;Cración del gráfico
draw(plot1)
frame(wks)
;Gráfico de angulo
res2                            = True
res2@gsnMaximize                = True
res2@vpWidthF                   = 0.8  
res2@vpHeightF                  = 0.3
res2@tiMainString               = "M5 Mean Dir Time Series"
res2@tiMainFontHeightF          = 0.015
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
res2@trYMaxF                    = 360.
res2@trYMinF                    = 0.
;Definición de la paleta de colores
gsn_define_colormap(wks,"MPL_plasma")
;Creación de gráficos por los niveles
res2@xyMonoLineThickness = True
res2@xyLineThicknessF    = 4.0
;Gráfico
res2@xyLineColor       = (254/4)*2
plot1                  = gsn_csm_xy(wks,data(:,0),data(:,25),res2)
res2@xyLineColor       = (254/4)*1
plot2                  = gsn_csm_xy(wks,data(:,0),data(:,26),res2)
overlay(plot1,plot2)
;Caracteristicas Generales
delete(textres)
delete(lineres)
gres                            = True
lineres                         = True
textres                         = True
lineres@lgLineThicknesses       = 5.0
lineres@LineLengthPercent       = 2.
gres@ItemSpacePercent           = 5.
gres@LineLabelWhiteSpacePercent = 1
textres@lgLabelFontHeights      = 0.0115
;Creación de la Legenda
gres@YPosPercent     = 92.5
gres@XPosPercent     = 4.0
textres@lgLabels     = (/"z = "+sprintf("%6.1f",5.0)+" m","z = "+sprintf("%6.1f",2.0)+" m"/)
lineres@lgLineColors = (/(254/4)*2,(254/4)*1/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)
;Cración del gráfico
draw(plot1)
frame(wks)








;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;M6;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
res@tiMainString           = "M6 Mean Velocity Time Series"
res@tiMainFontHeightF      = 0.015
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
res@trYMaxF                = 18.
res@trYMinF                = 0.
;Definición de la paleta de colores
gsn_define_colormap(wks,"MPL_viridis")
;Factor de corrección horaria
nn = 0.0
;Creación de gráficos por los niveles
res@xyMonoLineThickness = True
res@xyLineThicknessF    = 4.0
;Gráficos
res@xyLineColor = (254/2)*2  
plot1           = gsn_csm_xy(wks,data(:,0)+nn,data(:,27),res)
res@xyLineColor = (254/2)*1 
plot2           = gsn_csm_xy(wks,data(:,0)+nn,data(:,28),res)
overlay(plot1,plot2)
res@xyLineColor = 2 
plot3           = gsn_csm_xy(wks,data(:,0)+nn,data(:,29),res)
overlay(plot1,plot3) 
;Caracterísitcas de la Legenda
delete(textres)
delete(lineres)
gres                            = True
lineres                         = True
textres                         = True
lineres@lgLineThicknesses       = 5.0
lineres@LineLengthPercent       = 2.
gres@ItemSpacePercent           = 5.
gres@LineLabelWhiteSpacePercent = 1
textres@lgLabelFontHeights      = 0.0115
;Creación de la Legenda
gres@YPosPercent     = 22.5
gres@XPosPercent     = 4.0
textres@lgLabels     = (/"z = "+sprintf("%6.1f",9.0)+" m","z = "+sprintf("%6.1f",5.0)+" m","z = "+sprintf("%6.1f",2.0)+" m"/)
lineres@lgLineColors = (/(254/2)*2,(254/2)*1,2/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)
;Cración del gráfico
draw(plot1)
frame(wks)
;Gráfico de angulo
res2                            = True
res2@gsnMaximize                = True
res2@vpWidthF                   = 0.8  
res2@vpHeightF                  = 0.3
res2@tiMainString               = "M6 Mean Dir Time Series"
res2@tiMainFontHeightF          = 0.015
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
res2@trYMaxF                    = 360.
res2@trYMinF                    = 0.
;Definición de la paleta de colores
gsn_define_colormap(wks,"MPL_plasma")
;Creación de gráficos por los niveles
res2@xyMonoLineThickness = True
res2@xyLineThicknessF    = 4.0
;Gráfico
res2@xyLineColor       = (254/4)*2
plot1                  = gsn_csm_xy(wks,data(:,0),data(:,30),res2)
res2@xyLineColor       = (254/4)*1
plot2                  = gsn_csm_xy(wks,data(:,0),data(:,31),res2)
overlay(plot1,plot2)
;Caracteristicas Generales
delete(textres)
delete(lineres)
gres                            = True
lineres                         = True
textres                         = True
lineres@lgLineThicknesses       = 5.0
lineres@LineLengthPercent       = 2.
gres@ItemSpacePercent           = 5.
gres@LineLabelWhiteSpacePercent = 1
textres@lgLabelFontHeights      = 0.0115
;Creación de la Legenda
gres@YPosPercent     = 92.5
gres@XPosPercent     = 4.0
textres@lgLabels     = (/"z = "+sprintf("%6.1f",5.0)+" m","z = "+sprintf("%6.1f",2.0)+" m"/)
lineres@lgLineColors = (/(254/4)*2,(254/4)*1/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)
;Cración del gráfico
draw(plot1)
frame(wks)









;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;M7;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
res@tiMainString           = "M7 Mean Velocity Time Series"
res@tiMainFontHeightF      = 0.015
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
res@trYMaxF                = 18.
res@trYMinF                = 0.
;Definición de la paleta de colores
gsn_define_colormap(wks,"MPL_viridis")
;Factor de corrección horaria
nn = 0.0
;Creación de gráficos por los niveles
res@xyMonoLineThickness = True
res@xyLineThicknessF    = 4.0
;Gráficos
res@xyLineColor = (254/2)*1  
plot1           = gsn_csm_xy(wks,data(:,0)+nn,data(:,32),res)
res@xyLineColor = 2 
plot2           = gsn_csm_xy(wks,data(:,0)+nn,data(:,33),res)
overlay(plot1,plot2) 
;Caracterísitcas de la Legenda
delete(textres)
delete(lineres)
gres                            = True
lineres                         = True
textres                         = True
lineres@lgLineThicknesses       = 5.0
lineres@LineLengthPercent       = 2.
gres@ItemSpacePercent           = 5.
gres@LineLabelWhiteSpacePercent = 1
textres@lgLabelFontHeights      = 0.0115
;Creación de la Legenda
gres@YPosPercent     = 22.5
gres@XPosPercent     = 4.0
textres@lgLabels     = (/"z = "+sprintf("%6.1f",5.0)+" m","z = "+sprintf("%6.1f",2.0)+" m"/)
lineres@lgLineColors = (/(254/2)*1,2/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)
;Cración del gráfico
draw(plot1)
frame(wks)
;Gráfico de angulo
res2                            = True
res2@gsnMaximize                = True
res2@vpWidthF                   = 0.8  
res2@vpHeightF                  = 0.3
res2@tiMainString               = "M7 Mean Dir Time Series"
res2@tiMainFontHeightF          = 0.015
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
res2@trYMaxF                    = 360.
res2@trYMinF                    = 0.
;Definición de la paleta de colores
gsn_define_colormap(wks,"MPL_plasma")
;Creación de gráficos por los niveles
res2@xyMonoLineThickness = True
res2@xyLineThicknessF    = 4.0
;Gráfico
res2@xyLineColor       = (254/4)*2
plot1                  = gsn_csm_xy(wks,data(:,0),data(:,34),res2)
res2@xyLineColor       = (254/4)*1
plot2                  = gsn_csm_xy(wks,data(:,0),data(:,35),res2)
overlay(plot1,plot2)
;Caracteristicas Generales
delete(textres)
delete(lineres)
gres                            = True
lineres                         = True
textres                         = True
lineres@lgLineThicknesses       = 5.0
lineres@LineLengthPercent       = 2.
gres@ItemSpacePercent           = 5.
gres@LineLabelWhiteSpacePercent = 1
textres@lgLabelFontHeights      = 0.0115
;Creación de la Legenda
gres@YPosPercent     = 92.5
gres@XPosPercent     = 4.0
textres@lgLabels     = (/"z = "+sprintf("%6.1f",5.0)+" m","z = "+sprintf("%6.1f",2.0)+" m"/)
lineres@lgLineColors = (/(254/4)*2,(254/4)*1/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)
;Cración del gráfico
draw(plot1)
frame(wks)









;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;M8;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
res@tiMainString           = "M8 Mean Velocity Time Series"
res@tiMainFontHeightF      = 0.015
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
res@trYMaxF                = 18.
res@trYMinF                = 0.
;Definición de la paleta de colores
gsn_define_colormap(wks,"MPL_viridis")
;Factor de corrección horaria
nn = 0.0
;Creación de gráficos por los niveles
res@xyMonoLineThickness = True
res@xyLineThicknessF    = 4.0
;Gráficos
res@xyLineColor = (254/2)*2
plot1           = gsn_csm_xy(wks,data(:,0)+nn,data(:,36),res)
res@xyLineColor = (254/2)*1 
plot2           = gsn_csm_xy(wks,data(:,0)+nn,data(:,37),res)
overlay(plot1,plot2)
res@xyLineColor = 2 
plot3           = gsn_csm_xy(wks,data(:,0)+nn,data(:,38),res)
overlay(plot1,plot3) 
;Caracterísitcas de la Legenda
delete(textres)
delete(lineres)
gres                            = True
lineres                         = True
textres                         = True
lineres@lgLineThicknesses       = 5.0
lineres@LineLengthPercent       = 2.
gres@ItemSpacePercent           = 5.
gres@LineLabelWhiteSpacePercent = 1
textres@lgLabelFontHeights      = 0.0115
;Creación de la Legenda
gres@YPosPercent     = 22.5
gres@XPosPercent     = 4.0
textres@lgLabels     = (/"z = "+sprintf("%6.1f",9.0)+" m","z = "+sprintf("%6.1f",5.0)+" m","z = "+sprintf("%6.1f",2.0)+" m"/)
lineres@lgLineColors = (/(254/2)*2,(254/2)*1,2/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)
;Cración del gráfico
draw(plot1)
frame(wks)
;Gráfico de angulo
res2                            = True
res2@gsnMaximize                = True
res2@vpWidthF                   = 0.8  
res2@vpHeightF                  = 0.3
res2@tiMainString               = "M8 Mean Dir Time Series"
res2@tiMainFontHeightF          = 0.015
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
res2@trYMaxF                    = 360.
res2@trYMinF                    = 0.
;Definición de la paleta de colores
gsn_define_colormap(wks,"MPL_plasma")
;Creación de gráficos por los niveles
res2@xyMonoLineThickness = True
res2@xyLineThicknessF    = 4.0
;Gráfico
res2@xyLineColor       = (254/4)*2
plot1                  = gsn_csm_xy(wks,data(:,0),data(:,39),res2)
res2@xyLineColor       = (254/4)*1
plot2                  = gsn_csm_xy(wks,data(:,0),data(:,40),res2)
overlay(plot1,plot2)
;Caracteristicas Generales
delete(textres)
delete(lineres)
gres                            = True
lineres                         = True
textres                         = True
lineres@lgLineThicknesses       = 5.0
lineres@LineLengthPercent       = 2.
gres@ItemSpacePercent           = 5.
gres@LineLabelWhiteSpacePercent = 1
textres@lgLabelFontHeights      = 0.0115
;Creación de la Legenda
gres@YPosPercent     = 92.5
gres@XPosPercent     = 4.0
textres@lgLabels     = (/"z = "+sprintf("%6.1f",5.0)+" m","z = "+sprintf("%6.1f",2.0)+" m"/)
lineres@lgLineColors = (/(254/4)*2,(254/4)*1/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)
;Cración del gráfico
draw(plot1)
frame(wks)



end