load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/skewt_func.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
begin
;Lectura de datos
DATADir     = "../"
FILES       = systemfunc("ls -1 " + DATADir + "wrfout_d06_*")
numFILES    = dimsizes(FILES)
a           = addfiles(FILES,"r")
times       = wrf_user_getvar(a,"times",-1)
ntimes      = dimsizes(times)
;Dimensiones del dominio
mdims       = getfilevardimsizes(a[0],"P")
nd          = dimsizes(mdims)
dimZ        = mdims(nd-3)
dimX        = mdims(nd-1)
dimY        = mdims(nd-2)
maxn        = 10;dimZ - 1
;Creación del entorno
wks         = gsn_open_wks("pdf","perfil_medio")
;Manipulación de la información
;Ubicación del punto para el perfil
dataLON     = (/ -71.716,   -71.708,    -71.730,    -71.704 /)
dataLAT     = (/ -33.103,   -33.115,    -33.110,    -33.104 /)
do ii = 0,3,1
    loc         = wrf_user_ll_to_ij(a[0], dataLON(ii), dataLAT(ii), True)
    locX        = loc(0)
    locY        = loc(1)
    hgt         = wrf_user_getvar(a[0], "HGT",0)
    if ( locX .lt. 1 .or. locX .gt. dimX .or. locY .lt. 1 .or. locY .gt. dimY )
        print("Fuera de dominio")
    else 
        locX    = locX - 1
        locY    = locY - 1
    end if
    ;Creación de Arreglos
    sumuv       = new(dimZ,float)
    sumuv(:)    = 0.0
    levels      = new(dimZ,float)
    promZ       = new(dimZ,float)

    ;Loop por los Eta levels
    zz         = wrf_user_getvar(a[0],"z",0)
    promx      = new(dimY,float)
    promx(:)   = 0.0
    promy      = new(1,float)
    promy      = 0.0
    promtot    = new(dimZ,float)
    promtot(:) = 0.0
    do i = 0,dimZ-1,1
        levels(i)       = i + 1
        auxzz           = zz(i,:,:) - hgt(:,:)
        do j = 0,dimX-1,1
            promx       = promx + auxzz(j,:)
        end do
        do k = 0,dimY-1,1
            promy       = promy + promx(k)
        end do
        promtot(i)      = promy/(dimX*dimY)
        ;Reinicio de Promedios
        promx(:)        = 0.0
        promy           = 0.0
    end do
    ;Loop por los archivos
    do it = 0,ntimes-1,1
        print("Working on time: " + times(it) )
        z           = wrf_user_getvar(a[it],"z",0)
        auxz        = z(:,locX,locY) - hgt(locX,locY)
        uvm         = wrf_user_getvar(a[it],"uvmet",0)
        u           = uvm(0,:,:,:) 
        v           = uvm(1,:,:,:)
        uv          = sqrt(u(:,locX,locY)^2+v(:,locX,locY)^2)
        sumuv       = sumuv + uv
    end do
    ;Config Gráficos
    res                     = True
    res@xyMarkLineModes     = "Markers"                
    res@xyMarkers           =  16                       
    res@xyMarkerColor       = "red"                    
    res@xyMarkerSizeF       = 0.01
    res@tmYMajorGrid        = True
    res@tmXMajorGrid        = True
    res@tmYRBorderOn        = False
    res@tmXTBorderOn        = False
    res@tmYROn              = False
    res@tmYUseLeft          = False
    res@tmXTOn              = False
    res@tmXUseBottom        = False
    res@xyYStyle            = "Log"
    res@tiXAxisString       = "Vertical Node"
    res@tiYAxisString       = "Height [m]"
    res@tiMainString        = "Vertical Mesh Distribution for Profile"
    ;res@gsnXAxisIrregular2Log = True
    ;Perfil medio
    sumuv   = sumuv/(ntimes)
    res1                    = True
    res1@trXMaxF = 10
    res1@trXMinF = 5
    res1@tiYAxisString  = "z [m]"
    res1@tiXAxisString  = "Wind Speed [m/s]"
    res1@tiMainString       = "Wind Profile for ("+dataLAT(ii)+", "+dataLON(ii)+")"
    plot    = gsn_csm_xy(wks,sumuv(0:maxn-1),auxz(0:maxn-1),res1)
    ;Eta Levels           
    plot    = gsn_csm_xy(wks, levels, auxz, res)
end do
res@tiMainString        = "MeanVertical Mesh Distribution"
res@xyMarkerColor       = "blue"                    
plot    = gsn_csm_xy(wks, levels, promtot, res)
end