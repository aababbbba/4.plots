#!/bin/bash
convert -delay 10 -loop 0 eta1/V/*.png eta1_vel.gif
convert -delay 10 -loop 0 cross/*.png cross.gif
convert -delay 10 -loop 0 st/*.png eta1_st.gif
convert -delay 10 -loop 0 vec/*.png vec.gif