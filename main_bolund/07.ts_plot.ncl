;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; Código hecho por Pablo Andrés Cárdenas Zamorano - UTFSM - 2018 ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Esta subrutina grafica la serie de tiempo de velocidad y ángulo en el punto de interés según tslist en wrf
;La serie de tiempo se grafica por todos los niveles eta, partiendo desde la superficie hasta el nivel 10
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Carga de paquetes
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
begin

mast = "8"

;Inicialización del entorno
wks = gsn_open_wks("png","ts/4.ts.m"+mast)
;Obtención de datos para la velocidad
print("        Cargando datos...")
datau = readAsciiTable("../m"+mast+".d08.UUmod", 21, "float", 1)
datav = readAsciiTable("../m"+mast+".d08.VVmod", 21, "float", 1)


;Obteción de datos para la alura de cada nivel
DATADir     = "../"
FILES       = systemfunc (" ls -1 " + DATADir + "wrfout_d08_*")
a           = addfiles(FILES,"r")
mdims       = getfilevardimsizes(a[0],"P")
nd          = dimsizes(mdims)
dimX        = mdims(nd-1)
dimY        = mdims(nd-2)

;Obtención de altura para cada nivel
if (mast .eq. "1")
    dataLON     = 12.09760
    dataLAT     = 55.70332
end if
if (mast .eq. "2")
    dataLON     = 12.09787
    dataLAT     = 55.70340
end if
if (mast .eq. "3")
    dataLON     = 12.09850
    dataLAT     = 55.70360
end if
if (mast .eq. "4")
    dataLON     = 12.09927
    dataLAT     = 55.70386
end if
if (mast .eq. "5")
    dataLON     = 12.09848
    dataLAT     = 55.70315
end if
if (mast .eq. "6")
    dataLON     = 12.09770
    dataLAT     = 55.70360
end if
if (mast .eq. "7")
    dataLON     = 12.09735
    dataLAT     = 55.70360
end if
if (mast .eq. "8")
    dataLON     = 12.09992
    dataLAT     = 55.70360
end if

loc         = wrf_user_ll_to_ij(a[0], dataLON, dataLAT, True)
locX        = loc(0)
locY        = loc(1)
hgt         = wrf_user_getvar(a[0], "HGT",0)
if ( locX .lt. 1 .or. locX .gt. dimX .or. locY .lt. 1 .or. locY .gt. dimY )
    print("Punto fuera de dominio")
else 
    locX    = locX - 1
    locY    = locY - 1
end if
z           = wrf_user_getvar(a[0],"z",0)
auxz        = z(:,locX,locY) - hgt(locX,locY)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;Gráfico de velocidad;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Caracteríticas de gráfico de velocidad
res                        = True
res@gsnMaximize            = True      
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
res@trYMaxF           = 15.0
res@trYMinF           = 0
res@trXMaxF           = 24.0
res@trXMinF           = 0.0
res@xyMonoLineThickness = True
res@xyLineThicknessF = 4.0
;Definición de la paleta de colores
gsn_define_colormap(wks,"MPL_viridis")
nn = 6.0 ;Factor de corrección horaria
;Creación de gráficos por los 10 primeros niveles

magu = sqrt(datau(:,1)^2.0 + datav(:,1)^2.0)
res@xyLineColor       = 2  
plot1  = gsn_csm_xy(wks,datau(:,0)+nn,magu,res)
magu = sqrt(datau(:,2)^2.0 + datav(:,2)^2.0)
res@xyLineColor       = 31
plot2  = gsn_csm_xy(wks,datau(:,0)+nn,magu,res)
overlay(plot1,plot2) 
magu = sqrt(datau(:,3)^2.0 + datav(:,3)^2.0)
res@xyLineColor       = 59
plot3  = gsn_csm_xy(wks,datau(:,0)+nn,magu,res)
overlay(plot1,plot3)
magu = sqrt(datau(:,4)^2.0 + datav(:,4)^2.0)
res@xyLineColor       = 87
plot4  = gsn_csm_xy(wks,datau(:,0)+nn,magu,res)
overlay(plot1,plot4) 
magu = sqrt(datau(:,5)^2.0 + datav(:,5)^2.0)
res@xyLineColor       = 115
plot5  = gsn_csm_xy(wks,datau(:,0)+nn,magu,res) 
overlay(plot1,plot5)

magu = sqrt(datau(:,6)^2.0 + datav(:,6)^2.0)
res@xyLineColor       = 143
plot6  = gsn_csm_xy(wks,datau(:,0)+nn,magu,res)
overlay(plot1,plot6) 
magu = sqrt(datau(:,7)^2.0 + datav(:,7)^2.0)
res@xyLineColor       = 171
plot7  = gsn_csm_xy(wks,datau(:,0)+nn,magu,res)
overlay(plot1,plot7) 
magu = sqrt(datau(:,8)^2.0 + datav(:,8)^2.0)
res@xyLineColor       = 199
plot8  = gsn_csm_xy(wks,datau(:,0)+nn,magu,res)
overlay(plot1,plot8)
magu = sqrt(datau(:,9)^2.0 + datav(:,9)^2.0)
res@xyLineColor       = 227
plot9  = gsn_csm_xy(wks,datau(:,0)+nn,magu,res)
overlay(plot1,plot9) 
magu = sqrt(datau(:,10)^2.0 + datav(:,10)^2.0)
res@xyLineColor       = 255
plot10  = gsn_csm_xy(wks,datau(:,0)+nn,magu,res) 
overlay(plot1,plot10)
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
gres@YPosPercent     = 24.5
gres@XPosPercent     = 4.0
textres@lgLabels     = (/"z = "+sprintf("%6.2f",auxz(0))+" m","z = "+sprintf("%6.2f",auxz(1))+" m","z = "+sprintf("%6.2f",auxz(2))+" m","z = "+sprintf("%6.2f",auxz(3))+" m","z = "+sprintf("%6.2f",auxz(4))+" m"/)
lineres@lgLineColors = (/2,31,59,87,115/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)
;Segunda Columna
gres@YPosPercent     = 24.5
gres@XPosPercent     = 18.0
textres@lgLabels     = (/"z = "+sprintf("%6.2f",auxz(5))+" m","z = "+sprintf("%6.2f",auxz(6))+" m","z = "+sprintf("%6.2f",auxz(7))+" m","z = "+sprintf("%6.2f",auxz(8))+" m","z = "+sprintf("%6.2f",auxz(9))+" m"/)
lineres@lgLineColors = (/143,171,199,227,255/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)
print("        Graficando serie de tiempo para velocidades...")
draw(plot1)
frame(wks)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;grafico de solo u
res@tiYAxisString     = "u (m s-1)"
;res@trYMaxF           = 0
;res@trYMinF           = -19

res@xyLineColor       = 2  
plot1  = gsn_csm_xy(wks,datau(:,0)+nn,datau(:,1),res)
res@xyLineColor       = 31
plot2  = gsn_csm_xy(wks,datau(:,0)+nn,datau(:,2),res)
overlay(plot1,plot2) 
res@xyLineColor       = 59
plot3  = gsn_csm_xy(wks,datau(:,0)+nn,datau(:,3),res)
overlay(plot1,plot3)
res@xyLineColor       = 87
plot4  = gsn_csm_xy(wks,datau(:,0)+nn,datau(:,4),res)
overlay(plot1,plot4) 
res@xyLineColor       = 115
plot5  = gsn_csm_xy(wks,datau(:,0)+nn,datau(:,5),res) 
overlay(plot1,plot5)

res@xyLineColor       = 143
plot6  = gsn_csm_xy(wks,datau(:,0)+nn,datau(:,6),res)
overlay(plot1,plot6) 
res@xyLineColor       = 171
plot7  = gsn_csm_xy(wks,datau(:,0)+nn,datau(:,7),res)
overlay(plot1,plot7) 
res@xyLineColor       = 199
plot8  = gsn_csm_xy(wks,datau(:,0)+nn,datau(:,8),res)
overlay(plot1,plot8)
res@xyLineColor       = 227
plot9  = gsn_csm_xy(wks,datau(:,0)+nn,datau(:,9),res)
overlay(plot1,plot9) 
res@xyLineColor       = 255
plot10  = gsn_csm_xy(wks,datau(:,0)+nn,datau(:,10),res) 
overlay(plot1,plot10)
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
gres@YPosPercent     = 24.5
gres@XPosPercent     = 4.0
textres@lgLabels     = (/"z = "+sprintf("%6.2f",auxz(0))+" m","z = "+sprintf("%6.2f",auxz(1))+" m","z = "+sprintf("%6.2f",auxz(2))+" m","z = "+sprintf("%6.2f",auxz(3))+" m","z = "+sprintf("%6.2f",auxz(4))+" m"/)
lineres@lgLineColors = (/2,31,59,87,115/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)
;Segunda Columna
gres@YPosPercent     = 24.5
gres@XPosPercent     = 18.0
textres@lgLabels     = (/"z = "+sprintf("%6.2f",auxz(5))+" m","z = "+sprintf("%6.2f",auxz(6))+" m","z = "+sprintf("%6.2f",auxz(7))+" m","z = "+sprintf("%6.2f",auxz(8))+" m","z = "+sprintf("%6.2f",auxz(9))+" m"/)
lineres@lgLineColors = (/143,171,199,227,255/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)
print("        Graficando serie de tiempo para velocidades u...")
draw(plot1)
frame(wks)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;grafico de solo v
res@tiYAxisString     = "v (m s-1)"
res@xyLineThicknessF  = 4.0
;res@trYMaxF           = 8
;res@trYMinF           = 0

res@xyLineColor       = 2  
plot1  = gsn_csm_xy(wks,datau(:,0)+nn,datav(:,1),res)
res@xyLineColor       = 31
plot2  = gsn_csm_xy(wks,datau(:,0)+nn,datav(:,2),res)
overlay(plot1,plot2) 
res@xyLineColor       = 59
plot3  = gsn_csm_xy(wks,datau(:,0)+nn,datav(:,3),res)
overlay(plot1,plot3)
res@xyLineColor       = 87
plot4  = gsn_csm_xy(wks,datau(:,0)+nn,datav(:,4),res)
overlay(plot1,plot4) 
res@xyLineColor       = 115
plot5  = gsn_csm_xy(wks,datau(:,0)+nn,datav(:,5),res) 
overlay(plot1,plot5)

res@xyLineColor       = 143
plot6  = gsn_csm_xy(wks,datau(:,0)+nn,datav(:,6),res)
overlay(plot1,plot6) 
res@xyLineColor       = 171
plot7  = gsn_csm_xy(wks,datau(:,0)+nn,datav(:,7),res)
overlay(plot1,plot7) 
res@xyLineColor       = 199
plot8  = gsn_csm_xy(wks,datau(:,0)+nn,datav(:,8),res)
overlay(plot1,plot8)
res@xyLineColor       = 227
plot9  = gsn_csm_xy(wks,datau(:,0)+nn,datav(:,9),res)
overlay(plot1,plot9) 
res@xyLineColor       = 255
plot10  = gsn_csm_xy(wks,datau(:,0)+nn,datav(:,10),res) 
overlay(plot1,plot10)
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
gres@YPosPercent     = 24.5
gres@XPosPercent     = 4.0
textres@lgLabels     = (/"z = "+sprintf("%6.2f",auxz(0))+" m","z = "+sprintf("%6.2f",auxz(1))+" m","z = "+sprintf("%6.2f",auxz(2))+" m","z = "+sprintf("%6.2f",auxz(3))+" m","z = "+sprintf("%6.2f",auxz(4))+" m"/)
lineres@lgLineColors = (/2,31,59,87,115/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)
;Segunda Columna
gres@YPosPercent     = 24.5
gres@XPosPercent     = 18.0
textres@lgLabels     = (/"z = "+sprintf("%6.2f",auxz(5))+" m","z = "+sprintf("%6.2f",auxz(6))+" m","z = "+sprintf("%6.2f",auxz(7))+" m","z = "+sprintf("%6.2f",auxz(8))+" m","z = "+sprintf("%6.2f",auxz(9))+" m"/)
lineres@lgLineColors = (/143,171,199,227,255/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)
print("        Graficando serie de tiempo para velocidades v...")
draw(plot1)
frame(wks)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
res2@trYMaxF                    = 360.
res2@trYMinF                    = 0.
res2@trXMaxF           = 24.0
res2@trXMinF           = 0.0
;Definición de la paleta de colores
gsn_define_colormap(wks,"MPL_plasma")
;Selección de colores para el gráfico de ángulos
colorlow  = 2
colorhigh = (255-2);*3/4
h         = (colorhigh - colorlow)/9
color     = new(10,integer)
color(0)  = colorlow
;Ciclo que define el numero de color en la paleta
do i = 1,9
    color(i) = color(i-1)+h
end do

;Creación de gráficos por los 10 primeros niveles
res2@xyMonoLineThickness = True
res2@xyLineThicknessF = 4.0
wdir = wind_direction(datau(:,1),datav(:,1),0)
res2@xyLineColor       = color(0)
plot1  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res2)
wdir = wind_direction(datau(:,2),datav(:,2),0)
res2@xyLineColor       = color(1)
plot2  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res2)
overlay(plot1,plot2) 
wdir = wind_direction(datau(:,3),datav(:,3),0)
res2@xyLineColor       = color(2)
plot3  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res2)
overlay(plot1,plot3)
wdir = wind_direction(datau(:,4),datav(:,4),0)
res2@xyLineColor       = color(3)
plot4  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res2)
overlay(plot1,plot4) 
wdir = wind_direction(datau(:,5),datav(:,5),0)
res2@xyLineColor       = color(4)
plot5  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res2)
overlay(plot1,plot5)

wdir = wind_direction(datau(:,6),datav(:,6),0)
res2@xyLineColor       = color(5)
plot6  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res2)
overlay(plot1,plot6) 
wdir = wind_direction(datau(:,7),datav(:,7),0)
res2@xyLineColor       = color(6)
plot7  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res2)
overlay(plot1,plot7) 
wdir = wind_direction(datau(:,8),datav(:,8),0)
res2@xyLineColor       = color(7) 
plot8  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res2)
overlay(plot1,plot8)
wdir = wind_direction(datau(:,9),datav(:,9),0)
res2@xyLineColor       = color(8)
plot9  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res2)
overlay(plot1,plot9) 
wdir = wind_direction(datau(:,10),datav(:,10),0)
res2@xyLineColor       = color(9) 
plot10  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res2)
overlay(plot1,plot10)

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
textres@lgLabels     = (/"z = "+sprintf("%6.2f",auxz(0))+" m","z = "+sprintf("%6.2f",auxz(1))+" m","z = "+sprintf("%6.2f",auxz(2))+" m","z = "+sprintf("%6.2f",auxz(3))+" m","z = "+sprintf("%6.2f",auxz(4))+" m"/)
lineres@lgLineColors = (/color(0),color(1),color(2),color(3),color(4)/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)
;Segunda Columna
gres@YPosPercent     = 92.5
gres@XPosPercent     = 18.0
textres@lgLabels     = (/"z = "+sprintf("%6.2f",auxz(5))+" m","z = "+sprintf("%6.2f",auxz(6))+" m","z = "+sprintf("%6.2f",auxz(7))+" m","z = "+sprintf("%6.2f",auxz(8))+" m","z = "+sprintf("%6.2f",auxz(9))+" m"/)
lineres@lgLineColors = (/color(5),color(6),color(7),color(8),color(9)/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)

print("        Graficando serie de tiempo para angulos...")
draw(plot1)
frame(wks)
end