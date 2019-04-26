;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; Código hecho por Pablo Andrés Cárdenas Zamorano - UTFSM - 2019 ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
wks_U                       = gsn_open_wks(type,"V_masts")
wks_k                       = gsn_open_wks(type,"k_masts")
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
;Definición de propiedades generales de los gráficos
gsn_define_colormap(wks_U,"MPL_viridis")
res                         = True
res@gsnMaximize             = True
res@vpWidthF                = 0.4 
res@vpHeightF               = 0.7      
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
res@tmGridDrawOrder             = "PreDraw"
res@xyMarkerColor           = ((2*253)/9)
res@xyLineColor             = (90)
res@trYMaxF                 = 15.0
res@gsnDraw                 = False
res@gsnFrame                = False
;
gsn_define_colormap(wks_k,"MPL_viridis")
res2                         = True
res2@gsnMaximize             = True
res2@vpWidthF                = 0.4 
res2@vpHeightF               = 0.7      
res2@xyLineThicknesses       = 6.0
res2@xyMarkLineModes         = "Lines"                
res2@xyMarkers               = 16
res2@xyMarkerSizeF           = 0.01
res2@tiMainFontHeightF       = 0.016
res2@tiXAxisFontHeightF      = 0.02
res2@tiYAxisFontHeightF      = 0.02
res2@tmXBLabelFontHeightF    = 0.02
res2@tmYLLabelFontHeightF    = 0.00
res2@tmXBMajorOutwardLengthF = 0.0
res2@tmXBMinorOutwardLengthF = 0.0
res2@tmYLMajorOutwardLengthF = 0.0
res2@tmYLMinorOutwardLengthF = 0.0
res2@tmXMajorGrid            = True
res2@tmYMajorGrid            = True
res2@tmYMajorGridLineColor   = "Gray"
res2@tmXMajorGridLineColor   = "Gray"
res2@tmGridDrawOrder         = "PreDraw"
res2@xyMarkerColor           = ((2*253)/9)
res2@xyLineColor             = (90)
res2@trYMaxF                 = 15.0
res2@gsnDraw                 = False
res2@gsnFrame                = False
;
ter         = wrf_user_getvar(a[0],"HGT",0)

;M0
print("        Creando gráfico para M0")
start_lat   = 55.70313
start_lon   = 12.0970
loc         = wrf_user_ll_to_ij(a[0], start_lon, start_lat, True)
locX        = loc(0)
locY        = loc(1)
;Inicialización de matrices a almacenar
z           = new((/X,eta_max/),float)
tke         = new((/X,eta_max/),float)
u           = new((/X,eta_max/),float)
v           = new((/X,eta_max/),float)
U           = new((/X,eta_max/),float)
;Para inicializarlos en vacío
z           = 0.
tke         = 0.
u           = 0.
v           = 0.
U           = 0.
;Obtención de data
locX        = locX - 1
locY        = locY - 1
;Almacenamiento de la altura del terreno
hgt_point   = ter(locX,locY)
;LOOP POR CADA GRÁFICO DEL PROMEDIO MOVIL
do ii = 0,X-1,1 ;Loop por por cada gráfico
    n_inicial = 72+ii ;índice del archivo inicial
    n_final   = n_inicial + (N-1);índice del archivo final
    ;loop por los archivos del promedio
    do it = n_inicial,n_final,1 ;Loop por los archivos
        ;Obtención de las variables relevantes para cada archivo (nz,nx,ny)
        z_data   = wrf_user_getvar(a[it],"z",0)
        tke_data = wrf_user_getvar(a[it],"TKE",0) 
        uvm      = wrf_user_getvar(a[it],"uvmet",0) ;Extrae las componente u,v rotadas a la cord de la tierra y en los mass point
        u_data   = uvm(0,:,:,:) 
        v_data   = uvm(1,:,:,:)  
        ;loop por los niveles
        do jj = 0, eta_max-1
            z(ii,jj)    = z(ii,jj) + z_data(jj,locX,locY)
            tke(ii,jj)  = tke(ii,jj) + tke_data(jj,locX,locY)
            u(ii,jj)    = u(ii,jj) + u_data(jj,locX,locY)
            v(ii,jj)    = v(ii,jj) + v_data(jj,locX,locY)
        end do
    end do
    ;Calculo de promedios
    z(ii,:)     = z(ii,:)/N - hgt_point
    u(ii,:)     = u(ii,:)/N
    tke(ii,:)   = tke(ii,:)/N
    v(ii,:)     = v(ii,:)/N
end do
;Gráfico V
res@tiXAxisString = "V [m/s]"
res@tiYAxisString = "z [m]"
do ii=0,X-1,1 ;Paso por cada promedio horario
    res@tiMainString = "Mean profile from "+titulos(72+ii)+" to "+titulos(72+ii+(N-1))
    U(ii,:)          = sqrt(u(ii,:)^2+v(ii,:)^2)
    ;plot             = gsn_csm_xy(wks_U, U(ii,:) , z(ii,:), res)
    ;draw(plot)
    ;frame(wks_U)
end do


U_ref = U
k_ref = tke
;
res@trXMinF           = -1.0
res@trXMaxF           =  1.0
res@tmXBMode          = "Explicit"
res@tmXBValues        = (/-1.0,-0.5,0,0.5,1 /)
res@tmXBLabels        = sprintf("%4.1f",(/-1.0,-0.5,0,0.5,1 /))
;
res2@trXMinF           = -0.05
res2@trXMaxF           =  0.2
res2@tmXBMode          = "Explicit"
res2@tmXBValues        = (/-0.05,0.0,0.05,0.10,0.15,0.2 /)
res2@tmXBLabels        = sprintf("%5.2f",(/-0.05,0.0,0.05,0.10,0.15,0.2 /))
res2@tiXAxisString = "~F33~D~N~~F~k"
;res2@tiYAxisString = "z [m]"
;M1
print("        Creando gráfico para M1")
start_lat   = 55.70332
start_lon   = 12.09760
loc         = wrf_user_ll_to_ij(a[0], start_lon, start_lat, True)
locX        = loc(0)
locY        = loc(1)
;Inicialización de matrices a almacenar
z           = new((/X,eta_max/),float)
tke         = new((/X,eta_max/),float)
u           = new((/X,eta_max/),float)
v           = new((/X,eta_max/),float)
U           = new((/X,eta_max/),float)
;Para inicializarlos en vacío
z           = 0.
tke         = 0.
u           = 0.
v           = 0.
U           = 0.
;Obtención de data
locX        = locX - 1
locY        = locY - 1
;Almacenamiento de la altura del terreno
hgt_point   = ter(locX,locY)
;LOOP POR CADA GRÁFICO DEL PROMEDIO MOVIL
do ii = 0,X-1,1 ;Loop por por cada gráfico
    n_inicial = 72+ii ;índice del archivo inicial
    n_final   = n_inicial + (N-1);índice del archivo final
    ;loop por los archivos del promedio
    do it = n_inicial,n_final,1 ;Loop por los archivos
        ;Obtención de las variables relevantes para cada archivo (nz,nx,ny)
        z_data  = wrf_user_getvar(a[it],"z",0)
        tke_data = wrf_user_getvar(a[it],"TKE",0)
        uvm     = wrf_user_getvar(a[it],"uvmet",0) ;Extrae las componente u,v rotadas a la cord de la tierra y en los mass point
        u_data  = uvm(0,:,:,:) 
        v_data  = uvm(1,:,:,:)  
        ;loop por los niveles
        do jj = 0, eta_max-1
            z(ii,jj)    = z(ii,jj) + z_data(jj,locX,locY)
            tke(ii,jj)  = tke(ii,jj) + tke_data(jj,locX,locY)
            u(ii,jj)    = u(ii,jj) + u_data(jj,locX,locY)
            v(ii,jj)    = v(ii,jj) + v_data(jj,locX,locY)
        end do
    end do
    ;Calculo de promedios
    z(ii,:)     = z(ii,:)/N - hgt_point
    tke(ii,:)   = tke(ii,:)/N
    u(ii,:)     = u(ii,:)/N
    v(ii,:)     = v(ii,:)/N
end do
;Gráfico V
res@tiXAxisString = "~F33~D~N~~F~S"
res@tiYAxisString = "z [m]"
res@xyLineColor    = 40
res2@xyLineColor   = 40
do ii=0,X-1,1 ;Paso por cada promedio horario
    res@tiMainString = "Mean profile from "+titulos(72+ii)+" to "+titulos(72+ii+(N-1))
    res2@tiMainString = "Mean profile from "+titulos(72+ii)+" to "+titulos(72+ii+(N-1))
    U(ii,:)          = sqrt(u(ii,:)^2+v(ii,:)^2)
    plot1            = gsn_csm_xy(wks_U, (U(ii,:)-U_ref(ii,:))/U_ref(ii,:) , z(ii,:), res)
    plot_k1          = gsn_csm_xy(wks_k, (tke(ii,:)-k_ref(ii,:))/U_ref(ii,:) , z(ii,:), res2)
;    draw(plot)
;    frame(wks_U)
end do

;M2
print("        Creando gráfico para M2")
start_lat   = 55.70340
start_lon   = 12.09787
loc         = wrf_user_ll_to_ij(a[0], start_lon, start_lat, True)
locX        = loc(0)
locY        = loc(1)
;Inicialización de matrices a almacenar
z           = new((/X,eta_max/),float)
tke         = new((/X,eta_max/),float)
u           = new((/X,eta_max/),float)
v           = new((/X,eta_max/),float)
U           = new((/X,eta_max/),float)
;Para inicializarlos en vacío
z           = 0.
tke         = 0.
u           = 0.
v           = 0.
U           = 0.
;Obtención de data
locX        = locX - 1
locY        = locY - 1
;Almacenamiento de la altura del terreno
hgt_point   = ter(locX,locY)
;LOOP POR CADA GRÁFICO DEL PROMEDIO MOVIL
do ii = 0,X-1,1 ;Loop por por cada gráfico
    n_inicial = 72+ii ;índice del archivo inicial
    n_final   = n_inicial + (N-1);índice del archivo final
    ;loop por los archivos del promedio
    do it = n_inicial,n_final,1 ;Loop por los archivos
        ;Obtención de las variables relevantes para cada archivo (nz,nx,ny)
        z_data  = wrf_user_getvar(a[it],"z",0)
        tke_data = wrf_user_getvar(a[it],"TKE",0)
        uvm     = wrf_user_getvar(a[it],"uvmet",0) ;Extrae las componente u,v rotadas a la cord de la tierra y en los mass point
        u_data  = uvm(0,:,:,:) 
        v_data  = uvm(1,:,:,:)  
        ;loop por los niveles
        do jj = 0, eta_max-1
            z(ii,jj)    = z(ii,jj) + z_data(jj,locX,locY)
            tke(ii,jj)  = tke(ii,jj) + tke_data(jj,locX,locY)
            u(ii,jj)    = u(ii,jj) + u_data(jj,locX,locY)
            v(ii,jj)    = v(ii,jj) + v_data(jj,locX,locY)
        end do
    end do
    ;Calculo de promedios
    z(ii,:)     = z(ii,:)/N - hgt_point
    tke(ii,:)   = tke(ii,:)/N
    u(ii,:)     = u(ii,:)/N
    v(ii,:)     = v(ii,:)/N
end do
;Gráfico V
res@tiXAxisString = "~F33~D~N~~F~S"
res@tiYAxisString = "z [m]"
res@xyLineColor    = 100
res2@xyLineColor   = 100
res2@xyDashPattern = 2
res@xyDashPattern = 2
do ii=0,X-1,1 ;Paso por cada promedio horario
    res@tiMainString = "Mean profile from "+titulos(72+ii)+" to "+titulos(72+ii+(N-1))
    U(ii,:)          = sqrt(u(ii,:)^2+v(ii,:)^2)
    plot2            = gsn_csm_xy(wks_U, (U(ii,:)-U_ref(ii,:))/U_ref(ii,:) , z(ii,:), res)
    plot_k2          = gsn_csm_xy(wks_k, (tke(ii,:)-k_ref(ii,:))/U_ref(ii,:) , z(ii,:), res2)
    overlay(plot1, plot2)
    overlay(plot_k1, plot_k2)
    ;draw(plot)
    ;frame(wks_U)
end do

;M3
print("        Creando gráfico para M3")
start_lat   = 55.70360
start_lon   = 12.09850
loc         = wrf_user_ll_to_ij(a[0], start_lon, start_lat, True)
locX        = loc(0)
locY        = loc(1)
;Inicialización de matrices a almacenar
z           = new((/X,eta_max/),float)
tke         = new((/X,eta_max/),float)
u           = new((/X,eta_max/),float)
v           = new((/X,eta_max/),float)
U           = new((/X,eta_max/),float)
;Para inicializarlos en vacío
z           = 0.
tke         = 0.
u           = 0.
v           = 0.
U           = 0.
;Obtención de data
locX        = locX - 1
locY        = locY - 1
;Almacenamiento de la altura del terreno
hgt_point   = ter(locX,locY)
;LOOP POR CADA GRÁFICO DEL PROMEDIO MOVIL
do ii = 0,X-1,1 ;Loop por por cada gráfico
    n_inicial = 72+ii ;índice del archivo inicial
    n_final   = n_inicial + (N-1);índice del archivo final
    ;loop por los archivos del promedio
    do it = n_inicial,n_final,1 ;Loop por los archivos
        ;Obtención de las variables relevantes para cada archivo (nz,nx,ny)
        z_data  = wrf_user_getvar(a[it],"z",0)
        tke_data = wrf_user_getvar(a[it],"TKE",0)
        uvm     = wrf_user_getvar(a[it],"uvmet",0) ;Extrae las componente u,v rotadas a la cord de la tierra y en los mass point
        u_data  = uvm(0,:,:,:) 
        v_data  = uvm(1,:,:,:)  
        ;loop por los niveles
        do jj = 0, eta_max-1
            z(ii,jj)    = z(ii,jj) + z_data(jj,locX,locY)
            tke(ii,jj)  = tke(ii,jj) + tke_data(jj,locX,locY)
            u(ii,jj)    = u(ii,jj) + u_data(jj,locX,locY)
            v(ii,jj)    = v(ii,jj) + v_data(jj,locX,locY)
        end do
    end do
    ;Calculo de promedios
    z(ii,:)     = z(ii,:)/N - hgt_point
    tke(ii,:)   = tke(ii,:)/N
    u(ii,:)     = u(ii,:)/N
    v(ii,:)     = v(ii,:)/N
end do
;Gráfico V
res@tiXAxisString = "~F33~D~N~~F~S"
res@tiYAxisString = "z [m]"
res@xyLineColor   = 160
res2@xyLineColor   = 160
res2@xyDashPattern = 3
res@xyDashPattern = 3
do ii=0,X-1,1 ;Paso por cada promedio horario
    res@tiMainString = "Mean profile from "+titulos(72+ii)+" to "+titulos(72+ii+(N-1))
    U(ii,:)          = sqrt(u(ii,:)^2+v(ii,:)^2)
    plot3             = gsn_csm_xy(wks_U, (U(ii,:)-U_ref(ii,:))/U_ref(ii,:) , z(ii,:), res)
    plot_k3          = gsn_csm_xy(wks_k, (tke(ii,:)-k_ref(ii,:))/U_ref(ii,:) , z(ii,:), res2)
    overlay(plot1, plot3)
    overlay(plot_k1, plot_k3)
    ;draw(plot)
    ;frame(wks_U)
end do

;M4
print("        Creando gráfico para M4")
start_lat   = 55.70386
start_lon   = 12.09927
loc         = wrf_user_ll_to_ij(a[0], start_lon, start_lat, True)
locX        = loc(0)
locY        = loc(1)
;Inicialización de matrices a almacenar
z           = new((/X,eta_max/),float)
tke         = new((/X,eta_max/),float)
u           = new((/X,eta_max/),float)
v           = new((/X,eta_max/),float)
U           = new((/X,eta_max/),float)
;Para inicializarlos en vacío
z           = 0.
tke         = 0.
u           = 0.
v           = 0.
U           = 0.
;Obtención de data
locX        = locX - 1
locY        = locY - 1
;Almacenamiento de la altura del terreno
hgt_point   = ter(locX,locY)
;LOOP POR CADA GRÁFICO DEL PROMEDIO MOVIL
do ii = 0,X-1,1 ;Loop por por cada gráfico
    n_inicial = 72+ii ;índice del archivo inicial
    n_final   = n_inicial + (N-1);índice del archivo final
    ;loop por los archivos del promedio
    do it = n_inicial,n_final,1 ;Loop por los archivos
        ;Obtención de las variables relevantes para cada archivo (nz,nx,ny)
        z_data  = wrf_user_getvar(a[it],"z",0)
        tke_data = wrf_user_getvar(a[it],"TKE",0)
        uvm     = wrf_user_getvar(a[it],"uvmet",0) ;Extrae las componente u,v rotadas a la cord de la tierra y en los mass point
        u_data  = uvm(0,:,:,:) 
        v_data  = uvm(1,:,:,:)  
        ;loop por los niveles
        do jj = 0, eta_max-1
            z(ii,jj)    = z(ii,jj) + z_data(jj,locX,locY)
            tke(ii,jj)  = tke(ii,jj) + tke_data(jj,locX,locY)
            u(ii,jj)    = u(ii,jj) + u_data(jj,locX,locY)
            v(ii,jj)    = v(ii,jj) + v_data(jj,locX,locY)
        end do
    end do
    ;Calculo de promedios
    z(ii,:)     = z(ii,:)/N - hgt_point
    tke(ii,:)   = tke(ii,:)/N
    u(ii,:)     = u(ii,:)/N
    v(ii,:)     = v(ii,:)/N
end do
;Gráfico V
res@tiXAxisString = "~F33~D~N~~F~S"
res@tiYAxisString = "z [m]"
res@xyLineColor    = 220
res2@xyLineColor   = 220
res2@xyDashPattern = 4
res@xyDashPattern = 4     
do ii=0,X-1,1 ;Paso por cada promedio horario
    res@tiMainString = "Mean profile from "+titulos(72+ii)+" to "+titulos(72+ii+(N-1))
    U(ii,:)          = sqrt(u(ii,:)^2+v(ii,:)^2)
    plot4            = gsn_csm_xy(wks_U, (U(ii,:)-U_ref(ii,:))/U_ref(ii,:) , z(ii,:), res)
    plot_k4          = gsn_csm_xy(wks_k, (tke(ii,:)-k_ref(ii,:))/U_ref(ii,:) , z(ii,:), res2)
    overlay(plot1, plot4)
    draw(plot1)
    frame(wks_U)
    overlay(plot_k1, plot_k4)
    draw(plot_k1)
    frame(wks_k)
end do

end