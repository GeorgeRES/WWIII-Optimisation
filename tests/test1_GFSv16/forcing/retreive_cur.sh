#!/bin/bash
module load intel netcdf nco cdo hpss
CDO=/apps/cdo/1.9.10/gnu/1.9.10/bin/cdo

FIXwave=/scratch1/NCEPDEV/global/glopara/fix_nco_gfsv16/fix_wave_gfs/
GLBDUMP=/scratch1/NCEPDEV/global/glopara/dump

STARTDATE="2021-04-01"
ENDDATE="2021-04-02"

start=$(date -d $STARTDATE +%s)
end=$(date -d $ENDDATE +%s)


#-----------------------------------------------------------------------------------#
#                                       CURRENT (hourly)                            #
#-----------------------------------------------------------------------------------#

  echo ' '                                                                 
  echo '       *****************************************************************'     
  echo "      ***                  CURRENT Forcing Prep                        ***"
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
# HPSS retreival
# for current, the data is retreivied from global dump (daily)
#    FILECUR1=(/NCEPPROD/5year/hpssprod/runhistory/rh$YY/$YY$MM/$YY$MM$DD/com_rtofs_prod_rtofs.${YY}${MM}${DD}.ab.tar)
#    FILECUR2=(/NCEPPROD/5year/hpssprod/runhistory/rh$YY/$YY$MM/$YY$MM$DD/com_rtofs_prod_rtofs.${YY}${MM}${DD}.ncoda.tar)
#-----------------------------------------------------------------------------------#
# source from global dump
  cp $GLBDUMP/rtofs.$YY$MM$DD/rtofs_glo_2ds_f0${HH}_prog.nc ./rtofs_$YY$MM$DD${HH}_prog.nc

cp rtofs_$YY$MM$DD${HH}_prog.nc cur_$YY$MM$DD${HH}_prog.nc
ncks -O -a -h -x -v Layer cur_$YY$MM$DD${HH}_prog.nc cur_temp1.nc
ncwa -h -O -a Layer cur_temp1.nc cur_temp2.nc
ncrename -h -O -v MT,time -d MT,time cur_temp2.nc
ncks -v u_velocity,v_velocity cur_temp2.nc cur_temp3.nc
mv -f cur_temp3.nc cur_$YY$MM$DD${HH}_flat.nc
# Convert to regular lat lon file
# If weights need to be regenerated due to CDO ver change, use:
#$CDO genbil,r4320x2160 rtofs_glo_2ds_f000_3hrly_prog.nc weights.nc
 if [ $d == $start ]; then
$CDO genbil,r4320x2160 rtofs_$YY$MM$DD${HH}_prog.nc weights.nc
fi
#cp ${FIXwave}/weights_rtofs_to_r4320x2160.nc ./weights.nc
# Interpolate to regular 5 min grid
$CDO remap,r4320x2160,weights.nc cur_$YY$MM$DD${HH}_flat.nc cur_5min_01.nc
# Perform 9-point smoothing twice to make RTOFS data less noisy when
# interpolating from 1/12 deg RTOFS grid to 1/6 deg wave grid 
#smoothing
#  $CDO -f nc -smooth9 cur_5min_01.nc cur_5min_02.nc
#  $CDO -f nc -smooth9 cur_5min_02.nc cur_$YY$MM$DD${HH}_5min.nc
cp cur_5min_01.nc cur_$YY$MM$DD${HH}_5min.nc
#-----------------------------------------------------------------------------------#
#put all time steps together
 if [ $d == $start ]; then
#   cp cur_$YY$MM$DD${HH}_5min.nc cur.nc
#   cp cur.nc rtofs_current.nc
   cp cur_$YY$MM$DD${HH}_5min.nc rtofs_current.nc
 else
#  if [ -f out.nc ]; then rm out.nc;fi
#   ncks -O --mk_rec_dmn time cur.nc out.nc
#  mv cur.nc rtofs_current.nc
   mv rtofs_current.nc rtofs_current_tmp.nc
#   ncrcat -h out.nc cur_$YY$MM$DD${HH}_5min.nc cur.nc
   ncrcat -h rtofs_current_tmp.nc cur_$YY$MM$DD${HH}_5min.nc rtofs_current.nc
 fi

# Cleanup
rm -f wgrib.out cur_5min_??.nc cur_temp[123].nc rtofs_$YY$MM$DD${HH}_prog.nc cur_$YY$MM$DD${HH}_5min.nc cur_$YY$MM$DD${HH}_prog.nc cur_$YY$MM$DD${HH}_flat.nc
d=$(( $d + 3600 ))
done
rm rtofs_current_tmp.nc weights.nc
mv cur.nc rtofs_current.nc

  echo '       *****************************************************************' 
  echo "rtofs_current.nc prepared"
  echo ' '                                                                 
  echo '       *****************************************************************'     
  echo "     ***                            done                               ***"
  echo '       *****************************************************************'    
  echo ' '  
