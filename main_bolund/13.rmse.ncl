;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; Código hecho por Pablo Andrés Cárdenas Zamorano - UTFSM - 2019 ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Calcula el RMSE y MAE en los puntos de medición según la serie de tiempo experimental (cada 10m)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
begin
;Carga de datos 
data_simu = readAsciiTable("main/data_simu.txt", 41, "float", 0)
data_real = readAsciiTable("main/data_med.txt", 41, "float", 0)

;filtro de la tabla 
aux_simu = new((/18,22/),float)
aux_real = new((/18,22/),float)
aux_simu = 0.0
aux_real = 0.0

aux_simu(:,0:2)=data_simu(:,1:3);M1 
aux_simu(:,3:5)=data_simu(:,7:9);M2 
aux_simu(:,6:8)=data_simu(:,12:14);M3 
aux_simu(:,9:11)=data_simu(:,17:19);M4
aux_simu(:,12:13)=data_simu(:,23:24);M5
aux_simu(:,14:16)=data_simu(:,27:29);M6
aux_simu(:,17:18)=data_simu(:,32:33);M7
aux_simu(:,19:21)=data_simu(:,36:38);M8

aux_real(:,0:2)=data_real(:,1:3);M1 
aux_real(:,3:5)=data_real(:,7:9);M2 
aux_real(:,6:8)=data_real(:,12:14);M3 
aux_real(:,9:11)=data_real(:,17:19);M4
aux_real(:,12:13)=data_real(:,23:24);M5
aux_real(:,14:16)=data_real(:,27:29);M6
aux_real(:,17:18)=data_real(:,32:33);M7
aux_real(:,19:21)=data_real(:,36:38);M8

;Cálculo de RMSE
rmse = sqrt(sum((aux_simu(:,:)-aux_real(:,:))^2.0)/(22.0*18.0))
print("RMSE  =  "+rmse+" m/s")

;Cálculo del MAE
abs_error = sum(abs(aux_simu(:,:)-aux_real(:,:)))/(22.0*18.0)
print("MAE   =  "+abs_error+" m/s")

end