#!/bin/bash
pdftk  ts_interpol_compare.pdf cat 1-endwest output ts_interpol_compare_rot.pdf
pdftk  ts_interpol_compare_o.pdf cat 1-endwest output ts_interpol_compare_o_rot.pdf