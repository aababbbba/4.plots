;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; Código hecho por Pablo Andrés Cárdenas Zamorano - UTFSM - 2018 ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Calcula el RMSE en los puntos de medición según la serie de tiempo experimental (cada 10m)
;1. Extrae las velocidades en los primeros 8 niveles
;2. Interpola a 6 alturas caracteristicas: 10,40,60,80,100 y 116.5m
;3. Almacena los datos reales y los datos simulados en arreglos
;4; Calcula el RMSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Carga de paquetes
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
begin
;Inicialización del entorno
wks = gsn_open_wks("pdf","ts_interpol_compare")
;Obtención de datos
print("        Cargando datos...")
datau = readAsciiTable("../metm.d07.UUmod", 21, "float", 1)
datav = readAsciiTable("../metm.d07.VVmod", 21, "float", 1)
data    = readAsciiTable("main/data_hovsore.txt", 10, "float", 1)
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
;Alturas a interpolar
magu_n1 = sqrt(datau(:,1)^2.0 + datav(:,1)^2.0)
magu_n4 = sqrt(datau(:,4)^2.0 + datav(:,4)^2.0)
magu_n6 = sqrt(datau(:,6)^2.0 + datav(:,6)^2.0)
magu_n7 = sqrt(datau(:,7)^2.0 + datav(:,7)^2.0)
magu_n8 = sqrt(datau(:,8)^2.0 + datav(:,8)^2.0)
magu_n9 = sqrt(datau(:,9)^2.0 + datav(:,9)^2.0)
;Constantes
z0 = 15./1000. ;Lo debería entregar el modelo

;interpolación10m
zr = auxz(0)
print(zr)
magu_10m = magu_n1*(log(10.0/z0)/log(zr/z0))
; ;interpolación40m
zr = auxz(3)
print(zr)
magu_40m = magu_n4*(log(40.0/z0)/log(zr/z0))
; ;interpolación60m
zr = auxz(5)
print(zr)
magu_60m = magu_n6*(log(60.0/z0)/log(zr/z0))
; ;interpolación80m
zr = auxz(6)
print(zr)
magu_80m = magu_n7*(log(80.0/z0)/log(zr/z0))
; ;interpolación100m
zr = auxz(7)
print(zr)
magu_100m = magu_n8*(log(100.0/z0)/log(zr/z0))
; ;interpolación116.5m
zr = auxz(8)
print(zr)
magu_116m = magu_n9*(log(116.5/z0)/log(zr/z0))
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;Gráfico de velocidad;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;Caracteríticas de gráfico de velocidad
res                        = True
res@gsnMaximize            = True      
;res@xyLineThicknesses      = 1
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
res@tmGridDrawOrder        = "PreDraw"

res@trYMaxF           = 20.0
res@trYMinF           = 0;min_uv

res@trXMaxF           = 22.0
res@trXMinF           = 8.0

;Definición de la paleta de colores
gsn_define_colormap(wks,"MPL_viridis")
;Datos experimentales
nn = 2.0
res@xyLineThicknessF = 3.0
res@xyDashPattern = 14
res@xyLineColor       = (254/6)*6   
plot1  = gsn_csm_xy(wks,data(:,0)+nn,data(:,1),res)

res@xyLineColor       = (254/6)*5 
plot12  = gsn_csm_xy(wks,data(:,0)+nn,data(:,2),res)
overlay(plot1,plot12) 

res@xyLineColor       = (254/6)*4 
plot13  = gsn_csm_xy(wks,data(:,0)+nn,data(:,3),res)
overlay(plot1,plot13)

res@xyLineColor       = (254/6)*3 
plot14  = gsn_csm_xy(wks,data(:,0)+nn,data(:,4),res)
overlay(plot1,plot14) 

res@xyLineColor       = (254/6)*2 
plot15  = gsn_csm_xy(wks,data(:,0)+nn,data(:,5),res) 
overlay(plot1,plot15)

res@xyLineColor       = (254/6)*1 
plot16  = gsn_csm_xy(wks,data(:,0)+nn,data(:,6),res)
overlay(plot1,plot16) 

nn = 8.0 ;Factor de corrección horaria
tt = datau(:,0)+nn
res@xyLineThicknessF = 4.0
res@xyMonoLineThickness = True
res@xyDashPattern = 0
res@xyLineColor       = (254/6)*1   
plot11  = gsn_csm_xy(wks,tt,magu_10m,res)
overlay(plot1,plot11)
res@xyLineColor       = (254/6)*2
plot2  = gsn_csm_xy(wks,tt,magu_40m,res)
overlay(plot1,plot2) 
res@xyLineColor       = (254/6)*3
plot3  = gsn_csm_xy(wks,tt,magu_60m,res)
overlay(plot1,plot3)
res@xyLineColor       = (254/6)*4
plot4  = gsn_csm_xy(wks,tt,magu_80m,res)
overlay(plot1,plot4) 
res@xyLineColor       = (254/6)*5
plot5  = gsn_csm_xy(wks,tt,magu_100m,res) 
overlay(plot1,plot5)
res@xyLineColor       = (254/6)*6
plot6  = gsn_csm_xy(wks,tt,magu_116m,res)
overlay(plot1,plot6)

res@xyLineThicknessF = 2
res@xyLineColors       = "Black"
plotxx = gsn_csm_xy(wks,(/14,14/),(/-2.0,25/),res)
overlay(plot1,plotxx)

auxz2 = new(6,float)
auxz2 = (/10,40,60,80,100,116.5/)
nn = 0.0 ;Factor de corrección horaria
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
textres@lgLabels     = (/"z = "+sprintf("%6.1f",auxz2(0))+" m","z = "+sprintf("%6.1f",auxz2(1))+" m","z = "+sprintf("%6.1f",auxz2(2))+" m"/)
lineres@lgLineColors = (/(254/6)*1,(254/6)*2,(254/6)*3/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)
;Segunda Columna
gres@YPosPercent     = 22.5
gres@XPosPercent     = 18.0
textres@lgLabels     = (/"z = "+sprintf("%6.1f",auxz2(3))+" m","z = "+sprintf("%6.1f",auxz2(4))+" m","z = "+sprintf("%6.1f",auxz2(5))+" m"/)
lineres@lgLineColors = (/(254/6)*4,(254/6)*5,(254/6)*6/)
plot1                = simple_legend(wks,plot1,gres,lineres,textres)

draw(plot1)
frame(wks)


; ;almacenamiento de lo datos reales
; datos_real = new((/6,49/),float)
; do ii = 0,5,1
;     datos_real(ii,:) = data(36:,6-ii)
; end do

; ;Constantes que dependen del dt 
; auxdt = 9720    ;numero de la fila donde pasan 10 min en la ts 
; auxts = 349920-1  ;numero de la fila donde empiezan las 12:00

; ;almacenamiento de lo datos simulados
; datos_simu = new((/6,49/),float)
; do jj=0,48,1
;     datos_simu(0,jj) = magu_10m(auxts+jj*auxdt) 
; end do
; do jj=0,48,1
;     datos_simu(1,jj) = magu_40m(auxts+jj*auxdt) 
; end do
; do jj=0,48,1
;     datos_simu(2,jj) = magu_60m(auxts+jj*auxdt) 
; end do
; do jj=0,48,1
;     datos_simu(3,jj) = magu_80m(auxts+jj*auxdt) 
; end do
; do jj=0,48,1
;     datos_simu(4,jj) = magu_100m(auxts+jj*auxdt) 
; end do
; do jj=0,48,1
;     datos_simu(5,jj) = magu_116m(auxts+jj*auxdt) 
; end do
; print("")
; ;Cálculo de RMSE
; rmse = sqrt(sum((datos_simu - datos_real)^2.0)/(6.0*49.0))
; print("RMSE  =  "+rmse+" m/s")

; ;Cálculo del MAE
; abs_error = sqrt(sum(abs(datos_simu - datos_real))/(6.0*49.0))
; print("MAE   =  "+abs_error+" m/s")
end