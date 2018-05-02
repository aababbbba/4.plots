;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; Código hecho por Pablo Andrés Cárdenas Zamorano - UTFSM - 2018 ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Grafica el perfil de velocidad medio para cierto número de Archivos (permite calcular promedios horarios)
;El promedio se realiza espacialmente eliminando algunos datos que están en los extremos del dominio (buffer zone)
;Se grafica tambien un mapa de la velocidad de friccion media horaria
;Tambien grafica el perfil medio de Phi_M
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
wks                         = gsn_open_wks(type,"6.mean_profile")
;Obtención de datos
a                           = addfiles(FILES,"r")
times                       = wrf_user_getvar(a, "times", -1)
ntimes                      = dimsizes(times)
ter                         = wrf_user_getvar(a[0],"HGT",0)
;Dimensiones del dominio
mdims                       = getfilevardimsizes(a[0],"P")
nd                          = dimsizes(mdims)
dimZ                        = mdims(nd-3)
dimY                        = mdims(nd-2)
dimX                        = mdims(nd-1)
hora_init                   = 18

;Gráfico de u*
wks1                        = gsn_open_wks(type,"6.ust")
;Características del gráfico del terreno
res1                         = True
res1@cnLineDashPattern       = 2
res1@cnLineColor             = "Black"
res1@cnLineLabelsOn          = False
res1@gsnDraw                 = False
res1@gsnFrame                = False
res1@gsnMaximize             = True
;Plot del terreno
contour_hgt                 = gsn_contour(wks1,ter,res1)
;Características del gráfico de ust
res1@MainTitle               = "Velocidad de friccion"
res1@cnFillPalette           = "MPL_plasma"
res1@cnFillOn                = True
res1@gsnSpreadColors         = True
res1@gsnSpreadColorStart     = 1
res1@gsnSpreadColorEnd       = -3
res1@Footer                  = False
res1@InitTime                = False
res1@FieldTitle              = "u* (m s-1)"
res1@cnLevelSelectionMode    = "ManualLevels"
res1@cnMinLevelValF          = 0.12
res1@cnMaxLevelValF          = 0.58
res1@cnLevelSpacingF        = 0.0115
res1@cnInfoLabelOn   = False
res1@lbAutoManage = False
res1@lbLabelStride         = 4.
res1@lbLabelFontHeightF    = .015
;Carácterísticas del wrfoverlay 
mpres                       = True
mpres@mpOutlineOn           = False
;Características del plot global
auxres  = True
auxres@NoTitles = True

;Información para promediar archivos
N = 5 ; Cantidad de archivos a promediar
X = (ntimes-1)/(N-1) ; Número de promedios horarios
buffer = 15 ;cantidad de elementos a quitar de los bordes para el promedio
eta_max = 15 ; Cantidad máxima de niveles a graficar

;Cálculo de orografía promedio del terreno
print("        Calculando altura promedio del terreno")
mean_hgt = 0.0
do xx = buffer-1,dimX-buffer-1,1 ;Loop en x
    do yy = buffer-1,dimY-buffer-1,1 ;Loop en y
        ;suma parcial en y
        mean_hgt = mean_hgt + ter(xx,yy)
    end do
end do
mean_hgt = mean_hgt/((dimX-2.0*buffer)*(dimY-2.0*buffer))

;Inicialización de matrices a almacenar
vel_suma_parcial     = new(eta_max,float)
z_suma_parcial       = new(eta_max,float)
ust_suma_parcial     = new((/dimX,dimY/),float)
velocidad            = new((/X,eta_max/),float)
altura               = new((/X,eta_max/),float)
ust                  = new((/X,dimX,dimY/),float)

velocidad = 0. ; Para inicializarlos
altura = 0.
ust = 0.

;Definición de propiedades del gráfico
gsn_define_colormap(wks,"MPL_viridis")
res                        = True
res@gsnMaximize            = True      
res@xyLineThicknesses      = 1
res@tiXAxisString          = "V (m s-1)"
res@tiYAxisString          = "z (m)"
res@xyMarkLineModes     = "MarkLines"                
res@xyMarkers           =  16
res@xyMarkerSizeF       = 0.01
res@xyMarkerColor       = 100
res@xyLineColor         = 100
;res@gsnDraw                = False
;res@gsnFrame               = False
res@tiMainFontHeightF   =  0.018
res@tiXAxisFontHeightF         = 0.018
res@tiYAxisFontHeightF         = 0.018
res@tmXBLabelFontHeightF       = 0.014
res@tmYLLabelFontHeightF       = 0.014
res@tmXBMajorOutwardLengthF= 0.0
res@tmXBMinorOutwardLengthF= 0.0
res@tmYLMajorOutwardLengthF= 0.0
res@tmYLMinorOutwardLengthF= 0.0
res@tmXMajorGrid           = True
res@tmYMajorGrid           = True
res@tmYMajorGridLineColor  = "Gray"
res@tmXMajorGridLineColor  = "Gray"
res@trXMaxF           = 16.0
res@trXMinF           = 0.0

;COMINZO DE CICLOS DO
do ii = 0,X-1,1 ;Loop por por cada gráfico
    print("        Generando gráfico "+(ii+1)+" para perfil medio y u*...")
    n_inicial = ii*(N-1) ;índice del archivo inicial
    n_final = n_inicial + (N-1);índice del archivo final

    vel_suma_parcial(:)   = 0.0 ;Reinicia el promedio
    z_suma_parcial(:)     = 0.0 ;Reinicia el promedio
    ust_suma_parcial(:,:) = 0.0
    system("printf '            '")
    do it = n_inicial,n_final,1 ;Loop por los archivos
        ;Mensajes de consola
        if (it .eq. n_final) then
            print((it+1)+"...")
        else 
            system("printf '"+(it+1)+"...'")
        end if
        ;Obtención de las variables relevantes para cada archivo
        uvm                     = wrf_user_getvar(a[it],"uvmet",0)
        u                       = uvm(0,:,:,:) 
        v                       = uvm(1,:,:,:)
        mag                     = sqrt(u^2 + v^2)
        z                       = wrf_user_getvar(a[it],"z",0) ;formato (nz,nx,ny)
        ust_data                = wrf_user_getvar(a[it],"UST",0)
        do jj = 0, eta_max-1 ;Loop por cada nivel Vertical
            do xx = buffer-1,dimX-buffer-1,1 ;Loop en x
                do yy = buffer-1,dimY-buffer-1,1 ;Loop en y
                    ;suma parcial vel en y
                    vel_suma_parcial(jj) = vel_suma_parcial(jj) + mag(jj,xx,yy)
                    ;suma parcial z en y
                    z_suma_parcial(jj)   = z_suma_parcial(jj) + z(jj,xx,yy)
                end do
            end do
        end do
        ust_suma_parcial = ust_suma_parcial + ust_data 
    end do
    ;Calculo de promedios
    prom_vel = vel_suma_parcial/(N*(dimX-2.0*buffer)*(dimY-2.0*buffer))
    prom_z   = z_suma_parcial/(N*(dimX-2.0*buffer)*(dimY-2.0*buffer)) - mean_hgt
    ust_suma_parcial = ust_suma_parcial/N
    ;Almacenamiento para trabajo posterior
    velocidad(ii,:) = prom_vel
    altura(ii,:)    = prom_z
    ust(ii,:,:)     = ust_suma_parcial
    if (ii .lt. (X-1)) then
        print("            minust = "+sprintf("%6.4f",min(ust(ii,:,:)))+"    maxust = "+sprintf("%6.4f",max(ust(ii,:,:))))
    else
        system("printf '            minust = "+sprintf("%6.4f",min(ust(ii,:,:)))+"    maxust = "+sprintf("%6.4f",max(ust(ii,:,:)))+"'")
    end if
    
    ;HACER EL PLOT
    res@tiMainString      = "Perfil medio de velocidad entre "+(hora_init+ii)+":00 y "+(hora_init+ii+1)+":00"
    plot           = gsn_csm_xy(wks,prom_vel, prom_z, res)
    ;Plot de ust
    contour_ust    = wrf_contour(a[0],wks1,ust(ii,:,:),res1)
    plot          = wrf_map_overlays(a[0],wks1,(/contour_hgt,contour_ust/),auxres,mpres)
end do

;Cálculo del gradiente de velocidad
grad_vel = new((/X,(eta_max-1)/),float)
z_grad   = new((/X,(eta_max-1)/),float)
print(" ")
print("        Cálculo de gradiente de velocidad normalizado:")
wks2     = gsn_open_wks(type,"6.mean_grad")
gsn_define_colormap(wks2,"MPL_viridis")

res@tiXAxisString     = "~F33~F~B2~M~N~ (-)"
res@tiYAxisString     = "z (m)"
res@xyMarkerColor     = 20
res@xyLineColor       = 20
res@trXMaxF           = 6.
res@trXMinF           = 0.0
do ii=0,X-1,1 ;Paso por cada promedio horario
    mean_ust = avg(ust(ii,(buffer-1):(dimX-buffer-1),(buffer-1):(dimY-buffer-1)))
    do jj = 0,eta_max-2,1 ;Paso por cada nivel
        grad_vel(ii,jj) = (velocidad(ii,jj+1)-velocidad(ii,jj))/(altura(ii,jj+1)-altura(ii,jj))
        z_grad(ii,jj)   = (altura(ii,jj+1)+altura(ii,jj))/2.0
    end do
    ;Calculo de Phi 
    Phi = z_grad(ii,:)*grad_vel(ii,:)*0.4/mean_ust
    if (ii .lt. X-1) then
        print("            maxphi = "+sprintf("%6.4f",max(Phi))+"    minphi = "+sprintf("%6.4f",min(Phi)))
    else
        system("printf '            maxphi = "+sprintf("%6.4f",max(Phi))+"    minphi = "+sprintf("%6.4f",min(Phi))+"'")
    end if
    
    res@tiMainString      = "~F33~F~B2~M~N~~F~ promedio entre "+(hora_init+ii)+":00 y "+(hora_init+ii+1)+":00"
    plot           = gsn_csm_xy(wks2,Phi, z_grad(ii,:), res)
end do

end