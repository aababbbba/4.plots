;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; Código hecho por Pablo Andrés Cárdenas Zamorano - UTFSM - 2019 ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Calcula el RMSE y MAE en los puntos de medición según la serie de tiempo experimental (cada 10m)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Carga de datos 
data_simu = readAsciiTable("main/data_interpol_simu.txt", 7, "float", 37)
data_real = readAsciiTable("main/data_interpol_med.txt", 7, "float", 37)
print(data_simu(:,0))
;Cálculo de RMSE
rmse = sqrt(sum((data_simu(:,1:) - data_real(:,1:))^2.0)/(6.0*48.0))
print("RMSE  =  "+rmse+" m/s")

;Cálculo del MAE
abs_error = sum(abs(data_simu(:,1:) - data_real(:,1:)))/(6.0*48.0)
print("MAE   =  "+abs_error+" m/s")