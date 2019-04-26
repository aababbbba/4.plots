#!/bin/bash
sed -i 's/mast = "8"/mast = "1"/g' main/07.ts_plot.ncl
ncl main/07.ts_plot.ncl
sed -i 's/mast = "1"/mast = "2"/g' main/07.ts_plot.ncl
ncl main/07.ts_plot.ncl
sed -i 's/mast = "2"/mast = "3"/g' main/07.ts_plot.ncl
ncl main/07.ts_plot.ncl
sed -i 's/mast = "3"/mast = "4"/g' main/07.ts_plot.ncl
ncl main/07.ts_plot.ncl
sed -i 's/mast = "4"/mast = "5"/g' main/07.ts_plot.ncl
ncl main/07.ts_plot.ncl
sed -i 's/mast = "5"/mast = "6"/g' main/07.ts_plot.ncl
ncl main/07.ts_plot.ncl
sed -i 's/mast = "6"/mast = "7"/g' main/07.ts_plot.ncl
ncl main/07.ts_plot.ncl
sed -i 's/mast = "7"/mast = "8"/g' main/07.ts_plot.ncl
ncl main/07.ts_plot.ncl
