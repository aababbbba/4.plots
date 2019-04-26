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
wks = gsn_open_wks("pdf","ts_interpol_compare_o")
;Parámetros generales para todos los gráficos
;Obtención de datos para la velocidad
print("Cargando datos experimentales...")
;data experimental
data = readAsciiTable("main/bolund_data.txt", 41, "float", 1)
;Obteción de datos para la alura de cada nivel
DATADir     = "../"
FILES       = systemfunc (" ls -1 " + DATADir + "wrfout_d08_*")
a           = addfiles(FILES,"r")
mdims       = getfilevardimsizes(a[0],"P")
nd          = dimsizes(mdims)
dimX        = mdims(nd-1)
dimY        = mdims(nd-2)
hgt         = wrf_user_getvar(a[0], "HGT",0); altura de la superficie
z           = wrf_user_getvar(a[0], "z" ,0) ;campo de z en cada elemento del dominio
;Configuración de los gráficos de velocidad
res                             = True
res@gsnMaximize                 = True      
res@vpWidthF                    = 0.8  
res@vpHeightF                   = 0.3
res@tiMainFontHeightF           = 0.015
res@tiXAxisString               = "t (h)"
res@tiXAxisFontHeightF          = 0.0115
res@tiYAxisString               = "~F33~q~F~ (~F34~0~F~)"
res@tiYAxisFontHeightF          = 0.0115
res@gsnDraw                     = False
res@gsnFrame                    = False
res@tmXBLabelFontHeightF        = 0.01
res@tmYLLabelFontHeightF        = 0.01
res@tmXBMajorOutwardLengthF     = 0.0
res@tmXBMinorOutwardLengthF     = 0.0
res@tmYLMajorOutwardLengthF     = 0.0
res@tmYLMinorOutwardLengthF     = 0.0
res@tmXMajorGrid                = True
res@tmYMajorGrid                = True
res@tmYMajorGridLineColor       = "Gray"
res@tmXMajorGridLineColor       = "Gray"
res@tmGridDrawOrder             = "PreDraw"
res@trYMaxF                     = 360.0
res@trYMinF                     = 0.0
res@trXMaxF                     = 24.0
res@trXMinF                     = 0.0
gsn_define_colormap(wks,"MPL_plasma")
;Configuración de la legenda
gres                            = True
lineres                         = True
textres                         = True
lineres@lgLineThicknesses       = 5.0
lineres@LineLengthPercent       = 2.
gres@ItemSpacePercent           = 5.
gres@LineLabelWhiteSpacePercent = 1
textres@lgLabelFontHeights      = 0.0115
gres@YPosPercent                = 91.5
gres@XPosPercent                = 4.0
;Selección de colores para el gráfico de ángulos
colorlow  = 2
colorhigh = (230-2);*3/4
h         = (colorhigh - colorlow)/4
color     = new(10,integer)
color(0)  = colorlow
;Ciclo que define el numero de color en la paleta
do i = 1,4
    color(i) = color(i-1)+h
end do
;M1 M1 M1 M1
;M1 M1 M1 M1
;M1 M1 M1 M1
    ;Obtención de altura para cada nivel
    print("Creando gráfico para M1...")
    dataLON     = 12.09760
    dataLAT     = 55.70332
    loc         = wrf_user_ll_to_ij(a[0], dataLON, dataLAT, True)
    locX        = loc(0)
    locY        = loc(1)
    if ( locX .lt. 1 .or. locX .gt. dimX .or. locY .lt. 1 .or. locY .gt. dimY )
        print("Punto fuera de dominio")
    else 
        locX    = locX - 1
        locY    = locY - 1
    end if
    auxz        = z(:,locX,locY) - hgt(locX,locY)
    ;data de simulación
    datau = readAsciiTable("../m1.d08.UUmod", 21, "float", 1)
    datav = readAsciiTable("../m1.d08.VVmod", 21, "float", 1)
    ;Gráfico de velocidad
    res@tiMainString        = "M1 Wind Direction"
    ;Datos medidos
    nn = 6.0 ;Factor de corrección horaria
    tt = datau(:,0)+nn
    res@xyLineThicknessF    = 4.0
    res@xyDashPattern       = 0
    ;hacer gráficos
    wdir = wind_direction(datau(:,1),datav(:,1),0)
    res@xyLineColor       = color(0)
    plot1  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    wdir = wind_direction(datau(:,2),datav(:,2),0)
    res@xyLineColor       = color(1)
    plot2  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot2) 
    wdir = wind_direction(datau(:,3),datav(:,3),0)
    res@xyLineColor       = color(2)
    plot3  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot3)
    wdir = wind_direction(datau(:,4),datav(:,4),0)
    res@xyLineColor       = color(3)
    plot4  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot4) 
    wdir = wind_direction(datau(:,5),datav(:,5),0)
    res@xyLineColor       = color(4)
    plot5  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot5)
    ;Datos experimentales
    nn                      = 0.0
    res@xyLineThicknessF    = 3.0
    res@xyDashPattern       = 14
    ;hacer graficos
    res@xyLineColor       = 190 
    plot22  = gsn_csm_xy(wks,data(:,0)+nn,data(:,4),res)
    res@xyLineColor       = 127
    overlay(plot1,plot22) 
    plot12  = gsn_csm_xy(wks,data(:,0)+nn,data(:,5),res)
    overlay(plot1,plot12) 
    res@xyLineColor       = 64
    plot13  = gsn_csm_xy(wks,data(:,0)+nn,data(:,6),res)
    overlay(plot1,plot13)
    ;Marca del Spinup
    res@xyLineThicknessF  = 2
    res@xyLineColor       = 1
    res@xyDashPattern     = 14
    plotxx = gsn_csm_xy(wks,(/12,12/),(/-2.0,400/),res)
    overlay(plot1,plotxx)
    ;Creación de la Legenda
    textres@lgLabels     = (/"z = "+sprintf("%6.1f",9.0)+" m","z = "+sprintf("%6.1f",5.0)+" m","z = "+sprintf("%6.1f",2.0)+" m"/)
    lineres@lgLineColors = (/190,127,64/)
    plot1                = simple_legend(wks,plot1,gres,lineres,textres)
    ;Creación de segunda legenda
    gres@YPosPercent     = 30.0
    gres@XPosPercent     = 4.0
    delete(textres@lgLabels)
    delete(lineres@lgLineColors)
    textres@lgLabels     = (/"z = "+sprintf("%6.2f",auxz(0))+" m","z = "+sprintf("%6.2f",auxz(1))+" m","z = "+sprintf("%6.2f",auxz(2))+" m","z = "+sprintf("%6.2f",auxz(3))+" m","z = "+sprintf("%6.2f",auxz(4))+" m"/)
    lineres@lgLineColors = (/color(0),color(1),color(2),color(3),color(4)/)
    plot1                = simple_legend(wks,plot1,gres,lineres,textres)
    ;Finalización del gráfico
    draw(plot1)
    frame(wks)
;M2 M2 M2 M2
;M2 M2 M2 M2
;M2 M2 M2 M2
    ;Obtención de altura para cada nivel
    print("Creando gráfico para M2...")
    dataLON     = 12.09787
    dataLAT     = 55.70340
    loc         = wrf_user_ll_to_ij(a[0], dataLON, dataLAT, True)
    locX        = loc(0)
    locY        = loc(1)
    if ( locX .lt. 1 .or. locX .gt. dimX .or. locY .lt. 1 .or. locY .gt. dimY )
        print("Punto fuera de dominio")
    else 
        locX    = locX - 1
        locY    = locY - 1
    end if
    auxz        = z(:,locX,locY) - hgt(locX,locY)
    ;data de simulación
    delete(datau)
    delete(datav)
    delete(wdir)
    delete(tt)
    datau = readAsciiTable("../m2.d08.UUmod", 21, "float", 1)
    datav = readAsciiTable("../m2.d08.VVmod", 21, "float", 1)
    ;Gráfico de velocidad
    res@tiMainString        = "M2 Wind Direction"
    ;Datos medidos
    nn = 6.0 ;Factor de corrección horaria
    tt = datau(:,0)+nn
    res@xyLineThicknessF    = 4.0
    res@xyDashPattern       = 0
    ;hacer gráficos
    wdir = wind_direction(datau(:,1),datav(:,1),0)
    res@xyLineColor       = color(0)
    plot1  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    wdir = wind_direction(datau(:,2),datav(:,2),0)
    res@xyLineColor       = color(1)
    plot2  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot2) 
    wdir = wind_direction(datau(:,3),datav(:,3),0)
    res@xyLineColor       = color(2)
    plot3  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot3)
    wdir = wind_direction(datau(:,4),datav(:,4),0)
    res@xyLineColor       = color(3)
    plot4  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot4) 
    wdir = wind_direction(datau(:,5),datav(:,5),0)
    res@xyLineColor       = color(4)
    plot5  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot5)
    ;Datos experimentales
    nn                      = 0.0
    res@xyLineThicknessF    = 3.0
    res@xyDashPattern       = 14
    ;hacer graficos
    res@xyLineColor       = 127 
    plot22  = gsn_csm_xy(wks,data(:,0)+nn,data(:,10),res)
    res@xyLineColor       = 64
    overlay(plot1,plot22) 
    plot12  = gsn_csm_xy(wks,data(:,0)+nn,data(:,11),res)
    overlay(plot1,plot12) 
    ;Marca del Spinup
    res@xyLineThicknessF  = 2
    res@xyLineColor       = 1
    plotxx = gsn_csm_xy(wks,(/12,12/),(/-2.0,400/),res)
    overlay(plot1,plotxx)
    ;Creación de la Legenda
    delete(textres@lgLabels)
    delete(lineres@lgLineColors)
    gres@YPosPercent        = 91.5
    gres@XPosPercent        = 4.0
    textres@lgLabels        = (/"z = "+sprintf("%6.1f",9.0)+" m","z = "+sprintf("%6.1f",5.0)+" m","z = "+sprintf("%6.1f",2.0)+" m"/)
    lineres@lgLineColors    = (/190,127,64/)
    plot1                   = simple_legend(wks,plot1,gres,lineres,textres)
    ;Creación de segunda legenda
    gres@YPosPercent     = 30.0
    gres@XPosPercent     = 4.0
    delete(textres@lgLabels)
    delete(lineres@lgLineColors)
    textres@lgLabels     = (/"z = "+sprintf("%6.2f",auxz(0))+" m","z = "+sprintf("%6.2f",auxz(1))+" m","z = "+sprintf("%6.2f",auxz(2))+" m","z = "+sprintf("%6.2f",auxz(3))+" m","z = "+sprintf("%6.2f",auxz(4))+" m"/)
    lineres@lgLineColors = (/color(0),color(1),color(2),color(3),color(4)/)
    plot1                = simple_legend(wks,plot1,gres,lineres,textres)
    ;Finalización del gráfico
    draw(plot1)
    frame(wks)
;M3 M3 M3 M3
;M3 M3 M3 M3
;M3 M3 M3 M3
    ;Obtención de altura para cada nivel
    print("Creando gráfico para M3...")
    dataLON     = 12.09850
    dataLAT     = 55.70360
    loc         = wrf_user_ll_to_ij(a[0], dataLON, dataLAT, True)
    locX        = loc(0)
    locY        = loc(1)
    if ( locX .lt. 1 .or. locX .gt. dimX .or. locY .lt. 1 .or. locY .gt. dimY )
        print("Punto fuera de dominio")
    else 
        locX    = locX - 1
        locY    = locY - 1
    end if
    auxz        = z(:,locX,locY) - hgt(locX,locY)
    ;data de simulación
    delete(datau)
    delete(datav)
    delete(wdir)
    delete(tt)
    datau = readAsciiTable("../m3.d08.UUmod", 21, "float", 1)
    datav = readAsciiTable("../m3.d08.VVmod", 21, "float", 1)
    ;Gráfico de velocidad
    res@tiMainString        = "M3 Wind Direction"
    ;Datos medidos
    nn = 6.0 ;Factor de corrección horaria
    tt = datau(:,0)+nn
    res@xyLineThicknessF    = 4.0
    res@xyDashPattern       = 0
    ;hacer gráficos
    wdir = wind_direction(datau(:,1),datav(:,1),0)
    res@xyLineColor       = color(0)
    plot1  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    wdir = wind_direction(datau(:,2),datav(:,2),0)
    res@xyLineColor       = color(1)
    plot2  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot2) 
    wdir = wind_direction(datau(:,3),datav(:,3),0)
    res@xyLineColor       = color(2)
    plot3  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot3)
    wdir = wind_direction(datau(:,4),datav(:,4),0)
    res@xyLineColor       = color(3)
    plot4  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot4) 
    wdir = wind_direction(datau(:,5),datav(:,5),0)
    res@xyLineColor       = color(4)
    plot5  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot5)
    ;Datos experimentales
    nn                      = 0.0
    res@xyLineThicknessF    = 3.0
    res@xyDashPattern       = 14
    ;hacer graficos
    res@xyLineColor       = 127 
    plot22  = gsn_csm_xy(wks,data(:,0)+nn,data(:,15),res)
    res@xyLineColor       = 64
    overlay(plot1,plot22) 
    plot12  = gsn_csm_xy(wks,data(:,0)+nn,data(:,16),res)
    overlay(plot1,plot12) 
    ;Marca del Spinup
    res@xyLineThicknessF  = 2
    res@xyLineColor       = 1
    plotxx = gsn_csm_xy(wks,(/12,12/),(/-2.0,400/),res)
    overlay(plot1,plotxx)
    ;Creación de la Legenda
    delete(textres@lgLabels)
    delete(lineres@lgLineColors)
    gres@YPosPercent        = 91.5
    gres@XPosPercent        = 4.0
    textres@lgLabels        = (/"z = "+sprintf("%6.1f",9.0)+" m","z = "+sprintf("%6.1f",5.0)+" m","z = "+sprintf("%6.1f",2.0)+" m"/)
    lineres@lgLineColors    = (/190,127,64/)
    plot1                   = simple_legend(wks,plot1,gres,lineres,textres)
    ;Creación de segunda legenda
    gres@YPosPercent     = 30.0
    gres@XPosPercent     = 4.0
    delete(textres@lgLabels)
    delete(lineres@lgLineColors)
    textres@lgLabels     = (/"z = "+sprintf("%6.2f",auxz(0))+" m","z = "+sprintf("%6.2f",auxz(1))+" m","z = "+sprintf("%6.2f",auxz(2))+" m","z = "+sprintf("%6.2f",auxz(3))+" m","z = "+sprintf("%6.2f",auxz(4))+" m"/)
    lineres@lgLineColors = (/color(0),color(1),color(2),color(3),color(4)/)
    plot1                = simple_legend(wks,plot1,gres,lineres,textres)
    ;Finalización del gráfico
    draw(plot1)
    frame(wks)
;M4 M4 M4 M4
;M4 M4 M4 M4
;M4 M4 M4 M4
    ;Obtención de altura para cada nivel
    print("Creando gráfico para M4...")
    dataLON     = 12.09927
    dataLAT     = 55.70386
    loc         = wrf_user_ll_to_ij(a[0], dataLON, dataLAT, True)
    locX        = loc(0)
    locY        = loc(1)
    if ( locX .lt. 1 .or. locX .gt. dimX .or. locY .lt. 1 .or. locY .gt. dimY )
        print("Punto fuera de dominio")
    else 
        locX    = locX - 1
        locY    = locY - 1
    end if
    auxz        = z(:,locX,locY) - hgt(locX,locY)
    ;data de simulación
    delete(datau)
    delete(datav)
    delete(wdir)
    delete(tt)
    datau = readAsciiTable("../m4.d08.UUmod", 21, "float", 1)
    datav = readAsciiTable("../m4.d08.VVmod", 21, "float", 1)
    ;Gráfico de velocidad
    res@tiMainString        = "M4 Wind Direction"
    ;Datos medidos
    nn = 6.0 ;Factor de corrección horaria
    tt = datau(:,0)+nn
    res@xyLineThicknessF    = 4.0
    res@xyDashPattern       = 0
    ;hacer gráficos
    wdir = wind_direction(datau(:,1),datav(:,1),0)
    res@xyLineColor       = color(0)
    plot1  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    wdir = wind_direction(datau(:,2),datav(:,2),0)
    res@xyLineColor       = color(1)
    plot2  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot2) 
    wdir = wind_direction(datau(:,3),datav(:,3),0)
    res@xyLineColor       = color(2)
    plot3  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot3)
    wdir = wind_direction(datau(:,4),datav(:,4),0)
    res@xyLineColor       = color(3)
    plot4  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot4) 
    wdir = wind_direction(datau(:,5),datav(:,5),0)
    res@xyLineColor       = color(4)
    plot5  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot5)
    ;Datos experimentales
    nn                      = 0.0
    res@xyLineThicknessF    = 3.0
    res@xyDashPattern       = 14
    ;hacer graficos
    res@xyLineColor       = 190 
    plot22  = gsn_csm_xy(wks,data(:,0)+nn,data(:,20),res)
    res@xyLineColor       = 127
    overlay(plot1,plot22) 
    plot12  = gsn_csm_xy(wks,data(:,0)+nn,data(:,21),res)
    overlay(plot1,plot12) 
    res@xyLineColor       = 64
    plot13  = gsn_csm_xy(wks,data(:,0)+nn,data(:,22),res)
    overlay(plot1,plot13)
    ;Marca del Spinup
    res@xyLineThicknessF  = 2
    res@xyLineColor       = 1
    plotxx = gsn_csm_xy(wks,(/12,12/),(/-2.0,400/),res)
    overlay(plot1,plotxx)
    ;Creación de la Legenda
    delete(textres@lgLabels)
    delete(lineres@lgLineColors)
    gres@YPosPercent        = 91.5
    gres@XPosPercent        = 4.0
    textres@lgLabels        = (/"z = "+sprintf("%6.1f",9.0)+" m","z = "+sprintf("%6.1f",5.0)+" m","z = "+sprintf("%6.1f",2.0)+" m"/)
    lineres@lgLineColors    = (/190,127,64/)
    plot1                   = simple_legend(wks,plot1,gres,lineres,textres)
    ;Creación de segunda legenda
    gres@YPosPercent     = 30.0
    gres@XPosPercent     = 4.0
    delete(textres@lgLabels)
    delete(lineres@lgLineColors)
    textres@lgLabels     = (/"z = "+sprintf("%6.2f",auxz(0))+" m","z = "+sprintf("%6.2f",auxz(1))+" m","z = "+sprintf("%6.2f",auxz(2))+" m","z = "+sprintf("%6.2f",auxz(3))+" m","z = "+sprintf("%6.2f",auxz(4))+" m"/)
    lineres@lgLineColors = (/color(0),color(1),color(2),color(3),color(4)/)
    plot1                = simple_legend(wks,plot1,gres,lineres,textres)
    ;Finalización del gráfico
    draw(plot1)
    frame(wks)
;M5 M5 M5 M5
;M5 M5 M5 M5
;M5 M5 M5 M5
    ;Obtención de altura para cada nivel
    print("Creando gráfico para M5...")
    dataLON     = 12.09848
    dataLAT     = 55.70315
    loc         = wrf_user_ll_to_ij(a[0], dataLON, dataLAT, True)
    locX        = loc(0)
    locY        = loc(1)
    if ( locX .lt. 1 .or. locX .gt. dimX .or. locY .lt. 1 .or. locY .gt. dimY )
        print("Punto fuera de dominio")
    else 
        locX    = locX - 1
        locY    = locY - 1
    end if
    auxz        = z(:,locX,locY) - hgt(locX,locY)
    ;data de simulación
    delete(datau)
    delete(datav)
    delete(wdir)
    delete(tt)
    datau = readAsciiTable("../m5.d08.UUmod", 21, "float", 1)
    datav = readAsciiTable("../m5.d08.VVmod", 21, "float", 1)
    ;Gráfico de velocidad
    res@tiMainString        = "M5 Wind Direction"
    ;Datos medidos
    nn = 6.0 ;Factor de corrección horaria
    tt = datau(:,0)+nn
    res@xyLineThicknessF    = 4.0
    res@xyDashPattern       = 0
    ;hacer gráficos
    wdir = wind_direction(datau(:,1),datav(:,1),0)
    res@xyLineColor       = color(0)
    plot1  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    wdir = wind_direction(datau(:,2),datav(:,2),0)
    res@xyLineColor       = color(1)
    plot2  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot2) 
    wdir = wind_direction(datau(:,3),datav(:,3),0)
    res@xyLineColor       = color(2)
    plot3  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot3)
    wdir = wind_direction(datau(:,4),datav(:,4),0)
    res@xyLineColor       = color(3)
    plot4  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot4) 
    wdir = wind_direction(datau(:,5),datav(:,5),0)
    res@xyLineColor       = color(4)
    plot5  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot5)
    ;Datos experimentales
    nn                      = 0.0
    res@xyLineThicknessF    = 3.0
    res@xyDashPattern       = 14
    ;hacer graficos
    res@xyLineColor       = 127 
    plot22  = gsn_csm_xy(wks,data(:,0)+nn,data(:,25),res)
    res@xyLineColor       = 64
    overlay(plot1,plot22) 
    plot12  = gsn_csm_xy(wks,data(:,0)+nn,data(:,26),res)
    overlay(plot1,plot12) 
    ;Marca del Spinup
    res@xyLineThicknessF  = 2
    res@xyLineColor       = 1
    plotxx = gsn_csm_xy(wks,(/12,12/),(/-2.0,400/),res)
    overlay(plot1,plotxx)
    ;Creación de la Legenda
    delete(textres@lgLabels)
    delete(lineres@lgLineColors)
    gres@YPosPercent        = 91.5
    gres@XPosPercent        = 4.0
    textres@lgLabels        = (/"z = "+sprintf("%6.1f",9.0)+" m","z = "+sprintf("%6.1f",5.0)+" m","z = "+sprintf("%6.1f",2.0)+" m"/)
    lineres@lgLineColors    = (/190,127,64/)
    plot1                   = simple_legend(wks,plot1,gres,lineres,textres)
    ;Creación de segunda legenda
    gres@YPosPercent     = 30.0
    gres@XPosPercent     = 4.0
    delete(textres@lgLabels)
    delete(lineres@lgLineColors)
    textres@lgLabels     = (/"z = "+sprintf("%6.2f",auxz(0))+" m","z = "+sprintf("%6.2f",auxz(1))+" m","z = "+sprintf("%6.2f",auxz(2))+" m","z = "+sprintf("%6.2f",auxz(3))+" m","z = "+sprintf("%6.2f",auxz(4))+" m"/)
    lineres@lgLineColors = (/color(0),color(1),color(2),color(3),color(4)/)
    plot1                = simple_legend(wks,plot1,gres,lineres,textres)
    ;Finalización del gráfico
    draw(plot1)
    frame(wks)
;M6 M6 M6 M6
;M6 M6 M6 M6
;M6 M6 M6 M6
    ;Obtención de altura para cada nivel
    print("Creando gráfico para M6...")
    dataLON     = 12.09770
    dataLAT     = 55.70360
    loc         = wrf_user_ll_to_ij(a[0], dataLON, dataLAT, True)
    locX        = loc(0)
    locY        = loc(1)
    if ( locX .lt. 1 .or. locX .gt. dimX .or. locY .lt. 1 .or. locY .gt. dimY )
        print("Punto fuera de dominio")
    else 
        locX    = locX - 1
        locY    = locY - 1
    end if
    auxz        = z(:,locX,locY) - hgt(locX,locY)
    ;data de simulación
    delete(datau)
    delete(datav)
    delete(wdir)
    delete(tt)
    datau = readAsciiTable("../m6.d08.UUmod", 21, "float", 1)
    datav = readAsciiTable("../m6.d08.VVmod", 21, "float", 1)
    ;Gráfico de velocidad
    res@tiMainString        = "M6 Wind Direction"
    ;Datos medidos
    nn = 6.0 ;Factor de corrección horaria
    tt = datau(:,0)+nn
    res@xyLineThicknessF    = 4.0
    res@xyDashPattern       = 0
    ;hacer gráficos
    wdir = wind_direction(datau(:,1),datav(:,1),0)
    res@xyLineColor       = color(0)
    plot1  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    wdir = wind_direction(datau(:,2),datav(:,2),0)
    res@xyLineColor       = color(1)
    plot2  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot2) 
    wdir = wind_direction(datau(:,3),datav(:,3),0)
    res@xyLineColor       = color(2)
    plot3  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot3)
    wdir = wind_direction(datau(:,4),datav(:,4),0)
    res@xyLineColor       = color(3)
    plot4  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot4) 
    wdir = wind_direction(datau(:,5),datav(:,5),0)
    res@xyLineColor       = color(4)
    plot5  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot5)
    ;Datos experimentales
    nn                      = 0.0
    res@xyLineThicknessF    = 3.0
    res@xyDashPattern       = 14
    ;hacer graficos
    res@xyLineColor       = 127 
    plot22  = gsn_csm_xy(wks,data(:,0)+nn,data(:,30),res)
    res@xyLineColor       = 64
    overlay(plot1,plot22) 
    plot12  = gsn_csm_xy(wks,data(:,0)+nn,data(:,31),res)
    overlay(plot1,plot12) 
    ;Marca del Spinup
    res@xyLineThicknessF  = 2
    res@xyLineColor       = 1
    plotxx = gsn_csm_xy(wks,(/12,12/),(/-2.0,400/),res)
    overlay(plot1,plotxx)
    ;Creación de la Legenda
    delete(textres@lgLabels)
    delete(lineres@lgLineColors)
    gres@YPosPercent        = 91.5
    gres@XPosPercent        = 4.0
    textres@lgLabels        = (/"z = "+sprintf("%6.1f",9.0)+" m","z = "+sprintf("%6.1f",5.0)+" m","z = "+sprintf("%6.1f",2.0)+" m"/)
    lineres@lgLineColors    = (/190,127,64/)
    plot1                   = simple_legend(wks,plot1,gres,lineres,textres)
    ;Creación de segunda legenda
    gres@YPosPercent     = 30.0
    gres@XPosPercent     = 4.0
    delete(textres@lgLabels)
    delete(lineres@lgLineColors)
    textres@lgLabels     = (/"z = "+sprintf("%6.2f",auxz(0))+" m","z = "+sprintf("%6.2f",auxz(1))+" m","z = "+sprintf("%6.2f",auxz(2))+" m","z = "+sprintf("%6.2f",auxz(3))+" m","z = "+sprintf("%6.2f",auxz(4))+" m"/)
    lineres@lgLineColors = (/color(0),color(1),color(2),color(3),color(4)/)
    plot1                = simple_legend(wks,plot1,gres,lineres,textres)
    ;Finalización del gráfico
    draw(plot1)
    frame(wks)
;M7 M7 M7 M7
;M7 M7 M7 M7
;M7 M7 M7 M7
    ;Obtención de altura para cada nivel
    print("Creando gráfico para M7...")
    dataLON     = 12.09735
    dataLAT     = 55.70360
    loc         = wrf_user_ll_to_ij(a[0], dataLON, dataLAT, True)
    locX        = loc(0)
    locY        = loc(1)
    if ( locX .lt. 1 .or. locX .gt. dimX .or. locY .lt. 1 .or. locY .gt. dimY )
        print("Punto fuera de dominio")
    else 
        locX    = locX - 1
        locY    = locY - 1
    end if
    auxz        = z(:,locX,locY) - hgt(locX,locY)
    ;data de simulación
    delete(datau)
    delete(datav)
    delete(wdir)
    delete(tt)
    datau = readAsciiTable("../m7.d08.UUmod", 21, "float", 1)
    datav = readAsciiTable("../m7.d08.VVmod", 21, "float", 1)
    ;Gráfico de velocidad
    res@tiMainString        = "M7 Wind Direction"
    ;Datos medidos
    nn = 6.0 ;Factor de corrección horaria
    tt = datau(:,0)+nn
    res@xyLineThicknessF    = 4.0
    res@xyDashPattern       = 0
    ;hacer gráficos
    wdir = wind_direction(datau(:,1),datav(:,1),0)
    res@xyLineColor       = color(0)
    plot1  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    wdir = wind_direction(datau(:,2),datav(:,2),0)
    res@xyLineColor       = color(1)
    plot2  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot2) 
    wdir = wind_direction(datau(:,3),datav(:,3),0)
    res@xyLineColor       = color(2)
    plot3  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot3)
    wdir = wind_direction(datau(:,4),datav(:,4),0)
    res@xyLineColor       = color(3)
    plot4  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot4) 
    wdir = wind_direction(datau(:,5),datav(:,5),0)
    res@xyLineColor       = color(4)
    plot5  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot5)
    ;Datos experimentales
    nn                      = 0.0
    res@xyLineThicknessF    = 3.0
    res@xyDashPattern       = 14
    ;hacer graficos
    res@xyLineColor       = 127 
    plot22  = gsn_csm_xy(wks,data(:,0)+nn,data(:,34),res)
    res@xyLineColor       = 64
    overlay(plot1,plot22) 
    plot12  = gsn_csm_xy(wks,data(:,0)+nn,data(:,35),res)
    overlay(plot1,plot12) 
    ;Marca del Spinup
    res@xyLineThicknessF  = 2
    res@xyLineColor       = 1
    plotxx = gsn_csm_xy(wks,(/12,12/),(/-2.0,400/),res)
    overlay(plot1,plotxx)
    ;Creación de la Legenda
    delete(textres@lgLabels)
    delete(lineres@lgLineColors)
    gres@YPosPercent        = 91.5
    gres@XPosPercent        = 4.0
    textres@lgLabels        = (/"z = "+sprintf("%6.1f",9.0)+" m","z = "+sprintf("%6.1f",5.0)+" m","z = "+sprintf("%6.1f",2.0)+" m"/)
    lineres@lgLineColors    = (/190,127,64/)
    plot1                   = simple_legend(wks,plot1,gres,lineres,textres)
    ;Creación de segunda legenda
    gres@YPosPercent     = 30.0
    gres@XPosPercent     = 4.0
    delete(textres@lgLabels)
    delete(lineres@lgLineColors)
    textres@lgLabels     = (/"z = "+sprintf("%6.2f",auxz(0))+" m","z = "+sprintf("%6.2f",auxz(1))+" m","z = "+sprintf("%6.2f",auxz(2))+" m","z = "+sprintf("%6.2f",auxz(3))+" m","z = "+sprintf("%6.2f",auxz(4))+" m"/)
    lineres@lgLineColors = (/color(0),color(1),color(2),color(3),color(4)/)
    plot1                = simple_legend(wks,plot1,gres,lineres,textres)
    ;Finalización del gráfico
    draw(plot1)
    frame(wks)
;M8 M8 M8 M8
;M8 M8 M8 M8
;M8 M8 M8 M8
    ;Obtención de altura para cada nivel
    print("Creando gráfico para M8...")
    dataLON     = 12.09992
    dataLAT     = 55.70360
    loc         = wrf_user_ll_to_ij(a[0], dataLON, dataLAT, True)
    locX        = loc(0)
    locY        = loc(1)
    if ( locX .lt. 1 .or. locX .gt. dimX .or. locY .lt. 1 .or. locY .gt. dimY )
        print("Punto fuera de dominio")
    else 
        locX    = locX - 1
        locY    = locY - 1
    end if
    auxz        = z(:,locX,locY) - hgt(locX,locY)
    ;data de simulación
    delete(datau)
    delete(datav)
    delete(wdir)
    delete(tt)
    datau = readAsciiTable("../m8.d08.UUmod", 21, "float", 1)
    datav = readAsciiTable("../m8.d08.VVmod", 21, "float", 1)
    ;Gráfico de velocidad
    res@tiMainString        = "M8 Wind Direction"
    ;Datos medidos
    nn = 6.0 ;Factor de corrección horaria
    tt = datau(:,0)+nn
    res@xyLineThicknessF    = 4.0
    res@xyDashPattern       = 0
    ;hacer gráficos
    wdir = wind_direction(datau(:,1),datav(:,1),0)
    res@xyLineColor       = color(0)
    plot1  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    wdir = wind_direction(datau(:,2),datav(:,2),0)
    res@xyLineColor       = color(1)
    plot2  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot2) 
    wdir = wind_direction(datau(:,3),datav(:,3),0)
    res@xyLineColor       = color(2)
    plot3  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot3)
    wdir = wind_direction(datau(:,4),datav(:,4),0)
    res@xyLineColor       = color(3)
    plot4  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot4) 
    wdir = wind_direction(datau(:,5),datav(:,5),0)
    res@xyLineColor       = color(4)
    plot5  = gsn_csm_xy(wks,datau(:,0)+nn,wdir,res)
    overlay(plot1,plot5)
    ;Datos experimentales
    nn                      = 0.0
    res@xyLineThicknessF    = 3.0
    res@xyDashPattern       = 14
    ;hacer graficos
    res@xyLineColor       = 127 
    plot22  = gsn_csm_xy(wks,data(:,0)+nn,data(:,39),res)
    res@xyLineColor       = 64
    overlay(plot1,plot22) 
    plot12  = gsn_csm_xy(wks,data(:,0)+nn,data(:,40),res)
    overlay(plot1,plot12) 
    ;Marca del Spinup
    res@xyLineThicknessF  = 2
    res@xyLineColor       = 1
    plotxx = gsn_csm_xy(wks,(/12,12/),(/-2.0,400/),res)
    overlay(plot1,plotxx)
    ;Creación de la Legenda
    delete(textres@lgLabels)
    delete(lineres@lgLineColors)
    gres@YPosPercent        = 91.5
    gres@XPosPercent        = 4.0
    textres@lgLabels        = (/"z = "+sprintf("%6.1f",9.0)+" m","z = "+sprintf("%6.1f",5.0)+" m","z = "+sprintf("%6.1f",2.0)+" m"/)
    lineres@lgLineColors    = (/190,127,64/)
    plot1                   = simple_legend(wks,plot1,gres,lineres,textres)
    ;Creación de segunda legenda
    gres@YPosPercent     = 30.0
    gres@XPosPercent     = 4.0
    delete(textres@lgLabels)
    delete(lineres@lgLineColors)
    textres@lgLabels     = (/"z = "+sprintf("%6.2f",auxz(0))+" m","z = "+sprintf("%6.2f",auxz(1))+" m","z = "+sprintf("%6.2f",auxz(2))+" m","z = "+sprintf("%6.2f",auxz(3))+" m","z = "+sprintf("%6.2f",auxz(4))+" m"/)
    lineres@lgLineColors = (/color(0),color(1),color(2),color(3),color(4)/)
    plot1                = simple_legend(wks,plot1,gres,lineres,textres)
    ;Finalización del gráfico
    draw(plot1)
    frame(wks)
end 