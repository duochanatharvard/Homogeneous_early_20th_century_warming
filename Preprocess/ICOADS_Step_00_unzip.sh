#!/bin/sh
cd /n/home10/dchan/holy_kuang/ICOADS3/ICOADS_00_raw_zip
pwd
ls
#for f in ( *.tar ); do tar -xfv $f; done
for f in *.tar;
do
    echo $f
    tar -xvf $f;
done

mv *.gz /n/home10/dchan/holy_kuang/ICOADS3/ICOADS_00_raw
cd ../ICOADS_00_raw
gunzip *.gz
touch *
