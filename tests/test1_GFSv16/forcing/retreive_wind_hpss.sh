#!/bin/bash
module load intel netcdf nco cdo hpss wgrib2
CDO=/apps/cdo/1.9.10/gnu/1.9.10/bin/cdo

FIXwave=/scratch1/NCEPDEV/global/glopara/fix_nco_gfsv16/fix_wave_gfs/
GLBDUMP=/scratch1/NCEPDEV/global/glopara/dump
WGRIB2=/apps/wgrib2/2.0.8/intel/18.0.3.222/bin/wgrib2

STARTDATE="2021-04-01"
ENDDATE="2021-04-02"

start=$(date -d $STARTDATE +%s)
end=$(date -d $ENDDATE +%s)


#-----------------------------------------------------------------------------------#
#                                        WIND (hourly)                              #
#-----------------------------------------------------------------------------------#

  echo ' '                                                                 
  echo '       *****************************************************************'     
  echo "      ***                     Wind Forcing Prep                        ***"
  echo '       *****************************************************************'    
  echo ' ' 



d="$start"
echo "start date: $(date -d @$start '+%Y-%m-%d %2H')"
echo "end date: $(date -d @$end '+%Y-%m-%d %2H')"
while [[ $d -le $end ]]
do
date -d @$d '+%Y-%m-%d %2H'
    YY=$(date -d @$d '+%Y')
    MM=$(date -d @$d '+%m')
    DD=$(date -d @$d '+%d')
    HH=$(date -d @$d '+%2H')
#-----------------------------------------------------------------------------------#
#FILEWAVE=(/NCEPPROD/hpssprod/runhistory/rh$YY/$YY$MM/$YY$MM$DD/com_gfs_prod_gdas.${YY}${MM}${DD}_${HH}.gdaswave_output.tar)
FILEWAVE=(/NCEPPROD/hpssprod/runhistory/rh$YY/$YY$MM/$YY$MM$DD/com_gfs_prod_gfs.${YY}${MM}${DD}_${HH}.gfswave_output.tar)
aoc=./gfs.$YY$MM$DD/${HH}/wave/gridded/gfswave.t${HH}z.arctic.9km.f00
gnh=./gfs.$YY$MM$DD/${HH}/wave/gridded/gfswave.t${HH}z.global.0p16.f00
gsh=./gfs.$YY$MM$DD/${HH}/wave/gridded/gfswave.t${HH}z.gsouth.0p25.f00
glo=./gfs.$YY$MM$DD/${HH}/wave/gridded/gfswave.t${HH}z.global.0p25.f00

if [ ! -d ./gfs.$YY$MM$DD ]
then
htar -xvf $FILEWAVE ${aoc}0.grib2 ${aoc}1.grib2 ${aoc}2.grib2 ${aoc}3.grib2 ${aoc}4.grib2 ${aoc}5.grib2 ${gnh}0.grib2 ${gnh}1.grib2 ${gnh}2.grib2 ${gnh}3.grib2 ${gnh}4.grib2 ${gnh}5.grib2 ${gsh}0.grib2 ${gsh}1.grib2 ${gsh}2.grib2 ${gsh}3.grib2 ${gsh}4.grib2 ${gsh}5.grib2 ${glo}0.grib2 ${glo}1.grib2 ${glo}2.grib2 ${glo}3.grib2 ${glo}4.grib2 ${glo}5.grib2
fi
#-----------------------------------------------------------------------------------#
# convert grib2 to netcdf
grib2_list=`( ls gfs.$YY$MM$DD/${HH}/wave/gridded )`
echo $grib2_list
for file in $grib2_list
  do
  $WGRIB2 gfs.$YY$MM$DD/${HH}/wave/gridded/$file -netcdf gfs.$YY$MM$DD/${HH}/wave/gridded/$file.nc -nc4
echo $file
done
#-----------------------------------------------------------------------------------#
if [ $d == $start ]; then
#Append netcdf files
ncrcat -h ${aoc}0.grib2.nc ${aoc}1.grib2.nc ${aoc}2.grib2.nc ${aoc}3.grib2.nc ${aoc}4.grib2.nc ${aoc}5.grib2.nc aoc_wnd.nc
ncrcat -h ${gnh}0.grib2.nc ${gnh}1.grib2.nc ${gnh}2.grib2.nc ${gnh}3.grib2.nc ${gnh}4.grib2.nc ${gnh}5.grib2.nc gnh_wnd.nc
ncrcat -h ${gsh}0.grib2.nc ${gsh}1.grib2.nc ${gsh}2.grib2.nc ${gsh}3.grib2.nc ${gsh}4.grib2.nc ${gsh}5.grib2.nc gsh_wnd.nc
ncrcat -h ${glo}0.grib2.nc ${glo}1.grib2.nc ${glo}2.grib2.nc ${glo}3.grib2.nc ${glo}4.grib2.nc ${glo}5.grib2.nc glo_wnd.nc
else
mv aoc_wnd.nc aoc_wnd_tmp.nc
mv gnh_wnd.nc gnh_wnd_tmp.nc
mv gsh_wnd.nc gsh_wnd_tmp.nc
mv glo_wnd.nc glo_wnd_tmp.nc
ncrcat -h  aoc_wnd_tmp.nc ${aoc}0.grib2.nc ${aoc}1.grib2.nc ${aoc}2.grib2.nc ${aoc}3.grib2.nc ${aoc}4.grib2.nc ${aoc}5.grib2.nc aoc_wnd.nc
ncrcat -h  gnh_wnd_tmp.nc ${gnh}0.grib2.nc ${gnh}1.grib2.nc ${gnh}2.grib2.nc ${gnh}3.grib2.nc ${gnh}4.grib2.nc ${gnh}5.grib2.nc gnh_wnd.nc
ncrcat -h  gsh_wnd_tmp.nc ${gsh}0.grib2.nc ${gsh}1.grib2.nc ${gsh}2.grib2.nc ${gsh}3.grib2.nc ${gsh}4.grib2.nc ${gsh}5.grib2.nc gsh_wnd.nc
ncrcat -h  glo_wnd_tmp.nc ${glo}0.grib2.nc ${glo}1.grib2.nc ${glo}2.grib2.nc ${glo}3.grib2.nc ${glo}4.grib2.nc ${glo}5.grib2.nc glo_wnd.nc
fi

    d=$(( $d + 21600 ))
done

rm *tmp aoc_wnd_tmp.nc gnh_wnd_tmp.nc gsh_wnd_tmp.nc glo_wnd_tmp.nc
  echo '       *****************************************************************' 
  echo "aoc_wnd.nc, gnh_wnd.nc, gsh_wnd.nc, glo_wnd.nc prepared"
  echo ' '                                                                 
  echo '       *****************************************************************'     
  echo "     ***                            done                               ***"
  echo '       *****************************************************************'    
  echo ' '  
