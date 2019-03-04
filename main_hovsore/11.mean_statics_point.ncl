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
DATADir                     = "../1.wrfouts/"
FILES                       = systemfunc (" ls -1 " + DATADir + "wrfout_d07_*")
numFILES                    = dimsizes(FILES)
;Entornos
type                        = "pdf"
wks_u                       = gsn_open_wks(type,"8.1.u")
wks_v                       = gsn_open_wks(type,"8.1.v")
wks_w                       = gsn_open_wks(type,"8.1.w")
wks_U                       = gsn_open_wks(type,"8.1.V")
wks_gradU                   = gsn_open_wks(type,"8.2.gradU")
wks_tau13                   = gsn_open_wks(type,"8.3.tau13")
wks_tke                     = gsn_open_wks(type,"8.3.tke")
wks_theta                   = gsn_open_wks(type,"8.3.theta")
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
eta_max   = 18 ; Cantidad máxima de niveles a graficar
delta     = 1000.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Inicialización de matrices a almacenar
def11               = new((/X,eta_max/),float)
def12               = new((/X,eta_max/),float)
def13               = new((/X,eta_max/),float)
def22               = new((/X,eta_max/),float)
def23               = new((/X,eta_max/),float)
def33               = new((/X,eta_max/),float)
tke                 = new((/X,eta_max/),float)
xkmv                = new((/X,eta_max/),float)
xkmh                = new((/X,eta_max/),float)
z                   = new((/X,eta_max/),float)
ust                 = new(X,float)
u                   = new((/X,eta_max/),float)
v                   = new((/X,eta_max/),float)
U                   = new((/X,eta_max/),float)
w                   = new((/X,eta_max/),float)
phi                 = new((/X,(eta_max-1)/),float)
z_grad              = new((/X,(eta_max-1)/),float)
theta               = new((/X,eta_max/),float)
;Para inicializarlos en vacío
def11  = 0. 
def12  = 0.
def13  = 0.
def22  = 0.
def23  = 0.
def33  = 0.
tke    = 0.
xkmv   = 0.
xkmh   = 0.
z      = 0.
z_grad = 0.
ust    = 0.
u      = 0.
v      = 0.
U      = 0.
w      = 0.
phi    = 0.
theta  = 0.
tau13_res = 0.
tau11_res = 0.
tau22_res = 0.
tau33_res = 0.
;Creación de títulos de los gráficos
; titulos = (/"12:00","12:10","12:20","12:30","12:40","12:50",\
;            "13:00","13:10","13:20","13:30","13:40","13:50",\
;            "14:00","14:10","14:20","14:30","14:40","14:50",\
;            "15:00","15:10","15:20","15:30","15:40","15:50",\
;            "16:00","16:10","16:20","16:30","16:40","16:50",\
;            "17:00","17:10","17:20","17:30","17:40","17:50",\
;            "18:00","18:10","18:20","18:30","18:40","18:50",\
;            "19:00","19:10","19:20","19:30","19:40","19:50",\
;            "20:00","20:10","20:20","20:30","20:40","20:50",\
;            "21:00","21:10","21:20","21:30","21:40","21:50",\
;            "22:00"/)
titulos = (/"08:00","08:10","08:20","08:30","08:40","08:50",\
           "09:00","09:10","09:20","09:30","09:40","09:50",\
           "10:00","10:10","10:20","10:30","10:40","10:50"/)
;Ubicación del punto de control en las coordenadas del modelo (mass points)
loc         = wrf_user_ll_to_ij(a[0], 8.1509, 56.4406, True)
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
            tke_data    = wrf_user_getvar(a[it],"TKE",0)
            theta_data  = wrf_user_getvar(a[it],"T",0)
            def11_data  = wrf_user_getvar(a[it],"DEFOR11",0)
            def12_data  = wrf_user_getvar(a[it],"DEFOR12",0)
            def22_data  = wrf_user_getvar(a[it],"DEFOR22",0)
            def23_aux   = wrf_user_getvar(a[it],"DEFOR23",0)
            def33_aux   = wrf_user_getvar(a[it],"DEFOR33",0)
            def13_aux   = wrf_user_getvar(a[it],"DEFOR13",0)
            def23_data  = wrf_user_unstagger(def23_aux, "Z")
            def33_data  = wrf_user_unstagger(def33_aux, "Z")
            def13_data  = wrf_user_unstagger(def13_aux, "Z")
            xkmv_data   = wrf_user_getvar(a[it],"XKMV",0)
            xkmh_data   = wrf_user_getvar(a[it],"XKMH",0)
            z_data      = wrf_user_getvar(a[it],"z",0)
            uvm         = wrf_user_getvar(a[it],"uvmet",0) ;Extrae las componente u,v rotadas a la cord de la tierra y en los mass point
            u_data      = uvm(0,:,:,:) 
            v_data      = uvm(1,:,:,:)
            w_data      = wrf_user_getvar(a[it],"wa",0); Extrae w en los mass pointa
            ust_data    = wrf_user_getvar(a[it],"UST",0)    
            ;loop por los niveles
            ust(ii) = ust(ii) + ust_data(locX,locY)
            do jj = 0, eta_max-1
                def11(ii,jj) = def11(ii,jj) + def11_data(jj,locX,locY);valor puntual
                def12(ii,jj) = def12(ii,jj) + def12_data(jj,locX,locY)
                def13(ii,jj) = def13(ii,jj) + def13_data(jj,locX,locY)
                def22(ii,jj) = def22(ii,jj) + def22_data(jj,locX,locY)
                def23(ii,jj) = def23(ii,jj) + def23_data(jj,locX,locY)
                def33(ii,jj) = def33(ii,jj) + def33_data(jj,locX,locY)
                tke(ii,jj)   = tke(ii,jj) + tke_data(jj,locX,locY)
                xkmv(ii,jj)  = xkmv(ii,jj) + xkmv_data(jj,locX,locY)
                xkmh(ii,jj)  = xkmh(ii,jj) + xkmh_data(jj,locX,locY)
                z(ii,jj)     = z(ii,jj) + z_data(jj,locX,locY)
                u(ii,jj)     = u(ii,jj) + u_data(jj,locX,locY)
                v(ii,jj)     = v(ii,jj) + v_data(jj,locX,locY)
                w(ii,jj)     = w(ii,jj) + w_data(jj,locX,locY)
                theta(ii,jj) = theta(ii,jj) + theta_data(jj,locX,locY)
            end do
        end do
        ;Calculo de promedios
        def11(ii,:) = def11(ii,:)/N
        def12(ii,:) = def12(ii,:)/N
        def13(ii,:) = def13(ii,:)/N
        def22(ii,:) = def22(ii,:)/N
        def23(ii,:) = def23(ii,:)/N
        def33(ii,:) = def33(ii,:)/N
        tke(ii,:)   = tke(ii,:)/N
        xkmv(ii,:)  = xkmv(ii,:)/N
        xkmh(ii,:)  = xkmh(ii,:)/N
        z(ii,:)     = z(ii,:)/N - hgt_point
        u(ii,:)     = u(ii,:)/N
        v(ii,:)     = v(ii,:)/N
        w(ii,:)     = w(ii,:)/N
        theta(ii,:) = theta(ii,:)/N + 300.
        ust(ii)     = ust(ii)/N
    end do
end if
print(ust)
;Conversion a coordenada de capa límite
z = z/delta
;Definición de propiedades generales de los gráficos
gsn_define_colormap(wks_u,"MPL_viridis")
gsn_define_colormap(wks_v,"MPL_viridis")
gsn_define_colormap(wks_w,"MPL_viridis")
gsn_define_colormap(wks_U,"MPL_viridis")
gsn_define_colormap(wks_gradU,"MPL_viridis")
gsn_define_colormap(wks_tau13,"MPL_viridis")
gsn_define_colormap(wks_tke,"MPL_viridis")
gsn_define_colormap(wks_theta,"MPL_viridis")

res                         = True
res@gsnMaximize             = True
res@vpWidthF                = 0.5 
res@vpHeightF               = 0.6      
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

print("        Creando gráficos...")

;Gráfico u
res@tiXAxisString = "u (m/s)"
res@tiYAxisString = "z/~F33~d~N~ (-)"
do ii=0,X-1,1 ;Paso por cada promedio horario
    res@tiMainString = "Mean profile from "+titulos(ii)+" to "+titulos(ii+(N-1))
    plot             = gsn_csm_xy(wks_u, u(ii,:), z(ii,:), res)
end do

;Gráfico v
res@tiXAxisString = "v (m/s)"
res@tiYAxisString = "z/~F33~d~N~ (-)"
do ii=0,X-1,1 ;Paso por cada promedio horario
    res@tiMainString = "Mean profile from "+titulos(ii)+" to "+titulos(ii+(N-1))
    plot             = gsn_csm_xy(wks_v, v(ii,:), z(ii,:), res)
end do

;Gráfico w
res@tiXAxisString = "w (m/s)"
res@tiYAxisString = "z/~F33~d~N~ (-)"
do ii=0,X-1,1 ;Paso por cada promedio horario
    res@tiMainString = "Mean profile from "+titulos(ii)+" to "+titulos(ii+(N-1))
    plot             = gsn_csm_xy(wks_w, w(ii,:), z(ii,:), res)
end do

;Gráfico V
res@tiXAxisString = "V (m/s)"
res@tiYAxisString = "z/~F33~d~N~ (-)"
do ii=0,X-1,1 ;Paso por cada promedio horario
    res@tiMainString = "Mean profile from "+titulos(ii)+" to "+titulos(ii+(N-1))
    U(ii,:)          = sqrt(u(ii,:)^2+v(ii,:)^2)
    plot             = gsn_csm_xy(wks_U, U(ii,:) , z(ii,:), res)
end do

;Gráfico gradU
res@tiXAxisString = "~F33~F~B2~M~N~ (-)"
res@tiYAxisString = "z/~F33~d~N~ (-)"
do ii=0,X-1,1 ;Paso por cada promedio horario
    res@tiMainString = "Mean profile from "+titulos(ii)+" to "+titulos(ii+(N-1))
    do jj=1,(eta_max-1)
        phi(ii,(jj-1)) = (U(ii,jj)-U(ii,jj-1))/(z(ii,jj)-z(ii,jj-1))
        z_grad(ii,(jj-1)) = (z(ii,jj)+z(ii,(jj-1)))*0.5
        phi(ii,(jj-1)) = phi(ii,(jj-1))*z_grad(ii,(jj-1))*0.4/ust(ii)
    end do
    plot             = gsn_csm_xy(wks_gradU, phi(ii,:) , z_grad(ii,:), res)
end do

;Gráfico tau13
res@tiXAxisString = "~F33~t~B2~13~N~~F~   /u*2 (-)"
res@tiYAxisString = "z/~F33~d~N~ (-)"
do ii=0,X-1,1 ;Paso por cada promedio horario
    res@tiMainString = "Mean profile from "+titulos(ii)+" to "+titulos(ii+(N-1))
    calc_tau13       = (-1.0*xkmv(ii,:)*def13(ii,:))/(ust(ii)^2.0)
    calc_tau23       = (-1.0*xkmv(ii,:)*def23(ii,:))/(ust(ii)^2.0)
    plot             = gsn_csm_xy(wks_tau13, -1.0*sqrt(calc_tau13^2.0 + calc_tau23^2.0) , z(ii,:), res)
end do

;Gráfico tke
res@tiXAxisString = "tke/u*2 (-)"
res@tiYAxisString = "z/~F33~d~N~ (-)"
do ii=0,X-1,1 ;Paso por cada promedio horario
    res@tiMainString = "Mean profile from "+titulos(ii)+" to "+titulos(ii+(N-1))
    calc_tke         = tke(ii,:)/(ust(ii)^2.0)
    plot             = gsn_csm_xy(wks_tke, calc_tke , z(ii,:), res)
end do

;Gráfico theta
res@tiXAxisString = "~F33~q~N~~F~ (~F135~G~F~C)"
res@tiYAxisString = "z (m)"
res@tiYAxisString = "z/~F33~d~N~ (-)"
res@tmXBFormat    = "f"
;res@vpWidthF                = 0.3  
;res@vpHeightF               = 0.6
;res@tiMainFontHeightF       = 0.018
;res@tiXAxisFontHeightF      = 0.018
;res@tiYAxisFontHeightF      = 0.018
;res@tmXBLabelFontHeightF    = 0.014
;res@tmYLLabelFontHeightF    = 0.014
do ii=0,X-1,1 ;Paso por cada promedio horario
    res@tiMainString = "Mean profile from "+titulos(ii)+" to "+titulos(ii+(N-1))
    plot             = gsn_csm_xy(wks_theta, theta(ii,:) , z(ii,:), res)
end do
end