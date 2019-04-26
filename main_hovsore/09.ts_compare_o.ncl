;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; Código hecho por Pablo Andrés Cárdenas Zamorano - UTFSM - 2018 ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Calcula el RMSE en los puntos de medición según la serie de tiempo experimental (cada 10m)
;1. Extrae las velocidades en los primeros 8 niveles
;3. Almacena los datos reales y los datos simulados en arreglos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Carga de paquetes
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
begin
;Inicialización del entorno
wks = gsn_open_wks("pdf","ts_interpol_compare_o")
;Obtención de datos
print("        Cargando datos...")
datau = readAsciiTable("../metm.d07.UUmod", 21, "float", 1)
datav = readAsciiTable("../metm.d07.VVmod", 21, "float", 1)
data    = readAsciiTable("main/data_hovsore_v2.txt", 10, "float", 1)
;Obteción de datos para la alura de cada nivel
DATADir     = "../"
FILES       = systemfunc (" ls -1 " + DATADir + "wrfout_d07_*")
a           = addfiles(FILES,"r")
mdims       = getfilevardimsizes(a[0],"P")
nd          = dimsizes(mdims)
dimX        = mdims(nd-1)
dimY        = mdims(nd-2)
;Obtención de altura para cada nivel
dataLON     =  8.150896
dataLAT     = 56.440582
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
print(auxz)
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
res2@tmGridDrawOrder            = "PreDraw"    
res2@xyLineThicknesses          = 1  
res2@tiXAxisString              = "t (h)" 
res2@tiYAxisString              = "~F33~q~F~ (~F34~0~F~)"
res2@trYMaxF                    = 180.
res2@trYMinF                    = 0.
res2@trXMaxF                    = 24.0
res2@trXMinF                    = 0.0

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

;Datos observador
nn = 0.0
res2@xyMonoLineThickness = True
res2@xyLineThicknessF = 3.0
res2@xyDashPattern = 14

res2@xyLineColor       = (254/6)*6 
plot1  = gsn_csm_xy(wks,data(:,0)+nn,data(:,7),res2)

res2@xyLineColor       = (254/6)*3 
plot13  = gsn_csm_xy(wks,data(:,0)+nn,data(:,8),res2)
overlay(plot1,plot13)

res2@xyLineColor       = 5 
plot14  = gsn_csm_xy(wks,data(:,0)+nn,data(:,9),res2)
overlay(plot1,plot14) 

;Creación de gráficos por los 10 primeros niveles
nn = 6.0 ;Factor de corrección horaria
res2@xyDashPattern = 0
res2@xyMonoLineThickness = True
res2@xyLineThicknessF = 4.0
wdir = wind_direction(datau(:,1),datav(:,1),0)
res2@xyLineColor       = color(0)
plot12  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res2)
overlay(plot1,plot12) 
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




res2@xyLineThicknessF = 2
res2@xyDashPattern     = 14
res2@xyLineColors       = "Black"
plotxx = gsn_csm_xy(wks,(/12,12/),(/-2.0,190/),res2)
overlay(plot1,plotxx)

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
lineres@lgLineColors = (/5,(254/6)*3 ,(254/6)*6/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)

print("        Graficando serie de tiempo para angulos...")
draw(plot1)
frame(wks)
end