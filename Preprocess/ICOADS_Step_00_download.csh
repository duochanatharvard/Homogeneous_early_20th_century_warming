#!/bin/csh

#################################################################
# Csh Script to retrieve 26 online Data files of 'ds548.0',
# total 29.92G. This script uses 'wget' to download data.
#
# Highlight this script by Select All, Copy and Paste it into a file;
# make the file executable and run it on command line.
#
# You need pass in your password as a parameter to execute
# this script; or you can set an environment variable RDAPSWD
# if your Operating System supports it.
#
# Contact zji@ucar.edu (Zaihua Ji) for further assistance.
#################################################################

set pswd = 101atChrisyatRDA
if(x$pswd == x && `env | grep RDAPSWD` != '') then
 set pswd = $RDAPSWD
endif
if(x$pswd == x) then
 echo
 echo Usage: $0 YourPassword
 echo
 exit 1
endif
set v = `wget -V |grep 'GNU Wget ' | cut -d ' ' -f 3`
set a = `echo $v | cut -d '.' -f 1`
set b = `echo $v | cut -d '.' -f 2`
if(100 * $a + $b > 109) then
 set opt = 'wget --no-check-certificate'
else
 set opt = 'wget'
endif
set opt1 = '-O Authentication.log --save-cookies auth.rda_ucar_edu --post-data'
set opt2 = "email=duochan@g.harvard.edu&passwd=$pswd&action=login"
$opt $opt1="$opt2" https://rda.ucar.edu/cgi-bin/login
set opt1 = "-N --load-cookies auth.rda_ucar_edu"
set opt2 = "$opt $opt1 http://rda.ucar.edu/data/ds548.0/"
set filelist = ( \
imma1_r3.0.0/IMMA1_R3.0.0_1662-1799.tar \
imma1_r3.0.0/IMMA1_R3.0.0_1800-1849.tar \
imma1_r3.0.0/IMMA1_R3.0.0_1850-1899.tar \
imma1_r3.0.0/IMMA1_R3.0.0_1900-1929.tar \
imma1_r3.0.0/IMMA1_R3.0.0_1930-1949.tar \
imma1_r3.0.0/IMMA1_R3.0.0_1950-1959.tar \
imma1_r3.0.0/IMMA1_R3.0.0_1960-1969.tar \
imma1_r3.0.0/IMMA1_R3.0.0_1970-1974.tar \
imma1_r3.0.0/IMMA1_R3.0.0_1975-1979.tar \
imma1_r3.0.0/IMMA1_R3.0.0_1980-1984.tar \
imma1_r3.0.0/IMMA1_R3.0.0_1985-1989.tar \
imma1_r3.0.0/IMMA1_R3.0.0_1990-1994.tar \
imma1_r3.0.0/IMMA1_R3.0.0_1995-1997.tar \
imma1_r3.0.0/IMMA1_R3.0.0_1998-2000.tar \
imma1_r3.0.0/IMMA1_R3.0.0_2001-2002.tar \
imma1_r3.0.0/IMMA1_R3.0.0_2003-2004.tar \
imma1_r3.0.0/IMMA1_R3.0.0_2005.tar \
imma1_r3.0.0/IMMA1_R3.0.0_2006.tar \
imma1_r3.0.0/IMMA1_R3.0.0_2007.tar \
imma1_r3.0.0/IMMA1_R3.0.0_2008.tar \
imma1_r3.0.0/IMMA1_R3.0.0_2009.tar \
imma1_r3.0.0/IMMA1_R3.0.0_2010.tar \
imma1_r3.0.0/IMMA1_R3.0.0_2011.tar \
imma1_r3.0.0/IMMA1_R3.0.0_2012.tar \
imma1_r3.0.0/IMMA1_R3.0.0_2013.tar \
imma1_r3.0.0/IMMA1_R3.0.0_2014.tar \
)
while($#filelist > 0)
set syscmd = "$opt2$filelist[1]"
echo "$syscmd ..."
$syscmd
shift filelist
end

rm -f auth.rda_ucar_edu Authentication.log
exit 0
