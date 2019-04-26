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
FILES                       = systemfunc (" ls -1 " + DATADir + "wrfout_d08_*")
numFILES                    = dimsizes(FILES)
;Entornos
type                        = "pdf"
wks_U                       = gsn_open_wks(type,"V_referencia")
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
N         = 37 ; Cantidad de archivos a promediar
X         = 1;(ntimes - N + 1) ; Número de promedios moviles
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
titulos = (/"06:00","06:05","06:10","06:15","06:20","06:25",\
        "06:30","06:35","06:40","06:45","06:50","06:55",\
        "07:00","07:05","07:10","07:15","07:20","07:25",\
        "07:30","07:35","07:40","07:45","07:50","07:55",\
        "08:00","08:05","08:10","08:15","08:20","08:25",\
        "08:30","08:35","08:40","08:45","08:50","08:55",\
        "09:00","09:05","09:10","09:15","09:20","09:25",\
        "09:30","09:35","09:40","09:45","09:50","09:55",\
        "10:00","10:05","10:10","10:15","10:20","10:25",\
        "10:30","10:35","10:40","10:45","10:50","10:55",\
        "11:00","11:05","11:10","11:15","11:20","11:25",\
        "11:30","11:35","11:40","11:45","11:50","11:55",\
        "12:00","12:05","12:10","12:15","12:20","12:25",\
        "12:30","12:35","12:40","12:45","12:50","12:55",\
        "13:00","13:05","13:10","13:15","13:20","13:25",\
        "13:30","13:35","13:40","13:45","13:50","13:55",\
        "14:00","14:05","14:10","14:15","14:20","14:25",\
        "14:30","14:35","14:40","14:45","14:50","14:55",\
        "15:00","15:05","15:10","15:15","15:20","15:25",\
        "15:30","15:35","15:40","15:45","15:50","15:55",\
        "16:00","16:05","16:10","16:15","16:20","16:25",\
        "16:30","16:35","16:40","16:45","16:50","16:55",\
        "17:00","17:05","17:10","17:15","17:20","17:25",\
        "17:30","17:35","17:40","17:45","17:50","17:55",\
        "18:00","18:05","18:10","18:15","18:20","18:25",\
        "18:30","18:35","18:40","18:45","18:50","18:55",\
        "19:00","19:05","19:10","19:15","19:20","19:25",\
        "19:30","19:35","19:40","19:45","19:50","19:55",\
        "20:00","20:05","20:10","20:15","20:20","20:25",\
        "20:30","20:35","20:40","20:45","20:50","20:55",\
        "21:00","21:05","21:10","21:15","21:20","21:25",\
        "21:30","21:35","21:40","21:45","21:50","21:55",\
        "22:00"/)
;Ubicación del punto de control en las coordenadas del modelo (mass points)
start_lat       = 55.70313
start_lon       = 12.0970
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
        n_inicial = 72+ii ;índice del archivo inicial
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
res@vpWidthF                = 0.4 
res@vpHeightF               = 0.9      
res@xyLineThicknesses       = 8.0
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
res@xyLineColor             = (180)
res@trYMaxF                 = 15.0
res@trXMinF                 = 0.0
res@trXMaxF                 = 15.0
res3                         = True
res3@xyLineThicknessF  = 4.0
res3@xyDashPattern     = 3
res3@xyLineColor       = "black";"red3"
res3@gsnDraw  = False
res3@gsnFrame = False

print("        Creando gráficos...")
;Gráfico V
res@tiXAxisString = "V [m/s]"
res@tiYAxisString = "z [m]"
data_z = (/ 0,0.325, 0.650,1,2.0,2.5,4,  5,10,15  /)
data_u = (/ 3.5,6.9,7.6,8.0,8.5,8.7, 9.3, 9.5,10,11  /)
res@gsnDraw  = False
res@gsnFrame = False

print(z(:,0:5))
do ii=0,X-1,1 ;Paso por cada promedio horario
    res@tiMainString = "Mean profile from "+titulos(72+ii)+" to "+titulos(72+ii+(N-1))
    U(ii,:)          = sqrt(u(ii,:)^2+v(ii,:)^2)
    print(U(:,:))
    plot             = gsn_csm_xy(wks_U, U(ii,:) , z(ii,:), res)
    plot2            = gsn_csm_xy(wks_U, data_u , data_z, res3)
    overlay(plot, plot2)
    draw(plot)
    frame(wks_U)
end do
end