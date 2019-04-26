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
FILES                       = systemfunc (" ls -1 " + DATADir + "wrfinput_d08")
numFILES                    = dimsizes(FILES)
;Entornos
type                        = "png"
wks                         = gsn_open_wks(type,"mesh/hd_mesh_50")
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
max_altura  = 40 ;Altura maxima para el grafico
ii          = 50 ; nodo en y donde se extraera la info
max_level   = dimZ-10
dx          = 2.74348
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Obtencion de datos 
hgt     = wrf_user_getvar(a[0], "HGT",0)
z_data  = wrf_user_getvar(a[0],"z",0) ;nz, nx, ny
aux     = ispan(1, dimX, 1)*dx ; para recorrer todo el dominio
;Propiedades del grafico
gsn_define_colormap(wks,"MPL_viridis")
res                         = True
res@vpWidthF                = 1.0
res@vpHeightF               = 1.0
res@gsnMaximize             = True     
res@xyMarkLineModes         = "Lines"                
res@tiYAxisFontHeightF      = 0.03
res@tmYLLabelFontHeightF    = 0.03
res@tiXAxisFontHeightF      = 0.03
res@tmXBLabelFontHeightF    = 0.03
res@tmYROn                  = False
res@tmXBOn                  = True
res@tmXTOn                  = False
res@tiYAxisString           = "z (m)"
res@tiXAxisString           = "y (m)"
res@trYMaxF                 = max_altura
res@trYMinF                 = 0
res@trXMaxF                 = 60
res@trXMinF                 = 20
res@gsnDraw                 = False
res@gsnFrame                = False
;do ii = 0,dimY-1,1
;do ii = 42,45,1
    ;Comienzo del algoritmo de generación de gráficos
    print(" Creando gráfico para y = "+(ii+1))
     res@xyLineThicknesses   = 4.0
     res@xyLineColor         = 120
     aux_z                   = (z_data(0,ii,:)+z_data(1,ii,:))*0.5;Se promedian los valores de altura en los mass point
     plot1                   = gsn_csm_xy(wks, aux, aux_z, res) ;nivel 1
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
    res@xyLineThicknesses   = 12.0
    res@xyLineColor         = 1
    plot                    = gsn_csm_xy(wks, aux, hgt(ii,:), res)
    overlay(plot1,plot)
    draw(plot1)
    frame(wks)
;end do
end