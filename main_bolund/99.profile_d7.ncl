;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; Código hecho por Pablo Andrés Cárdenas Zamorano - UTFSM - 2018 ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Esta subrutina grafica los promedios móviles horarios en el punto de interés para las siguientes variables:
;velocidad u, velocidad v, magnitud de velocidad, gradiente de velocidad, tau13 y si es posible: tke
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Carga de paquetes
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
begin

print("        Cargando archivos...")
;Ubicación de Archivos
DATADir                     = "../"
FILES                       = systemfunc (" ls -1 " + DATADir + "wrfout_d07_*")
numFILES                    = dimsizes(FILES)
;Entornos
type                        = "pdf"
wks_U                       = gsn_open_wks(type,"V_d7")
;Almacenamiento de archivos
a                           = addfiles(FILES,"r")
times                       = wrf_user_getvar(a, "times", -1)
ntimes                      = dimsizes(times)
;Dimensiones del dominio
mdims                       = getfilevardimsizes(a[0],"P")
nd                          = dimsizes(mdims)
dimZ                        = mdims(nd-3)
dimY                        = mdims(nd-2)
dimX                        = mdims(nd-1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Información para promediar archivos
N         = 1 ; Cantidad de archivos a promediar
X         = (ntimes - N + 1) ; Número de promedios moviles
eta_max   = 10 ; Cantidad máxima de niveles a graficar
delta     = 1.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Inicialización de matrices a almacenar
z                   = new((/X,eta_max/),float)
u                   = new((/X,eta_max/),float)
v                   = new((/X,eta_max/),float)
U                   = new((/X,eta_max/),float)
;Para inicializarlos en vacío
z      = 0.
u      = 0.
v      = 0.
U      = 0.
;Creación de títulos de los gráficos
titulos = (/"06:00","12:00"/)
;Ubicación del punto de control en las coordenadas del modelo (mass points)
start_lat       = 55.70194
start_lon       = 12.09250
loc         = wrf_user_ll_to_ij(a[0], start_lon, start_lat, True)
locX        = loc(0)
locY        = loc(1)
if ( locX .lt. 1 .or. locX .gt. dimX .or. locY .lt. 1 .or. locY .gt. dimY )
    print("Fuera de dominio")
else 
    locX      = locX - 1
    locY      = locY - 1
    ;Almacenamiento de la altura del terreno
    ter       = wrf_user_getvar(a[0],"HGT",0)
    hgt_point = ter(locX,locY)
    ;LOOP POR CADA GRÁFICO DEL PROMEDIO MOVIL
    do ii = 0,X-1,1 ;Loop por por cada gráfico
        print("        Obteniendo datos para gráfico "+(ii+1)+":")
        n_inicial = ii ;índice del archivo inicial
        n_final   = n_inicial + (N-1);índice del archivo final
        system("printf '            '")
        ;loop por los archivos del promedio
        do it = n_inicial,n_final,1 ;Loop por los archivos
            ;Mensajes de consola
            if (it .eq. n_final) then
                print((it+1)+".")
            else 
                system("printf '"+(it+1)+".'")
            end if
            ;Obtención de las variables relevantes para cada archivo (nz,nx,ny)
            z_data      = wrf_user_getvar(a[it],"z",0)
            uvm         = wrf_user_getvar(a[it],"uvmet",0) ;Extrae las componente u,v rotadas a la cord de la tierra y en los mass point
            u_data      = uvm(0,:,:,:) 
            v_data      = uvm(1,:,:,:)  
            ;loop por los niveles
            do jj = 0, eta_max-1
                z(ii,jj)     = z(ii,jj) + z_data(jj,locX,locY)
                u(ii,jj)     = u(ii,jj) + u_data(jj,locX,locY)
                v(ii,jj)     = v(ii,jj) + v_data(jj,locX,locY)
            end do
        end do
        ;Calculo de promedios
        z(ii,:)     = z(ii,:)/N - hgt_point
        u(ii,:)     = u(ii,:)/N
        v(ii,:)     = v(ii,:)/N
    end do
end if
;Conversion a coordenada de capa límite
z = z/delta
;Definición de propiedades generales de los gráficos
gsn_define_colormap(wks_U,"MPL_viridis")

res                         = True
res@gsnMaximize             = True
res@vpWidthF                = 0.5 
res@vpHeightF               = 0.8      
res@xyLineThicknesses       = 6.0
res@xyMarkLineModes         = "Lines"                
res@xyMarkers               = 16
res@xyMarkerSizeF           = 0.01
res@tiMainFontHeightF       = 0.016
res@tiXAxisFontHeightF      = 0.02
res@tiYAxisFontHeightF      = 0.02
res@tmXBLabelFontHeightF    = 0.02
res@tmYLLabelFontHeightF    = 0.02
res@tmXBMajorOutwardLengthF = 0.0
res@tmXBMinorOutwardLengthF = 0.0
res@tmYLMajorOutwardLengthF = 0.0
res@tmYLMinorOutwardLengthF = 0.0
res@tmXMajorGrid            = True
res@tmYMajorGrid            = True
res@tmYMajorGridLineColor   = "Gray"
res@tmXMajorGridLineColor   = "Gray"
res@xyMarkerColor           = ((2*253)/9)
res@xyLineColor             = ((2*253)/9)
res@trYMaxF                 = 15.0
res@trXMinF                 = 0.0
res@trXMaxF                 = 15.0
res3                         = True
res3@xyLineThicknessF  = 6.0
res3@xyDashPattern     = 2
res3@xyLineColor       = 150;"red3"

print("        Creando gráficos...")
;Gráfico V
res@tiXAxisString = "V (m/s)"
res@tiYAxisString = "z/~F33~d~N~ (-)"
data_z = (/ 0,0.325, 0.650,5,10,15  /)
data_u = (/ 3.5,6.9,7.6,9.5,10,11  /)
res@gsnDraw  = False
res@gsnFrame = False
do ii=0,X-1,1 ;Paso por cada promedio horario
    res@tiMainString = "Mean profile from "+titulos(ii)+" to "+titulos(ii+(N-1))
    U(ii,:)          = sqrt(u(ii,:)^2+v(ii,:)^2)
    plot             = gsn_csm_xy(wks_U, U(ii,:) , z(ii,:), res)
    plot2            = gsn_csm_xy(wks_U, data_u , data_z, res3)
    overlay(plot, plot2)
    draw(plot)
    frame(wks_U)
end do
end