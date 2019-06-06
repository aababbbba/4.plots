;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; Código hecho por Pablo Andrés Cárdenas Zamorano - UTFSM - 2018 ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Se grafica la comparación entre los valores obtenidos en la simulación y aquellos obtenidos por peña
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Carga de paquetes
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
begin
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;subrutina de error bar
undef("add_x_errorbar")
procedure add_x_errorbar(wks, plot, x[*]:numeric,y[*]:numeric, xerror[*]:numeric, res)
local dimz, xpoints, ypoints, gsres, i
begin
  gsres = res       
  dimz  = dimsizes(y)

  xpoints = (/x-xerror, x+xerror/)
  ypoints = (/ y, y/)

  do i=0, dimz(0)-1
     plot@$tostring("x_errorbar"+i)$ = gsn_add_polyline(wks, plot, xpoints(:,i), ypoints(:,i), gsres )
  end do
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Ubicación de Archivos
DATADir                     = "../"
FILES                       = systemfunc (" ls -1 " + DATADir + "wrfout_d07_*")
numFILES                    = dimsizes(FILES)
;Entornos
type                        = "pdf"
wks_u                       = gsn_open_wks(type,"9u")
wks_v                       = gsn_open_wks(type,"9v")
wks_U                       = gsn_open_wks(type,"9V")
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
;Información para promediar archivos
N         = 13 ; Cantidad de archivos a promediar
X         = (ntimes - N + 1) ; Número de promedios moviles
;X         = 1
eta_max   = 21 ; Cantidad máxima de niveles a graficar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Inicialización de matrices a almacenar
z                   = new((/X,eta_max/),float)
u                   = new((/X,eta_max/),float)
v                   = new((/X,eta_max/),float)
u_rot               = new((/X,eta_max/),float)
v_rot               = new((/X,eta_max/),float)
u10                 = new((/X/),float)
v10                 = new((/X/),float)
;Para inicializarlos en vacío
z      = 0.
u      = 0.
v      = 0.
u10    = 0.
v10    = 0.
u_rot  = 0.
v_rot  = 0.

delta = 750.0
;Creación de títulos de los gráficos
titulos = (/"06:00","06:10","06:20","06:30","06:40","06:50",\
           "07:00","07:10","07:20","07:30","07:40","07:50",\
           "08:00","08:10","08:20","08:30","08:40","08:50",\
           "09:00","09:10","09:20","09:30","09:40","09:50",\
           "10:00","10:10","10:20","10:30","10:40","10:50",\
           "11:00","11:10","11:20","11:30","11:40","11:50",\
           "12:00","12:10","12:20","12:30","12:40","12:50",\
           "13:00","13:10","13:20","13:30","13:40","13:50",\
           "14:00","14:10","14:20","14:30","14:40","14:50",\
           "15:00","15:10","15:20","15:30","15:40","15:50",\
           "16:00","16:10","16:20","16:30","16:40","16:50",\
           "17:00","17:10","17:20","17:30","17:40","17:50",\
           "18:00","18:10","18:20","18:30","18:40","18:50",\
           "19:00","19:10","19:20","19:30","19:40","19:50",\
           "20:00","20:10","20:20","20:30","20:40","20:50",\
           "21:00","21:10","21:20","21:30","21:40","21:50",\
           "22:00"/)
;Datos a comparar
z_comp = (/ 10.,40.,100.,150.,200.,250.,300.,350.,400.,450.,500.,550.,600.,650.,700.,750.,800.,850.,900.,950.,1000.,1050.,1100.,1150.,1200. /)
err_u = (/ 1.9, 2.25, 2.53, 2.86, 2.85, 2.90, 3.00, 3.07, 3.12, 3.17, 3.25, 3.29, 3.34,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0. /)
err_v = (/ 0.00, 0.08,0.20,0.48,0.54,0.64,0.81,0.91,0.94,0.98,1.07,1.12,1.15,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0. /)
err_V = sqrt(err_u^2.0+err_v^2.0)
u_comp = (/ 10.04,11.57,13.23,15.14,15.72,15.92,16.48,16.74,16.92,17.11,17.28,17.42,17.50,17.56,17.69,17.82,17.97,18.13,18.28,18.40,18.50,18.32,17.91,17.81,17.81 /)
v_comp = (/ 0.00,0.24,0.98,2.21,2.36,2.62,2.76,2.95,3.08,3.25,3.50,3.75,3.97,4.18,4.45,4.76,5.13,5.47,5.87,6.29,6.67,7.13,7.27,7.83,8.20/)
;Datos de peña
pena_uu = (/ 9.7752808989 ,10.2247191011 ,11.3483146067 ,11.797752809 ,12.5842696629 ,13.0337078652 ,13.4831460674 ,14.1573033708 ,15.0561797753 ,15.393258427 ,15.7303370787 ,16.0674157303 ,16.2921348315 ,16.404494382 ,16.7415730337 ,17.3033707865 ,17.4157303371 ,17.7528089888 ,17.8651685393 ,17.9775280899 ,17.7528089888 /)
pena_uz = (/ 14.3345103633 ,18.933206259 ,36.4381772615 ,44.7106047001 ,71.8706529138 ,86.0484440533 ,114.587826257 ,162.917293953 ,266.205207228 ,334.759502503 ,431.431398743 ,546.993634458 ,628.64132079 ,699.208906389 ,771.359483498 ,938.764302558 ,994.112783686 ,1096.69415872 ,1190.21957895 ,1250.12092875 ,1291.72079093 /)
pena_uz = pena_uz/delta

pena_vv = (/ 1.5088757396 ,1.6272189349 ,1.6272189349 ,1.8639053254 ,1.9822485207 ,2.2189349112 ,2.3372781065 ,2.573964497 ,2.8106508876 ,3.0473372781 ,3.5207100592 ,3.5207100592 ,3.875739645 ,4.4674556213 ,4.5857988166 ,5.8875739645 ,7.899408284,8.1360946746 ,8.3727810651 /)
pena_vz = (/ 14.2176790742 ,19.0887865674 ,26.051710847 ,39.5456031683 ,58.5730300079 ,97.2871231918 ,137.192355393 ,213.429445017 ,323.978574254 ,468.223609721 ,660.279570006 ,704.954533188 ,765.072633055 ,915.997100251 ,962.097386026 ,1061.37512835 ,1239.93200455 ,1250.12092875 ,1302.33528042 /)
pena_vz = pena_vz/delta

pena_UU = (/ 9.962406015 ,10.4135338346 ,11.3157894737 ,11.992481203 ,12.7819548872 ,13.4586466165 ,14.1353383459 ,14.6992481203 ,15.1503759398 ,15.6015037594 ,16.0526315789 ,16.3909774436 ,16.7293233083 ,16.8421052632 ,17.5187969925 ,17.969924812 ,18.6466165414 ,19.4360902256 ,20.0 ,20.0 ,19.7744360902 /)
pena_Uz = (/ 14.2176790742 ,18.4740322831 ,29.6963275501 ,44.3461975838 ,65.1480946309 ,94.1539918335 ,133.865123944 ,169.721932355 ,215.183264122 ,281.900365052 ,375.397259157 ,468.223609721 ,608.395929925 ,693.510108466 ,810.180449869 ,938.764302558 ,1044.14447419 ,1180.51887176 ,1229.82612364 ,1260.39357866 ,1291.72079093 /)
pena_Uz = pena_Uz/delta

;Ubicación del punto de control en las coordenadas del modelo (mass points)
loc         = wrf_user_ll_to_ij(a[0], 8.1509, 56.4406, True)
locX        = loc(0)
locY        = loc(1)
print(locX+" , "+locY)
if ( locX .lt. 1 .or. locX .gt. dimX .or. locY .lt. 1 .or. locY .gt. dimY )
    print("Fuera de dominio")
else 
    locX      = locX - 1
    locY      = locY - 1
    ;Almacenamiento de la altura del terreno
    ter       = wrf_user_getvar(a[0],"HGT",0)
    hgt_point = ter(locX,locY)
    ;LOOP POR CADA GRÁFICO DEL PROMEDIO MOVIL
    ;Obtención de Datos
    do ii = 0,X-1,1 ;Loop por por cada gráfico
        ;ii = 36
        print("        Obteniendo datos para gráfico "+(ii+1)+":")
        n_inicial = ii ;índice del archivo inicial
        n_final   = n_inicial + (N-1);índice del archivo final
        system("printf '            '")
        ;ii = 0
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
            uv10m       = wrf_user_getvar(a[it],"uvmet10",0) ;lo mismo pero en 10m
            u_data      = uvm(0,:,:,:) 
            v_data      = uvm(1,:,:,:)
            u10_data    = uv10m(0,:,:) 
            v10_data    = uv10m(1,:,:) 
            ;loop por los niveles
            u10(ii) = u10(ii) + u10_data(locX,locY)
            v10(ii) = v10(ii) + v10_data(locX,locY)
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
        u10(ii)     = u10(ii)/N
        v10(ii)     = v10(ii)/N
    end do
    ;las matrices u,v,z contienen la información de los acrhivos promediadas en cada hora móvil
    ;Rotación de la velocidad para tener v=0 en la altura a 10m
    magV= sqrt(u10^2.0+v10^2.0)
    cos_theta = u10/magV
    sin_theta = v10/magV

    cos_theta = -0.965
    sin_theta = sqrt(1.0-cos_theta^2)
    ;print("cos: "+cos_theta)
    ;print("sin: "+sin_theta)
    ;Rotación de vectores por cada gráfico
    do ii = 0,X-1,1
        u_rot(ii,:) = u(ii,:)*cos_theta(ii) + v(ii,:)*sin_theta(ii)
        v_rot(ii,:) = v(ii,:)*cos_theta(ii) - u(ii,:)*sin_theta(ii)
    end do
end if
;Definición de propiedades generales de los gráficos
gsn_define_colormap(wks_u,"MPL_viridis")
gsn_define_colormap(wks_v,"MPL_viridis")
gsn_define_colormap(wks_U,"MPL_viridis")
res                         = True
res@vpWidthF                = 0.3  
res@vpHeightF               = 0.6
res@gsnMaximize             = True      
;res@xyMonoLineThickness     = True
;res@xyLineThicknessF        = 3.0
res@xyLineThicknesses       = 8.0
res@xyMarkLineModes         = "Lines"          
res@xyMarkers               = 16
res@xyMarkerSizeF           = 0.01
res@tiMainFontHeightF       = 0.018
res@tiXAxisFontHeightF      = 0.018
res@tiYAxisFontHeightF      = 0.018
res@tmXBLabelFontHeightF    = 0.014
res@tmYLLabelFontHeightF    = 0.014
res@tmXBMajorOutwardLengthF = 0.0
res@tmXBMinorOutwardLengthF = 0.0
res@tmYLMajorOutwardLengthF = 0.0
res@tmYLMinorOutwardLengthF = 0.0
res@tmXMajorGrid            = True
res@tmYMajorGrid            = True
res@tmYMajorGridLineColor   = "Gray"
res@tmXMajorGridLineColor   = "Gray"
res@tmGridDrawOrder         = "PreDraw"
;res@xyYStyle                = "Log"
;res@trYMinF                    = 1.
print("        Creando gráficos...")
res2                         = True
res2@xyMarkLineModes         = "Markers"                
res2@xyMarkers               = 16
res2@xyMarkerSizeF           = 0.01
res2@xyMarkerColor           = 10
res3                         = True
res3@xyLineThicknessF  = 6.0
res3@xyDashPattern     = 2
res3@xyLineColor       = 150;"red3"
res@gsnDraw  = False
res@gsnFrame = False
res2@gsnDraw  = False
res2@gsnFrame = False
res3@gsnDraw  = False
res3@gsnFrame = False
gsresx = True                                          ; add x error bars
gsresx@gsLineColor      = 10
gsresx@gsLineThicknessF = 3.0

;Gráfico u
res@tiXAxisString = "u (m/s)"
res@tiYAxisString = "z/~F33~d~N~ (-)"
res@xyMarkerColor = 50;((3*253)/4)
res@xyLineColor   = 210;((3*253)/4)

;Escalamiento por la capa límite delta
z = z/delta
z_comp = z_comp/delta
;ii=1
do ii=0,X-1,1 ;Paso por cada promedio horario
    res@tiMainString = "Mean profile from "+titulos(ii)+" to "+titulos(ii+(N-1))
    plot             = gsn_csm_xy(wks_u, u_rot(ii,:), z(ii,:), res)
    plot3            = gsn_csm_xy(wks_u, pena_uu, pena_uz, res3)
    overlay(plot, plot3)
    plot2            = gsn_csm_xy(wks_u, u_comp, z_comp, res2)
    overlay(plot, plot2)
    add_x_errorbar(wks_u, plot, u_comp, z_comp, err_u, gsresx)
    draw(plot)
    frame(wks_u)

end do
;Gráfico v
res@tiXAxisString = "v (m/s)"
res@tiYAxisString = "z/~F33~d~N~ (-)"
res@xyMarkerColor = ((3*253)/4)
res@xyLineColor   = 210;((3*253)/4)
do ii=0,X-1,1 ;Paso por cada promedio horario
    res@tiMainString = "Mean profile from "+titulos(ii)+" to "+titulos(ii+(N-1))
    plot             = gsn_csm_xy(wks_v, abs(v_rot(ii,:)), z(ii,:), res)
    plot3            = gsn_csm_xy(wks_v, pena_vv, pena_vz, res3)
    overlay(plot, plot3)
    plot2            = gsn_csm_xy(wks_v, v_comp, z_comp, res2)
    overlay(plot, plot2)
    add_x_errorbar(wks_v, plot, v_comp, z_comp, err_v, gsresx)
    draw(plot)
    frame(wks_v)
end do

;Gráfico V
res@tiXAxisString = "V (m/s)"
res@tiYAxisString = "z/~F33~d~N~ (-)"
res@xyMarkerColor = ((3*253)/4)
res@xyLineColor   = 210;((3*253)/4)
do ii=0,X-1,1 ;Paso por cada promedio horario
    res@tiMainString = "Mean profile from "+titulos(ii)+" to "+titulos(ii+(N-1))
    plot             = gsn_csm_xy(wks_U, sqrt(u_rot(ii,:)^2.0+v_rot(ii,:)^2.0), z(ii,:), res)
    plot3            = gsn_csm_xy(wks_U, pena_UU, pena_Uz, res3)
    overlay(plot, plot3)
    plot2            = gsn_csm_xy(wks_U, sqrt(u_comp^2.0+v_comp^2.0), z_comp, res2)
    overlay(plot, plot2)
    add_x_errorbar(wks_U, plot, sqrt(u_comp^2.0+v_comp^2.0), z_comp, err_V, gsresx)
    draw(plot)
    frame(wks_U)
end do

end