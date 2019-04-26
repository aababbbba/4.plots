#!/bin/bash
rm -r data/
rm -r plots/

mkdir data
mkdir plots

cd data/
mkdir raw
mkdir fft
mkdir mean
cd raw
mkdir eta01
mkdir eta02
mkdir eta03
mkdir eta04
mkdir eta05
cd ../
cd fft/
mkdir eta01
mkdir eta02
mkdir eta03
mkdir eta04
mkdir eta05
cd ../
cd mean/
mkdir eta01
mkdir eta02
mkdir eta03
mkdir eta04
mkdir eta05
cd ../../