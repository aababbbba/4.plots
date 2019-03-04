;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; Código hecho por Pablo Andrés Cárdenas Zamorano - UTFSM - 2018 ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Este programa grafica la distribución de la malla del WRF bidimensionalmente dado un índice en y para recorrer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Carga de paquetes
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
begin
;Ubicación de Archivo
DATADir                     = "../"
FILES                       = systemfunc (" ls -1 " + DATADir + "wrfout_d07_2010-09-08_06:00:00")
numFILES                    = dimsizes(FILES)
;Entornos
type                        = "pdf"
wks                         = gsn_open_wks(type,"mesh/mesh_y")
;Almacenamiento de archivos
a                           = addfiles(FILES,"r")
;Dimensiones del dominio
mdims                       = getfilevardimsizes(a[0],"P")
nd                          = dimsizes(mdims)
dimZ                        = mdims(nd-3)
dimY                        = mdims(nd-2)
dimX                        = mdims(nd-1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Información para dibujar
max_altura  = 500 ;Altura maxima para el grafico
max_level   = dimZ-2
dx          = 24.6914
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Obtencion de datos 
hgt     = wrf_user_getvar(a[0], "HGT",0)
z_data  = wrf_user_getvar(a[0],"z",0) ;nz, nx, ny
aux     = ispan(1, dimX, 1)*dx ; para recorrer todo el dominio
;Propiedades del grafico
gsn_define_colormap(wks,"MPL_viridis")
res                         = True
res@vpWidthF                = 0.5
res@vpHeightF               = (max_altura/(dx*dimX))*2; escala 4:1
res@gsnMaximize             = True     
res@xyMarkLineModes         = "Lines"                
res@tiYAxisFontHeightF      = 0.015
res@tmYLLabelFontHeightF    = 0.015
res@tiXAxisFontHeightF      = 0.015
res@tmXBLabelFontHeightF    = 0.015
res@tmYROn                  = False
res@tmXBOn                  = True
res@tmXTOn                  = False
res@tiYAxisString           = "z (m)"
res@tiXAxisString           = "y (m)"
res@trYMaxF                 = max_altura
res@trYMinF                 = 0
res@trXMaxF                 = dimX*dx
res@trXMinF                 = 1*dx
res@gsnDraw                 = False
res@gsnFrame                = False
do ii = 0,dimX-1,1
    ;Comienzo del algoritmo de generación de gráficos
    print(" Creando gráfico para y = "+(ii+1))
    res@xyLineColor             = ((5*253)/8)
    res@xyLineThicknesses       = 2.0
    aux_z                       = (z_data(0,ii,:)+z_data(1,ii,:))*0.5;Se promedian los valores de altura en los mass point
    plot1                       = gsn_csm_xy(wks, aux, aux_z, res) ;nivel 1
    ;Ciclo para los distintos niveles
    do jj = 1,max_level,1
        aux_z = (z_data(jj,ii,:)+z_data(jj+1,ii,:))*0.5 ;promedia los niveles
        plot2 = gsn_csm_xy(wks, aux, aux_z, res)
        overlay(plot1,plot2)
        draw(plot1)
    end do
    ;Algoritmo para lineas verticales 
    plot1 = gsn_csm_xy(wks, (/1, 1/)*dx, (/hgt(ii,0), max_altura/), res) ;linea correspondiente al nivel 1
    ;Ciclo para el resto de las lineas verticales
    do nn = 2, dimX,1
        plot2 = gsn_csm_xy(wks, (/nn, nn/)*dx, (/hgt(ii,nn-1), max_altura/), res)
        overlay(plot1,plot2)
        draw(plot1)
    end do
    ;Dibuja la silueta del terreno
    res@xyLineThicknesses   = 6.0
    res@xyLineColor         = 1
    plot                    = gsn_csm_xy(wks, aux, hgt(ii,:), res)
    overlay(plot1,plot)
    draw(plot1)
    frame(wks)
end do
end