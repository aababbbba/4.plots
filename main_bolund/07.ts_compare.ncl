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
wks = gsn_open_wks("pdf","ts_interpol_compare")

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
res@tiYAxisString               = "V (m s-1)"
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
;res@xyMonoLineThickness         = True
res@trYMaxF                     = 18.0
res@trYMinF                     = 0.0
res@trXMaxF                     = 24.0
res@trXMinF                     = 0.0
gsn_define_colormap(wks,"MPL_viridis")
;Configuración de la legenda
gres                            = True
lineres                         = True
textres                         = True
lineres@lgLineThicknesses       = 5.0
lineres@LineLengthPercent       = 2.
gres@ItemSpacePercent           = 5.
gres@LineLabelWhiteSpacePercent = 1
textres@lgLabelFontHeights      = 0.0115
gres@YPosPercent                = 92.5
gres@XPosPercent                = 4.0
textres@lgLabels                = (/"z = "+sprintf("%6.1f",9.0)+" m","z = "+sprintf("%6.1f",5.0)+" m","z = "+sprintf("%6.1f",2.0)+" m"/)

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
    print(auxz)
    ;data de simulación
    datau = readAsciiTable("../m1.d08.UUmod", 21, "float", 1)
    datav = readAsciiTable("../m1.d08.VVmod", 21, "float", 1)
    ;Interpolación a 2,5 y 9m
    z0 = 15./1000. ;Lo debería entregar el modelo
    ;Velocidades a interpolar
    magu_n1 = sqrt(datau(:,1)^2.0 + datav(:,1)^2.0)
    magu_n3 = sqrt(datau(:,3)^2.0 + datav(:,3)^2.0)
    magu_n4 = sqrt(datau(:,4)^2.0 + datav(:,4)^2.0)
    ;Interpolación2m
    zr = auxz(0)
    print("    "+sprintf("%8.5f",zr))
    magu_2m = magu_n1*(log(2.0/z0)/log(zr/z0))
    ;Interpolación5m
    zr = auxz(2)
    print("    "+sprintf("%8.5f",zr))
    magu_5m = magu_n3*(log(5.0/z0)/log(zr/z0))
    ;Interpolación9m
    zr = auxz(3)
    print("    "+sprintf("%8.5f",zr))
    magu_9m = magu_n4*(log(9.0/z0)/log(zr/z0))
    ;Gráfico de velocidad
    res@tiMainString        = "M1 Mean Velocity"
    ;Datos experimentales
    nn                      = 0.0
    res@xyLineThicknessF    = 3.0
    res@xyDashPattern       = 14
    ;hacer graficos
    res@xyLineColor       = 230 
    plot1  = gsn_csm_xy(wks,data(:,0)+nn,data(:,1),res)
    res@xyLineColor       = 100
    plot12  = gsn_csm_xy(wks,data(:,0)+nn,data(:,2),res)
    overlay(plot1,plot12) 
    res@xyLineColor       = 2
    plot13  = gsn_csm_xy(wks,data(:,0)+nn,data(:,3),res)
    overlay(plot1,plot13)
    ;Datos medidos
    nn = 6.0 ;Factor de corrección horaria
    tt = datau(:,0)+nn
    res@xyLineThicknessF    = 4.0
    res@xyDashPattern       = 0
    ;hacer gráficos
    res@xyLineColor         = 2
    plot11  = gsn_csm_xy(wks,tt,magu_2m,res)
    overlay(plot1,plot11)
    res@xyLineColor       = 100
    plot2  = gsn_csm_xy(wks,tt,magu_5m,res)
    overlay(plot1,plot2) 
    res@xyLineColor       = 230
    plot3  = gsn_csm_xy(wks,tt,magu_9m,res)
    overlay(plot1,plot3)
    ;Marca del Spinup
    res@xyDashPattern     = 14
    res@xyLineThicknessF  = 2
    res@xyLineColor       = 1
    plotxx = gsn_csm_xy(wks,(/12,12/),(/-2.0,25/),res)
    overlay(plot1,plotxx)
    ;Creación de la Legenda
    lineres@lgLineColors = (/230,100,2/)
    plot1                = simple_legend(wks,plot1,gres,lineres,textres)
    ;Finalización del gráfico
    draw(plot1)
    frame(wks)
    ;Inicialización de matriz de almacenamiento
    aux=dimsizes(datau(:,0))
    matrix  = new((/aux,4/),float)
    matrix  = 0.
    ;print(matrix)
    matrix(:,0)=datau(:,0)+6.0
    matrix(:,3)=magu_2m
    matrix(:,2)=magu_5m
    matrix(:,1)=magu_9m
    ;Escritura en una matriz
    opt         = True
    opt@fout    = "main/data_raw/m1_raw.txt"
    write_matrix(matrix,4 + "f16.10",opt)
    delete(aux)
    delete(matrix)

;Limpieza de arreglos
delete(loc)
delete(auxz)
delete(datau)
delete(datav)
delete(magu_n1)
delete(magu_n3)
delete(magu_n4)
delete(magu_9m)
delete(magu_5m)
delete(magu_2m)
delete(tt)

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
    datau = readAsciiTable("../m2.d08.UUmod", 21, "float", 1)
    datav = readAsciiTable("../m2.d08.VVmod", 21, "float", 1)
    ;Interpolación a 2,5 y 9m
    z0 = 15./1000. ;Lo debería entregar el modelo
    ;Velocidades a interpolar
    magu_n1 = sqrt(datau(:,1)^2.0 + datav(:,1)^2.0)
    magu_n3 = sqrt(datau(:,3)^2.0 + datav(:,3)^2.0)
    magu_n4 = sqrt(datau(:,4)^2.0 + datav(:,4)^2.0)
    ;Interpolación2m
    zr = auxz(0)
    print("    "+sprintf("%8.5f",zr))
    magu_2m = magu_n1*(log(2.0/z0)/log(zr/z0))
    ;Interpolación5m
    zr = auxz(2)
    print("    "+sprintf("%8.5f",zr))
    magu_5m = magu_n3*(log(5.0/z0)/log(zr/z0))
    ;Interpolación9m
    zr = auxz(3)
    print("    "+sprintf("%8.5f",zr))
    magu_9m = magu_n4*(log(9.0/z0)/log(zr/z0))
    ;Gráfico de velocidad
    res@tiMainString        = "M2 Mean Velocity"
    ;Datos experimentales
    nn                      = 0.0
    res@xyLineThicknessF    = 3.0
    res@xyDashPattern       = 14
    ;hacer graficos
    res@xyLineColor       = 230 
    plot1  = gsn_csm_xy(wks,data(:,0)+nn,data(:,7),res)
    res@xyLineColor       = 100
    plot12  = gsn_csm_xy(wks,data(:,0)+nn,data(:,8),res)
    overlay(plot1,plot12) 
    res@xyLineColor       = 2
    plot13  = gsn_csm_xy(wks,data(:,0)+nn,data(:,9),res)
    overlay(plot1,plot13)
    ;Datos medidos
    nn = 6.0 ;Factor de corrección horaria
    tt = datau(:,0)+nn
    res@xyLineThicknessF    = 4.0
    res@xyDashPattern       = 0
    ;hacer gráficos
    res@xyLineColor         = 2
    plot11  = gsn_csm_xy(wks,tt,magu_2m,res)
    overlay(plot1,plot11)
    res@xyLineColor       = 100
    plot2  = gsn_csm_xy(wks,tt,magu_5m,res)
    overlay(plot1,plot2) 
    res@xyLineColor       = 230
    plot3  = gsn_csm_xy(wks,tt,magu_9m,res)
    overlay(plot1,plot3)
    ;Marca del Spinup
    res@xyDashPattern     = 14
    res@xyLineThicknessF = 2
    res@xyLineColor       = 1
    plotxx = gsn_csm_xy(wks,(/12,12/),(/-2.0,25/),res)
    overlay(plot1,plotxx)
    ;Creación de la Legenda
    lineres@lgLineColors = (/230,100,2/)
    plot1                = simple_legend(wks,plot1,gres,lineres,textres)
    ;Finalización del gráfico
    draw(plot1)
    frame(wks)
    ;Inicialización de matriz de almacenamiento
    aux=dimsizes(datau(:,0))
    matrix  = new((/aux,4/),float)
    matrix  = 0.
    ;print(matrix)
    matrix(:,0)=datau(:,0)+6.0
    matrix(:,3)=magu_2m
    matrix(:,2)=magu_5m
    matrix(:,1)=magu_9m
    ;Escritura en una matriz
    opt         = True
    opt@fout    = "main/data_raw/m2_raw.txt"
    write_matrix(matrix,4 + "f16.10",opt)
    delete(aux)
    delete(matrix)

;Limpieza de arreglos
delete(loc)
delete(auxz)
delete(datau)
delete(datav)
delete(magu_n1)
delete(magu_n3)
delete(magu_n4)
delete(magu_9m)
delete(magu_5m)
delete(magu_2m)
delete(tt)

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
    datau = readAsciiTable("../m3.d08.UUmod", 21, "float", 1)
    datav = readAsciiTable("../m3.d08.VVmod", 21, "float", 1)
    ;Interpolación a 2,5 y 9m
    z0 = 15./1000. ;Lo debería entregar el modelo
    ;Velocidades a interpolar
    magu_n1 = sqrt(datau(:,1)^2.0 + datav(:,1)^2.0)
    magu_n3 = sqrt(datau(:,3)^2.0 + datav(:,3)^2.0)
    magu_n4 = sqrt(datau(:,4)^2.0 + datav(:,4)^2.0)
    ;Interpolación2m
    zr = auxz(0)
    print("    "+sprintf("%8.5f",zr))
    magu_2m = magu_n1*(log(2.0/z0)/log(zr/z0))
    ;Interpolación5m
    zr = auxz(2)
    print("    "+sprintf("%8.5f",zr))
    magu_5m = magu_n3*(log(5.0/z0)/log(zr/z0))
    ;Interpolación9m
    zr = auxz(3)
    print("    "+sprintf("%8.5f",zr))
    magu_9m = magu_n4*(log(9.0/z0)/log(zr/z0))
    ;Gráfico de velocidad
    res@tiMainString        = "M3 Mean Velocity"
    ;Datos experimentales
    nn                      = 0.0
    res@xyLineThicknessF    = 3.0
    res@xyDashPattern       = 14
    ;hacer graficos
    res@xyLineColor       = 230 
    plot1  = gsn_csm_xy(wks,data(:,0)+nn,data(:,12),res)
    res@xyLineColor       = 100
    plot12  = gsn_csm_xy(wks,data(:,0)+nn,data(:,13),res)
    overlay(plot1,plot12) 
    res@xyLineColor       = 2
    plot13  = gsn_csm_xy(wks,data(:,0)+nn,data(:,14),res)
    overlay(plot1,plot13)
    ;Datos medidos
    nn = 6.0 ;Factor de corrección horaria
    tt = datau(:,0)+nn
    res@xyLineThicknessF    = 4.0
    res@xyDashPattern       = 0
    ;hacer gráficos
    res@xyLineColor         = 2
    plot11  = gsn_csm_xy(wks,tt,magu_2m,res)
    overlay(plot1,plot11)
    res@xyLineColor       = 100
    plot2  = gsn_csm_xy(wks,tt,magu_5m,res)
    overlay(plot1,plot2) 
    res@xyLineColor       = 230
    plot3  = gsn_csm_xy(wks,tt,magu_9m,res)
    overlay(plot1,plot3)
    ;Marca del Spinup
    res@xyDashPattern     = 14
    res@xyLineThicknessF = 2
    res@xyLineColor       = 1
    plotxx = gsn_csm_xy(wks,(/12,12/),(/-2.0,25/),res)
    overlay(plot1,plotxx)
    ;Creación de la Legenda
    lineres@lgLineColors = (/230,100,2/)
    plot1                = simple_legend(wks,plot1,gres,lineres,textres)
    ;Finalización del gráfico
    draw(plot1)
    frame(wks)
    ;Inicialización de matriz de almacenamiento
    aux=dimsizes(datau(:,0))
    matrix  = new((/aux,4/),float)
    matrix  = 0.
    ;print(matrix)
    matrix(:,0)=datau(:,0)+6.0
    matrix(:,3)=magu_2m
    matrix(:,2)=magu_5m
    matrix(:,1)=magu_9m
    ;Escritura en una matriz
    opt         = True
    opt@fout    = "main/data_raw/m3_raw.txt"
    write_matrix(matrix,4 + "f16.10",opt)
    delete(aux)
    delete(matrix)

;Limpieza de arreglos
delete(loc)
delete(auxz)
delete(datau)
delete(datav)
delete(magu_n1)
delete(magu_n3)
delete(magu_n4)
delete(magu_9m)
delete(magu_5m)
delete(magu_2m)
delete(tt)

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
    datau = readAsciiTable("../m4.d08.UUmod", 21, "float", 1)
    datav = readAsciiTable("../m4.d08.VVmod", 21, "float", 1)
    ;Interpolación a 2,5 y 9m
    z0 = 15./1000. ;Lo debería entregar el modelo
    ;Velocidades a interpolar
    magu_n1 = sqrt(datau(:,1)^2.0 + datav(:,1)^2.0)
    magu_n3 = sqrt(datau(:,3)^2.0 + datav(:,3)^2.0)
    magu_n4 = sqrt(datau(:,4)^2.0 + datav(:,4)^2.0)
    ;Interpolación2m
    zr = auxz(0)
    print("    "+sprintf("%8.5f",zr))
    magu_2m = magu_n1*(log(2.0/z0)/log(zr/z0))
    ;Interpolación5m
    zr = auxz(2)
    print("    "+sprintf("%8.5f",zr))
    magu_5m = magu_n3*(log(5.0/z0)/log(zr/z0))
    ;Interpolación9m
    zr = auxz(3)
    print("    "+sprintf("%8.5f",zr))
    magu_9m = magu_n4*(log(9.0/z0)/log(zr/z0))
    ;Gráfico de velocidad
    res@tiMainString        = "M4 Mean Velocity"
    ;Datos experimentales
    nn                      = 0.0
    res@xyLineThicknessF    = 3.0
    res@xyDashPattern       = 14
    ;hacer graficos
    res@xyLineColor       = 230 
    plot1  = gsn_csm_xy(wks,data(:,0)+nn,data(:,17),res)
    res@xyLineColor       = 100
    plot12  = gsn_csm_xy(wks,data(:,0)+nn,data(:,18),res)
    overlay(plot1,plot12) 
    res@xyLineColor       = 2
    plot13  = gsn_csm_xy(wks,data(:,0)+nn,data(:,19),res)
    overlay(plot1,plot13)
    ;Datos medidos
    nn = 6.0 ;Factor de corrección horaria
    tt = datau(:,0)+nn
    res@xyLineThicknessF    = 4.0
    res@xyDashPattern       = 0
    ;hacer gráficos
    res@xyLineColor         = 2
    plot11  = gsn_csm_xy(wks,tt,magu_2m,res)
    overlay(plot1,plot11)
    res@xyLineColor       = 100
    plot2  = gsn_csm_xy(wks,tt,magu_5m,res)
    overlay(plot1,plot2) 
    res@xyLineColor       = 230
    plot3  = gsn_csm_xy(wks,tt,magu_9m,res)
    overlay(plot1,plot3)
    ;Marca del Spinup
    res@xyDashPattern     = 14
    res@xyLineThicknessF = 2
    res@xyLineColor       = 1
    plotxx = gsn_csm_xy(wks,(/12,12/),(/-2.0,25/),res)
    overlay(plot1,plotxx)
    ;Creación de la Legenda
    lineres@lgLineColors = (/230,100,2/)
    plot1                = simple_legend(wks,plot1,gres,lineres,textres)
    ;Finalización del gráfico
    draw(plot1)
    frame(wks)
    ;Inicialización de matriz de almacenamiento
    aux=dimsizes(datau(:,0))
    matrix  = new((/aux,4/),float)
    matrix  = 0.
    ;print(matrix)
    matrix(:,0)=datau(:,0)+6.0
    matrix(:,3)=magu_2m
    matrix(:,2)=magu_5m
    matrix(:,1)=magu_9m
    ;Escritura en una matriz
    opt         = True
    opt@fout    = "main/data_raw/m4_raw.txt"
    write_matrix(matrix,4 + "f16.10",opt)
    delete(aux)
    delete(matrix)

;Limpieza de arreglos
delete(loc)
delete(auxz)
delete(datau)
delete(datav)
delete(magu_n1)
delete(magu_n3)
delete(magu_n4)
delete(magu_9m)
delete(magu_5m)
delete(magu_2m)
delete(tt)

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
    datau = readAsciiTable("../m5.d08.UUmod", 21, "float", 1)
    datav = readAsciiTable("../m5.d08.VVmod", 21, "float", 1)
    ;Interpolación a 2,5 y 9m
    z0 = 15./1000. ;Lo debería entregar el modelo
    ;Velocidades a interpolar
    magu_n1 = sqrt(datau(:,1)^2.0 + datav(:,1)^2.0)
    magu_n3 = sqrt(datau(:,3)^2.0 + datav(:,3)^2.0)
    magu_n4 = sqrt(datau(:,4)^2.0 + datav(:,4)^2.0)
    ;Interpolación2m
    zr = auxz(0)
    print("    "+sprintf("%8.5f",zr))
    magu_2m = magu_n1*(log(2.0/z0)/log(zr/z0))
    ;Interpolación5m
    zr = auxz(2)
    print("    "+sprintf("%8.5f",zr))
    magu_5m = magu_n3*(log(5.0/z0)/log(zr/z0))
    ;Interpolación9m
    zr = auxz(3)
    print("    "+sprintf("%8.5f",zr))
    magu_9m = magu_n4*(log(9.0/z0)/log(zr/z0))
    ;Gráfico de velocidad
    res@tiMainString        = "M5 Mean Velocity"
    ;Datos experimentales
    nn                      = 0.0
    res@xyLineThicknessF    = 3.0
    res@xyDashPattern       = 14
    ;hacer graficos
    res@xyLineColor       = 100
    plot1  = gsn_csm_xy(wks,data(:,0)+nn,data(:,23),res)
    res@xyLineColor       = 2
    plot13  = gsn_csm_xy(wks,data(:,0)+nn,data(:,24),res)
    overlay(plot1,plot13)
    ;Datos medidos
    nn = 6.0 ;Factor de corrección horaria
    tt = datau(:,0)+nn
    res@xyLineThicknessF    = 4.0
    res@xyDashPattern       = 0
    ;hacer gráficos
    res@xyLineColor         = 2
    plot11  = gsn_csm_xy(wks,tt,magu_2m,res)
    overlay(plot1,plot11)
    res@xyLineColor       = 100
    plot2  = gsn_csm_xy(wks,tt,magu_5m,res)
    overlay(plot1,plot2) 
    res@xyLineColor       = 230
    plot3  = gsn_csm_xy(wks,tt,magu_9m,res)
    overlay(plot1,plot3)
    ;Marca del Spinup
    res@xyDashPattern     = 14
    res@xyLineThicknessF = 2
    res@xyLineColor       = 1
    plotxx = gsn_csm_xy(wks,(/12,12/),(/-2.0,25/),res)
    overlay(plot1,plotxx)
    ;Creación de la Legenda
    lineres@lgLineColors = (/230,100,2/)
    plot1                = simple_legend(wks,plot1,gres,lineres,textres)
    ;Finalización del gráfico
    draw(plot1)
    frame(wks)
    ;Inicialización de matriz de almacenamiento
    aux=dimsizes(datau(:,0))
    matrix  = new((/aux,4/),float)
    matrix  = 0.
    ;print(matrix)
    matrix(:,0)=datau(:,0)+6.0
    matrix(:,3)=magu_2m
    matrix(:,2)=magu_5m
    matrix(:,1)=magu_9m
    ;Escritura en una matriz
    opt         = True
    opt@fout    = "main/data_raw/m5_raw.txt"
    write_matrix(matrix,4 + "f16.10",opt)
    delete(aux)
    delete(matrix)

;Limpieza de arreglos
delete(loc)
delete(auxz)
delete(datau)
delete(datav)
delete(magu_n1)
delete(magu_n3)
delete(magu_n4)
delete(magu_9m)
delete(magu_5m)
delete(magu_2m)
delete(tt)

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
    datau = readAsciiTable("../m6.d08.UUmod", 21, "float", 1)
    datav = readAsciiTable("../m6.d08.VVmod", 21, "float", 1)
    ;Interpolación a 2,5 y 9m
    z0 = 15./1000. ;Lo debería entregar el modelo
    ;Velocidades a interpolar
    magu_n1 = sqrt(datau(:,1)^2.0 + datav(:,1)^2.0)
    magu_n3 = sqrt(datau(:,3)^2.0 + datav(:,3)^2.0)
    magu_n4 = sqrt(datau(:,4)^2.0 + datav(:,4)^2.0)
    ;Interpolación2m
    zr = auxz(0)
    print("    "+sprintf("%8.5f",zr))
    magu_2m = magu_n1*(log(2.0/z0)/log(zr/z0))
    ;Interpolación5m
    zr = auxz(2)
    print("    "+sprintf("%8.5f",zr))
    magu_5m = magu_n3*(log(5.0/z0)/log(zr/z0))
    ;Interpolación9m
    zr = auxz(3)
    print("    "+sprintf("%8.5f",zr))
    magu_9m = magu_n4*(log(9.0/z0)/log(zr/z0))
    ;Gráfico de velocidad
    res@tiMainString        = "M6 Mean Velocity"
    ;Datos experimentales
    nn                      = 0.0
    res@xyLineThicknessF    = 3.0
    res@xyDashPattern       = 14
    ;hacer graficos
    res@xyLineColor       = 230 
    plot1  = gsn_csm_xy(wks,data(:,0)+nn,data(:,27),res)
    res@xyLineColor       = 100
    plot12  = gsn_csm_xy(wks,data(:,0)+nn,data(:,28),res)
    overlay(plot1,plot12) 
    res@xyLineColor       = 2
    plot13  = gsn_csm_xy(wks,data(:,0)+nn,data(:,29),res)
    overlay(plot1,plot13)
    ;Datos medidos
    nn = 6.0 ;Factor de corrección horaria
    tt = datau(:,0)+nn
    res@xyLineThicknessF    = 4.0
    res@xyDashPattern       = 0
    ;hacer gráficos
    res@xyLineColor         = 2
    plot11  = gsn_csm_xy(wks,tt,magu_2m,res)
    overlay(plot1,plot11)
    res@xyLineColor       = 100
    plot2  = gsn_csm_xy(wks,tt,magu_5m,res)
    overlay(plot1,plot2) 
    res@xyLineColor       = 230
    plot3  = gsn_csm_xy(wks,tt,magu_9m,res)
    overlay(plot1,plot3)
    ;Marca del Spinup
    res@xyDashPattern     = 14
    res@xyLineThicknessF = 2
    res@xyLineColor       = 1
    plotxx = gsn_csm_xy(wks,(/12,12/),(/-2.0,25/),res)
    overlay(plot1,plotxx)
    ;Creación de la Legenda
    lineres@lgLineColors = (/230,100,2/)
    plot1                = simple_legend(wks,plot1,gres,lineres,textres)
    ;Finalización del gráfico
    draw(plot1)
    frame(wks)
    ;Inicialización de matriz de almacenamiento
    aux=dimsizes(datau(:,0))
    matrix  = new((/aux,4/),float)
    matrix  = 0.
    ;print(matrix)
    matrix(:,0)=datau(:,0)+6.0
    matrix(:,3)=magu_2m
    matrix(:,2)=magu_5m
    matrix(:,1)=magu_9m
    ;Escritura en una matriz
    opt         = True
    opt@fout    = "main/data_raw/m6_raw.txt"
    write_matrix(matrix,4 + "f16.10",opt)
    delete(aux)
    delete(matrix)

;Limpieza de arreglos
delete(loc)
delete(auxz)
delete(datau)
delete(datav)
delete(magu_n1)
delete(magu_n3)
delete(magu_n4)
delete(magu_9m)
delete(magu_5m)
delete(magu_2m)
delete(tt)

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
    datau = readAsciiTable("../m7.d08.UUmod", 21, "float", 1)
    datav = readAsciiTable("../m7.d08.VVmod", 21, "float", 1)
    ;Interpolación a 2,5 y 9m
    z0 = 15./1000. ;Lo debería entregar el modelo
    ;Velocidades a interpolar
    magu_n1 = sqrt(datau(:,1)^2.0 + datav(:,1)^2.0)
    magu_n3 = sqrt(datau(:,3)^2.0 + datav(:,3)^2.0)
    magu_n4 = sqrt(datau(:,4)^2.0 + datav(:,4)^2.0)
    ;Interpolación2m
    zr = auxz(0)
    print("    "+sprintf("%8.5f",zr))
    magu_2m = magu_n1*(log(2.0/z0)/log(zr/z0))
    ;Interpolación5m
    zr = auxz(2)
    print("    "+sprintf("%8.5f",zr))
    magu_5m = magu_n3*(log(5.0/z0)/log(zr/z0))
    ;Interpolación9m
    zr = auxz(3)
    print("    "+sprintf("%8.5f",zr))
    magu_9m = magu_n4*(log(9.0/z0)/log(zr/z0))
    ;Gráfico de velocidad
    res@tiMainString        = "M7 Mean Velocity"
    ;Datos experimentales
    nn                      = 0.0
    res@xyLineThicknessF    = 3.0
    res@xyDashPattern       = 14
    ;hacer graficos
    res@xyLineColor       = 100
    plot1  = gsn_csm_xy(wks,data(:,0)+nn,data(:,32),res)
    res@xyLineColor       = 2
    plot13  = gsn_csm_xy(wks,data(:,0)+nn,data(:,33),res)
    overlay(plot1,plot13)
    ;Datos medidos
    nn = 6.0 ;Factor de corrección horaria
    tt = datau(:,0)+nn
    res@xyLineThicknessF    = 4.0
    res@xyDashPattern       = 0
    ;hacer gráficos
    res@xyLineColor         = 2
    plot11  = gsn_csm_xy(wks,tt,magu_2m,res)
    overlay(plot1,plot11)
    res@xyLineColor       = 100
    plot2  = gsn_csm_xy(wks,tt,magu_5m,res)
    overlay(plot1,plot2) 
    res@xyLineColor       = 230
    plot3  = gsn_csm_xy(wks,tt,magu_9m,res)
    overlay(plot1,plot3)
    ;Marca del Spinup
    res@xyDashPattern     = 14
    res@xyLineThicknessF = 2
    res@xyLineColor       = 1
    plotxx = gsn_csm_xy(wks,(/12,12/),(/-2.0,25/),res)
    overlay(plot1,plotxx)
    ;Creación de la Legenda
    lineres@lgLineColors = (/230,100,2/)
    plot1                = simple_legend(wks,plot1,gres,lineres,textres)
    ;Finalización del gráfico
    draw(plot1)
    frame(wks)
    ;Inicialización de matriz de almacenamiento
    aux=dimsizes(datau(:,0))
    matrix  = new((/aux,4/),float)
    matrix  = 0.
    ;print(matrix)
    matrix(:,0)=datau(:,0)+6.0
    matrix(:,3)=magu_2m
    matrix(:,2)=magu_5m
    matrix(:,1)=magu_9m
    ;Escritura en una matriz
    opt         = True
    opt@fout    = "main/data_raw/m7_raw.txt"
    write_matrix(matrix,4 + "f16.10",opt)
    delete(aux)
    delete(matrix)

;Limpieza de arreglos
delete(loc)
delete(auxz)
delete(datau)
delete(datav)
delete(magu_n1)
delete(magu_n3)
delete(magu_n4)
delete(magu_9m)
delete(magu_5m)
delete(magu_2m)
delete(tt)

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
    datau = readAsciiTable("../m8.d08.UUmod", 21, "float", 1)
    datav = readAsciiTable("../m8.d08.VVmod", 21, "float", 1)
    ;Interpolación a 2,5 y 9m
    z0 = 15./1000. ;Lo debería entregar el modelo
    ;Velocidades a interpolar
    magu_n1 = sqrt(datau(:,1)^2.0 + datav(:,1)^2.0)
    magu_n3 = sqrt(datau(:,3)^2.0 + datav(:,3)^2.0)
    magu_n4 = sqrt(datau(:,4)^2.0 + datav(:,4)^2.0)
    ;Interpolación2m
    zr = auxz(0)
    print("    "+sprintf("%8.5f",zr))
    magu_2m = magu_n1*(log(2.0/z0)/log(zr/z0))
    ;Interpolación5m
    zr = auxz(2)
    print("    "+sprintf("%8.5f",zr))
    magu_5m = magu_n3*(log(5.0/z0)/log(zr/z0))
    ;Interpolación9m
    zr = auxz(3)
    print("    "+sprintf("%8.5f",zr))
    magu_9m = magu_n4*(log(9.0/z0)/log(zr/z0))
    ;Gráfico de velocidad
    res@tiMainString        = "M8 Mean Velocity"
    ;Datos experimentales
    nn                      = 0.0
    res@xyLineThicknessF    = 3.0
    res@xyDashPattern       = 14
    ;hacer graficos
    res@xyLineColor       = 230 
    plot1  = gsn_csm_xy(wks,data(:,0)+nn,data(:,36),res)
    res@xyLineColor       = 100
    plot12  = gsn_csm_xy(wks,data(:,0)+nn,data(:,37),res)
    overlay(plot1,plot12) 
    res@xyLineColor       = 2
    plot13  = gsn_csm_xy(wks,data(:,0)+nn,data(:,38),res)
    overlay(plot1,plot13)
    ;Datos medidos
    nn = 6.0 ;Factor de corrección horaria
    tt = datau(:,0)+nn
    res@xyLineThicknessF    = 4.0
    res@xyDashPattern       = 0
    ;hacer gráficos
    res@xyLineColor         = 2
    plot11  = gsn_csm_xy(wks,tt,magu_2m,res)
    overlay(plot1,plot11)
    res@xyLineColor       = 100
    plot2  = gsn_csm_xy(wks,tt,magu_5m,res)
    overlay(plot1,plot2) 
    res@xyLineColor       = 230
    plot3  = gsn_csm_xy(wks,tt,magu_9m,res)
    overlay(plot1,plot3)
    ;Marca del Spinup
    res@xyDashPattern     = 14
    res@xyLineThicknessF = 2
    res@xyLineColor       = 1
    plotxx = gsn_csm_xy(wks,(/12,12/),(/-2.0,25/),res)
    overlay(plot1,plotxx)
    ;Creación de la Legenda
    lineres@lgLineColors = (/230,100,2/)
    plot1                = simple_legend(wks,plot1,gres,lineres,textres)
    ;Finalización del gráfico
    draw(plot1)
    frame(wks)
    ;Inicialización de matriz de almacenamiento
    aux=dimsizes(datau(:,0))
    matrix  = new((/aux,4/),float)
    matrix  = 0.
    ;print(matrix)
    matrix(:,0)=datau(:,0)+6.0
    matrix(:,3)=magu_2m
    matrix(:,2)=magu_5m
    matrix(:,1)=magu_9m
    ;Escritura en una matriz
    opt         = True
    opt@fout    = "main/data_raw/m8_raw.txt"
    write_matrix(matrix,4 + "f16.10",opt)
    delete(aux)
    delete(matrix)
end