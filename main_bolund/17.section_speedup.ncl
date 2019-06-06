;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; Código hecho por Pablo Andrés Cárdenas Zamorano - UTFSM - 2019 ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Grafica el speedup en la sección en corte a 240°
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Carga de paquetes
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
begin
;Información de la carpeta contenedora
DATADir                     = "../"
FILES                       = systemfunc (" ls -1 " + DATADir + "wrfout_d08_*")
numFILES                    = dimsizes(FILES)
;Inicialización del gráfico
type                        = "pdf"
wks                         = gsn_open_wks(type,"speedup")
;Almacenamiento de los archivos a plotear 
a                           = addfiles(FILES,"r")
;Obtención de pasos de tiempo para los archivos
times                       = wrf_user_getvar(a, "times", -1)
ntimes                      = dimsizes(times)
;Dimensiones del corte
start_lat       = 55.70313
end_lat         = 55.70442
start_lon       = 12.09700
end_lon         = 12.10100
opt                       = True
opt@latlon                = True
opt@linecoords            = True
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
;Datos de comparación
U1 = 5.120095
U2 = 5.619566
U3 = 6.064954
;caracteristicas del gráfico
res                       = True
res@gsnMaximize           = True
res@vpWidthF              = 0.6  
res@vpHeightF             = 0.15*0.533333*1.5
res@tiMainString          = "Corte Transversal M1-M4"
res@tiMainFontHeightF     = 0.012
res@gsnStringFontHeightF  = 0.008
res@tmXBLabelFontHeightF  = 0.007
res@tmYLLabelFontHeightF  = 0.008
;res@tmXBLabelAngleF       = 45.
res@tmXBMode              = "Explicit"
res@tmYLMode              = "Explicit"
ll_step                   = 15
gsn_define_colormap(wks,"MPL_viridis")
;res@tmXBMajorOutwardLengthF = 0.0
res@tmXBMinorOutwardLengthF = 0.0
res@tmYLMajorOutwardLengthF = 0.0
res@tmYLMinorOutwardLengthF = -0.01
res@tmXMajorGrid            = True
;res@tmYMinorGrid            = True
res@tmYMajorGrid            = True
res@tmYMajorGridLineColor   = "Gray"
res@tmXMajorGridLineColor   = "Gray"
res@gsnDraw                     = False
res@gsnFrame                    = False
res@tmGridDrawOrder             = "PreDraw"
res@trXMaxF                     = 104
res@xyLineThicknessF    = 5.0
res@tiYAxisString       = "~F33~D~N~~F~S"
res@tiYAxisFontHeightF      = 0.01
res@trYMaxF                     = 1.0
res@trYMinF                     = -1.0
res@tmYLValues        = (/-1.0,-0.5,0,0.5,1 /)
res@tmYLLabels        = sprintf("%4.1f",(/-1.0,-0.5,0,0.5,1 /))

res3 = True
res3@xyMarkerSizes     = 0.01
res3@xyMarkers         = 0
res3@xyMarkLineModes   = "Markers"
res3@xyMarkerColors    = "darkolivegreen3"
res3@gsnDraw  = False
res3@gsnFrame = False

res2 = True
res2@xyMarkerSizes     = 0.01
res2@xyMarkers         = 0
res2@xyMarkLineModes   = "Markers"
res2@xyMarkerColors    = "darkslateblue"
res2@gsnDraw  = False
res2@gsnFrame = False
;ITERACION
do it = 72,ntimes-1,1
;it = ntimes-1
    ;Comienzo de creación de gráficos
    print("     Graficando en tiempo: " + times(it))
    xlat = wrf_user_getvar(a[it], "XLAT",0)
    xlon = wrf_user_getvar(a[it], "XLONG",0)
    uvm                     = wrf_user_getvar(a[it],"uvmet",0)
    u                       = uvm(0,:,:,:) 
    v                       = uvm(1,:,:,:)
    mag                     = sqrt(u^2 + v^2)
    opt@file_handle = a[it]
    lat_plane = wrf_user_interp_line(xlat,(/start_lon,start_lat,end_lon,end_lat/),opt)
    lon_plane = wrf_user_interp_line(xlon,(/start_lon,start_lat,end_lon,end_lat/),opt)
    u1_plane   = wrf_user_interp_line(mag(0,:,:),(/start_lon,start_lat,end_lon,end_lat/),opt)
    u2_plane   = wrf_user_interp_line(mag(1,:,:),(/start_lon,start_lat,end_lon,end_lat/),opt)
    u3_plane   = wrf_user_interp_line(mag(2,:,:),(/start_lon,start_lat,end_lon,end_lat/),opt)
    xvalues = ispan(0,dimsizes(u1_plane(:))-1,1)
    res@tmXBValues        = xvalues(::ll_step)
    res@tmXBLabels        = sprintf("%8.4f",u1_plane@lats(::ll_step)) + "~S~o~N~N~C~" + sprintf("%8.4f",u1_plane@lons(::ll_step)) + "~S~o~N~E"
    res@tiMainString          = "Speedup en z1,z2,z3. "+titulos(it)
    res@xyLineColor         = 40
    xy_plot = gsn_csm_y(wks,((u1_plane-U1)/U1),res)
    res@xyLineColor         = 145
    xy_plot2 = gsn_csm_y(wks,((u2_plane-U2)/U2),res)
    res@xyLineColor         = 250
    xy_plot3 = gsn_csm_y(wks,((u3_plane-U3)/U3),res)
    overlay(xy_plot,xy_plot2)
    overlay(xy_plot,xy_plot3)

    ;M1
    plotm1a = gsn_csm_xy(wks,(/14.5,14.5/),(/-0.35,-0.35/),res3);5m
    overlay(xy_plot,plotm1a)
    plotm1b = gsn_csm_xy(wks,(/14.5,14.5/),(/-0.55,-0.55/),res2) ;2m
    overlay(xy_plot,plotm1b)

    ;M2
    plotm2a = gsn_csm_xy(wks,(/23,23/),(/0.27,0.27/),res3);5m
    overlay(xy_plot,plotm2a)
    plotm2b = gsn_csm_xy(wks,(/23,23/),(/-0.08,-0.08/),res2) ;2m
    overlay(xy_plot,plotm2b)

    ;M3
    plotm3a = gsn_csm_xy(wks,(/39,39/),(/0.0,0.0/),res3);5m
    overlay(xy_plot,plotm3a)
    plotm3b = gsn_csm_xy(wks,(/39,39/),(/-0.12,-0.12/),res2) ;2m
    overlay(xy_plot,plotm3b)

    ;M4
    plotm4a = gsn_csm_xy(wks,(/59,59/),(/-0.54,-0.54/),res3);5m
    overlay(xy_plot,plotm4a)
    plotm4b = gsn_csm_xy(wks,(/59,59/),(/-0.2,-0.2/),res2) ;2m
    overlay(xy_plot,plotm4b)

    draw(xy_plot)
    frame(wks)
end do
end